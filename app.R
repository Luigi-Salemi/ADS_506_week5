# Australian Wine Sales Forecasting Shiny App
# Based on mockup.qmd requirements document

library(shiny)
library(tidyverse)
library(fpp3)
library(gt)
library(urca)
library(lubridate)

# Load and prepare data
wine_raw <- read_csv("AustralianWines.csv", show_col_types = FALSE)

wine_data <- wine_raw %>%
  mutate(Month = yearmonth(parse_date_time(Month, "my"))) %>%
  mutate(across(-Month, ~as.numeric(as.character(.)))) %>%
  pivot_longer(
    cols = -Month,
    names_to = "Varietal",
    values_to = "Sales"
  ) %>%
  mutate(Varietal = str_trim(Varietal)) %>%
  filter(!is.na(Sales)) %>%
  as_tsibble(key = Varietal, index = Month)

# Get unique varietals and date range
varietals <- unique(wine_data$Varietal)
min_date <- min(wine_data$Month)
max_date <- max(wine_data$Month)

# UI
ui <- fluidPage(
  titlePanel("Australian Wine Sales Forecasting"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      
      # Varietal selection
      checkboxGroupInput(
        "varietals",
        "Select Varietals (max 3 recommended):",
        choices = varietals,
        selected = c("Red", "Dry white")
      ),

      helpText("Note: Model fitting may take 5-10 seconds per varietal"),

      hr(),
      
      # Date range inputs
      h4("Training Period"),
      selectInput(
        "train_start",
        "Training Start:",
        choices = as.character(seq(min_date, max_date, by = 1)),
        selected = "1980 Jan"
      ),
      
      selectInput(
        "train_end",
        "Training End (Cutoff):",
        choices = as.character(seq(min_date, max_date, by = 1)),
        selected = "1992 Dec"
      ),
      
      hr(),
      
      # Forecast horizon
      numericInput(
        "forecast_horizon",
        "Forecast Horizon (months):",
        value = 12,
        min = 1,
        max = 24,
        step = 1
      ),
      
      hr(),
      
      # Model selection
      h4("Models to Fit"),
      checkboxInput("fit_tslm", "TSLM (Trend + Season)", value = TRUE),
      checkboxInput("fit_ets", "ETS (Auto)", value = TRUE),
      checkboxInput("fit_arima", "ARIMA (Auto)", value = TRUE)
    ),
    
    mainPanel(
      width = 9,
      tabsetPanel(
        id = "tabs",
        
        # Tab 1: Visualization
        tabPanel(
          "Visualization",
          h3("Time Series Overview"),
          plotOutput("ts_plot", height = "600px"),
          hr(),
          h4("Summary Statistics"),
          gt_output("summary_table")
        ),
        
        # Tab 2: Model Building
        tabPanel(
          "Model Building",
          h3("Model Specifications"),
          gt_output("model_specs_table"),
          hr(),
          h3("Training Accuracy"),
          gt_output("train_accuracy_table"),
          hr(),
          h3("Validation Accuracy"),
          gt_output("validation_accuracy_table"),
          hr(),
          h3("Combined Accuracy Comparison"),
          gt_output("combined_accuracy_table")
        ),
        
        # Tab 3: Forecast
        tabPanel(
          "Forecast",
          h3("Comparative Forecasts"),
          plotOutput("forecast_plot", height = "700px"),
          hr(),
          h4("Forecast Details"),
          gt_output("forecast_table")
        ),
        
        # About tab
        tabPanel(
          "About",
          h3("About This App"),
          p("This Shiny application provides interactive time-series forecasting for Australian wine sales data."),
          h4("Features:"),
          tags$ul(
            tags$li("Interactive varietal selection and date range filtering"),
            tags$li("Multiple forecasting models: TSLM, ETS, and ARIMA"),
            tags$li("Training and validation accuracy metrics"),
            tags$li("Comparative forecast visualization with prediction intervals"),
            tags$li("User-defined forecast horizon")
          ),
          h4("Dataset:"),
          p("Monthly Australian wine sales by varietal (1980-1994)"),
          h4("Models:"),
          tags$ul(
            tags$li(strong("TSLM:"), "Time Series Linear Model with trend and seasonal components"),
            tags$li(strong("ETS:"), "Error-Trend-Seasonal model with automatic specification"),
            tags$li(strong("ARIMA:"), "AutoRegressive Integrated Moving Average with automatic order selection")
          )
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {

  # Reactive: Filtered data for visualization
  filtered_data <- reactive({
    req(input$varietals, input$train_start, input$train_end)

    train_start <- yearmonth(input$train_start)
    train_end <- yearmonth(input$train_end)

    wine_data %>%
      filter(
        Varietal %in% input$varietals,
        Month >= train_start
      )
  })

  # Reactive: Training data
  train_data <- reactive({
    req(input$varietals, input$train_start, input$train_end)

    train_start <- yearmonth(input$train_start)
    train_end <- yearmonth(input$train_end)

    wine_data %>%
      filter(
        Varietal %in% input$varietals,
        Month >= train_start,
        Month <= train_end
      )
  })

  # Reactive: Validation data
  validation_data <- reactive({
    req(input$train_end, input$forecast_horizon)

    train_end <- yearmonth(input$train_end)
    validation_start <- train_end + 1
    validation_end <- train_end + input$forecast_horizon

    wine_data %>%
      filter(
        Varietal %in% input$varietals,
        Month >= validation_start,
        Month <= validation_end
      )
  })

  # Reactive: Fitted models
  # Add progress indicator and caching
  fitted_models <- reactive({
    req(train_data())

    # Build model formula based on selected models
    model_list <- list()

    if (input$fit_tslm) {
      model_list$TSLM <- TSLM(Sales ~ trend() + season())
    }
    if (input$fit_ets) {
      model_list$ETS <- ETS(Sales)
    }
    if (input$fit_arima) {
      model_list$ARIMA <- ARIMA(Sales)
    }

    # Require at least one model
    req(length(model_list) > 0)

    # Show progress
    withProgress(message = 'Fitting models...', value = 0, {
      incProgress(0.3, detail = "Preparing data")

      # Fit models
      result <- train_data() %>%
        model(!!!model_list)

      incProgress(0.7, detail = "Finalizing")
      result
    })
  }) %>% bindCache(input$varietals, input$train_start, input$train_end,
                    input$fit_tslm, input$fit_ets, input$fit_arima)

  # Reactive: Forecasts
  forecasts <- reactive({
    req(fitted_models(), input$forecast_horizon)

    fitted_models() %>%
      forecast(h = input$forecast_horizon)
  }) %>% bindCache(input$varietals, input$train_start, input$train_end,
                    input$forecast_horizon, input$fit_tslm, input$fit_ets, input$fit_arima)

  # Output: Time series plot
  output$ts_plot <- renderPlot({
    req(filtered_data())

    train_end <- yearmonth(input$train_end)

    p <- filtered_data() %>%
      ggplot(aes(x = Month, y = Sales)) +
      geom_line(color = "steelblue", linewidth = 0.7) +
      geom_vline(xintercept = as.Date(train_end),
                 linetype = "dashed", color = "red", linewidth = 0.8) +
      facet_wrap(~Varietal, scales = "free_y", ncol = 1) +
      labs(
        title = "Australian Wine Sales by Varietal",
        subtitle = paste("Red line indicates training cutoff:", input$train_end),
        x = "Month",
        y = "Sales (thousands of liters)"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        strip.text = element_text(face = "bold", size = 12),
        plot.title = element_text(face = "bold", size = 16)
      )

    print(p)
  })

  # Output: Summary statistics table
  output$summary_table <- render_gt({
    req(filtered_data())

    filtered_data() %>%
      as_tibble() %>%
      group_by(Varietal) %>%
      summarise(
        Observations = n(),
        Mean = mean(Sales, na.rm = TRUE),
        SD = sd(Sales, na.rm = TRUE),
        Min = min(Sales, na.rm = TRUE),
        Max = max(Sales, na.rm = TRUE)
      ) %>%
      gt() %>%
      tab_header(title = "Summary Statistics by Varietal") %>%
      fmt_number(columns = c(Mean, SD, Min, Max), decimals = 1)
  })

  # Output: Model specifications table
  output$model_specs_table <- render_gt({
    req(fitted_models())

    model_names <- names(fitted_models())[!names(fitted_models()) %in% c("Varietal")]

    specs_df <- fitted_models() %>%
      pivot_longer(
        cols = all_of(model_names),
        names_to = "Model",
        values_to = "Fit"
      ) %>%
      mutate(Specification = format(Fit)) %>%
      as_tibble() %>%
      select(Varietal, Model, Specification)

    specs_df %>%
      gt() %>%
      tab_header(title = "Model Specifications by Varietal") %>%
      cols_label(
        Varietal = "Varietal",
        Model = "Model Type",
        Specification = "Specification"
      )
  })

  # Output: Training accuracy table
  output$train_accuracy_table <- render_gt({
    req(fitted_models())

    fitted_models() %>%
      accuracy() %>%
      select(Varietal, .model, RMSE, MAE, MAPE) %>%
      arrange(Varietal, .model) %>%
      gt() %>%
      tab_header(title = "Training Set Accuracy Metrics") %>%
      cols_label(
        Varietal = "Varietal",
        .model = "Model",
        RMSE = "RMSE",
        MAE = "MAE",
        MAPE = "MAPE"
      ) %>%
      fmt_number(columns = c(RMSE, MAE, MAPE), decimals = 2)
  })

  # Output: Validation accuracy table
  output$validation_accuracy_table <- render_gt({
    req(forecasts(), validation_data())

    # Check if validation data exists
    if (nrow(validation_data()) == 0) {
      return(
        tibble(Message = "No validation data available for the selected forecast horizon") %>%
          gt() %>%
          tab_header(title = "Validation Set Accuracy Metrics")
      )
    }

    forecasts() %>%
      accuracy(validation_data()) %>%
      select(Varietal, .model, RMSE, MAE, MAPE) %>%
      arrange(Varietal, .model) %>%
      gt() %>%
      tab_header(title = "Validation Set Accuracy Metrics") %>%
      cols_label(
        Varietal = "Varietal",
        .model = "Model",
        RMSE = "RMSE",
        MAE = "MAE",
        MAPE = "MAPE"
      ) %>%
      fmt_number(columns = c(RMSE, MAE, MAPE), decimals = 2)
  })

  # Output: Combined accuracy table
  output$combined_accuracy_table <- render_gt({
    req(fitted_models(), forecasts(), validation_data())

    # Training accuracy
    train_acc <- fitted_models() %>%
      accuracy() %>%
      select(Varietal, .model, RMSE, MAE, MAPE) %>%
      rename(
        RMSE_train = RMSE,
        MAE_train = MAE,
        MAPE_train = MAPE
      )

    # Validation accuracy
    if (nrow(validation_data()) > 0) {
      val_acc <- forecasts() %>%
        accuracy(validation_data()) %>%
        select(Varietal, .model, RMSE, MAE, MAPE) %>%
        rename(
          RMSE_val = RMSE,
          MAE_val = MAE,
          MAPE_val = MAPE
        )

      # Combine
      combined <- train_acc %>%
        left_join(val_acc, by = c("Varietal", ".model"))

      combined %>%
        gt() %>%
        tab_header(title = "Training vs Validation Accuracy") %>%
        cols_label(
          Varietal = "Varietal",
          .model = "Model"
        ) %>%
        fmt_number(
          columns = c(RMSE_train, MAE_train, MAPE_train,
                     RMSE_val, MAE_val, MAPE_val),
          decimals = 2
        ) %>%
        tab_spanner(
          label = "Training",
          columns = c(RMSE_train, MAE_train, MAPE_train)
        ) %>%
        tab_spanner(
          label = "Validation",
          columns = c(RMSE_val, MAE_val, MAPE_val)
        )
    } else {
      train_acc %>%
        gt() %>%
        tab_header(title = "Training Accuracy (No validation data available)")
    }
  })

  # Output: Forecast plot
  output$forecast_plot <- renderPlot({
    req(forecasts(), filtered_data())

    train_end <- yearmonth(input$train_end)

    p <- forecasts() %>%
      autoplot(filtered_data(), level = c(80, 95)) +
      facet_grid(Varietal ~ .model, scales = "free_y") +
      geom_vline(xintercept = as.Date(train_end),
                 linetype = "dashed", color = "red", linewidth = 0.8) +
      labs(
        title = "Comparative Forecasts by Model and Varietal",
        subtitle = paste("Forecast horizon:", input$forecast_horizon, "months | Red line = training cutoff"),
        x = "Month",
        y = "Sales (thousands of liters)",
        color = "Model",
        fill = "Prediction Interval"
      ) +
      theme_minimal(base_size = 12) +
      theme(
        strip.text = element_text(face = "bold", size = 10),
        plot.title = element_text(face = "bold", size = 14),
        legend.position = "bottom"
      )

    print(p)
  })

  # Output: Forecast table
  output$forecast_table <- render_gt({
    req(forecasts())

    forecasts() %>%
      as_tibble() %>%
      select(Varietal, .model, Month, .mean, Sales) %>%
      head(30) %>%
      gt() %>%
      tab_header(title = "Forecast Details (First 30 rows)") %>%
      cols_label(
        Varietal = "Varietal",
        .model = "Model",
        Month = "Month",
        .mean = "Forecast",
        Sales = "Distribution"
      ) %>%
      fmt_number(columns = .mean, decimals = 1)
  })
}

# Run the app
shinyApp(ui = ui, server = server)


