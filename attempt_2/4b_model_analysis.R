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
load(here("attempt_2/results/data_split.rda"))
load(here("attempt_2/recipes/m2_recipes.rda"))

load(here("attempt_2/results/b_logistic_fit.rda"))
load(here("attempt_2/results/b_dtree_fit.rda"))
load(here("attempt_2/results/b_nbayes_fit.rda"))
load(here("attempt_2/results/b_knn_fit.rda"))
load(here("attempt_2/results/b_rulefit_fit.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical =TRUE))

# results

logistic_result <- collect_metrics(logistic_fit_b) |> 
  mutate(model = "logistic")
logistic_result

dtree_result <- collect_metrics(dtree_fit_b) |> 
  mutate(model = "decision tree")
dtree_result

knn_result <- collect_metrics(knn_fit_b) |> 
  mutate(model = "KNN")
knn_result

nbayes_result <- collect_metrics(nbayes_fit_b) |> 
  mutate(model = "Naive Bayes")
nbayes_result

rulefit_result <- collect_metrics(rulefit_fit_b) |> 
  mutate(model = "RuleFit")
rulefit_result

log_b_acc <- logistic_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic M2")

dtree_b_acc <- dtree_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree M2")

knn_b_acc <- knn_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN M2")

nbayes_b_acc <- nbayes_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes M2")

rulefit_b_acc <- rulefit_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit M2")


table_b_accuracy <- bind_rows(log_b_acc, dtree_b_acc, knn_b_acc, nbayes_b_acc, rulefit_b_acc) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_b_accuracy

dtree_autoplot_b <- autoplot(dtree_fit_b, metric = "accuracy")
knn_autoplot_b <- autoplot(knn_fit_b, metric = "accuracy")
rulefit_autoplot_b <- autoplot(rulefit_fit_b, metric = "accuracy")
# nbayes_autoplot_a <- autoplot(nbayes_fit, metric = "accuracy")

save(table_b_accuracy, dtree_autoplot_b,
     knn_autoplot_b, rulefit_autoplot_b,
     file = here("attempt_2/results/metric_results_b.rda"))




