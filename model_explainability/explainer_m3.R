# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(vip)

# ---- Load Trained Objects ----
load(here("model_explainability/quest_files/m3_data_split.rda"))   # data_split
load(here("model_explainability/quest_files/m3_recipes.rda"))      # m3_recipe_t
load(here("model_explainability/quest_files/m3_dtree_fit.rda"))    # dtree_fit (tuning result)

# ---- Finalize & Fit the Model ----
dtree_wf <- extract_workflow(dtree_fit_c)

# 1. Get best hyperparameters
best_params <- select_best(dtree_fit_c, metric = "f_meas")

# 2. Finalize the workflow
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)

# 3. Get original training data
data_train <- training(data_split)

# 4. Fit final model to full training data
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Extract fitted tree model for explainability ----
tree_model <- extract_fit_parsnip(final_dtree_fit)$fit

# ---- Create VIP Plot ----
vip_plot_m3 <- vip(tree_model, 
                num_features = 15, 
                bar = TRUE,
                aesthetics = list(fill = "steelblue"),
                title = "Variable Importance – Decision Tree (Quest – M3)")

# ---- Save Plot ----
ggsave(
  filename = here("model_explainability/results/vip_dtree_quest_m3.png"),
  plot = vip_plot_m3,
  width = 10, height = 6,
  dpi = 300
)

save(vip_plot_m3, file = here("model_explainability/results/vip_dtree_quest_m3.rda"))
