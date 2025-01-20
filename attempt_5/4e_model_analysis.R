# Analysis of trained models (comparisons)
# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

# load data, recipes and fits
load(here("attempt_5/results/data_split.rda"))
load(here("attempt_5/recipes/m4_recipes.rda"))

load(here("attempt_5/results/e_logistic_fit.rda"))
load(here("attempt_5/results/e_dtree_fit.rda"))
load(here("attempt_5/results/e_nbayes_fit.rda"))
load(here("attempt_5/results/e_knn_fit.rda"))
load(here("attempt_5/results/e_rulefit_fit.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical =TRUE))

# results

logistic_result <- collect_metrics(logistic_fit_e) |> 
  mutate(model = "logistic")
logistic_result

dtree_result <- collect_metrics(dtree_fit_e) |> 
  mutate(model = "decision tree")
dtree_result

knn_result <- collect_metrics(knn_fit_e) |> 
  mutate(model = "KNN")
knn_result

nbayes_result <- collect_metrics(nbayes_fit_e) |> 
  mutate(model = "Naive Bayes")
nbayes_result

rulefit_result <- collect_metrics(rulefit_fit_e) |> 
  mutate(model = "RuleFit")
rulefit_result

log_e_acc <- logistic_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic M4")

dtree_e_acc <- dtree_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree M4")

knn_e_acc <- knn_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN M4")

nbayes_e_acc <- nbayes_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes M4")

rulefit_e_acc <- rulefit_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit M4")


table_e_accuracy <- bind_rows(log_e_acc, dtree_e_acc, knn_e_acc, nbayes_e_acc, rulefit_e_acc) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_e_accuracy

dtree_autoplot_e <- autoplot(dtree_fit_e, metric = "accuracy")
knn_autoplot_e <- autoplot(knn_fit_e, metric = "accuracy")
rulefit_autoplot_e <- autoplot(rulefit_fit_e, metric = "accuracy")
# nbayes_autoplot_a <- autoplot(nbayes_fit, metric = "accuracy")

save(table_e_accuracy, dtree_autoplot_e,
     knn_autoplot_e, rulefit_autoplot_e,
     file = here("attempt_5/results/metric_results_e.rda"))




