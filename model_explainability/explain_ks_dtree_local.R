# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(DALEXtra)

# ---- Load Final Model & Training Data ----
load(here("model_explainability/quest_files/ks_data_split.rda"))     # data_split
load(here("model_explainability/quest_files/ks_dtree_fit.rda"))      # dtree_fit
load(here("model_explainability/quest_files/ks_recipes.rda"))        # ks_recipe_t

# ---- Finalize & Fit the Model ----
dtree_wf <- extract_workflow(dtree_fit)
best_params <- select_best(dtree_fit, metric = "f_meas")
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Build Explainer for Local Explanation ----
explainer_ks_tree <- explain_tidymodels(
  model = final_dtree_fit,
  data = data_train |> select(-depression_ever),
  y = data_train$depression_ever,
  label = "Quest – Kitchen Sink – Decision Tree",
  verbose = FALSE
)

# ---- Choose One Observation to Explain ----
one_person <- data_train |> 
  filter(data_group == "LGBTQ_Migrant") |> 
  slice_sample(n = 1)


# ---- Local Explanation with predict_parts() ----
local_explanation_ks <- predict_parts(
  explainer = explainer_ks_tree,
  new_observation = one_person,
  type = "break_down"
)

# ---- Plot Local Explanation ----
local_plot_ks <- plot(local_explanation_ks) +
  labs(title = "Local Explanation – Quest (Kitchen Sink – Decision Tree)")


# ---- Save Plot ----
ggsave(
  filename = here("model_explainability/results/local_explanation_ks.png"),
  plot = local_plot_ks,
  width = 10, height = 6,
  dpi = 300
)

save(local_explanation_ks, local_plot_ks, file = here("model_explainability/results/local_explanation_ks.rda"))
