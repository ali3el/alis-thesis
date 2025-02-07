# Logistic Regression

# # load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

load(here("attempt_1/results/data_split.rda"))
load(here("attempt_1/recipes/ks_recipes.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical =TRUE))

# model specifications ----
logistic_model <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

# define workflows ----
logistic_workflow <- workflow() |> 
  add_model(logistic_model) |> 
  add_recipe(ks_recipe)

# metrics
custom_metrics <- metric_set(accuracy, precision, recall, f_meas, roc_auc, brier_class)

# fit workflows/models ----
logistic_fit <- fit_resamples(logistic_workflow,
                              resamples = data_fold,
                              metrics = custom_metrics,
                              control = control_resamples(
                              save_workflow = TRUE,
                              parallel_over = "everything"))


# when tuning we need to make a grid
# write out results (fitted/trained workflows) ----
save(logistic_fit, file = "attempt_1/results/a_logistic_fit.rda")
