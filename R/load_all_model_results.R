#' Title
#'
#' @param days_to_forecast Number of Days you want to include in your Forecast. If you need to forecast more then
#' 1 month you could use days_to_forecast > 31.
#' @param months_to_forecast Number of months you want to include in your Forecast.
#' @param year_to_forecast The year you want to forecast.
#' @param starting_month Depend on where you fit ends, you need a "starting_month" Could be 1 for January.
#' @param smard_fc SMARD Forecast Data
#' @param real_data Cleaned PowerConsum Data
#' Use \link{load_power_consum()} here to get "smard_fc" and "real_data"
#'
#' @return list(combined_forecasts = combined_forecasts, raw_forecasts = raw_forecasts). Will return a list of combined Forecasts
#' and Raw Forecasts (nested).
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' fc <- load_all_model_results(
#'   days_to_forecast = 40,
#'   months_to_forecast = 6,
#'   year_to_forecast = 2024,
#'   starting_month = 1,
#'   smard_fc = cleaned_smard_pred, # load_power_consum(path)
#'   real_data = cleaned_power_consum # load_power_consum(path)
#' )
#' 
#' all_forecasts <- fc$combined_forecasts
#' raw_fc <- fc$raw_forecasts
#' }


load_all_model_results <- function(days_to_forecast, months_to_forecast,
                                   year_to_forecast, starting_month, smard_fc, real_data) {
  
  all_forecasts <- list()
  raw_forecasts <- list()

  for(file in list.files("model")) {
    
    print(file)
    fit <- readRDS(paste0("model/", file))
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
    
    raw_fc <- fit |>
      forecast(new_data = filtered_test_data)
    raw_forecasts[[file]] <- raw_fc
    
    
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
    select(.model, DateIndex, PowerConsum, .mean, WorkDay, Holiday, WorkdayHolidayWeekend)
  
  return (list(combined_forecasts = combined_forecasts, raw_forecasts = raw_forecasts))
}