#' Will represent LHM and DHR as own components.
#'
#' @param raw_fc_ensembled Should be Forecast Data with the best Model.
#' @param path_dhm Path to the ARIMA model (DHM).
#' @param path_lhm Path to the Linear-Model (LHM).
#' @param from_month From Which Month the Plot should be. 
#' @param to_month Until Which Month the Plot should be.
#'
#'
#' @examples
#' \dontrun{
#' ensembled_fc <- load_ensembled_models(
#' days_to_forecast = 40,
#' months_to_forecast = 6,
#' year_to_forecast = 2024,
#' starting_month = 1,
#' real_data = cleaned_power_consum,
#' smard_fc = cleaned_smard_pred,
#' model_path = "ensemble_model"
#' )
#' all_forecasts_ensembled <- ensembled_fc$all_forecasts
#' raw_fc_ensembled <- ensembled_fc$raw_forecasts
#' 
#' # LHM DHM representation
#' plot_representation_of_lhm_dhm_components(path_dhm = "ensemble_model/version_5/arima_2021_2023.rds",
#'                                           path_lhm = "ensemble_model/version_5/holiday_effect_2021_2023.rds",
#'                                           from_month = 1,
#'                                           to_month = 1,
#'                                           raw_fc_ensembled = raw_fc_ensembled)
#' }
#' 
plot_representation_of_lhm_dhm_components <- function(raw_fc_ensembled, path_dhm, path_lhm, from_month, to_month) {
  
  
  fc_v0_linear <- raw_fc_ensembled[[path_lhm]]
  fc_v0_arima <- raw_fc_ensembled[[path_dhm]]
  fc_v0_arima$linear_fc_before <- fc_v0_linear
  
  
  fc_v0_arima <- fc_v0_arima |>
    filter(month(DateIndex) >= from_month & month(DateIndex) <= to_month)
  
  
  p <- ggplot(fc_v0_arima, aes(x=DateIndex)) +
    geom_line(aes(y = PowerConsum, color = "PowerConsum")) +
    geom_line(aes(y = .mean, color = "DHM")) +
    geom_line(aes(y = linear_fc_before, color = "LHM")) +
    geom_line(aes(y = .mean + linear_fc_before, color = "LHM + DHM")) +
    scale_color_manual(
      name = "Legend",
      values = c(
        "PowerConsum" = "#2E9FDF",
        "DHM" = "orange",
        "LHM" = "black",
        "LHM + DHM" = "#FC4E07"
      )
    )

  
  ggsave("plots/lhm_dhm_representation.png",   
         plot = p,
         width = 5.5,
         height = 3.7,
         dpi = 600)
  
  
}