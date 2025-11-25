# Australian Wine Sales Forecasting Shiny App

## Overview

This interactive Shiny application provides comprehensive time-series forecasting for Australian wine sales data by varietal. The app enables users to compare multiple forecasting models, evaluate their performance, and visualize predictions with confidence intervals.

## Features

### Core Functionality
- **Interactive Varietal Selection**: Choose from multiple wine varietals (Fortified, Red, Rose, Sparkling, Sweet white, Dry white)
- **Flexible Date Range Controls**: Define custom training periods with adjustable start and end dates
- **Multiple Forecasting Models**:
  - **TSLM**: Time Series Linear Model with trend and seasonal components
  - **ETS**: Error-Trend-Seasonal model with automatic specification
  - **ARIMA**: AutoRegressive Integrated Moving Average with automatic order selection
- **User-Defined Forecast Horizon**: Set forecast periods from 1 to 24 months
- **Model Toggle**: Enable/disable specific models for comparison

### Three Main Tabs

#### 1. Visualization Tab
- Faceted time series plots with free y-scales for each varietal
- Visual training/validation split indicator
- Summary statistics table by varietal

#### 2. Model Building Tab
- Model specifications (ETS component form, ARIMA orders, TSLM details)
- Training accuracy metrics (RMSE, MAE, MAPE)
- Validation accuracy metrics
- Combined accuracy comparison table

#### 3. Forecast Tab
- Comparative forecast visualization by model and varietal
- 80% and 95% prediction intervals
- Faceted grid layout for easy comparison
- Forecast details table

## Dataset

**Source**: AustralianWines.csv  
**Period**: January 1980 - December 1994  
**Frequency**: Monthly  
**Variables**: Sales (thousands of liters) by wine varietal

## Technical Requirements

### R Version
- R >= 4.0.0

### Required Packages
```r
install.packages(c(
  "shiny",
  "tidyverse",
  "fpp3",
  "gt",
  "urca",
  "lubridate"
))
```

### Package Versions (Tested)
- shiny: 1.11.1
- tidyverse: 2.0.0
- fpp3: 1.0.2
- gt: 1.1.0
- urca: 1.3-4
- lubridate: 1.9.4

## Installation and Usage

### Local Deployment

1. Clone this repository or download the files
2. Ensure `AustralianWines.csv` is in the same directory as `app.R`
3. Install required packages (see above)
4. Run the app:

```r
shiny::runApp("app.R")
```

### Deployment to Posit Connect Cloud

1. Initialize Git repository (if not already done):
```bash
git init
git add .
git commit -m "Initial commit"
```

2. Create manifest file:
```r
rsconnect::writeManifest()
```

3. Push to GitHub and deploy via Posit Connect Cloud interface

## Project Structure

```
ShinyApp/
├── app.R                  # Main Shiny application
├── AustralianWines.csv    # Dataset
├── mockup.qmd            # Requirements document (Quarto)
├── mockup.html           # Rendered requirements document
└── README.md             # This file
```

## Workflow

This project follows the **"Quarto-First" workflow**:

1. **Requirements Document**: Created `mockup.qmd` with static R code for data wrangling, visualization, and modeling
2. **Validation**: Rendered the Quarto document to ensure all logic works correctly
3. **App Development**: Translated the validated logic into an interactive Shiny application
4. **Testing**: Verified all interactive controls and outputs
5. **Deployment**: Prepared for deployment with proper documentation

## Key Implementation Details

### Data Handling
- Automatic conversion of non-numeric values (e.g., "*" in Rose column) to NA
- Removal of missing values to ensure clean tsibble creation
- Trailing space handling in column names

### Model Fitting
- Dynamic model selection based on user input
- Automatic specification for ETS and ARIMA models
- Trend and seasonal components for TSLM

### Visualization
- Free y-scales for faceted plots to accommodate different sales magnitudes
- Clear visual indicators for training/validation split
- Prediction intervals at 80% and 95% confidence levels

## Reproducibility

To reproduce any analysis shown in the app:

1. Select the desired varietals from the checkbox group
2. Set the training start and end dates
3. Choose the forecast horizon
4. Enable/disable models as needed
5. Navigate through the tabs to view results

All settings are reactive and update automatically when inputs change.

## Author

Created for the "Storytelling with Shiny" course assignment.

## License

This project is for educational purposes.

