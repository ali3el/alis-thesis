# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

# load data, recipes and fits
load(here("attempt_1/results/metric_results_a.rda"))
load(here("attempt_2/results/metric_results_b.rda"))
load(here("attempt_3/results/metric_results_c.rda"))
load(here("attempt_4/results/metric_results_d.rda"))
load(here("attempt_5/results/metric_results_e.rda"))

combined_table <- 
  bind_rows(table_a_accuracy, table_b_accuracy, table_c_accuracy,
            table_d_accuracy, table_e_accuracy) |> 
  arrange(desc(mean)) |> 
  knitr::kable()

combined_table
