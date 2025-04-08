library(tidyverse)
library(here)

# ---- STEP 1: Load attempt summary tables ----
load(here("attempt_1/results/attempt_1_summary_table.rda"))  # summary_final_attempt1
load(here("attempt_2/results/attempt_2_summary_table.rda"))
load(here("attempt_3/results/attempt_3_summary_table.rda"))
load(here("attempt_4/results/attempt_4_summary_table.rda"))
load(here("attempt_5/results/attempt_5_summary_table.rda"))

# ---- STEP 2: Define recipe labels for each attempt (customize these) ----
recipe_labels <- c(
  "Kitchen Sink", 
  "M2", 
  "M3", 
  "M1", 
  "M4"
)

# ---- STEP 3: Add metadata to each attempt ----
summary_final_attempt1 <- summary_final_attempt1 |>
  mutate(attempt = 1, platform = "Local", recipe = recipe_labels[1])
summary_final_attempt2 <- summary_final_attempt2 |>
  mutate(attempt = 2, platform = "Local", recipe = recipe_labels[2])
summary_final_attempt3 <- summary_final_attempt3 |>
  mutate(attempt = 3, platform = "Local", recipe = recipe_labels[3])
summary_final_attempt4 <- summary_final_attempt4 |>
  mutate(attempt = 4, platform = "Local", recipe = recipe_labels[4])
summary_final_attempt5 <- summary_final_attempt5 |>
  mutate(attempt = 5, platform = "Local", recipe = recipe_labels[5])

# ---- STEP 4: Combine all into one table ----
local_summary_all <- bind_rows(
  summary_final_attempt1,
  summary_final_attempt2,
  summary_final_attempt3,
  summary_final_attempt4,
  summary_final_attempt5
)

# ---- STEP 5: Create best model per attempt table (based on F1-score) ----
local_best_models <- local_summary_all |>
  group_by(attempt) |>
  filter(f_meas == max(f_meas, na.rm = TRUE)) |>
  ungroup() |>
  arrange(attempt)


# ---- STEP 6: (Optional) Save cleaned full dataset ----
save(local_summary_all, local_best_models, file = here("master_comparison/local_model_results.rda"))
