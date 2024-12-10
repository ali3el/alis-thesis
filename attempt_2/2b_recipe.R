# Setup pre-processing/recipes - M1 just groups
# load packages ----
library(tidyverse)
library(tidymodels)
library(here)


load(here("attempt_2/results/data_split.rda"))

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

# M1 recipe - just groups
## for non tree (parametric) models 

m1_recipe <- recipe(depression_ever ~ data_group, data = data_train) |> 
  #step_rm(year) |> 
  step_impute_mode(all_nominal_predictors()) |>  # For categorical variables
  step_impute_median(all_numeric_predictors()) |>  # For numeric variables
  step_novel(all_nominal_predictors()) |> 
  # Convert nominal predictors to dummy variables
  step_dummy(all_nominal_predictors()) |> 
  # Remove zero-variance predictors
  step_zv(all_predictors()) |> 
  # Normalize predictors
  step_normalize(all_predictors())

prep(m1_recipe) |> 
  bake(new_data = NULL)

## for  tree (non-parametric) models 
m1_recipe_t <- recipe(depression_ever ~ data_group, data = data_train) |> 
  # Remove other unnecessary variables
  #step_rm(year) |> 
  step_impute_mode(all_nominal_predictors()) |>  # For categorical variables
  step_impute_median(all_numeric_predictors()) |>  # For numeric variables
  step_novel(all_nominal_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(m1_recipe_t) |> 
  bake(new_data = NULL)

save(m1_recipe, m1_recipe_t, file = here("attempt_2/recipes/m1_recipes.rda"))



