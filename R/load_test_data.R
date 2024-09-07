#' Will load the correct test-data for any model.
#' 
#' Any logic can be defined here, how the test-data should look like for any model.
#'
#' @param model_name Could be "arima_1_2021_2023.rds" or "version_0"
#' @param transformed_power_consum Could be cleaned_power_consum. Check example.
#'
#' @return test_power_consum. Correct test-data for any model.
#'
#' @examples
#' \dontrun{
#' # Load PowerConsum Data
#' power_consum_loaded <- load_power_consum(path=power_consum_path)
#' raw_power_consum <- power_consum_loaded$raw_data
#' cleaned_power_consum <- power_consum_loaded$cleaned_data
#' 
#' cleaned_power_consum$localName[is.na(cleaned_power_consum$localName)] = "Working-Day"
#' 
#' aned_power_consum$MeanLastWeek <- rollapply(cleaned_power_consum$PowerConsum, width = 24*8, FUN = function(x) mean(x[1:(24*8-25)]), align = "right", fill = NA) 
#' 
#' aned_power_consum$MeanLastTwoDays <- rollapply(cleaned_power_consum$PowerConsum, width = 24*3, FUN = function(x) mean(x[1:(24*3-25)]), align = "right", fill = NA) 
#' 
#' aned_power_consum$MaxLastOneDay <- rollapply(cleaned_power_consum$PowerConsum, width = 24*2, FUN = function(x) max(x[1:(24*2-25)]), align = "right", fill = NA) 
#' 
#' aned_power_consum$MinLastOneDay <- rollapply(cleaned_power_consum$PowerConsum, width = 24*2, FUN = function(x) min(x[1:(24*2-25)]), align = "right", fill = NA) 
#' 
#' load_test_data("version_0", cleaned_power_consum)
#' }
#' 


load_test_data <- function(model_name, transformed_power_consum) {
  
  test_power_consum <- transformed_power_consum
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
  
  if (model_name == "arima_8_2021_2023.rds") {
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
  
  if (model_name == "arima_7_2021_2023.rds") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        LastDayWasHolodiayAndNotWeekend,
        NextDayIsHolidayAndNotWeekend,
        WorkDay
      )
  }
  
  if (model_name %in% c("version_1", 
                        "version_2", "version_3",
                        "version_4", "version_5",
                        "version_6")) {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidaySmoothed
      )
  }
  
  if (model_name == "version_0") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidaySmoothed
      )
  }
  
  if (model_name == "version_7") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidaySmoothed
      ) |>
      mutate(HolidaySmoothed = Holiday + 0.5*sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
  }
    
  if (model_name == "version_8") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidayExtended,
        HolidaySmoothed
      ) |>
      mutate(HolidaySmoothed = HolidayExtended + 0.5*sin(2 * pi * (as.numeric(Hour)+1) / 24))
  
  }
  
  if (model_name == "version_5") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidayExtended,
        HolidaySmoothed
      )
  }
  
  if (model_name == "version_10") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidayExtended,
        HolidaySmoothed
      ) 
  }
  
  if (model_name == "version_9") {
    test_power_consum <- transformed_power_consum |>
      select(
        MeanLastWeek,
        WorkDay,
        EndOfTheYear,
        FirstWeekOfTheYear, 
        MeanLastTwoDays,
        MaxLastOneDay,
        MinLastOneDay,
        Holiday,
        PowerConsum,
        WorkdayHolidayWeekend,
        Hour,
        HolidayExtended,
        HolidaySmoothed
      ) |>
      mutate(HolidaySmoothed = Holiday + 0.25*sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
  }

  return (test_power_consum)
  
  
}