plot_forecast <- function(all_forecasts, metric_results, cleaned_power_consum, raw_fc,
                          month_to_plot, days_to_plot) {
  
  best_forecast <- metric_results |>
    filter(!(.model == "SMARD")) |>
    filter(MAPE == min(MAPE[MAPE > 0])) |>
    slice(1) |>
    select(.model)
  
  name_of_best_model <- best_forecast$.model
  name_of_best_model <- "arima_6_2021_2023.rds"
  
  print("Best Model is:")
  print(name_of_best_model)
  
  filtered_best_forecast <- all_forecasts |>
    filter(.model == name_of_best_model) |>
    left_join(cleaned_power_consum |> rename(RealPowerConsum = PowerConsum,
                                             WorkingDay = WorkDay,
                                             WorkdayHolidayWeekendr = WorkdayHolidayWeekend), by = "DateIndex") |>
    mutate(WorkDay = as.factor(WorkDay))
  
  single_best_forecast <- raw_fc[[name_of_best_model]] |>
    filter(month(DateIndex) <= month_to_plot) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter(year(DateIndex) == 2024)
  
  filtered_power_consum <- cleaned_power_consum |>
    filter(day(DateIndex) < days_to_plot) |>
    filter((year(DateIndex) == 2024 & month(DateIndex) <= month_to_plot)  
           | (year(DateIndex) == 2023 & month(DateIndex) == 12))
  
  smard_fc <- all_forecasts |>
    filter(.model == "SMARD") |>
    filter(month(DateIndex) <= month_to_plot) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter(year(DateIndex) == 2024)
  
  p <- autoplot(single_best_forecast, color = "#FC4E07") +
    # geom_line(data = smard_fc,
    #           lwd = 0.2,
    #           aes(x = DateIndex, y = .mean, color = "SMARD")) +
    geom_line(data = filtered_power_consum,
              lwd = 0.2,
              aes(x = DateIndex, y = PowerConsum, color = "Real Obs.")) +
    geom_line(data = single_best_forecast,
              lwd = 0.2 ,
              aes(x = DateIndex, y = .mean, color =
                    "Forecast")) +
    theme(legend.position = "bottom", strip.text = element_text(size = 12)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 2), title = " "),
           fill = guide_legend(title = " "))+
    scale_color_manual(
      values = c(
        name = " ",
        "SMARD" = "darkgrey",
        "Real Obs." = "#2E9FDF",
        "Forecast" = "#FC4E07"
      ),
      labels = c(
        "SMARD" = "SMARD",
        "Real Obs." = "Tatsaechliche \nStromverbrauch",
        "Forecast" = "ARIMA"
      )
    ) +
    labs(level = "Level")
  
  
  ggsave(
    paste0("plots/",name_of_best_model, ".png"),
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
  
  p <- ggplot()+
    geom_point(data = filtered_best_forecast, aes(x=RealPowerConsum, y=.mean, color=WorkdayHolidayWeekendr), alpha=0.5, size=0.5) +
    geom_abline(slope = 1, intercept = 0, color = "black", lwd=0.5, alpha=0.5) +
    xlim(30000, 80000) + 
    ylim(30000, 80000) + 
    scale_color_manual(
      values = c(
        name = " ",
        "Feiertag\nKein Wochenende" = "#FF9100",
        "Kein Feiertag\nKein Wochenende" = "#2E9FDF",
        "Kein Feiertag\nWochenende" = "#FC1E07"
      )) +
    theme(legend.position = "bottom", strip.text = element_text(size = 12)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 2), title = " "),
           fill = guide_legend(title = " "))
  
  ggsave(
    paste0("plots/real_to_fc_",name_of_best_model, ".png"),
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
  
  return(name_of_best_model)
  
}
  
  
  