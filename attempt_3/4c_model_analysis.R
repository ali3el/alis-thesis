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
log_c_acc <- logistic_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_c_acc <- dtree_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_c_acc <- knn_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_c_acc <- nbayes_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_c_acc <- rulefit_result |> 
  filter(.metric == "accuracy") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")


table_c_accuracy <- bind_rows(log_c_acc, dtree_c_acc, knn_c_acc, nbayes_c_acc, rulefit_c_acc) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_c_accuracy

dtree_autoplot_c_acc <- autoplot(dtree_fit, metric = "accuracy")
knn_autoplot_c_acc <- autoplot(knn_fit, metric = "accuracy")
rulefit_autoplot_c_acc <- autoplot(rulefit_fit, metric = "accuracy")
# nbayes_autoplot_a <- autoplot(nbayes_fit, metric = "accuracy")

# precision
log_c_pre <- logistic_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_c_pre <- dtree_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_c_pre <- knn_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_c_pre <- nbayes_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_c_pre <- rulefit_result |> 
  filter(.metric == "precision") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")

dtree_autoplot_c_pre <- autoplot(dtree_fit, metric = "precision")
knn_autoplot_c_pre <- autoplot(knn_fit, metric = "precision")
rulefit_autoplot_c_pre <- autoplot(rulefit_fit, metric = "precision")

table_c_precision <- bind_rows(log_c_pre, dtree_c_pre, knn_c_pre, nbayes_c_pre, rulefit_c_pre) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_c_precision

# f1
log_c_f1 <- logistic_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_c_f1 <- dtree_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_c_f1 <- knn_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_c_f1 <- nbayes_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_c_f1 <- rulefit_result |> 
  filter(.metric == "f_meas") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")

dtree_autoplot_c_f1 <- autoplot(dtree_fit, metric = "f_meas")
knn_autoplot_c_f1 <- autoplot(knn_fit, metric = "f_meas")
rulefit_autoplot_c_f1 <- autoplot(rulefit_fit, metric = "f_meas")

table_c_f1 <- bind_rows(log_c_pre, dtree_c_pre, knn_c_pre, nbayes_c_pre, rulefit_c_pre) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_c_f1

# recall
log_c_rec <- logistic_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic KS")

dtree_c_rec <- dtree_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Decision Tree KS")

knn_c_rec <- knn_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "KNN KS")

nbayes_c_rec <- nbayes_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Naive Bayes KS")

rulefit_c_rec <- rulefit_result |> 
  filter(.metric == "recall") |> 
  slice_max(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "RuleFit KS")

dtree_autoplot_c_rec <- autoplot(dtree_fit, metric = "recall")
knn_autoplot_c_rec <- autoplot(knn_fit, metric = "recall")
rulefit_autoplot_c_rec <- autoplot(rulefit_fit, metric = "recall")

table_c_rec <- bind_rows(log_c_rec, dtree_c_rec, knn_c_rec, nbayes_c_rec, rulefit_c_rec) |> 
  select(model, mean, std_err, n) |> 
  arrange(mean) |> 
  distinct()
table_c_rec

save(table_c_accuracy, dtree_autoplot_c_acc,
     knn_autoplot_c_acc, rulefit_autoplot_c_acc,
     file = here("attempt_3/results/metric_results_c_acc.rda"))

save(table_c_precision, dtree_autoplot_c_pre,
     knn_autoplot_c_pre, rulefit_autoplot_c_pre,
     file = here("attempt_3/results/metric_results_c_pre.rda"))

save(table_c_rec, dtree_autoplot_c_rec,
     knn_autoplot_c_rec, rulefit_autoplot_c_rec,
     file = here("attempt_3/results/metric_results_c_rec.rda"))

save(table_c_f1, dtree_autoplot_c_f1,
     knn_autoplot_c_f1, rulefit_autoplot_c_f1,
     file = here("attempt_3/results/metric_results_c_f1.rda"))


