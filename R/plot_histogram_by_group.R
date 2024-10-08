#' Will create a Histogram for different Groups.
#'
#' @param filtered_power_consum Time Series you want to Plot.
#' @param group_name Column which represents a single group.
#' @param file_name Path and Name of the File, where the plot will be safed.
#' @param colors Self-Defined Colors.
#' @param x x-Values
#' @param x_label Label for x-Axis
#' @param y_label Label for y-Axis
#' @param name_0 Names for "0" from group_name
#' @param name_1 Names for "1" from group_name
#'
#' @examples
#' 
#' \dontrun{
# Load PowerConsum Data
#' power_consum_loaded <- load_power_consum(path=power_consum_path)
#' raw_power_consum <- power_consum_loaded$raw_data
#' cleaned_power_consum <- power_consum_loaded$cleaned_data
#' 
#' # Plot
#' plot_histogram_by_group(
#'   cleaned_power_consum,
#'   group_name = "WorkDay",
#'   file_name = "plots\\workday_histogram.png",
#'   colors = c("1" = "#2E9FDF", "0" = "#FC4E07"),
#'   x="PowerConsum",
#'   x_label = "Stromverbrauch [MW]",
#'   y_label = "Häufigkeit",
#'   name_0 = "Wochenende oder Feiertage",
#'   name_1 = "Werktag"
#' )
#' }
#' 
plot_histogram_by_group <- function(filtered_power_consum,
                                    group_name,
                                    file_name,
                                    colors,
                                    x,
                                    x_label,
                                    y_label,
                                    name_0,
                                    name_1) {
  filtered_power_consum <- filtered_power_consum |>
    mutate(Group = as.factor(!!sym(group_name)))
  
  p <-
    ggplot(filtered_power_consum, aes(x = !!sym(x), fill = Group )) +
    geom_histogram(alpha = 0.5, binwidth = 200, position = "dodge") +
    geom_density(fill=NA, aes(color = Group, y=200 * after_stat(count))) + 
    theme(legend.position = "bottom",
          strip.text = element_text(size = 10)) +
    labs(x = x_label, y = y_label) +
    scale_fill_manual(
      name = " ",
      values = colors,
      labels = c(
        "1" = name_1,
        "0" = name_0
      )
    ) +
    scale_color_manual(
      values = colors
    ) + 
  guides(color = "none") +
  scale_y_continuous(labels = label_comma())
  
  ggsave(
    file_name,
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
}