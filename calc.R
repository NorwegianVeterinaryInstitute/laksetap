# Install and load necessary packages
if (!require("shiny")) install.packages("shiny")

# Define the UI
ui <- fluidPage(
  titlePanel("Mortality Rate Calculator"),
  
  tabsetPanel(
    tabPanel("Calculate Mortality Rate",
             sidebarLayout(
               sidebarPanel(
                 numericInput("beginning_count", "Number of Animals at the Beginning of the Month:", value = 100),
                 numericInput("end_count", "Number of Animals at the End of the Month:", value = 90),
                 numericInput("dead_count", "Number of Dead Animals During the Month:", value = 5),
                 actionButton("calculate_button", "Calculate"),
                 br(),
                 verbatimTextOutput("result_text"),
                 plotOutput("mortality_plot")
               ),
               
               mainPanel()
             )
    ),
    
    tabPanel("Calculate Cumulative Mortality Risk",
             sidebarLayout(
               sidebarPanel(
                 textInput("mortality_input_cum", "Enter Monthly Mortality Rates (comma-separated):", ""),
                 actionButton("calculate_button_cum", "Calculate"),
                 br(),
                 verbatimTextOutput("result_text_cum"),
                 plotOutput("cumulative_risk_plot")
               ),
               
               mainPanel()
             )
    )
  )
)

# Define the server
server <- function(input, output) {
  observeEvent(input$calculate_button, {
    # Calculate mortality rate
    ar_count <- input$end_count
    d_count <- input$dead_count
    mort_rate <- d_count / ar_count
    
    # Display the results
    output$result_text <- renderText({
      paste("Mortality Rate:", sprintf("%.2f%%", mort_rate * 100))
    })
    
    # Plot the mortality rate over time (placeholder plot)
    output$mortality_plot <- renderPlot({
      plot(1, type = "n", xlab = "", ylab = "", main = "Mortality Rate Over Time")
      text(1, 1, paste("Mortality Rate:", sprintf("%.2f%%", mort_rate * 100)), cex = 1.5)
    })
  })
  
  observeEvent(input$calculate_button_cum, {
    # Extract and convert monthly mortality rates
    mort_rates_cum <- as.numeric(unlist(strsplit(input$mortality_input_cum, ",")))
    
    # Calculate cumulative mortality risk
    sum_mort_rate_cum <- sum(mort_rates_cum)
    cum_risk_cum <- 1 - exp(-sum_mort_rate_cum)
    
    # Display the results
    output$result_text_cum <- renderText({
      paste("Cumulative Mortality Risk:", sprintf("%.2f%%", cum_risk_cum * 100))
    })
    
    # Plot the monthly mortality rates over time (placeholder plot)
    output$cumulative_risk_plot <- renderPlot({
      barplot(mort_rates_cum, names.arg = seq_along(mort_rates_cum), col = "steelblue", 
              main = "Monthly Mortality Rates",
              xlab = "Month", ylab = "Mortality Rate")
    })
  })
}

# Run the app
shinyApp(ui, server)