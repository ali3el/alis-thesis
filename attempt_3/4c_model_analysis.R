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
load(here("attempt_3/results/data_split.rda"))
load(here("attempt_3/recipes/m3_recipes.rda"))

load(here("attempt_3/results/c_logistic_fit.rda"))
load(here("attempt_3/results/c_dtree_fit.rda"))
load(here("attempt_3/results/c_nbayes_fit.rda"))
load(here("attempt_3/results/c_knn_fit.rda"))
load(here("attempt_3/results/c_rulefit_fit.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical =TRUE))

# results

logistic_result <- collect_metrics(logistic_fit_c) |> 
  mutate(model = "logistic")
logistic_result

dtree_result <- collect_metrics(dtree_fit_c) |> 
  mutate(model = "decision tree")
dtree_result

knn_result <- collect_metrics(knn_fit_c) |> 
  mutate(model = "KNN")
knn_result

nbayes_result <- collect_metrics(nbayes_fit_c) |> 
  mutate(model = "Naive Bayes")
nbayes_result

rulefit_result <- collect_metrics(rulefit_fit_c) |> 
  mutate(model = "RuleFit")
rulefit_result

log_c_acc <- logistic_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic M3")

dtree_c_acc <- dtree_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree M3")

knn_c_acc <- knn_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN M3")

nbayes_c_acc <- nbayes_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes M3")

rulefit_c_acc <- rulefit_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit M3")


table_c_accuracy <- bind_rows(log_c_acc, dtree_c_acc, knn_c_acc, nbayes_c_acc, rulefit_c_acc) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_c_accuracy

dtree_autoplot_c <- autoplot(dtree_fit_c, metric = "accuracy")
knn_autoplot_c <- autoplot(knn_fit_c, metric = "accuracy")
rulefit_autoplot_c <- autoplot(rulefit_fit_c, metric = "accuracy")
# nbayes_autoplot_a <- autoplot(nbayes_fit, metric = "accuracy")

save(table_c_accuracy, dtree_autoplot_c,
     knn_autoplot_c, rulefit_autoplot_c,
     file = here("attempt_3/results/metric_results_c.rda"))




