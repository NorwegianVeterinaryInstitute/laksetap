#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  #### Data ####
  laksetap_board <- pins::board_connect()
  
  losses <- pins::pin_read(laksetap_board, "vi2451/losses_and_mortality_yearly_data")
  losses_monthly_data <- pins::pin_read(laksetap_board, "vi2451/losses_monthly_data")
  mortality_rates_monthly_data <- pins::pin_read(laksetap_board, "vi2451/mortality_rates_monthly_data")
  mortality_cohorts_data <- pins::pin_read(laksetap_board, "vi2451/mortality_cohorts_data")
  
  
}
