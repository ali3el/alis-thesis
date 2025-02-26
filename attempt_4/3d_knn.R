# KNN 

# # load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

load(here("attempt_4/results/data_split.rda"))
load(here("attempt_4/recipes/m1_recipes.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical =TRUE))

# model specifications ----
knn_model <- 
  nearest_neighbor(
    mode = "classification",
    neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_workflow <- workflow() |> 
  add_model(knn_model) |> 
  add_recipe(m1_recipe) 

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_model)

knn_grid <- grid_regular(knn_params, levels = 5)

# metrics
custom_metrics <- metric_set(accuracy, precision, recall, f_meas, roc_auc, brier_class)

# fit workflows/models ----
knn_fit_d <- tune_grid(knn_workflow,
                     data_fold,
                     metrics = custom_metrics,
                     grid = knn_grid,
                     control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(knn_fit_d, file = here("attempt_4/results/d_knn_fit.rda"))
