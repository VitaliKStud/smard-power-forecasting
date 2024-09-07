#' Will Plot two variables against each other as as geom_point plot.
#'
#' @param cleaned_power_consum your data
#' @param file_name Will be safed here
#' @param x X-Values
#' @param y Y-Values
#' @param x_label Label for x-axis
#' @param y_label Label for y-axis
#'
#' @examples
#' 
#' \dontrun{
#' power_consum_path <- "dataset\\stunde_2015_2024\\Realisierter_Stromverbrauch_201501010000_202407090000_Stunde.csv"
#' # Load PowerConsum Data
#' power_consum_loaded <- load_power_consum(path=power_consum_path)
#' raw_power_consum <- power_consum_loaded$raw_data
#' cleaned_power_consum <- power_consum_loaded$cleaned_data
#' 
#' cleaned_power_consum$localName[is.na(cleaned_power_consum$localName)] = "Working-Day"
#' 
#' cleaned_power_consum$MeanLastWeek <- rollapply(cleaned_power_consum$PowerConsum, width = 24*8, FUN = function(x) mean(x[1:(24*8-25)]), align = "right", fill = NA) 
#' 
#' cleaned_power_consum$MeanLastTwoDays <- rollapply(cleaned_power_consum$PowerConsum, width = 24*3, FUN = function(x) mean(x[1:(24*3-25)]), align = "right", fill = NA) 
#' 
#' cleaned_power_consum$MaxLastOneDay <- rollapply(cleaned_power_consum$PowerConsum, width = 24*2, FUN = function(x) max(x[1:(24*2-25)]), align = "right", fill = NA) 
#' 
#' cleaned_power_consum$MinLastOneDay <- rollapply(cleaned_power_consum$PowerConsum, width = 24*2, FUN = function(x) min(x[1:(24*2-25)]), align = "right", fill = NA) 
#' 
#' plot_calculated_features(
#' cleaned_power_consum = cleaned_power_consum,
#' file_name = "plots/MinLastOneDay.png", 
#' x = "MinLastOneDay", 
#' y = "PowerConsum", 
#' x_label = "Minimaler Stromverbrauch vom letzten Tag [MW]",
#' y_label = "Stromverbrauch [MW]"
#' )
#' }

plot_calculated_features <- function(cleaned_power_consum, file_name, x, y, x_label, y_label){

  p <- ggplot(cleaned_power_consum |> mutate(WorkDay = as.factor(WorkDay)), 
              aes(x=!!sym(x), y=!!sym(y), color=WorkDay)) +
    geom_point(alpha=0.5, size=0.2) +
    scale_color_manual(
      name = " ",
      values =  c("1" = "#2E9FDF", "0" = "#FC4E07"),
      labels = c(
        "1" = "Werktag",
        "0" = "Wochenende oder Feiertag"
      )) +
    labs(x = x_label, y = y_label) +
    theme(legend.position = "bottom",
          panel.background = element_rect(fill = "#EBEBEB"),
          panel.grid.major = element_line(color = "white"),
          panel.grid.minor = element_line(color = "white"),
          strip.text = element_text(size = 10)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 3)))
  
  ggsave(
    file_name,
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )

}
