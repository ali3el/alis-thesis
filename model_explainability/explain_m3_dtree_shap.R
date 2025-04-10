# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(DALEXtra)
library(ingredients)

# ---- Load Model & Data ----
load(here("model_explainability/quest_files/m3_data_split.rda"))   # data_split
load(here("model_explainability/quest_files/m3_recipes.rda"))      # m3_recipe_t
load(here("model_explainability/quest_files/m3_dtree_fit.rda"))    # dtree_fit

# ---- Finalize & Fit Model ----
dtree_wf <- extract_workflow(dtree_fit_c)
best_params <- select_best(dtree_fit_c, metric = "f_meas")
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Build Explainer ----
explainer_m3_tree <- explain_tidymodels(
  model = final_dtree_fit,
  data = data_train |> select(-depression_ever),
  y = data_train$depression_ever,
  label = "Quest – M3 – Decision Tree",
  verbose = FALSE
)

# ---- Select Individual for SHAP ----
example_obs <- data_train %>%
  filter(data_group == "LGBTQ_Migrant") %>%
  slice(1)

# Optional: print the observation to document who it is
print(example_obs)

# ---- Compute SHAP Values ----
shap_m3_tree <- predict_parts(
  explainer = explainer_m3_tree,
  new_observation = example_obs,
  type = "shap"
)

# ---- Plot SHAP ----
shap_plot_m3 <- plot(shap_m3_tree) +
  labs(
    title = "SHAP Values – What Features Drove This Prediction?",
    subtitle = "Quest – M3 – Decision Tree"
  )

# ---- Save Plot ----
ggsave(
  filename = here("model_explainability/results/shap_explanation_m3_tree.png"),
  plot = shap_plot_m3,
  width = 10, height = 6,
  dpi = 300
)

# ---- Save Object (optional) ----
save(shap_plot_m3, shap_m3_tree, file = here("model_explainability/results/shap_explanation_m3_tree.rda"))
