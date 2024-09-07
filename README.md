# smard-power-forecasting

This repository is for forecasting german energy power consumption.

Based opn and inspired from:

- [Forecasting: Principles and Practice](https://otexts.com/fpp3/)
- DOI: [10.1109/TPWRS.2011.2162082](https://ieeexplore.ieee.org/document/5985500) - Short-Term Load Forecasting Based on a Semi-Parametric Additive Model
- DOI: [10.1109/TPWRS.2009.2036017](https://ieeexplore.ieee.org/document/5345698) - Density Forecasting for Long-Term Peak Electricity Demand
- DOI: [10.1080/00031305.2017.1380080](https://www.tandfonline.com/doi/full/10.1080/00031305.2017.1380080) - Forecasting at Scale

Data source: [SMARD](https://www.smard.de/home/downloadcenter/download-marktdaten/)
    
- Resolution: 1h
- Timewindow: from 2015-01-01 to 2024-09-07

Put all dowloaded files into:

    /example/dataset

Check the [forecast.Rmd](example/forecast.Rmd) file to see how you can run
this code on a updated Version of SMARD-Data.

---

## From raw to cleaned Dataset

    # Define datapaths
    power_consum_path <- "dataset\\stunde_2015_2024\\Realisierter_Stromverbrauch_201501010000_202407090000_Stunde.csv"
    power_consum_smard_prediction_path <- "dataset\\propgnose_vom_smard\\Prognostizierter_Stromverbrauch_202401010000_202407090000_Stunde.csv"
    
    # Load Smard Prediction
    power_consum_smard_prediction_loaded <- load_power_consum(path=power_consum_smard_prediction_path)
    raw_smard_pred <- power_consum_smard_prediction_loaded$raw_data
    cleaned_smard_pred <- power_consum_smard_prediction_loaded$cleaned_data
    
    cleaned_smard_pred <- cleaned_smard_pred |>
      mutate(.model = "SMARD")
    names(cleaned_smard_pred)[names(cleaned_smard_pred) == "PowerConsum"] <- ".mean"
    
    # Load PowerConsum Data
    power_consum_loaded <- load_power_consum(path=power_consum_path)
    raw_power_consum <- power_consum_loaded$raw_data
    cleaned_power_consum <- power_consum_loaded$cleaned_data

Following features were generated from the dataset:

| Index | Column Name                           | Description                                                      |
|-------|---------------------------------------|------------------------------------------------------------------|
| 1     | DateFrom                              | For validation of DateIndex (similar, but raw)                   |
| 2     | PowerConsum                           | Power Consum in MW                                               |
| 3     | DateIndex                             | Timestamp (yyyy-mm-dd hh:mm:ss)                                  |
| 4     | Weekday                               | Mo, Di, Mi, Do, Fr, Sa, So (Weekdays in german)                  |
| 5     | Date                                  | Date (yyyy-mm-dd)                                                |
| 6     | Year                                  | Year yyyy                                                        |
| 7     | Week                                  | Weeknumber 0-53                                                  |
| 8     | Hour                                  | Hournumber 0-24                                                  |
| 9     | Month                                 | Monthnumber 1-12                                                 |
| 10    | localName                             | Name of a Holiday for Timestamp                                  |
| 11    | WorkDay                               | 1/0 If Workday (Werktag) then 1                                  |
| 12    | Mo                                    | 1/0 If Monday then 1                                             |
| 13    | Di                                    | 1/0 If Tuesday then 1                                            |
| 14    | Mi                                    | 1/0 If Wednesday then 1                                          |
| 15    | Do                                    | 1/0 If Thursday then 1                                           |
| 16    | Fr                                    | 1/0 If Friday then 1                                             |
| 17    | Sa                                    | 1/0 If Saturday then 1                                           |
| 18    | So                                    | 1/0 If Sunday then 1 (not needed, if Mon.-Sat. are used)         |
| 19    | Holiday                               | 1/0 If it is a Holiday then 1                                    |
| 20    | WorkdayHolidayWeekend                 | If it is a Holiday, Weekend or a Workday (for Plots, is Char.)   |
| 21    | HolidayAndWorkDay                     | 1/0 If the Holiday is on a Workday then 1                        |
| 22    | LastDayWasNotWorkDay                  | 1/0 If last day was not a Workday then 1                         |
| 23    | LastDayWasNotWorkDayAndNowWorkDay     | 1/0 If last day was not a Workday and now it is a Workday then 1 |
| 24    | NextDayIsNotWorkDayAndNowWorkDay      | 1/0 If next day is not a Workday and now a workday then 1        |
| 25    | LastDayWasHolidayAndNotWeekend        | 1/0 If last day was a holiday and not a weekend then 1           |
| 26    | NextDayIsHolidayAndNotWeekend         | 1/0 If next day is a holiday and not a weekend then 1            |
| 27    | HolidayName                           | similar to localName (Name of the holiday)                       |
| 28    | EndOfTheYear                          | 1/0 If it the end of the year (Week 52 or 53)                    |
| 29    | FirstWeekOfTheYear                    | 1/0 If it is the beginning of the year (Week 1)                  |
| 30    | HolidayExtended                       | 1/0 Lagged Holiday (6 Hours into the next day)                   |
| 31    | HolidaySmoothed                       | HolidayExtend + sin(2*pi(Hour)+1)/24)                            |
| 32    | MeanLastWeek                          | Mean PowerConsum of the Last Week  (Shift: 24*8-25)              |
| 33    | MeanLastTwoDays                       | Mean PowerConsum of the last two days (Shift: 24*3-25)           |
| 34    | MaxLastOneDay                         | Max PowerConsum of the last Day (Shift: 24*2-25)                 |
| 35    | MinLastOneDay                         | Min PowerConsum of the last Day (Shift: 24*2-25)                 |

 
In this study there is a dataset for Power-Consum in germany from [SMARD](https://www.smard.de/home/downloadcenter/download-marktdaten/) for
the years 2015 - 2024.

Figure 1 shows the raw dataset with missing values (red), duplicated timestamps (darkred) and
Power-Consum over time (grey), hourly resolution. With one missing values and one duplicate every year it was
easy to clean up the dataset. Overall an almost clean set. After cleaning up the dataset there are
plausible observations for the Power-Consum:

- 8760 Observations for a regular year (24*365)
- 8784 Observations for a leap year (24*366)
- Remainded 4559 observations for the last year (2024), year is not complet


![TEST](example/plots/raw_power_consum.png)
Figure 1 Raw Power-Consum


## Raw Dataset, yearly representation

Figure 2 is yearly representation of the years 2015-2024. We can notice here, that in
the beginning of the year there is an increase of Power-Consum and in the end of the year
there is a decrease (Christmas, New-year).

![TEST](example/plots/raw_years.png)
Figure 2 Raw Power-Consum - Years

The boxplot combination of all years we can see the pattern in more detail. Figure 3 shows this
pattern. Beginning and the end of a year is represented in red.
![TEST](example/plots/raw_week.png)
Figure 3 Raw Power-Consum - Weeks


# Raw Dataset, monthly representation

Figure 4 is the monthly representation of the years 2018. Here we can observe in more detail
the end of the year. Around 24th December, there is a decrease of Power-Consum.

![TEST](example/plots/raw_month.png)
Figure 4 Raw Power-Consum - Monthly

## Day of the week effect

![TEST](example/plots/weekday_boxplot.png)
Figure 6 Raw Power-Consum - Weeks


## Raw Dataset, daily representation

Figure 7 is the hourly representation of the years 2015-2018. We can notice here, that in 
the night (20:00-06:00) there is a lower Power-Consum. In the Day-Time there is a higher Power-Consum.
Between (13:00-20:00) there is a pattern for almost all days (see also Figure 3). In the middle
of the peak there is a decrease and an increase again. This needs to be tracked by the model correctly.

![TEST](example/plots/hour_boxplot.png)
Figure 7 Raw Power-Consum - Hourly

# Holidays

Figure 8 shows the holiday effect. "Durchschnitt" is the mean Power-Consum over
years. There is a significant increase of Power-Consum for "Working-Days" (black) compared with holidays.

![TEST](example/plots/holiday_boxplot.png)
Figure 8 Holiday Effect


## Features

Within the exploration there were found few features, that are influencing Power-Consum:

- Holidays effect
- Day of the Week 
- Mean Power-Consum of last week
- Mean Power-Consum of last two days
- Max Power-Consum of last day
- Min Power-Consum of last day

Similar as discussed in DOI: [10.1109/TPWRS.2011.2162082](https://ieeexplore.ieee.org/document/5985500) - Short-Term Load Forecasting Based on a Semi-Parametric Additive Model

## Comlex seasonality

There is a complex seasonality. For the hourly resolution there is a yearly, weekly and a daily 
seasonality. Which needs to be tracked by the model. 

## Transformation, Train and Test Dataset

Before we start with modeling we need to check ACF, PACF and also the STL-Decomposition.
Probably there is a need of transformation for the Power-Consum (Box-Cox, Log). 
This will be also involved to fit the best model.

## Model

To compare the best model there are few simple approaches, like the MEAN, NAIVE and DRIFT methods.
To compare the models we use metrics MAE and MAPE. 

### LHM + DHR (Best Model)

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

## Results


| Index | Model Name                  | RMSE      | MAPE      | MAE       | Ensembled |
|-------|-----------------------------|-----------|-----------|-----------|-----------|
| 2     | RealObservations             | 0.000     | 0.000000  | 0.000     | TRUE      |
| 3     | SMARD                        | 2480.693  | 3.602140  | 1869.466  | FALSE     |
| 4     | SMARD                        | 2480.693  | 3.602140  | 1869.466  | TRUE      |
| 5     | version_5                    | 2626.807  | 3.816012  | 1937.670  | TRUE      |
| 6     | version_0                    | 2613.258  | 3.846888  | 1946.314  | TRUE      |
| 7     | version_7                    | 2770.359  | 4.107272  | 2076.045  | TRUE      |
| 8     | version_8                    | 2775.441  | 4.146788  | 2091.153  | TRUE      |
| 9     | version_9                    | 2887.179  | 4.177841  | 2100.381  | TRUE      |
| 10    | version_6                    | 2906.242  | 4.216517  | 2142.092  | TRUE      |
| 11    | arima_14_2021_2023.rds       | 3208.735  | 4.389492  | 2207.395  | FALSE     |
| 12    | arima_18_2021_2023.rds       | 3208.735  | 4.389492  | 2207.395  | FALSE     |
| 13    | version_4                    | 2875.929  | 4.535388  | 2255.645  | TRUE      |
| 14    | version_2                    | 2905.990  | 4.580770  | 2279.624  | TRUE      |
| 15    | arima_9_2021_2023.rds        | 3267.160  | 4.611857  | 2302.918  | FALSE     |
| 16    | arima_2_2021_2023.rds        | 3251.390  | 4.614028  | 2301.447  | FALSE     |
| 17    | arima_4_2021_2023.rds        | 3251.390  | 4.614028  | 2301.447  | FALSE     |
| 18    | arima_5_2021_2023.rds        | 3251.390  | 4.614028  | 2301.447  | FALSE     |
| 19    | arima_13_2021_2023.rds       | 3283.745  | 4.619636  | 2307.415  | FALSE     |
| 20    | arima_10_2021_2023.rds       | 3265.913  | 4.625508  | 2314.395  | FALSE     |
| 21    | arima_0_2021_2023.rds        | 3269.009  | 4.645944  | 2317.138  | FALSE     |
| 22    | arima_17_2021_2023.rds       | 3269.009  | 4.645944  | 2317.138  | FALSE     |
| 23    | arima_16_2021_2023.rds       | 3298.902  | 4.673116  | 2334.857  | FALSE     |
| 24    | arima_1_2021_2023.rds        | 3312.429  | 4.696342  | 2340.193  | FALSE     |
| 25    | arima_8_2021_2023.rds        | 3332.217  | 4.716612  | 2358.085  | FALSE     |
| 26    | arima_11_2021_2023.rds       | 3358.020  | 4.758970  | 2388.791  | FALSE     |
| 27    | arima_12_2021_2023.rds       | 3430.191  | 5.022772  | 2495.067  | FALSE     |
| 28    | arima_7_2021_2023.rds        | 3475.671  | 5.049287  | 2510.903  | FALSE     |
| 29    | version_3                    | 3546.729  | 5.064654  | 2570.530  | TRUE      |
| 30    | arima_15_2021_2023.rds       | 3734.584  | 5.165147  | 2606.661  | FALSE     |
| 31    | arima_6_2021_2023.rds        | 3748.583  | 5.375326  | 2723.837  | FALSE     |
| 32    | version_1                    | 4495.568  | 6.483477  | 3229.647  | TRUE      |
| 33    | arima_3_2021_2023.rds        | 4558.982  | 6.953247  | 3453.387  | FALSE     |
| 34    | tslm_0_2021_2023.rds         | 6760.994  | 11.189119 | 5694.949  | FALSE     |
| 35    | mean_2021_2023.rds           | 9489.303  | 16.406032 | 8101.476  | FALSE     |
| 36    | naive_2021_2023.rds          | 14699.338 | 20.797370 | 12130.587 | FALSE     |
| 37    | drift_2021_2023.rds          | 14763.692 | 20.917883 | 12200.002 | FALSE     |