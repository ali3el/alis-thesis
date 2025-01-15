# decision tree

# Load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# Handle common conflicts
tidymodels_prefer()

# Set seed
set.seed(301)

# Load preprocessed data and recipe ----
load(here("attempt_2/results/data_split.rda"))
load(here("attempt_2/recipes/m2_recipes.rda"))

# Enable parallel processing ----
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# Model specifications ----
dtree_model <- 
  decision_tree(
    mode = "classification",
    cost_complexity = tune(),   # Controls pruning
    tree_depth = tune(),        # Max depth of tree
    min_n = tune()              # Minimum samples required for a split
  ) |> 
  set_engine("rpart")           # Use the rpart engine


# Define workflow ----
dtree_workflow <- workflow() |> 
  add_model(dtree_model) |> 
  add_recipe(m2_recipe_t)

dtree_params <- extract_parameter_set_dials(dtree_model)


dtree_grid <- grid_regular(dtree_params, levels = 3)

dtree_fit_b <- tune_grid(
  dtree_workflow,
  resamples = data_fold,        # Assuming `data_fold` is your cross-validation folds
  grid = dtree_grid,
  control = control_grid(save_workflow = TRUE)
)

save(dtree_fit_b, file = "attempt_2/results/b_dtree_fit.rda")

