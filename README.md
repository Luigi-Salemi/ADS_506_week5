# Australian Wine Sales Forecasting

ADS 506 Week 5 Assignment - Interactive Shiny App

## About

This Shiny app analyzes Australian wine sales data (1980-1994) and creates forecasts using three different models:
- TSLM (Time Series Linear Model)
- ETS (Error-Trend-Seasonal)
- ARIMA (AutoRegressive Integrated Moving Average)

## Files

- `app.R` - Main Shiny application
- `AustralianWines.csv` - Dataset
- `mockup.qmd` - Initial analysis document

## How to Run

```r
# Install packages
install.packages(c("shiny", "tidyverse", "fpp3", "gt", "urca", "lubridate"))

# Run app
shiny::runApp("app.R")
```

## Features

- Select wine varietals to analyze
- Choose training period dates
- Compare multiple forecasting models
- View accuracy metrics (RMSE, MAE, MAPE)
- See forecast plots with prediction intervals
