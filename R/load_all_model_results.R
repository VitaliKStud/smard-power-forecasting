

load_all_model_results <- function(days_to_forecast, months_to_forecast,
                                   year_to_forecast, starting_month, smard_fc, real_data) {
  
  all_forecasts <- list()

  for(file in list.files("model")) {
    
    
    fit <- readRDS(paste0("model/", file))
    print(file)
    test_data <- load_test_data(model_name=file, 
                                transformed_power_consum = real_data)
    
    filtered_test_data <- test_data |>
      filter(year(DateIndex) == year_to_forecast) |> 
      filter(month(DateIndex) >= starting_month) |> 
      filter(month(DateIndex) <= months_to_forecast) |>
      filter(day(DateIndex) < days_to_forecast) |>
      as_tsibble()
    
    fc <- fit |>
      forecast(new_data = filtered_test_data) |>
      as_tsibble(index=DateIndex) |>
      as_tibble() |>
      mutate(.model = file)
      
    all_forecasts[[file]] <- fc
      
  }
  
  filtered_real_data <- real_data |>
    filter(year(DateIndex) == year_to_forecast) |>
    filter(month(DateIndex) >= starting_month) |>
    filter(month(DateIndex) <= months_to_forecast) |>
    filter(day(DateIndex) < days_to_forecast) |>
    distinct(DateIndex, .keep_all = TRUE) |>
    mutate(.model = "RealObservations",
           .mean = PowerConsum)
  
  smard_fc <- smard_fc |>
    distinct(DateIndex, .keep_all = TRUE)
  
  combined_forecasts <- all_forecasts |>
    bind_rows() |>
    bind_rows(smard_fc) |>
    bind_rows(filtered_real_data) |>
    select(.model, DateIndex, PowerConsum, .mean, WorkDay, Holiday)
  
  return (list(combined_forecasts = combined_forecasts, all_forecasts = all_forecasts))
}