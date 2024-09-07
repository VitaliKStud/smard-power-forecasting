#' Calculate Metrics
#'
#' This function will calculate MAPE, MAE and RMSE for all your Forecasts
#'
#' @param fc_data class: "tbl_df" "tbl" "data.frame" with columns (.mean, PowerConsum, DateIndex).
#' Use \link{load_all_model_results} to get data from the .rds models.
#' @param fc_data_ensembled class: "tbl_df" "tbl" "data.frame" with columns (.mean, PowerConsum, DateIndex, .model).
#' Use \link{load_ensembled_models} to get data from ensembled .rds models.
#' 
#' @return Metrics for all models
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
#' }
#' 


calculate_metrics <- function(fc_data, fc_data_ensembled){
  filtered_real_data <- fc_data |>
    filter(.model == "RealObservations") |>
    mutate(PowerConsum = .mean)

  results <- filtered_real_data |>
    select(DateIndex, PowerConsum) |>
    as_tibble(index="DateIndex") |>
    rename(RealPowerConsum = PowerConsum) |>
    right_join(fc_data, by = "DateIndex")
  
  metrics_by_model <- results |>
    group_by(.model) |>
    summarize(
      RMSE = sqrt(mean((RealPowerConsum - .mean)^2, na.rm = TRUE)),
      MAPE = mean(abs((RealPowerConsum - .mean) / RealPowerConsum), na.rm = TRUE) * 100, 
      MAE = mean(abs(RealPowerConsum - .mean), na.rm = TRUE) 
    )
  
  metrics_by_model$ensembled = FALSE
  
  filtered_real_data <- fc_data_ensembled |>
    filter(.model == "RealObservations") |>
    mutate(PowerConsum = .mean)
  
  results <- filtered_real_data |>
    select(DateIndex, PowerConsum) |>
    as_tibble(index="DateIndex") |>
    rename(RealPowerConsum = PowerConsum) |>
    right_join(fc_data_ensembled, by = "DateIndex")
  
  metrics_by_model_ensembled <- results |>
    group_by(.model) |>
    summarize(
      RMSE = sqrt(mean((RealPowerConsum - .mean)^2, na.rm = TRUE)),
      MAPE = mean(abs((RealPowerConsum - .mean) / RealPowerConsum), na.rm = TRUE) * 100, 
      MAE = mean(abs(RealPowerConsum - .mean), na.rm = TRUE) 
    )
  
  metrics_by_model_ensembled$ensembled = TRUE
  
  metrics_by_model <- metrics_by_model |>
    bind_rows(metrics_by_model_ensembled)
  
  
  return (metrics_by_model)
  
}