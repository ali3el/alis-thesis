# Attempt 2 — README

This folder documents **Attempt 2** of the modeling process for my thesis project. This iteration was originally developed in Quest and is now managed locally on my Mac. It refines the earlier workflow with updated preprocessing decisions and new modeling results.

This folder includes updated scripts for data preparation, model training, model comparison, and analysis of results. It also includes subfolders for preprocessing objects (`recipes/`) and model outputs (`results/`).

---

## R Scripts

- `1b_data_split.R`: Splits the dataset into training and testing sets with new parameters or seeds compared to Attempt 1.
- `2b_recipe.R`: Defines the data preprocessing steps, such as normalization or encoding, saved as recipe objects.
- `3b_decision_tree.R`: Trains a decision tree model.
- `3b_knn.R`: Trains a k-nearest neighbors model.
- `3b_log_reg.R`: Fits a logistic regression model.
- `3b_naive_bayes.R`: Trains a naive Bayes classifier.
- `3b_rulefit.R`: Trains a RuleFit model.
- `4b_model_analysis.R`: Compares the performance of all trained models using summary statistics like accuracy and ROC AUC.

---

## Folder: `recipes/`

- `m2_recipes.rda`: R object containing the preprocessing steps used for this attempt.

---

## Folder: `results/`

- `b_dtree_fit.rda`: Decision tree model object
- `b_knn_fit.rda`: K-nearest neighbors model object
- `b_logistic_fit.rda`: Logistic regression model object
- `b_nbayes_fit.rda`: Naive Bayes model object
- `b_rulefit_fit.rda`: RuleFit model object
- `attempt_2q_summary_table.rda`: Summary of model performances
- `data_split.rda`: Saved training/testing split for this attempt
