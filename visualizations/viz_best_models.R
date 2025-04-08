## Best Models Visualization

# # load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load(here("master_comparison/local_model_results.rda"))

f1_plot_local <- ggplot(local_best_models, aes(x = model, y = f_meas, fill = recipe)) +
  geom_col(position = "dodge") +
  labs(
    title = "Local Platform – F1 Score by Model and Recipe",
    x = "Model", y = "F1 Score"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


accuracy_plot <- ggplot(local_best_models, aes(x = model, y = accuracy, fill = recipe)) +
  geom_col(position = "dodge") +
  labs(
    title = "Local – Accuracy by Model and Recipe",
    y = "Accuracy", x = "Model"
  ) +
  theme_minimal()


roc_plot <- ggplot(local_best_models, aes(x = model, y = roc_auc, fill = recipe)) +
  geom_col(position = "dodge") +
  labs(
    title = "Local – ROC AUC by Model and Recipe",
    y = "ROC AUC", x = "Model"
  ) +
  theme_minimal()

# save plots
ggsave(
  filename = here("visualizations/plots/f1_local_by_model_recipe.png"),
  plot = f1_plot_local,
  width = 10, height = 6, dpi = 300
)

ggsave(
  filename = here("visualizations/plots/accuracy_local_by_model_recipe.png"),
  plot = accuracy_plot,
  width = 10, height = 6, dpi = 300
)

ggsave(
  filename = here("visualizations/plots/rocauc_local_by_model_recipe.png"),
  plot = roc_plot,
  width = 10, height = 6, dpi = 300
)

save(
  f1_plot_local, accuracy_plot, roc_plot,
  file = here("visualizations/plots/local_best_model_plots.rda")
)

