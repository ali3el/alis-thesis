# Attempt 3 — README

This folder contains **Attempt 3** of the modeling workflow for my thesis project. This version was developed in Quest and has been migrated to my local Mac environment for further review and documentation.

The folder includes scripts for data preparation, model fitting, evaluation, and saved outputs. Subfolders include serialized preprocessing recipes and model results.

---

## R Scripts

- `1c_data_split.R`: Splits the dataset into training and testing sets for consistent evaluation.
- `2c_recipe.R`: Builds preprocessing pipelines, saved as recipe objects for reuse.
- `3c_decision_tree.R`: Trains a decision tree model.
- `3c_knn.R`: Trains a k-nearest neighbors model.
- `3c_log_reg.R`: Fits a logistic regression model.
- `3c_naive_bayes.R`: Trains a naive Bayes classifier.
- `3c_rulefit.R`: Trains a RuleFit model.
- `4c_model_analysis.R`: Compares model performance based on accuracy, AUC, and other evaluation metrics.

---

## Folder: `recipes/`

- `m3_recipes.rda`: Serialized preprocessing pipeline(s) used in this attempt.

---

## Folder: `results/`

- `c_dtree_fit.rda`: Decision tree model object
- `c_knn_fit.rda`: K-nearest neighbors model object
- `c_logistic_fit.rda`: Logistic regression model object
- `c_nbayes_fit.rda`: Naive Bayes model object
- `c_rulefit_fit.rda`: RuleFit model object
- `data_split.rda`: Saved data split used for training/testing
- `attempt_3q_summary_table.rda`: Summary of model performances
