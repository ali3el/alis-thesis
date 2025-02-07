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
load(here("attempt_3/results/data_split.rda"))
load(here("attempt_3/recipes/m3_recipes.rda"))

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
  add_recipe(m3_recipe_t)

dtree_params <- extract_parameter_set_dials(dtree_model)


dtree_grid <- grid_regular(dtree_params, levels = 5)

# metrics
custom_metrics <- metric_set(accuracy, precision, recall, f_meas, roc_auc, brier_class)


dtree_fit_c <- tune_grid(
  dtree_workflow,
  resamples = data_fold,        # Assuming `data_fold` is your cross-validation folds
  metrics = custom_metrics,
  grid = dtree_grid,
  control = control_grid(save_workflow = TRUE)
)

save(dtree_fit_c, file = "attempt_3/results/c_dtree_fit.rda")

