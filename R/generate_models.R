#' Will generate any Model (just for more overview)
#'
#' Can create a fit for a model_name. This is more like a documentation for every
#' model. So if you want to add some models, you should document them here and expand
#' a "if" case.
#'
#' @param model_name can be for example "model/arima_0_2021_2023.rds".
#' @param train_power_consum Check example.
#' 
#' @examples
#' \dontrun{
#' train_power_consum <- cleaned_power_consum |>
#'   filter(year(DateIndex) > 2020 & (year(DateIndex) < 2024))
#' 
#' generate_models(model_name = "model/mean_naive_drift",
#'                 train_power_consum = train_power_consum)
#' }
#' 



generate_models <- function(model_name, train_power_consum) {
  
  if (!dir.exists("ensemble_model")) {
    dir.create("ensemble_model")
  }
  
  if (!dir.exists("model")) {
    dir.create("model")
  }
  
  if (!dir.exists("other_model")) {
    dir.create("other_model")
  }
  
  if(model_name == "model/arima_0_2021_2023.rds") {
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 10)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_0_2021_2023.rds")
  }
  
  if(model_name == "model/arima_1_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 10)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_1_2021_2023.rds")
    
  }
  
  if(model_name == "model/arima_2_2021_2023.rds") {
    
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 8)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_2_2021_2023.rds")
    
  }
  
  if(model_name == "model/arima_3_2021_2023.rds") {
    
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 8)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_3_2021_2023.rds")
    
  }
  
  if(model_name == "model/arima_4_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 8)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_4_2021_2023.rds")
    
  }
  
  if(model_name == "model/arima_5_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = 24, K = 8)
                      + fourier(period = 24*7, K = 5)
                      + fourier(period = 24*365.25, K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_5_2021_2023.rds")
    
    
  }
  if(model_name == "model/tslm_0_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        TSLM = TSLM(PowerConsum ~
                      WorkDay
                    + Holiday
                    + MeanLastWeek
                    + MeanLastTwoDays
                    + MaxLastOneDay
                    + MinLastOneDay
                    + LastDayWasHolodiayAndNotWeekend
                    + NextDayIsHolidayAndNotWeekend
                    + fourier(period = "day", K = 12)
                    + fourier(period = "week", K = 24)
                    + fourier(period = "year", K = 24)
        )
      )
    
    saveRDS(fit, file = "model/tslm_0_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/mean_naive_drift") {
    
    fit <- train_power_consum |>
      model(
        Mean = MEAN(PowerConsum),
      )
    
    saveRDS(fit, file = "model/mean_2021_2023.rds")   
    
    fit <- train_power_consum |>
      model(
        Naive = NAIVE(PowerConsum),
        Drift = NAIVE(PowerConsum ~ drift())
      ) 
    
    saveRDS(fit, file = "model/naive_2021_2023.rds")  
    
    fit <- train_power_consum |>
      model(
        Drift = NAIVE(PowerConsum ~ drift())
      ) 
    
    saveRDS(fit, file = "model/drift_2021_2023.rds")  
    
    
  }
  
  if(model_name == "other_model/prophet_0_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        PROPHET = prophet(
          PowerConsum ~ 
            MeanLastWeek
          + MeanLastTwoDays
          + MaxLastOneDay
          + MinLastOneDay
          + WorkDay 
          + Holiday
          + LastDayWasHolodiayAndNotWeekend
          + NextDayIsHolidayAndNotWeekend
          + season(period = "day", order = 24) 
          + season(period = "week", order = 5) 
          + season(period = "year", order = 3))
      )
    
    saveRDS(fit, file = "other_model/prophet_0_2021_2023.rds")   
    
    
  }
  
  if(model_name == "model/arima_6_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = 24, K = 8)
                      + fourier(period = 24*7, K = 5)
                      + fourier(period = 24*365.25, K = 3),
                      stepwise=FALSE,
                      greedy=FALSE,
                      approx=FALSE
        )
      )
    
    
    saveRDS(fit, file = "model/arima_6_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_7_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + WorkDay 
                      + fourier(period = 24, K = 4)
                      + fourier(period = 24*7, K = 3)
                      + fourier(period = 24*365.25, K = 2)
        )
      )
    saveRDS(fit, file = "model/arima_7_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_8_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + WorkDay 
                      + Holiday
                      + fourier(period = 24, K = 8)
                      + fourier(period = 24*7, K = 5)
                      # + fourier(period = 24*365.25, K = 3)
        )
      )
    saveRDS(fit, file = "model/arima_8_2021_2023.rds")
    
  }
  
  if(model_name == "model/arima_9_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_9_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_10_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 4)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_10_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_11_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 2)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_11_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_12_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 8)
                      + fourier(period = "week", K = 3)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_12_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_13_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 8)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 1)
        )
      )
    
    saveRDS(fit, file = "model/arima_13_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_14_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_14_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_15_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 9)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_15_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_16_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 5)
        )
      )
    
    saveRDS(fit, file = "model/arima_16_2021_2023.rds")
    
    
  }
  
  if(model_name == "model/arima_17_2021_2023.rds") {
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 10)
                      + fourier(period = "week", K = 5)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_17_2021_2023.rds")
    
    
  }
  
  
  if(model_name == "model/arima_18_2021_2023.rds") { 
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(PowerConsum ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + Holiday
                      + MeanLastWeek
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + LastDayWasHolodiayAndNotWeekend
                      + NextDayIsHolidayAndNotWeekend
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "model/arima_18_2021_2023.rds")
    
  }
  
  if(model_name == "other_model/prophet_1_2021_2023.rds") { 
    
    fit <- train_power_consum |>
      model(
        PROPHET = prophet(
          PowerConsum ~ 
            MeanLastWeek
          + MeanLastTwoDays
          + MaxLastOneDay
          + MinLastOneDay
          + WorkDay 
          + Holiday
          + LastDayWasHolodiayAndNotWeekend
          + NextDayIsHolidayAndNotWeekend
          + season(period = "day", order = 24) 
          + season(period = "week", order = 5) 
          + season(period = "year", order = 3))
      )
    
    saveRDS(fit, file = "other_model/prophet_1_2021_2023.rds")    
    
    
    
  }
  
  if(model_name == "ensemble_model/version_0") { 
    
    if (!dir.exists("ensemble_model/version_0")) {
      dir.create("ensemble_model/version_0")
    }
    
    holiday_effect_model <- lm(
      PowerConsum ~
        Holiday,
      data = train_power_consum
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_0/holiday_effect_2021_2023.rds") 
    
    train_power_consum$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays 
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_0/arima_2021_2023.rds") 
    
    
  }
  
  
  if(model_name == "ensemble_model/version_1") { 
    
    if (!dir.exists("ensemble_model/version_1")) {
      dir.create("ensemble_model/version_1")
    }
    
    holiday_effect_model <- lm(
      PowerConsum ~
        WorkDay
      + EndOfTheYear
      + FirstWeekOfTheYear,
      data = train_power_consum
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_1/holiday_effect_2021_2023.rds") 
    
    train_power_consum$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + WorkDay
                      + MeanLastWeek
                      + MeanLastTwoDays 
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_1/arima_2021_2023.rds") 
    
  }
  
  
  if(model_name == "ensemble_model/version_2") { 
    
    if (!dir.exists("ensemble_model/version_2")) {
      dir.create("ensemble_model/version_2")
    }
    
    holiday_effect_model <- lm(
      PowerConsum ~
        WorkDay,
      data = train_power_consum
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_2/holiday_effect_2021_2023.rds") 
    
    train_power_consum$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + MeanLastTwoDays 
                      + MaxLastOneDay
                      + MinLastOneDay
                      + EndOfTheYear
                      + FirstWeekOfTheYear
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_2/arima_2021_2023.rds") 
    
    
  }
  
  if(model_name == "ensemble_model/version_3") { 
    
    if (!dir.exists("ensemble_model/version_3")) {
      dir.create("ensemble_model/version_3")
    }
    
    holiday_effect_model <- lm(PowerConsum ~
                                 MeanLastTwoDays
                               + MaxLastOneDay
                               + MeanLastWeek
                               + MinLastOneDay,
                               data = train_power_consum)
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_3/holiday_effect_2021_2023.rds") 
    
    train_power_consum$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + Holiday
                      + WorkDay
                      + EndOfTheYear
                      + FirstWeekOfTheYear
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_3/arima_2021_2023.rds") 
    
  }
  
  if(model_name == "ensemble_model/version_4") { 
    
    if (!dir.exists("ensemble_model/version_4")) {
      dir.create("ensemble_model/version_4")
    }
    
    holiday_effect_model <- lm(
      PowerConsum ~
        Holiday 
      + WorkDay,
      data = train_power_consum
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_4/holiday_effect_2021_2023.rds") 
    
    train_power_consum$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + EndOfTheYear 
                      + FirstWeekOfTheYear 
                      + MeanLastTwoDays 
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_4/arima_2021_2023.rds") 
    
  }
  
  
  if(model_name == "ensemble_model/version_5") { 
    
    
    if (!dir.exists("ensemble_model/version_5")) {
      dir.create("ensemble_model/version_5")
    }
    
    
    train_power_consum_v5 <- train_power_consum |>
      mutate(HolidaySmoothed = Holiday + sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
    holiday_effect_model <- lm(
      PowerConsum ~
        HolidaySmoothed,
      data = train_power_consum_v5
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_5/holiday_effect_2021_2023.rds") 
    
    train_power_consum_v5$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum_v5 |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_5/arima_2021_2023.rds")
    
    rm(train_power_consum_v5)
    
    
  }
  
  if(model_name == "ensemble_model/version_6") { 
    
    if (!dir.exists("ensemble_model/version_6")) {
      dir.create("ensemble_model/version_6")
    }
    
    
    holiday_effect_model <- lm(
      PowerConsum ~
        HolidaySmoothed,
      data = train_power_consum
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_6/holiday_effect_2021_2023.rds") 
    
    train_power_consum$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_6/arima_2021_2023.rds")
    
  }
  
  if(model_name == "ensemble_model/version_7") { 
    
    if (!dir.exists("ensemble_model/version_7")) {
      dir.create("ensemble_model/version_7")
    }
    
    train_power_consum_v7 <- train_power_consum |>
      mutate(HolidaySmoothed = Holiday + 0.5*sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
    holiday_effect_model <- lm(
      PowerConsum ~
        HolidaySmoothed,
      data = train_power_consum_v7
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_7/holiday_effect_2021_2023.rds") 
    
    train_power_consum_v7$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum_v7 |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_7/arima_2021_2023.rds")
    
    rm(train_power_consum_v7)
    
  }
  
  if(model_name == "ensemble_model/version_8") { 
    
    if (!dir.exists("ensemble_model/version_8")) {
      dir.create("ensemble_model/version_8")
    }
    
    train_power_consum_v8 <- train_power_consum |>
      mutate(HolidaySmoothed =  HolidayExtended + 0.5*sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
    holiday_effect_model <- lm(
      PowerConsum ~
        HolidaySmoothed,
      data = train_power_consum_v8
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_8/holiday_effect_2021_2023.rds") 
    
    train_power_consum_v8$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum_v8 |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_8/arima_2021_2023.rds")
    
    rm(train_power_consum_v8)
    
  }
  
  if(model_name == "ensemble_model/version_9") { 
    
    if (!dir.exists("ensemble_model/version_9")) {
      dir.create("ensemble_model/version_9")
    }
    
    train_power_consum_v9 <- train_power_consum |>
      mutate(HolidaySmoothed =  Holiday + 0.25*sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
    holiday_effect_model <- lm(
      PowerConsum ~
        HolidaySmoothed,
      data = train_power_consum_v9
    )
    
    saveRDS(holiday_effect_model, file = "ensemble_model/version_9/holiday_effect_2021_2023.rds") 
    
    train_power_consum_v9$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum_v9 |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "ensemble_model/version_9/arima_2021_2023.rds")
    
    rm(train_power_consum_v9)
    
  }
  
  if(model_name == "other_model/version_10") { 
    
    if (!dir.exists("other_model/version_10")) {
      dir.create("other_model/version_10")
    }
    
    
    train_power_consum_v10 <- train_power_consum |>
      mutate(HolidaySmoothed = Holiday + sin(2 * pi * (as.numeric(Hour)+1) / 24))
    
    holiday_effect_model <- lm(
      PowerConsum ~
        HolidaySmoothed,
      data = train_power_consum_v10
    )
    
    saveRDS(holiday_effect_model, file = "other_model/version_10/holiday_effect_2020_2022.rds") 
    
    train_power_consum_v10$Residuals <- residuals(holiday_effect_model)
    
    fit <- train_power_consum_v10 |>
      model(
        ARIMA = ARIMA(Residuals ~
                        PDQ(0,0,0)
                      + pdq(d=0)
                      + MeanLastWeek
                      + WorkDay
                      + EndOfTheYear # new
                      + FirstWeekOfTheYear # new
                      + MeanLastTwoDays
                      + MaxLastOneDay
                      + MinLastOneDay
                      + fourier(period = "day", K = 6)
                      + fourier(period = "week", K = 7)
                      + fourier(period = "year", K = 3)
        )
      )
    
    saveRDS(fit, file = "other_model/version_10/arima_2020_2022.rds")
    
    rm(train_power_consum_v10)
    
  }
    
    if(model_name == "other_model/version_11") { 
      
      
      if (!dir.exists("other_model/version_11")) {
        dir.create("other_model/version_11")
      }
      
      
      train_power_consum_v10 <- train_power_consum |>
        mutate(HolidaySmoothed = Holiday + sin(2 * pi * (as.numeric(Hour)+1) / 24))
      
      holiday_effect_model <- lm(
        PowerConsum ~
          HolidaySmoothed,
        data = train_power_consum_v10
      )
      
      saveRDS(holiday_effect_model, file = "other_model/version_11/holiday_effect_2019_2021.rds") 
      
      train_power_consum_v10$Residuals <- residuals(holiday_effect_model)
      
      fit <- train_power_consum_v10 |>
        model(
          ARIMA = ARIMA(Residuals ~
                          PDQ(0,0,0)
                        + pdq(d=0)
                        + MeanLastWeek
                        + WorkDay
                        + EndOfTheYear # new
                        + FirstWeekOfTheYear # new
                        + MeanLastTwoDays
                        + MaxLastOneDay
                        + MinLastOneDay
                        + fourier(period = "day", K = 6)
                        + fourier(period = "week", K = 7)
                        + fourier(period = "year", K = 3)
          )
        )
      
      saveRDS(fit, file = "other_model/version_11/arima_2019_2021.rds")
      
      rm(train_power_consum_v10)
      
      
    }
    

  
  
  
}