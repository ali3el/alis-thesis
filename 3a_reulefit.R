# RuleFit

# Load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xrf)

# Handle common conflicts
tidymodels_prefer()

# Set seed
set.seed(301)

# Load preprocessed data and recipe ----
load(here("results/data_split.rda"))
load(here("recipes/ks_recipes.rda"))

# Enable parallel processing ----
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# Set RuleFit model specification
rulefit_model <- linear_reg() |> 
  set_engine("xrf") |> 
  set_mode("classification")


rulefit_workflow <- workflow() |> 
  add_model(rulefit_model) |> 
  add_recipe(ks_recipe_t)


rulefit_params <- parameters(max_depth(), min_n(), penalty())
rulefit_grid <- grid_regular(rulefit_params, levels = 5)

rulefit_fit <- tune_grid(
  rulefit_workflow,
  resamples = data_fold, # `data_fold` is my cross-validation folds
  grid = rulefit_grid,
  control = control_grid(save_workflow = TRUE)
)

save(rulefit_fit, file = "results/a_rulefit_fit.rda")


