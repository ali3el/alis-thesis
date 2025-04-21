# Attempt 1 — README

This folder documents **Attempt 1** of the modeling workflow for my thesis project. This attempt represents an early but structured pass at modeling using multiple algorithms and comparing their performance. All files and models here were initially developed on Quest and are now maintained locally on my Mac.

This directory includes data preprocessing, multiple model training scripts, analysis of results, and saved outputs. It also includes a subfolder for custom recipe objects and one for resulting model fits.

---

## R Scripts

- `1a_data_split.R`: Splits the dataset into training and testing sets for reproducibility and model validation.
- `2a_recipe.R`: Creates the preprocessing pipeline using the `recipes` package (e.g., normalization, encoding).
- `3a_decision_tree.R`: Trains a decision tree model using the preprocessed data.
- `3a_knn.R`: Trains a k-nearest neighbors (KNN) model.
- `3a_log_reg.R`: Fits a logistic regression model.
- `3a_naive_bayes.R`: Trains a naive Bayes classifier.
- `3a_rulefit.R`: Trains a RuleFit model (combining rules and linear terms).
- `4a_model_analysis.R`: Compares performance across all trained models using metrics such as accuracy and ROC AUC.

---

## Folder: `recipes/`

- `ks_recipes.rda`: Serialized R object storing preprocessing pipelines used for model training.

---

## Folder: `results/`

- `a_dtree_fit.rda`: Saved decision tree model object
- `a_knn_fit.rda`: Saved k-nearest neighbors model object
- `a_logistic_fit.rda`: Saved logistic regression model object
- `a_nbayes_fit.rda`: Saved naive Bayes model object
- `a_rulefit_fit.rda`: Saved RuleFit model object
- `attempt_1q_summary_table.rda`: Summary metrics (e.g., accuracy, AUC) across models
- `data_split.rda`: Saved training/testing split for reuse and consistency
