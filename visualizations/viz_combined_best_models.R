# ---- Load Libraries ----
library(tidyverse)
library(here)
library(patchwork)

# ---- Load Data ----
load(here("master_comparison/local_model_results.rda"))   # loads local_best_models
load(here("master_comparison/quest_model_results.rda"))   # loads quest_best_models

# ---- Combine & Clean ----
combined_best <- bind_rows(local_best_models, quest_best_models) |>
  mutate(
    model = str_to_title(model),  # standardize labels: "knn" → "Knn"
    recipe = factor(recipe, levels = c("Kitchen Sink", "M1", "M2", "M3", "M4"))
  )

# ---- Create Plot Function (DRY principle) ----
create_metric_plot <- function(data, metric, metric_label) {
  ggplot(data, aes(x = recipe, y = .data[[metric]], fill = model)) +
    geom_col(position = "dodge") +
    facet_wrap(~ platform) +
    labs(
      title = glue::glue("{metric_label} by Recipe and Model (Local vs Quest)"),
      x = "Recipe", y = metric_label
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# ---- Generate Plots ----
f1_plot       <- create_metric_plot(combined_best, "f_meas", "F1 Score")
roc_plot      <- create_metric_plot(combined_best, "roc_auc", "ROC AUC")
accuracy_plot <- create_metric_plot(combined_best, "accuracy", "Accuracy")

# ---- Combine Plots Vertically ----
combined_plot <- f1_plot / roc_plot / accuracy_plot +
  plot_annotation(title = "Model Performance Metrics by Recipe and Platform")

# ---- Save Individual Plots ----
ggsave(here("visualizations/plots/f1_comparison_by_model_recipe.png"),       f1_plot,       width = 10, height = 6, dpi = 300)
ggsave(here("visualizations/plots/rocauc_comparison_by_model_recipe.png"),   roc_plot,      width = 10, height = 6, dpi = 300)
ggsave(here("visualizations/plots/accuracy_comparison_by_model_recipe.png"), accuracy_plot, width = 10, height = 6, dpi = 300)

# ---- Save Combined Plot ----
ggsave(here("visualizations/plots/combined_model_performance_metrics.png"), combined_plot, width = 12, height = 14, dpi = 300)

# ---- Save All as .rda for Reuse ----
save(f1_plot, roc_plot, accuracy_plot, combined_plot,
     file = here("visualizations/plots/combined_model_comparison_plots.rda"))
