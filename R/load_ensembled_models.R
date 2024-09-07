#' Loading all ensembled Models
#'
#' This function will load all LHM and DHM models and combine them together, make forecasts.
#'
#' @param days_to_forecast Number of Days you want to include in your Forecast. If you need to forecast more then
#' 1 month you could use days_to_forecast > 31.
#' @param months_to_forecast Number of months you want to include in your Forecast.
#' @param year_to_forecast The year you want to forecast.
#' @param starting_month Depend on where you fit ends, you need a "starting_month" Could be 1 for January.
#' @param smard_fc SMARD Forecast Data
#' @param real_data Cleaned PowerConsum Data
#' @param model_path Should be the folder with "Versions"
#' 
#' #' Use \link{load_power_consum()} here to get "smard_fc" and "real_data"
#'
#' @return list(all_forecasts = combined_forecasts, raw_forecasts = raw_forecasts). Will return a list of combined Forecasts
#' and Raw Forecasts (nested).
#' @export
#'
#' @examples
#' 
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
#' }

load_ensembled_models <- function(days_to_forecast, months_to_forecast,
                                  year_to_forecast, starting_month, real_data,
                                  smard_fc, model_path) {
  
    all_forecasts <- list()
    raw_forecasts <- list()
    
    filtered_real_data <- real_data |>
      filter(year(DateIndex) == year_to_forecast) |>
      filter(month(DateIndex) >= starting_month) |>
      filter(month(DateIndex) <= months_to_forecast) |>
      filter(day(DateIndex) < days_to_forecast) |>
      distinct(DateIndex, .keep_all = TRUE) |>
      mutate(.model = "RealObservations",
             .mean = PowerConsum)
  
    for (version in list.files(model_path)) {
      print(version)
      for(file in list.files(paste0(model_path, "/", version))) {
        
        if (grepl("holiday", file)) {
          full_path_holiday <- paste0(model_path, "/",version,"/",file)
        }
        
        if (grepl("arima", file)) {
          full_path_arima <- paste0(model_path, "/",version,"/",file)
        }
      }
      fit_arima <- readRDS(full_path_arima)
      fit_holiday <- readRDS(full_path_holiday)

      test_data <- load_test_data(model_name=version, 
                                  transformed_power_consum = real_data)
      filtered_test_data <- test_data |>
        filter(year(DateIndex) == year_to_forecast) |> 
        filter(month(DateIndex) >= starting_month) |> 
        filter(month(DateIndex) <= months_to_forecast) |>
        filter(day(DateIndex) < days_to_forecast) |>
        as_tsibble()
      
      raw_fc_holiday <- predict(fit_holiday, newdata = filtered_test_data)
      raw_forecasts[[full_path_holiday]] <- raw_fc_holiday
      
      raw_fc_arima <- fit_arima |>
        forecast(new_data = filtered_test_data)
      raw_forecasts[[full_path_arima]] <- raw_fc_arima
      
      filtered_test_data$holiday_fc <- predict(fit_holiday, newdata = filtered_test_data)
      
      arima_fc <- forecast(fit_arima, new_data = filtered_test_data) |>
        mutate(MU = parameters(Residuals)$mu + filtered_test_data$holiday_fc,
               SIGMA = parameters(Residuals)$sigma,
               LOWER_BOUND = MU - 1.96 * SIGMA,
               UPPER_BOUND = MU + 1.96 * SIGMA)
      filtered_test_data$.mean <- arima_fc$MU
      filtered_test_data$lower_bound <- arima_fc$LOWER_BOUND
      filtered_test_data$upper_bound <- arima_fc$UPPER_BOUND
      filtered_test_data$.model <- version
      
      filtered_test_data <- filtered_test_data |> 
        as_tsibble(index=DateIndex) |>
        as_tibble()
      
      all_forecasts[[version]] <- filtered_test_data
      
    }
    smard_fc <- smard_fc |>
      left_join(filtered_real_data |> select(PowerConsum, DateIndex),
                by = "DateIndex") |>
      distinct(DateIndex, .keep_all = TRUE) 
    
    combined_forecasts <- all_forecasts |>
      bind_rows() |>
      bind_rows(smard_fc) |>
      bind_rows(filtered_real_data) |>
      select(.model, DateIndex, PowerConsum, .mean, WorkDay, Holiday, WorkdayHolidayWeekend,
             lower_bound, upper_bound)
    
  return(list(all_forecasts = combined_forecasts, raw_forecasts = raw_forecasts))
      
    }
  