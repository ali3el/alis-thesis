# Logistic Regression

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
logistic_model <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

# define workflows ----
logistic_workflow <- workflow() |> 
  add_model(logistic_model) |> 
  add_recipe(m3_recipe)

# fit workflows/models ----
logistic_fit_c <- fit_resamples(logistic_workflow,
                              resamples = data_fold,
                              control = control_resamples(
                                save_workflow = TRUE,
                                parallel_over = "everything"))


# when tuning we need to make a grid
# write out results (fitted/trained workflows) ----
save(logistic_fit_c, file = "attempt_3/results/c_logistic_fit.rda")

