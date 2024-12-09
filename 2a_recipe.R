# Setup pre-processing/recipes - KITCHEN SINK

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)


load(here("results/data_split.rda"))

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

# kitchen sink recipe
## for non tree (parametric) models 

ks_recipe <- recipe(depression_ever ~ ., data = data_train) |> 
  step_rm(year) |> 
  step_impute_mode(all_nominal_predictors()) |>  # For categorical variables
  step_impute_median(all_numeric_predictors()) |>  # For numeric variables
  # Convert nominal predictors to dummy variables
  step_dummy(all_nominal_predictors()) |> 
  # Remove zero-variance predictors
  step_zv(all_predictors()) |> 
  # Normalize predictors
  step_normalize(all_predictors())

prep(ks_recipe) |> 
  bake(new_data = NULL)


## for  tree (non-parametric) models 
ks_recipe_t <- recipe(depression_ever ~ ., data = data_train) |> 
  # Remove other unnecessary variables
  step_rm(year) |> 
  step_impute_mode(all_nominal_predictors()) |>  # For categorical variables
  step_impute_median(all_numeric_predictors()) |>  # For numeric variables
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(ks_recipe_t) |> 
  bake(new_data = NULL)

save(ks_recipe, ks_recipe_t, file = "recipes/ks_recipes.rda")



