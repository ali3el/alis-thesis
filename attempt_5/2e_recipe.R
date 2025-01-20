# Setup pre-processing/recipes - M4 just groups
# load packages ----
library(tidyverse)
library(tidymodels)
library(here)


load(here("attempt_5/results/data_split.rda"))

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(301)

# M4 recipe
## for non tree (parametric) models 

m4_recipe <- recipe(depression_ever ~ data_group + region + urban_rural + race_category +
                      age + sex + hispanic_ethnicity + hispanic_and_race + hispanic_details + 
                      education_level + max_education_level + not_covered + marital_status + 
                      parent_status + marital_status + employment_last_week + physical_health + 
                      mental_health_therapy + housing_tenure, 
                    data = data_train) |> 
  step_impute_mode(all_nominal_predictors()) |>  # For categorical variables
  step_impute_median(all_numeric_predictors()) |>  # For numeric variables
  step_novel(all_nominal_predictors()) |> 
  # Convert nominal predictors to dummy variables
  step_dummy(all_nominal_predictors()) |> 
  # Remove zero-variance predictors
  step_zv(all_predictors()) |> 
  # Normalize predictors
  step_normalize(all_predictors())

prep(m4_recipe) |> 
  bake(new_data = NULL)

## for  tree (non-parametric) models 
m4_recipe_t <- recipe(depression_ever ~ data_group + region + urban_rural + race_category +
                        age + sex + hispanic_ethnicity + hispanic_and_race + hispanic_details + 
                        education_level + max_education_level + not_covered + marital_status + 
                        parent_status + marital_status + employment_last_week + physical_health + 
                        mental_health_therapy + housing_tenure, 
                      data = data_train) |> 
  # Remove other unnecessary variables
  #step_rm(year) |> 
  step_impute_mode(all_nominal_predictors()) |>  # For categorical variables
  step_impute_median(all_numeric_predictors()) |>  # For numeric variables
  step_novel(all_nominal_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(m4_recipe_t) |> 
  bake(new_data = NULL)

save(m4_recipe, m4_recipe_t, file = here("attempt_5/recipes/m4_recipes.rda"))



