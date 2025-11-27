# Australian Wine Sales Forecasting

Interactive Shiny app for forecasting Australian wine sales across different varietals.

## About

This app analyzes Australian wine sales data (1980-1994) using three forecasting models:
- TSLM (Time Series Linear Model)
- ETS (Error-Trend-Seasonal)
- ARIMA (AutoRegressive Integrated Moving Average)

## Live App

<https://connect.posit.cloud/luigi-salemi-usd/content/019ab93b-d522-6571-32d0-7cf8442ae99c>

## How to Run Locally

```r
# Install packages
install.packages(c("shiny", "tidyverse", "fpp3", "gt", "urca", "lubridate"))

# Run app
shiny::runApp()
```

## Features

- Interactive varietal selection
- Flexible training period controls
- Comparative model forecasts with prediction intervals
- Accuracy metrics (RMSE, MAE, MAPE)
- Performance optimization with caching
