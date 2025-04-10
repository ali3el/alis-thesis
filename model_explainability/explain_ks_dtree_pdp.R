# ---- Load Libraries ----
library(tidyverse)
library(tidymodels)
library(here)
library(DALEXtra)
library(patchwork)

# ---- Load Model & Data ----
load(here("model_explainability/quest_files/ks_data_split.rda"))   # data_split
load(here("model_explainability/quest_files/ks_recipes.rda"))      # ks_recipe_t
load(here("model_explainability/quest_files/ks_dtree_fit.rda"))    # dtree_fit

# ---- Finalize & Fit Model ----
dtree_wf <- extract_workflow(dtree_fit)
best_params <- select_best(dtree_fit, metric = "f_meas")
final_dtree_wf <- finalize_workflow(dtree_wf, best_params)
final_dtree_fit <- fit(final_dtree_wf, data = data_train)

# ---- Build Explainer ----
explainer_ks_tree <- explain_tidymodels(
  model = final_dtree_fit,
  data = data_train |> select(-depression_ever),
  y = data_train$depression_ever,
  label = "Quest – Kitchen Sink – Decision Tree",
  verbose = FALSE
)

# ---- Generate PDPs ----
pdp_anxiety <- model_profile(explainer_ks_tree, variables = "anxiety_ever")
pdp_edu     <- model_profile(explainer_ks_tree, variables = "education_level")

# ---- Style Individual Plots ----
plot_anxiety_ks <- plot(pdp_anxiety) +
  labs(
    title = "Partial Dependence – Anxiety Diagnosis",
    subtitle = "Quest – Kitchen Sink – Decision Tree",
    x = "Anxiety Ever Diagnosed", y = "Average Predicted Depression"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11)
  )

plot_edu_ks <- plot(pdp_edu) +
  labs(
    title = "Partial Dependence – Education Level",
    subtitle = "Quest – Kitchen Sink – Decision Tree",
    x = "Education Level", y = "Average Predicted Depression"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11)
  )

# ---- Combine & Save ----
combined_pdp_plot_ks <- plot_anxiety_ks / plot_edu_ks

ggsave(
  filename = here("model_explainability/results/pdp_combined_cleaned_ks.png"),
  plot = combined_pdp_plot_ks,
  width = 10, height = 10,
  dpi = 300
)

# Optional: Save RDA version
save(combined_pdp_plot_ks, file = here("model_explainability/results/pdp_combined_cleaned_ks.rda"))
