plot_forecast_ensembled <- function(all_forecasts, metric_results, cleaned_power_consum,
                          month_to_plot, days_to_plot) {
  
  best_forecast <- metric_results |>
    filter(!(.model == "SMARD")) |>
    filter(ensembled == TRUE) |>
    filter(MAPE == min(MAPE[MAPE > 0])) |>
    slice(1) |>
    select(.model)
  
  
  name_of_best_model <- best_forecast$.model
  print("Best Model is:")
  print(name_of_best_model)
  
  filtered_best_forecast <- all_forecasts |>
    filter(.model == name_of_best_model) |>
    left_join(cleaned_power_consum |> rename(RealPowerConsum = PowerConsum,
                                             WorkingDay = WorkDay,
                                             WorkdayHolidayWeekendr = WorkdayHolidayWeekend), by = "DateIndex") |>
    mutate(WorkDay = as.factor(WorkDay)) |>
    filter(month(DateIndex) <= month_to_plot) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter(year(DateIndex) == 2024)
  
  
  filtered_power_consum <- cleaned_power_consum |>
    mutate(PowerConsum = PowerConsum) |>
    filter((year(DateIndex) == 2024 & month(DateIndex) <= month_to_plot & day(DateIndex) < days_to_plot)  
           | (year(DateIndex) == 2023 & month(DateIndex) == 12) & day(DateIndex) > 22)
  
  smard_fc <- all_forecasts |>
    filter(.model == "SMARD") |>
    filter(month(DateIndex) <= month_to_plot) |>
    filter(day(DateIndex) < days_to_plot) |>
    filter(year(DateIndex) == 2024)
  
  p <- ggplot(filtered_best_forecast, aes(x = DateIndex)) +
    geom_line(aes(y = .mean, color = "Vorhersage"), lwd=0.2) + 
    geom_line(data = filtered_power_consum,
              lwd = 0.2,
              aes(x = DateIndex, y = PowerConsum, color = "Tatsaechlicher\nStromverbrauch")) +
    geom_ribbon(aes(ymin = lower_bound, ymax = upper_bound), 
                alpha = 0.2, fill = "orange", alpha=0.2) + 
    geom_line(aes(y = lower_bound, color = "Lower Bound"), alpha=0.5, lwd=0.2) + 
    geom_line(aes(y = upper_bound, color = "Upper Bound"), alpha=0.5, lwd=0.2) + 
    scale_color_manual(name = "Legend", 
                       values = c("Vorhersage" = "#FC4E07", 
                                  "Lower Bound" = "orange", 
                                  "Upper Bound" = "orange",
                                  "Tatsaechlicher\nStromverbrauch" = "#2E9FDF")) +
    theme(legend.position = "bottom", strip.text = element_text(size = 12)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 2), title = " "),
           fill = guide_legend(title = " ")) +
    labs(x = "Zeitstempel", y = "Stromverbrauch [MW]")
  
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
        "Feiertag\nKein Wochenende" = "#603F26",
        "Kein Feiertag\nKein Wochenende" = "#2E9FDF",
        "Kein Feiertag\nWochenende" = "#FC4E07"
      ), 
      ,
      labels = c(
        "Feiertag\nKein Wochenende" = "Feiertag\n(Kein Wochenende)",
        "Kein Feiertag\nKein Wochenende" = "Werktag",
        "Kein Feiertag\nWochenende" = "Wochenende\n(Kein Feiertag)"
      )) +
    theme(legend.position = "bottom", strip.text = element_text(size = 12)) +
    guides(color = guide_legend(override.aes = list(lwd = 3, size = 2), title = " "),
           fill = guide_legend(title = " ")) +
    labs(x = "Tatsaechlicher\nStromverbrauch [MW]", y = "Vorhergesagter\nStromverbrauch [MW]") 
  
  ggsave(
    paste0("plots/real_to_fc_",name_of_best_model, ".png"),
    plot = p,
    width = 5.5,
    height = 3.7,
    dpi = 600
  )
  
  return(name_of_best_model)
  
}


