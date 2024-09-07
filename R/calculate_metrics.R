
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