#' Will plot Yearly, Monthly, Daily and Weekly representation of the Data.
#'
#' @param df A DataFrame you want to Plot.
#' @param date_column Column with your Dates. 
#' @param y Y-Value.
#' @param from_year For the Year Plot.
#' @param to_year For the Year Plot.
#' @param from_week For the Week Plot.
#' @param to_week for the Week Plot.
#' @param year_for_week For the Week Plot.
#' @param from_day For the Day Plot.
#' @param to_day For the Day Plot.
#' @param month_for_day For the Day Plot.
#' @param year_for_day For the Day Plot.
#' @param from_month For the Month Plot.
#' @param to_month For the Month Plot.
#' @param year_for_month For the Month Plot.
#' @param holiday Holiday-Column.
#' @param day_of_week DayOfWeek-Column (Mo, Di, Mi...).
#'
#'
#' @examples
#' \dontrun{
# Load PowerConsum Data
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
#' plot_year_month_week_day(
#'   df=cleaned_power_consum,
#'   date_column="DateIndex",
#'   y="PowerConsum",
#'   from_year=2015,
#'   to_year=2024,
#'   from_week=0,
#'   to_week=53,
#'   year_for_week=2018,
#'   from_day=1,
#'   to_day=30,
#'   month_for_day=4,
#'   year_for_day=2018,
#'   from_month=1,
#'   to_month=12,
#'   year_for_month=2018,
#'   holiday="Holiday",
#'   day_of_week = "Weekday"
#' )
#' }
#' 
plot_year_month_week_day <- function(df, date_column, y, 
                                     from_year, to_year,
                                     from_week, to_week, year_for_week, 
                                     from_day, to_day, month_for_day,  year_for_day, 
                                     from_month, to_month, year_for_month,
                                     holiday, day_of_week
                                     ){
  df <- df |>
    mutate(
      date_to_filter = !!sym(date_column),
      Month = as.factor(month(date_to_filter)),
      Year = as.factor(year(date_to_filter)),
      Day = as.factor(day(date_to_filter)),
      DayWithWeek = paste0(as.factor(day(date_to_filter)), as.character(!!sym(day_of_week))),
      Week = as.factor(week(date_to_filter)),
      Holiday = as.factor(!!sym(holiday))
    )
  
  df_year <- df |>
    filter(year(date_to_filter) >= from_year & year(date_to_filter) <= to_year)
  
  df_month <- df |>
    filter(year(date_to_filter) == year_for_month) |>
    filter(month(date_to_filter) >= from_month & month(date_to_filter) <= to_month)
  
  df_week <- df |>
    filter(year(date_to_filter) == year_for_week) |>
    filter(week(date_to_filter) >= from_week & week(date_to_filter) <= to_week)
  
  df_day <- df |>
    filter(year(date_to_filter) == year_for_day) |>
    filter(month(date_to_filter) == month_for_day) |>
    filter(day(date_to_filter) >= from_day & day(date_to_filter) <= to_day) |>
    arrange(Day)

  day_order <- unique(df_day$DayWithWeek)
  
  
  year_plot <- ggplot(data = df_year, aes(x = date_to_filter, y = !!sym(y), color=Holiday)) +
    geom_path(aes(group = 1)) +
    scale_color_manual(values = c("0" = "black", "1" = "darkred"),
                       labels = c("0" = "Normal Day", "1" = "Holiday")) +
    scale_x_datetime(
      date_minor_breaks = "1 month", date_breaks = "2 months",
      date_labels = "%b") +
    facet_wrap(~ Year, scales = "free_x") +
    labs(
      x = "Months",  
      y = "Grid Load",     
      title = "Yearly Grid Load 2015-2023"  
    )
  ggsave("plots\\raw_years.png", plot = year_plot, width = 20, height = 10, dpi = 300)
  
  month_plot <- ggplot(data=df_month, aes(x=date_to_filter, y=!!sym(y), color=Holiday)) +
    geom_path(aes(group = 1)) +
    scale_color_manual(values = c("0" = "black", "1" = "red")) +
    facet_wrap(~ Month, scales = "free_x")+
    labs(
      x = "Days",  
      y = "Date Load",     
      title = "Monthly representation of Grid Load 2018"  
    )
  ggsave("plots\\raw_month.png", plot = month_plot, width = 20, height = 10, dpi = 300)
  
  week_plot <- ggplot(df |> mutate(week_color = ifelse(Week == "1" | Week == "52" | 
                                                              Week == "53",
                                                            "Anfang und Ende des Jahres", 
                                                            "Regulaere Zeit")), 
                      aes(x = Week, y = !!sym(y), color=week_color)) +
    geom_boxplot() +
    theme(
      legend.position = "none", 
      strip.text = element_text(size = 12) 
    ) +
    scale_color_manual(
      name = " ",
      values =  c("Regulaere Zeit" = "darkgrey", "Anfang und Ende des Jahres" = "#FC4E07")) +
    labs(
      x = "Woche",
      y = "Stromverbrauch [MW]"
    )+
    scale_x_discrete(breaks = levels(cleaned_power_consum$Week)[seq(1, length(levels(cleaned_power_consum$Week)), by = 5)]) +
    # theme_minimal() +
    theme(legend.position = "bottom",
          panel.background = element_rect(fill = "#EBEBEB"),
          panel.grid.major = element_line(color = "white"),
          panel.grid.minor = element_line(color = "white"),
          strip.text = element_text(size = 10)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 3)))
  
  
  ggsave("plots\\raw_week.png", plot = week_plot, width = 20, height = 10, dpi = 300)
  
  day_plot <- ggplot(data=df_day, aes(x=date_to_filter, y=!!sym(y), color=Holiday)) +
    geom_path(aes(group = 1)) +
    scale_color_manual(values = c("0" = "black", "1" = "red")) + 
    facet_wrap(~ factor(DayWithWeek, levels=day_order), scales = "free_x", ncol=7) +
    scale_x_datetime(
      date_minor_breaks = "1 hour", date_breaks = "4 hours",
      date_labels = "%H") +
    labs(
      x = "Hours",  
      y = "Grid Load",
      title = "Daily representation of Grid Load for Apr. 2018"  
    )
  ggsave("plots\\raw_day.png", plot = day_plot, width = 20, height = 10, dpi = 300)

}