#' Will compare Residuals for SMARD with LHR + DHR Model, also ACF / PACF Plots for SMARD and LHR + DHR
#'
#' @param all_forecasts Should be all Forecasted values for all Models.
#' @param name_of_best_model The name of the best model (could be "version_0" for example).
#' 
#' @examples
#' \dontrun{
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
#' # Plot best Model for ensembled Models
#' name_of_best_model_ensembled <- plot_forecast_ensembled(
#'   all_forecasts = all_forecasts_ensembled,
#'   metric_results = metric_results,
#'   cleaned_power_consum = cleaned_power_consum,
#'   month_to_plot = 1,
#'   days_to_plot = 40
#' )
#' 
#' plot_compare_with_smard(
#'   all_forecasts = all_forecasts_ensembled, 
#'   name_of_best_model = name_of_best_model_ensembled
#' )
#' 
#' }
#' 
#' 
plot_compare_with_smard <- function(all_forecasts, name_of_best_model) {
  
  all_forecasts_ensembled_v_filter <- all_forecasts_ensembled |>
    filter(.model == name_of_best_model | .model == "SMARD") |>
    mutate(.res = PowerConsum - .mean,
           model_name = ifelse(.model == name_of_best_model, "0", "1"))
  
  best_forecast <- all_forecasts_ensembled_v_filter |>
    filter(.model == name_of_best_model) 
  
  smard_fc <- all_forecasts_ensembled_v_filter |>
    filter(.model == "SMARD")
  
  # Raw .res
  p <- ggplot() + 
    geom_line(data = smard_fc, aes(x = DateIndex, y = .res, color = "SMARD")) +
    geom_line(data = best_forecast, aes(x = DateIndex, y = .res, color = "LHM + DHR"))
  
  ggsave("plots/raw_smard_lhr_dhr_res.png",   
         plot = p,
         width = 5.5,
         height = 3.7,
         dpi = 600)
  
  
  # Histogram for .res
  plot_histogram_by_group(
    all_forecasts_ensembled_v_filter,
    group_name = "model_name",
    file_name = "plots\\smard_lhm_dhr_res_histogram.png",
    colors = c("1" = "#2E9FDF", "0" = "#FC4E07"),
    x=".res",
    x_label = ".res",
    y_label = "Häufigkeit",
    name_0 = "LHM + DHR",
    name_1 = "SMARD"
  )
  
  # ACF PACF
  p <- best_forecast |>
    as_tsibble(index=DateIndex) |>
    gg_tsdisplay(.res, plot_type = "partial", lag = 100)
  
  ggsave("plots/acf_pacf_best_forecast.png",   
         plot = p,
         width = 5.5,
         height = 3.7,
         dpi = 600)
  
  
  # ACF PACF
  p <- smard_fc |>
    as_tsibble(index=DateIndex) |>
    gg_tsdisplay(.res, plot_type = "partial", lag = 100)
  
  ggsave("plots/acf_pacf_smard_forecast.png",   
         plot = p,
         width = 5.5,
         height = 3.7,
         dpi = 600)
  
}