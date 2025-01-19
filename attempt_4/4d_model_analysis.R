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
load(here("attempt_4/results/data_split.rda"))
load(here("attempt_4/recipes/m1_recipes.rda"))

load(here("attempt_4/results/d_logistic_fit.rda"))
load(here("attempt_4/results/d_dtree_fit.rda"))
load(here("attempt_4/results/d_nbayes_fit.rda"))
load(here("attempt_4/results/d_knn_fit.rda"))
load(here("attempt_4/results/d_rulefit_fit.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical =TRUE))

# results

logistic_result <- collect_metrics(logistic_fit_d) |> 
  mutate(model = "logistic")
logistic_result

dtree_result <- collect_metrics(dtree_fit_d) |> 
  mutate(model = "decision tree")
dtree_result

knn_result <- collect_metrics(knn_fit_d) |> 
  mutate(model = "KNN")
knn_result

nbayes_result <- collect_metrics(nbayes_fit_d) |> 
  mutate(model = "Naive Bayes")
nbayes_result

rulefit_result <- collect_metrics(rulefit_fit_d) |> 
  mutate(model = "RuleFit")
rulefit_result

log_d_acc <- logistic_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic M1")

dtree_d_acc <- dtree_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree M1")

knn_d_acc <- knn_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN M1")

nbayes_d_acc <- nbayes_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes M1")

rulefit_d_acc <- rulefit_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit M1")


table_d_accuracy <- bind_rows(log_d_acc, dtree_d_acc, knn_d_acc, nbayes_d_acc, rulefit_d_acc) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_d_accuracy

dtree_autoplot_d <- autoplot(dtree_fit_d, metric = "accuracy")
knn_autoplot_d <- autoplot(knn_fit_d, metric = "accuracy")
rulefit_autoplot_d <- autoplot(rulefit_fit_d, metric = "accuracy")
# nbayes_autoplot_a <- autoplot(nbayes_fit, metric = "accuracy")

save(table_d_accuracy, dtree_autoplot_d,
     knn_autoplot_d, rulefit_autoplot_d,
     file = here("attempt_4/results/metric_results_d.rda"))




