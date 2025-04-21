# Attempt 4 — README

This folder documents **Attempt 4** of the modeling process for my thesis project. Originally created in Quest, this version now runs locally on my Mac for continued analysis and model evaluation.

This folder contains scripts for data splitting, recipe preparation, model fitting, and performance comparison. It also includes saved recipe objects and model results in their respective subfolders.

---

## R Scripts

- `1d_data_split.R`: Splits the dataset into training and testing sets.
- `2d_recipe.R`: Creates preprocessing pipelines for this attempt, saved for use in modeling.
- `3d_decision_tree.R`: Trains a decision tree classifier.
- `3d_knn.R`: Trains a k-nearest neighbors classifier.
- `3d_log_reg.R`: Fits a logistic regression model.
- `3d_naive_bayes.R`: Trains a naive Bayes model.
- `3d_rulefit.R`: Trains a RuleFit model.
- `4d_model_analysis.R`: Compares model performance and stores summary outputs.

---

## Folder: `recipes/`

- `m1_recipes.rda`: Preprocessing object used in this modeling attempt.

---

## Folder: `results/`

- `d_dtree_fit.rda`: Decision tree model object
- `d_knn_fit.rda`: K-nearest neighbors model object
- `d_logistic_fit.rda`: Logistic regression model object
- `d_nbayes_fit.rda`: Naive Bayes model object
- `d_rulefit_fit.rda`: RuleFit model object
- `data_split.rda`: Saved train/test split
- `attempt_4q_summary_table.rda`: Summary metrics for all models in this attempt
