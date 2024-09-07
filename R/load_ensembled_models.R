#' Loading all ensembled Models
#'
#' This function will load all LHM and DHM models and combine them together, make forecasts.
#'
#' @param days_to_forecast i.r. can be more then 32 will forecast max. of this days
#' @param months_to_forecast Will Forecast the number of this months
#' @param year_to_forecast Will Forecast this year
#' @param starting_month Should be 1 (January) if your Fit ends on 31.12
#' @param real_data Check \link{example/forecast.Rmd} should be cleaned_power_consum
#' @param smard_fc Data of smard_fc check \link{example/forecast.Rmd} should be cleaned_smard_pred

load_ensembled_models <- function(days_to_forecast, months_to_forecast,
                                  year_to_forecast, starting_month, real_data,
                                  smard_fc) {
  
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
  
    for (version in list.files("ensemble_model")) {
      print(version)
      for(file in list.files(paste0("ensemble_model/", version))) {
        
        if (grepl("holiday", file)) {
          full_path_holiday <- paste0("ensemble_model/",version,"/",file)
        }
        
        if (grepl("arima", file)) {
          full_path_arima <- paste0("ensemble_model/",version,"/",file)
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
  