#' Plot best Model for single Models
#'
#' @param all_forecasts Should be all Forecasted values for all Models.
#' @param metric_results Alle the metrics for all Models (Best Model will be extracted here)
#' @param cleaned_power_consum Cleaned Power Consum Data
#' @param raw_fc Raw Forecast Data
#' @param month_to_plot Until which month the best Forecast should be plotted?
#' @param days_to_plot How many days you want to plot? 
#' 
#' @return name_of_best_model Could be for example "version_0"
#' 
#' @examples
#' \dontrun{
# Load Smard Predictions
#' power_consum_smard_prediction_loaded <- load_power_consum(path=power_consum_smard_prediction_path)
#' raw_smard_pred <- power_consum_smard_prediction_loaded$raw_data
#' cleaned_smard_pred <- power_consum_smard_prediction_loaded$cleaned_data
#' 
#' cleaned_smard_pred <- cleaned_smard_pred |>
#'   mutate(.model = "SMARD")
#' names(cleaned_smard_pred)[names(cleaned_smard_pred) == "PowerConsum"] <- ".mean"
#' 
#' # Load PowerConsum Data
#' power_consum_loaded <- load_power_consum(path=power_consum_path)
#' raw_power_consum <- power_consum_loaded$raw_data
#' cleaned_power_consum <- power_consum_loaded$cleaned_data
#' 
#' 
#' ensembled_fc <- load_ensembled_models(
#'   days_to_forecast = 40,
#'   months_to_forecast = 6,
#'   year_to_forecast = 2024,
#'   starting_month = 1,
#'   real_data = cleaned_power_consum,
#'   smard_fc = cleaned_smard_pred,
#'   model_path = "ensemble_model"
#' )
#' all_forecasts_ensembled <- ensembled_fc$all_forecasts
#' raw_fc_ensembled <- ensembled_fc$raw_forecasts
#' 
#' fc <- load_all_model_results(
#'   days_to_forecast = 40,
#'   months_to_forecast = 6,
#'   year_to_forecast = 2024,
#'   starting_month = 1,
#'   smard_fc = cleaned_smard_pred,
#'   real_data = cleaned_power_consum
#' )
#' 
#' all_forecasts <- fc$combined_forecasts
#' raw_fc <- fc$raw_forecasts
#' 
#' 
#' metric_results <- calculate_metrics(fc_data = all_forecasts, fc_data_ensembled=all_forecasts_ensembled)
#' 
#' # Plot best Model for single Models
#' name_of_best_model_for_single_model <- plot_forecast(
#'   all_forecasts = all_forecasts,
#'   metric_results = metric_results,
#'   cleaned_power_consum = cleaned_power_consum,
#'   raw_fc = raw_fc,
#'   month_to_plot = 1,
#'   days_to_plot = 40
#' )
#' }
#' 
#' 
plot_forecast <- function(all_forecasts, metric_results, cleaned_power_consum, raw_fc,
                          month_to_plot, days_to_plot) {
  
  best_forecast <- metric_results |>
    filter(!(.model == "SMARD")) |>
    filter(ensembled == FALSE) |>
    filter(MAPE == min(MAPE[MAPE > 0])) |>
    slice(1) |>
    select(.model)
  
  
  name_of_best_model <- best_forecast$.model
  
  print("Best Model is:")
  print(name_of_best_model)
  
  filtered_best_forecast <- all_forecasts |>
    filter(.model == name_of_best_model) |>
    left_join(cleaned_power_consum |> rename(RealPowerConsum = PowerConsum,
                                             WorkingDay = WorkDay,
                                             WorkdayHolidayWeekendr = WorkdayHolidayWeekend), by = "DateIndex") |>
    mutate(WorkDay = as.factor(WorkDay))
  
  single_best_forecast <- raw_fc[[name_of_best_model]] |>
    filter(month(DateIndex) <= month_to_plot) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter(year(DateIndex) == 2024)
  
  filtered_power_consum <- cleaned_power_consum |>
    mutate(PowerConsum = PowerConsum) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter((year(DateIndex) == 2024 & month(DateIndex) <= month_to_plot)  
           | (year(DateIndex) == 2023 & month(DateIndex) == 12))
  
  smard_fc <- all_forecasts |>
    filter(.model == "SMARD") |>
    filter(month(DateIndex) <= month_to_plot) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter(year(DateIndex) == 2024)
  
  p <- autoplot(single_best_forecast, color = "#FC4E07") +
    # geom_line(data = smard_fc,
    #           lwd = 0.2,
    #           aes(x = DateIndex, y = .mean, color = "SMARD")) +
    geom_line(data = filtered_power_consum,
              lwd = 0.2,
              aes(x = DateIndex, y = PowerConsum, color = "Real Obs.")) +
    geom_line(data = single_best_forecast,
              lwd = 0.2 ,
              aes(x = DateIndex, y = .mean, color =
                    "Forecast")) +
    theme(legend.position = "bottom", strip.text = element_text(size = 12)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 2), title = " "),
           fill = guide_legend(title = " "))+
    scale_color_manual(
      values = c(
        name = " ",
        "SMARD" = "darkgrey",
        "Real Obs." = "#2E9FDF",
        "Forecast" = "#FC4E07"
      ),
      labels = c(
        "SMARD" = "SMARD",
        "Real Obs." = "Tatsaechliche \nStromverbrauch",
        "Forecast" = "ARIMA"
      )
    ) +
    labs(level = "Level")
  
  
  ggsave(
    paste0("plots/",name_of_best_model, ".png"),
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
  
  p <- ggplot()+
    geom_point(data = filtered_best_forecast, aes(x=RealPowerConsum, y=.mean, color=WorkdayHolidayWeekendr), alpha=0.5, size=0.5) +
    geom_abline(slope = 1, intercept = 0, color = "black", lwd=0.5, alpha=0.5) +
    xlim(30000, 80000) + 
    ylim(30000, 80000) + 
    scale_color_manual(
      values = c(
        name = " ",
        "Feiertag\nKein Wochenende" = "#FF9100",
        "Kein Feiertag\nKein Wochenende" = "#2E9FDF",
        "Kein Feiertag\nWochenende" = "#FC4E07"
      )) +
    theme(legend.position = "bottom", strip.text = element_text(size = 12)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 2), title = " "),
           fill = guide_legend(title = " "))
  
  ggsave(
    paste0("plots/real_to_fc_",name_of_best_model, ".png"),
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
  
  return(name_of_best_model)
  
}
  
  
  