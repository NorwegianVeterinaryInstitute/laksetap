#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #### Data ####

  losses_monthly_data <- getOption("losses_monthly_data")

  #### Make the title change with the tab ####
  output$tab_title <- shiny::renderUI({
    if (input$navbar == "monthly_mortality") {
      shiny::h2("Månedlig dødelighet %")
    } else if (input$navbar == "yearly_mortality") {
      shiny::h2("Årlig dødelighet %")
    } else if (input$navbar == "prod_mortality") {
      shiny::h2("Produksjonssyklus dødelighet %")
    } else if (input$navbar == "calc_main") {
      shiny::h2("Dødelighetskalkulator")
    } else if (input$navbar == "losses") {
      shiny::h2("Tapstall")
    } else if (input$navbar == "about") {
      shiny::h2("Om statistikken")
    }
  })

  session$userData$active_tab <- shiny::reactive({
    input$navbar
  })

  #### Make the UI for the top bar content change on each tab ####
  mod_top_bar_server("top_bar_1")

  #### Modules ####
  mod_monthly_mortality_server("monthly_mortality_1")
  mod_yearly_mortality_server("yearly_mortality_1")
  mod_cohort_mortality_server("cohort_mortality_1")
}
