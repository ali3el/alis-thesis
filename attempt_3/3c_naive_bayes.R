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
load(here("attempt_3/results/data_split.rda"))
load(here("attempt_3/recipes/m3_recipes.rda"))

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
  add_recipe(m3_recipe)

# Hyperparameter tuning values ----
nbayes_params <- extract_parameter_set_dials(nbayes_model)

# Create grid for tuning ----
nbayes_grid <- grid_regular(nbayes_params, levels = 5)

# metrics
custom_metrics <- metric_set(accuracy, precision, recall, f_meas, roc_auc, brier_class)

# Fit workflows/models ----
nbayes_fit_c <- tune_grid(
  nbayes_workflow,
  resamples = data_fold, # Assuming `data_fold` is your cross-validation folds
  metrics = custom_metrics,
  grid = nbayes_grid,
  control = control_grid(save_workflow = TRUE)
)

# Save results (fitted/trained workflows) ----
save(nbayes_fit_c, file = "attempt_3/results/c_nbayes_fit.rda")
