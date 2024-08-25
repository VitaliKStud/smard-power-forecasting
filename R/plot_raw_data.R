

plot_raw_data <- function(df, x, y, color, missing_value, file_name) {
  duplicated_data <- raw_power_consum |>
    filter(!!sym(color) == TRUE)
  
  missing_data <- raw_power_consum |>
    filter(!!sym(missing_value) == TRUE)
  
  p <- ggplot(df, aes(x = !!sym(x), y = !!sym(y))) +
    geom_line(aes(color = "Regular Data"), lwd = 0.1) +
    geom_point(
      data = duplicated_data,
      aes(
        x = !!sym(x),
        y = !!sym(y),
        color = "Duplicated Data",
      ),
      shape=18,
      size = 1.8
    ) +
    geom_point(data = missing_data,
               aes(
                 x = !!sym(x),
                 y = !!sym(y),
                 color = "Missing Data",
               ),
               shape=16,
               size = 1.8) +
    scale_color_manual(
      name = "Data Type",
      values = c(
        "Regular Data" = "#000000",
        "Duplicated Data" = "orange",
        "Missing Data" = "#FF0000"
      ),
      labels = c(
        "Regular Data" = "Regular Data",
        "Duplicated Data" = "Duplicated Data",
        "Missing Data" = "Missing Data"
      )
    ) +
    labs(
      title = "Grid Load Over Time",
      x = "Date",
      y = "Grid Load (MW)",
      color = "Data Type"
    ) +
    theme(
      plot.title = element_text(
        size = 14,
        face = "bold",
        hjust = 0.5
      ),
      legend.position = "bottom",
    )
  
  p
  
  ggsave(
    file_name,
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
  
}