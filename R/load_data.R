#'  Will load Power Consum Data and clean up
#'
#' @param path path Should be the path to your .csv File 
#'
#' @return list(raw_data = raw_data, cleaned_data = cleaned_data). Return raw data and cleaned
#'
#' @examples
#'\dontrun{
#' # Define datapaths
#' power_consum_path <- "dataset\\stunde_2015_2024\\Realisierter_Stromverbrauch_201501010000_202407090000_Stunde.csv"
#' power_consum_smard_prediction_path <- "dataset\\propgnose_vom_smard\\Prognostizierter_Stromverbrauch_202401010000_202407090000_Stunde.csv"
#' 
#' # Load Smard Predictions
#' power_consum_smard_prediction_loaded <- load_power_consum(path=power_consum_smard_prediction_path)
#' raw_smard_pred <- power_consum_smard_prediction_loaded$raw_data
#' cleaned_smard_pred <- power_consum_smard_prediction_loaded$cleaned_data
#' 
#' cleaned_smard_pred <- cleaned_smard_pred |>
#'   mutate(.model = "SMARD")
#' names(cleaned_smard_pred)[names(cleaned_smard_pred) == "PowerConsum"] <- ".mean"
#' 
#' # Load PowerConsum Data
#' power_consum_loaded <- load_power_consum(path=power_consum_path)
#' raw_power_consum <- power_consum_loaded$raw_data
#' cleaned_power_consum <- power_consum_loaded$cleaned_data
#' }
load_power_consum <- function(path) {
  
  holiday <- load_german_holidays(from_year = 2015, to_year = 2024, location="/DE")
  holiday <- holiday |> 
    mutate(date = as.Date(date)) |>
    select(localName, date)
  
  
  raw_data <- read.csv2(file = path)
  
  
  names(raw_data)[names(raw_data) == "Datum.von"] <- "DateFrom"
  names(raw_data)[names(raw_data) == "Gesamt..Netzlast...MWh..Berechnete.Auflösungen"] <- "PowerConsum"
  
  
  raw_data <-  raw_data |>
    select(DateFrom, PowerConsum) |>
    mutate(PowerConsum = as.numeric(gsub(",", ".", gsub("\\.", "", PowerConsum))),
           DateFrom = dmy_hm(DateFrom))
  
  cleaned_data <- raw_data |>
    distinct(DateFrom, .keep_all = TRUE) |>
    mutate(DateIndex = DateFrom) |>
    as_tsibble(index = DateIndex) |>
    select(DateFrom, PowerConsum) |>
    fill_gaps() |>
    fill(PowerConsum, .direction = "downup") |>
    mutate(
      Weekday = wday(DateIndex, label = TRUE),  
      Date = as.Date(DateIndex),
      Year = as.factor(year(DateIndex)),
      Week = as.factor(week(DateIndex)),
      Hour = as.factor(hour(DateIndex)),
      Month = as.factor(month(DateIndex)),
    ) |>
    left_join(holiday, by = c("Date" = "date")) |>
    mutate(
      WorkDay = ifelse(!(Date %in% holiday$date | Weekday %in% c("Sa", "So")), 1, 0),
      Mo = Weekday == "Mo",
      Di = Weekday == "Di",  
      Mi = Weekday == "Mi",  
      Do = Weekday == "Do",  
      Fr = Weekday == "Fr",  
      Sa = Weekday == "Sa",  
      So = Weekday == "So",
      Holiday = ifelse(Date %in% holiday$date, 1, 0),
      WorkdayHolidayWeekend = paste0(ifelse(Holiday, "Feiertag", "Kein Feiertag"), ifelse(Weekday %in% c("Sa", "So"), "\nWochenende","\nKein Wochenende")),
      HolidayAndWorkDay = ifelse((Holiday & !(Weekday %in% c("Sa", "So"))), 1, 0),
      LastDayWasNotWorkDay = !lag(WorkDay, n=24),
      LastDayWasNotWorkDayAndNowWorkDay = (LastDayWasNotWorkDay & WorkDay),
      NextDayIsNotWorkDayAndNowWorkDay= (WorkDay & !lead(WorkDay, n=24)),
      LastDayWasHolodiayAndNotWeekend = ifelse((lag(Holiday, n=24) & (!Sa | !So)), 1, 0),
      NextDayIsHolidayAndNotWeekend = ifelse((lead(Holiday, n=24) & (!lead(Sa, n=24) | !lead(So, n=24))),1,0),
      HolidayName = ifelse(is.na(localName), "Regulärer Tag", localName),
      EndOfTheYear = ifelse(Week == "52"| Week == "53", 1,0),
      FirstWeekOfTheYear = ifelse(Week == "1", 1,0),
      HolidayExtended = lag(Holiday, 6, default=0) + Holiday,
      HolidayExtended = ifelse(HolidayExtended == 2, 1, HolidayExtended),
      HolidaySmoothed = HolidayExtended + sin(2 * pi * (as.numeric(Hour)+1) / 24)
    )
  
  raw_data <- raw_data |>
    arrange(DateFrom) |>
    mutate(
      MissingValue = difftime(DateFrom, lag(DateFrom, default = first(DateFrom)), units = "hours") == 2,
      DuplicatedDate = duplicated(DateFrom),
      Year = year(DateFrom)
    )
  
  plot_raw_data(
    df = raw_data,
    x = "DateFrom",
    y = "PowerConsum",
    color = "DuplicatedDate",
    missing_value = "MissingValue",
    file_name = "plots\\raw_data.png"
  )
  
  return(list(raw_data = raw_data, cleaned_data = cleaned_data))
}

