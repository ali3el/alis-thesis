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
load(here("attempt_2/results/data_split.rda"))
load(here("attempt_2/recipes/m1_recipes.rda"))

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
rulefit_grid <- grid_regular(rulefit_params, levels = 3)

rulefit_fit_b <- tune_grid(
  rulefit_workflow,
  resamples = data_fold, # `data_fold` is my cross-validation folds
  grid = rulefit_grid,
  control = control_grid(save_workflow = TRUE)
)

save(rulefit_fit_b, file = here("attempt_2/results/b_rulefit_fit.rda"))


