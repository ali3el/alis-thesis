# KNN 

# # load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

load(here("attempt_3/results/data_split.rda"))
load(here("attempt_3/recipes/m3_recipes.rda"))

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
  add_recipe(m3_recipe) 

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_model)

knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
knn_fit_c <- tune_grid(knn_workflow,
                     data_fold,
                     grid = knn_grid,
                     control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(knn_fit_c, file = here("attempt_3/results/c_knn_fit.rda"))
