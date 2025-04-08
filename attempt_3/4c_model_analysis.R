# =============================
# Analysis: Attempt 3 Summary Table
# =============================

# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(pROC)

tidymodels_prefer()
set.seed(301)

# ---- Register Parallel Processing ----
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# ---- Load Data and Fits ----
load(here("attempt_3/results/data_split.rda"))
load(here("attempt_3/results/c_logistic_fit.rda"))
load(here("attempt_3/results/c_dtree_fit.rda"))
load(here("attempt_3/results/c_nbayes_fit.rda"))
load(here("attempt_3/results/c_knn_fit.rda"))
load(here("attempt_3/results/c_rulefit_fit.rda"))

# ---- Combine and Filter Metrics ----
all_results <- bind_rows(
  collect_metrics(logistic_fit_c) |> mutate(model = "Logistic"),
  collect_metrics(dtree_fit_c)    |> mutate(model = "Decision Tree"),
  collect_metrics(knn_fit_c)      |> mutate(model = "KNN"),
  collect_metrics(nbayes_fit_c)   |> mutate(model = "Naive Bayes"),
  collect_metrics(rulefit_fit_c)  |> mutate(model = "RuleFit")
)

# ---- Keep only the best score per model per metric ----
metrics_to_keep <- c("accuracy", "precision", "recall", "f_meas", "roc_auc")

summary_metrics <- all_results |>
  filter(.metric %in% metrics_to_keep) |>
  group_by(model, .metric) |>
  slice_max(mean, with_ties = FALSE) |>
  ungroup() |>
  select(model, .metric, mean, std_err)

# ---- Pivot to Wide Format and Clean ----
summary_clean <- summary_metrics |>
  pivot_wider(
    names_from = .metric,
    values_from = c(mean, std_err),
    names_glue = "{.metric}_{.value}"
  ) |>
  rename_with(~ str_replace(., "_mean$", ""), ends_with("_mean")) |>
  rename_with(~ str_replace(., "_std_err$", "std_err"), ends_with("_std_err")) |>
  select(model, accuracy, precision, recall, f_meas, roc_auc, f_measstd_err) |>
  rename(std_err_f_meas = f_measstd_err)

# ---- Sort by F1-score ----
summary_final_attempt3 <- summary_clean |>
  arrange(desc(f_meas))

# ---- Preview Final Table ----
print(summary_final_attempt3)

# ---- Save RDA ----
save(summary_final_attempt3, file = here("attempt_3/results/attempt_3_summary_table.rda"))
