# Model Explainability — README

This folder contains all files used to explain and interpret two of the best-performing models from my Quest-based modeling workflow. These models were originally developed in the Quest environment but have been copied here to my local Mac setup for easier access, experimentation, and visualization.

The focus of this folder is **model explainability**—understanding how individual predictors impact predictions using tools such as:
- Variable importance
- Partial dependence plots (PDP)
- SHAP values
- Local explanation tools

All outputs and scripts are built to run independently on local copies of the original Quest models.

---

## Scripts

### Explainers

- `explainer_ks.R`: Builds an explainer object for the Kitchen Sink decision tree model
- `explainer_m3.R`: Builds an explainer object for the M3 decision tree model
- `explainer_m3_dtree_local.R`: Local version of the M3 explainer for portability
- `explain_ks_dtree_local.R`: Local explanation pipeline for the Kitchen Sink model

### SHAP & PDP Analysis

- `explain_ks_dtree_shap.R`: Generates SHAP values for the KS model
- `explain_ks_dtree_pdp.R`: Generates PDP plots for the KS model
- `explain_m3_dtree_shap.R`: Generates SHAP values for the M3 model
- `explain_m3_dtree_pdp.R`: Generates PDP plots for the M3 model

---

## Folder: `quest_files/`

Stores the original `.rda` model objects from Quest so they can be reloaded locally:

- `*_data_split.rda`: Training/testing split used in Quest
- `*_recipes.rda`: Preprocessing pipeline used for model training
- `*_dtree_fit.rda`: Trained decision tree model

Includes both Kitchen Sink (`ks_`) and M3 model (`m3_`) versions.

---

## Folder: `results/`

This folder contains output artifacts from SHAP, PDP, local interpretation, and variable importance work:

- `*_shap_explanation_*.png` and `.rda`: SHAP value visualizations and objects
- `*_pdp_combined_cleaned_*.png` and `.rda`: Partial dependence plots and data
- `local_explanation_*.png` and `.rda`: Local explanations (e.g., LIME-style) for individual predictions
- `vip_dtree_quest_*.png` and `.rda`: Variable importance plots from decision tree models
