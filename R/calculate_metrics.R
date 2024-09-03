
calculate_metrics <- function(fc_data){
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
      RMSE = sqrt(mean((RealPowerConsum - .mean)^2, na.rm = TRUE)),  # Calculate RMSE
      MAPE = mean(abs((RealPowerConsum - .mean) / RealPowerConsum), na.rm = TRUE) * 100,  # Calculate MAPE
      MAE = mean(abs(RealPowerConsum - .mean), na.rm = TRUE)  # Calculate MAE
    )
  
  return (metrics_by_model)
  
}