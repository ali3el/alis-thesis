# naive bayes

# Load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(discrim)

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

# Model specifications ----
nbayes_model <- 
  naive_Bayes(
    mode = "classification",
    smoothness = tune(), # Hyperparameter for Laplace smoothing
    Laplace = tune()     # Additional smoothing parameter
  ) |> 
  set_engine("klaR")      # Ensure 'klaR' package is installed

# Define workflow ----
nbayes_workflow <- workflow() |> 
  add_model(nbayes_model) |> 
  add_recipe(m1_recipe)

# Hyperparameter tuning values ----
nbayes_params <- extract_parameter_set_dials(nbayes_model)

# Create grid for tuning ----
nbayes_grid <- grid_regular(nbayes_params, levels = 5)

# Fit workflows/models ----
nbayes_fit_d <- tune_grid(
  nbayes_workflow,
  resamples = data_fold, # Assuming `data_fold` is your cross-validation folds
  grid = nbayes_grid,
  control = control_grid(save_workflow = TRUE)
)

# Save results (fitted/trained workflows) ----
save(nbayes_fit_d, file = "attempt_4/results/d_nbayes_fit.rda")
