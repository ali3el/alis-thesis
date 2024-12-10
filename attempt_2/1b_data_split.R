# data splitting

# load packages ----

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(janitor)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

combined_data <- read_csv(here("data_combined/combined_nhis_data.csv"))


# data split
data_split <- initial_split(combined_data,
                            prop = 0.80,
                            strat = depression_ever,
                            breaks = 4)

data_train <- data_split |> training()
data_test <- data_split |> testing()

data_fold <- vfold_cv(data_train, v = 5,
                      strata = depression_ever)

save(data_split, data_train, data_test, data_fold, file = here("attempt_2/results/data_split.rda"))

