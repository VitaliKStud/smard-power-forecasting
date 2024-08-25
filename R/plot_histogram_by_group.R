

plot_histogram_by_group <- function(filtered_power_consum,
                                    group_name,
                                    file_name,
                                    colors,
                                    x) {
  p <-
    ggplot(filtered_power_consum, aes(x = !!sym(x), fill = !!sym(group_name))) +
    geom_density(alpha = 0.5) +
    scale_fill_manual(values = colors) +
    theme(legend.position = "top",
          strip.text = element_text(size = 12)) +
    labs(x = "Grid Load", y = "Count")
  
  ggsave(
    file_name,
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
}