# RuleFit

# Load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xrf)
library(rules)

# Handle common conflicts
tidymodels_prefer()

# Set seed
set.seed(301)

# Load preprocessed data and recipe ----
load(here("attempt_4/results/data_split.rda"))
load(here("attempt_4/recipes/m1_recipes.rda"))

# Enable parallel processing ----
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# Set RuleFit model specification
rulefit_model <- rule_fit(
  mode = "classification",
  penalty = tune()
) |> 
  set_engine("xrf")


rulefit_workflow <- workflow() |> 
  add_model(rulefit_model) |> 
  add_recipe(m1_recipe_t)


rulefit_params <- extract_parameter_set_dials(rulefit_model)
rulefit_grid <- grid_regular(rulefit_params, levels = 5)

# metrics
custom_metrics <- metric_set(accuracy, precision, recall, f_meas, roc_auc, brier_class)


rulefit_fit_d <- tune_grid(
  rulefit_workflow,
  resamples = data_fold, # `data_fold` is my cross-validation folds
  metrics = custom_metrics,
  grid = rulefit_grid,
  control = control_grid(save_workflow = TRUE)
)

save(rulefit_fit_d, file = here("attempt_4/results/d_rulefit_fit.rda"))


