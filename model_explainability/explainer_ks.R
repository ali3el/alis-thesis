# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(vip)

# ---- Load Trained Objects ----
load(here("model_explainability/quest_files/ks_data_split.rda"))   # data_split
load(here("model_explainability/quest_files/ks_recipes.rda"))      # ks_recipe_t
load(here("model_explainability/quest_files/ks_dtree_fit.rda"))    # dtree_fit (tuning result)

# ---- Finalize & Fit the Model ----
dtree_wf <- extract_workflow(dtree_fit)
best_params <- select_best(dtree_fit, metric = "f_meas")
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Extract fitted tree model for explainability ----
tree_model <- extract_fit_parsnip(final_dtree_fit)$fit

# ---- Create VIP Plot ----
vip_plot_ks <- vip(tree_model, 
                   num_features = 15, 
                   bar = TRUE,
                   aesthetics = list(fill = "steelblue"),
                   title = "Variable Importance – Decision Tree (Quest – Kitchen Sink)") +
  labs(subtitle = "Top 15 predictors ranked by Gini importance")

# ---- Save Plot ----
ggsave(
  filename = here("model_explainability/results/vip_dtree_quest_ks.png"),
  plot = vip_plot_ks,
  width = 10, height = 6,
  dpi = 300
)

# ---- Save RDA version (optional) ----
save(vip_plot_ks, file = here("model_explainability/results/vip_dtree_quest_ks.rda"))

# ---- Optional: Print plot in interactive session ----
print(vip_plot_ks)
