# Attempt 5 — README

This folder documents **Attempt 5** of the modeling process for my thesis project. It continues the work originally started on Quest and is now stored and maintained locally on my Mac.

This directory includes scripts for data preparation, model training, and performance evaluation, as well as stored recipe and model output files.

---

## R Scripts

- `1e_data_split.R`: Performs a training/testing split of the dataset.
- `2e_recipe.R`: Defines the data preprocessing steps and stores them as a recipe object.
- `3e_decision_tree.R`: Trains a decision tree model.
- `3e_knn.R`: Trains a k-nearest neighbors model.
- `3e_log_reg.R`: Fits a logistic regression model.
- `3e_naive_bayes.R`: Trains a naive Bayes classifier.
- `3e_rulefit.R`: Trains a RuleFit model.
- `4e_model_analysis.R`: Compares model results using performance metrics such as accuracy and AUC.

---

## Folder: `recipes/`

- `m4_recipes.rda`: Serialized recipe object containing preprocessing steps for this attempt.

---

## Folder: `results/`

- `e_dtree_fit.rda`: Decision tree model object
- `e_knn_fit.rda`: K-nearest neighbors model object
- `e_logistic_fit.rda`: Logistic regression model object
- `e_nbayes_fit.rda`: Naive Bayes model object
- `e_rulefit_fit.rda`: RuleFit model object
- `data_split.rda`: Saved train/test split object
- `attempt_5q_summary_table.rda`: Summary of model evaluation metrics for Attempt 5
