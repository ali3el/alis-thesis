# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(DALEXtra)

# ---- Load Final Model & Training Data ----
load(here("model_explainability/quest_files/m3_data_split.rda"))     # data_split
load(here("model_explainability/quest_files/m3_dtree_fit.rda"))      # dtree_fit
load(here("model_explainability/quest_files/m3_recipes.rda"))        # m3_recipe_t

# ---- Finalize & Fit the Model ----
dtree_wf <- extract_workflow(dtree_fit_c)
best_params <- select_best(dtree_fit_c, metric = "f_meas")
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Build Explainer for Local Explanation ----
explainer_m3_tree <- explain_tidymodels(
  model = final_dtree_fit,
  data = data_train |> select(-depression_ever),
  y = data_train$depression_ever,
  label = "Quest – M3 – Decision Tree",
  verbose = FALSE
)

# ---- Choose One Observation to Explain ----
one_person <- data_train |> 
  filter(data_group == "LGBTQ_NonMigrant") |> 
  slice_sample(n = 1)

# ---- Local Explanation with predict_parts() ----
local_explanation_m3 <- predict_parts(
  explainer = explainer_m3_tree,
  new_observation = one_person,
  type = "break_down"
)

# ---- Plot Local Explanation ----
local_plot_m3 <- plot(local_explanation_m3) +
  labs(title = "Local Explanation – Quest (M3 – Decision Tree)")


# ---- Save Plot ----
ggsave(
  filename = here("model_explainability/results/local_explanation_m3.png"),
  plot = local_plot_m3,
  width = 10, height = 6,
  dpi = 300
)

save(local_explanation_m3, local_plot_m3, file = here("model_explainability/results/local_explanation_m3.rda"))
