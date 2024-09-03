

load_test_data <- function(model_name, transformed_power_consum) {
  
  
  if (model_name == "arima_1_2021_2023.rds") {
    test_power_consum <- transformed_power_consum |>
      select(
        WorkDay,
        Holiday,
        MeanLastWeek,
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay
      )
  }
  
  if (model_name %in% c("arima_0_2021_2023.rds",
                        "arima_2_2021_2023.rds", 
                        "arima_4_2021_2023.rds",
                        "arima_6_2021_2023.rds",
                        "arima_5_2021_2023.rds",
                        "tslm_0_2021_2023.rds",
                        "prophet_0_2021_2023.rds")) {
    test_power_consum <- transformed_power_consum |>
      select(
        WorkDay,
        Holiday,
        MeanLastWeek,
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        LastDayWasHolodiayAndNotWeekend,
        NextDayIsHolidayAndNotWeekend
      )
  }
  
  if (model_name %in% c("mean_2021_2023.rds",
                        "drift_2021_2023.rds",
                        "naive_2021_2023.rds")) {
    test_power_consum <- transformed_power_consum |>
      select(
        DateIndex
      )
  }
  
  if (model_name == "arima_3_2021_2023.rds") {
    test_power_consum <- transformed_power_consum |>
      select(
        WorkDay,
        Holiday,
        LastDayWasHolodiayAndNotWeekend,
        NextDayIsHolidayAndNotWeekend
      )
  }

  return (test_power_consum)
  
  
}