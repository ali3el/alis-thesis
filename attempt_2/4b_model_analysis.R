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

logistic_result <- collect_metrics(logistic_fit) |> 
  mutate(model = "logistic")
logistic_result

dtree_result <- collect_metrics(dtree_fit) |> 
  mutate(model = "decision tree")
dtree_result

knn_result <- collect_metrics(knn_fit) |> 
  mutate(model = "KNN")
knn_result

nbayes_result <- collect_metrics(nbayes_fit) |> 
  mutate(model = "Naive Bayes")
nbayes_result

rulefit_result <- collect_metrics(rulefit_fit) |> 
  mutate(model = "RuleFit")
rulefit_result

# accuracy
log_b_acc <- logistic_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_b_acc <- dtree_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_b_acc <- knn_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_b_acc <- nbayes_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_b_acc <- rulefit_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")


table_b_accuracy <- bind_rows(log_b_acc, dtree_b_acc, knn_b_acc, nbayes_b_acc, rulefit_b_acc) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_b_accuracy

dtree_autoplot_b_acc <- autoplot(dtree_fit, metric = "accuracy")
knn_autoplot_b_acc <- autoplot(knn_fit, metric = "accuracy")
rulefit_autoplot_b_acc <- autoplot(rulefit_fit, metric = "accuracy")
# nbayes_autoplot_a <- autoplot(nbayes_fit, metric = "accuracy")

# precision
log_b_pre <- logistic_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_b_pre <- dtree_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_b_pre <- knn_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_b_pre <- nbayes_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_b_pre <- rulefit_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")

dtree_autoplot_b_pre <- autoplot(dtree_fit, metric = "precision")
knn_autoplot_b_pre <- autoplot(knn_fit, metric = "precision")
rulefit_autoplot_b_pre <- autoplot(rulefit_fit, metric = "precision")

table_b_precision <- bind_rows(log_b_pre, dtree_b_pre, knn_b_pre, nbayes_b_pre, rulefit_b_pre) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_b_precision

# f1
log_b_f1 <- logistic_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_b_f1 <- dtree_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_b_f1 <- knn_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_b_f1 <- nbayes_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_b_f1 <- rulefit_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")

dtree_autoplot_b_f1 <- autoplot(dtree_fit, metric = "f_meas")
knn_autoplot_b_f1 <- autoplot(knn_fit, metric = "f_meas")
rulefit_autoplot_b_f1 <- autoplot(rulefit_fit, metric = "f_meas")

table_b_f1 <- bind_rows(log_b_pre, dtree_b_pre, knn_b_pre, nbayes_b_pre, rulefit_b_pre) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_b_f1

# recall
log_b_rec <- logistic_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_b_rec <- dtree_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_b_rec <- knn_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_b_rec <- nbayes_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_b_rec <- rulefit_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")

dtree_autoplot_b_rec <- autoplot(dtree_fit, metric = "recall")
knn_autoplot_b_rec <- autoplot(knn_fit, metric = "recall")
rulefit_autoplot_b_rec <- autoplot(rulefit_fit, metric = "recall")

table_b_rec <- bind_rows(log_b_rec, dtree_b_rec, knn_b_rec, nbayes_b_rec, rulefit_b_rec) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_b_rec

save(table_b_accuracy, dtree_autoplot_b_acc,
     knn_autoplot_b_acc, rulefit_autoplot_b_acc,
     file = here("attempt_2/results/metric_results_b_acc.rda"))

save(table_b_precision, dtree_autoplot_b_pre,
     knn_autoplot_b_pre, rulefit_autoplot_b_pre,
     file = here("attempt_2/results/metric_results_b_pre.rda"))

save(table_b_rec, dtree_autoplot_b_rec,
     knn_autoplot_b_rec, rulefit_autoplot_b_rec,
     file = here("attempt_2/results/metric_results_b_rec.rda"))

save(table_b_f1, dtree_autoplot_b_f1,
     knn_autoplot_b_f1, rulefit_autoplot_b_f1,
     file = here("attempt_2/results/metric_results_b_f1.rda"))


