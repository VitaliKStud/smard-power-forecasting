#' This function will create plots for a selected column.
#'
#' @param df Your data as DataFrame or Time-Series.
#' @param title Title of the Plot (show in the header).
#' @param x Select a Column for x-values.
#' @param y Select a Column for y-values.
#' @param x_label Label of x-axis.
#' @param y_labe Label of y-axis.
#' @param file_name Plot will be saved with this name.

#' @return None
#'
#' @examples
#' \dontrun{
#' 
#' # Load PowerConsum Data
#' power_consum_loaded <- load_power_consum(path=power_consum_path)
#' raw_power_consum <- power_consum_loaded$raw_data
#' cleaned_power_consum <- power_consum_loaded$cleaned_data
#' 
#' plot_by_column(
#'   df = cleaned_power_consum,
#'   x = "Hour",
#'   y = "PowerConsum",
#'   x_label = "Stunden",
#'   y_label = "Stromverbrauch [MW]",
#'   file_name = "plots\\hour_boxplot.png",
#'   title = "Übersicht der einzelnen Stunden"
#' )
#'}
#'

plot_by_column <- function(df, x, y, title, x_label, y_label, file_name){
  
  p <- ggplot(df, aes(x = !!sym(x), y = !!sym(y))) +
  geom_boxplot() +
  theme(
    legend.position = "none", 
    strip.text = element_text(size = 12) 
  ) +
  labs(
    title = title,
    x = x_label,
    y = y_label
  )

  ggsave(file_name, plot = p, width = 20, height = 10, dpi = 300)
}



