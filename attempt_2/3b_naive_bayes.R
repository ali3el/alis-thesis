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
load(here("attempt_2/results/data_split.rda"))
load(here("attempt_2/recipes/m2_recipes.rda"))

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
  add_recipe(m2_recipe)

# Hyperparameter tuning values ----
nbayes_params <- extract_parameter_set_dials(nbayes_model)

# Create grid for tuning ----
nbayes_grid <- grid_regular(nbayes_params, levels = 3)

# Fit workflows/models ----
nbayes_fit_b <- tune_grid(
  nbayes_workflow,
  resamples = data_fold, # Assuming `data_fold` is your cross-validation folds
  grid = nbayes_grid,
  control = control_grid(save_workflow = TRUE)
)

# Save results (fitted/trained workflows) ----
save(nbayes_fit_b, file = "attempt_2/results/b_nbayes_fit.rda")
