#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  #### Data ####
  losses <- getOption("losses")  
  losses_monthly_data <- getOption("losses_monthly_data")
  mortality_cohorts_data <- getOption("mortality_cohorts_data")
  mortality_rates_monthly_data <- getOption("mortality_rates_monthly_data")

}
