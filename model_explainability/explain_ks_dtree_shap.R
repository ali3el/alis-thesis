# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(DALEXtra)
library(ingredients)

# ---- Load Model & Data ----
load(here("model_explainability/quest_files/ks_data_split.rda"))   # data_split
load(here("model_explainability/quest_files/ks_recipes.rda"))      # ks_recipe_t
load(here("model_explainability/quest_files/ks_dtree_fit.rda"))    # dtree_fit

# ---- Finalize & Fit Model ----
dtree_wf <- extract_workflow(dtree_fit)
best_params <- select_best(dtree_fit, metric = "f_meas")
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Build Explainer ----
explainer_ks_tree <- explain_tidymodels(
  model = final_dtree_fit,
  data = data_train |> select(-depression_ever),
  y = data_train$depression_ever,
  label = "Quest – Kitchen Sink – Decision Tree",
  verbose = FALSE
)

# ---- Select Individual for SHAP ----
example_obs <- data_train %>% 
  filter(data_group == "LGBTQ_Migrant") %>% 
  slice(1)

# Optional: print for reporting purposes
print(example_obs)

# ---- Compute SHAP Values ----
shap_ks_tree <- predict_parts(
  explainer = explainer_ks_tree,
  new_observation = example_obs,
  type = "shap"
)

# ---- Plot SHAP ----
shap_plot_ks <- plot(shap_ks_tree) +
  labs(
    title = "SHAP Values – What Features Drove This Prediction?",
    subtitle = "Quest – Kitchen Sink – Decision Tree"
  )

# ---- Save Plot ----
ggsave(
  filename = here("model_explainability/results/shap_explanation_ks_tree.png"),
  plot = shap_plot_ks,
  width = 10, height = 6,
  dpi = 300
)

# ---- Save Object (Optional) ----
save(shap_plot_ks, shap_ks_tree, file = here("model_explainability/results/shap_explanation_ks_tree.rda"))
