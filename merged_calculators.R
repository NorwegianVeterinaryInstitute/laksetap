library(shiny)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(shinyjs)

ui <- fluidPage(
  titlePanel("Mortality Calculator"),
  sidebarLayout(
    sidebarPanel(
      h4("Add one entry for each period with production"),
      selectInput("year", "Select Year:", choices = 2014:as.numeric(format(Sys.Date(), "%Y")), selected = as.numeric(format(Sys.Date(), "%Y"))),
      radioButtons("period_type", "Select Period Type:", choices = c("Monthly", "Weekly")),
      uiOutput("period_input"),
      numericInput("beginning_count", "Beginning Count:", value = NA, min = 0),
      numericInput("end_count", "End Count:", value = NA, min = 0),
      numericInput("dead_count", "Dead Count:", value = NA, min = 0),
      actionButton("add_entry_button", "Add Entry"),
      br(), br(),
      actionButton("clear_data_button", "Clear All Data"),
      br(), br(),
      downloadButton("download_table", "Download Table (.csv)"),
      downloadButton("download_plot", "Download Plot (.png)")
    ),
    mainPanel(
      h3("Mortality Table"),
      tableOutput("mortality_table"),
      h3("Mortality Plots"),
      plotOutput("mortality_plots")
    )
  )
)

server <- function(input, output, session) {
  mortality_data <- reactiveVal(data.frame(
    Period = character(),
    BeginningCount = numeric(),
    EndCount = numeric(),
    DeadCount = numeric(),
    Mortality = numeric(),
    stringsAsFactors = FALSE
  ))
  
  output$period_input <- renderUI({
    if (input$period_type == "Monthly") {
      selectInput("period_value", "Month:", choices = sprintf("%02d", 1:12))
    } else {
      selectInput("period_value", "Week:", choices = sprintf("%02d", 1:53))
    }
  })
  
  observeEvent(input$add_entry_button, {
    req(!is.na(input$year), !is.na(input$period_value),
        !is.na(input$beginning_count), !is.na(input$end_count), !is.na(input$dead_count))
    req(input$beginning_count >= 0, input$end_count >= 0, input$dead_count >= 0)
    
    ar_count <- (input$beginning_count + input$end_count) / 2
    
    if (ar_count == 0) {
      showNotification("Beginning and end counts cannot both be zero.", type = "error")
      return()
    }
    
    period_str <- paste0(input$year, "-", sprintf("%02d", as.integer(input$period_value)))
    
    existing <- mortality_data()
    if (period_str %in% existing$Period) {
      showNotification("This period already has data. Please choose another.", type = "error")
      return()
    }
    
    mort_rate <- input$dead_count / ar_count
    mort_risk <- 1 - exp(-mort_rate)
    
    new_entry <- data.frame(
      Period = period_str,
      BeginningCount = input$beginning_count,
      EndCount = input$end_count,
      DeadCount = input$dead_count,
      Mortality = mort_risk,
      stringsAsFactors = FALSE
    )
    
    updated_data <- bind_rows(existing, new_entry)
    mortality_data(updated_data)
  })
  
  observeEvent(input$clear_data_button, {
    mortality_data(data.frame(
      Period = character(),
      BeginningCount = numeric(),
      EndCount = numeric(),
      DeadCount = numeric(),
      Mortality = numeric(),
      stringsAsFactors = FALSE
    ))
  })
  
  output$mortality_table <- renderTable({
    df <- mortality_data()
    if (nrow(df) == 0) return(NULL)
    
    df <- df %>% arrange(Period)
    cum_risks <- 1 - exp(-cumsum(-log(1 - df$Mortality)))
    
    df %>%
      mutate(
        Mortality = sprintf("%.2f%%", Mortality * 100),
        CumulativeMortality = sprintf("%.2f%%", cum_risks * 100)
      )
  })
  
  output$mortality_plots <- renderPlot({
    df <- mortality_data()
    req(nrow(df) > 0)
    
    df <- df %>% arrange(Period)
    mort_risks <- df$Mortality
    cum_risks <- 1 - exp(-cumsum(-log(1 - mort_risks)))
    
    latest_cum <- tail(cum_risks, 1)
    
    plot_title <- ifelse(input$period_type == "Monthly", "Monthly Mortality", "Weekly Mortality")
    x_axis_label <- ifelse(input$period_type == "Monthly", "Month", "Week")
    
    par(mfrow = c(2, 1))
    
    barplot(mort_risks * 100,
            names.arg = df$Period, col = "#1C4FB9",
            main = plot_title,
            xlab = x_axis_label, ylab = "Mortality (%)")
    
    plot(cum_risks * 100,
         type = "o", col = "#FF5447", pch = 20, lty = 1,
         main = "Cumulative Mortality Over Time",
         xlab = x_axis_label, ylab = "Mortality (%)",
         ylim = c(0, max(cum_risks * 100) * 1.1),
         xaxt = "n")
    axis(1, at = 1:length(cum_risks), labels = df$Period)
    text(x = length(cum_risks), y = latest_cum * 100, labels = sprintf("Latest: %.2f%%", latest_cum * 100), pos = 3, col = "blue")
  })
  
  output$download_table <- downloadHandler(
    filename = function() {
      paste0("mortality_table_", Sys.Date(), ".csv")
    },
    content = function(file) {
      df <- mortality_data()
      if (nrow(df) == 0) return(NULL)
      
      df <- df %>% arrange(Period)
      cum_risks <- 1 - exp(-cumsum(-log(1 - df$Mortality)))
      df$Mortality <- sprintf("%.2f%%", df$Mortality * 100)
      df$CumulativeMortality <- sprintf("%.2f%%", cum_risks * 100)
      
      write.csv(df, file, row.names = FALSE)
    }
  )
  
  output$download_plot <- downloadHandler(
    filename = function() {
      paste0("mortality_plots_", Sys.Date(), ".png")
    },
    content = function(file) {
      df <- mortality_data()
      if (nrow(df) == 0) return(NULL)
      
      df <- df %>% arrange(Period)
      mort_risks <- df$Mortality
      cum_risks <- 1 - exp(-cumsum(-log(1 - mort_risks)))
      latest_cum <- tail(cum_risks, 1)
      
      plot_title <- ifelse(input$period_type == "Monthly", "Monthly Mortality", "Weekly Mortality")
      x_axis_label <- ifelse(input$period_type == "Monthly", "Month", "Week")
      
      png(file, width = 800, height = 600)
      par(mfrow = c(2, 1))
      barplot(mort_risks * 100,
              names.arg = df$Period, col = "#1C4FB9",
              main = plot_title,
              xlab = x_axis_label, ylab = "Mortality (%)")
      
      plot(cum_risks * 100,
           type = "o", col = "#FF5447", pch = 20, lty = 1,
           main = "Cumulative Mortality Over Time",
           xlab = x_axis_label, ylab = "Mortality (%)",
           ylim = c(0, max(cum_risks * 100) * 1.1),
           xaxt = "n")
      axis(1, at = 1:length(cum_risks), labels = df$Period)
      text(x = length(cum_risks), y = latest_cum * 100, labels = sprintf("Latest: %.2f%%", latest_cum * 100), pos = 3, col = "blue")
      dev.off()
    }
  )
}

shinyApp(ui, server)
