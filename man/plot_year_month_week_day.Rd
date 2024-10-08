% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_year_month_week_day.R
\name{plot_year_month_week_day}
\alias{plot_year_month_week_day}
\title{Will plot Yearly, Monthly, Daily and Weekly representation of the Data.}
\usage{
plot_year_month_week_day(
  df,
  date_column,
  y,
  from_year,
  to_year,
  from_week,
  to_week,
  year_for_week,
  from_day,
  to_day,
  month_for_day,
  year_for_day,
  from_month,
  to_month,
  year_for_month,
  holiday,
  day_of_week
)
}
\arguments{
\item{df}{A DataFrame you want to Plot.}

\item{date_column}{Column with your Dates.}

\item{y}{Y-Value.}

\item{from_year}{For the Year Plot.}

\item{to_year}{For the Year Plot.}

\item{from_week}{For the Week Plot.}

\item{to_week}{for the Week Plot.}

\item{year_for_week}{For the Week Plot.}

\item{from_day}{For the Day Plot.}

\item{to_day}{For the Day Plot.}

\item{month_for_day}{For the Day Plot.}

\item{year_for_day}{For the Day Plot.}

\item{from_month}{For the Month Plot.}

\item{to_month}{For the Month Plot.}

\item{year_for_month}{For the Month Plot.}

\item{holiday}{Holiday-Column.}

\item{day_of_week}{DayOfWeek-Column (Mo, Di, Mi...).}
}
\description{
Will plot Yearly, Monthly, Daily and Weekly representation of the Data.
}
\examples{
\dontrun{
power_consum_loaded <- load_power_consum(path=power_consum_path)
raw_power_consum <- power_consum_loaded$raw_data
cleaned_power_consum <- power_consum_loaded$cleaned_data

cleaned_power_consum$localName[is.na(cleaned_power_consum$localName)] = "Working-Day"

cleaned_power_consum$MeanLastWeek <- rollapply(cleaned_power_consum$PowerConsum, width = 24*8, FUN = function(x) mean(x[1:(24*8-25)]), align = "right", fill = NA) 

cleaned_power_consum$MeanLastTwoDays <- rollapply(cleaned_power_consum$PowerConsum, width = 24*3, FUN = function(x) mean(x[1:(24*3-25)]), align = "right", fill = NA) 

cleaned_power_consum$MaxLastOneDay <- rollapply(cleaned_power_consum$PowerConsum, width = 24*2, FUN = function(x) max(x[1:(24*2-25)]), align = "right", fill = NA) 

cleaned_power_consum$MinLastOneDay <- rollapply(cleaned_power_consum$PowerConsum, width = 24*2, FUN = function(x) min(x[1:(24*2-25)]), align = "right", fill = NA) 

plot_year_month_week_day(
  df=cleaned_power_consum,
  date_column="DateIndex",
  y="PowerConsum",
  from_year=2015,
  to_year=2024,
  from_week=0,
  to_week=53,
  year_for_week=2018,
  from_day=1,
  to_day=30,
  month_for_day=4,
  year_for_day=2018,
  from_month=1,
  to_month=12,
  year_for_month=2018,
  holiday="Holiday",
  day_of_week = "Weekday"
)
}

}
