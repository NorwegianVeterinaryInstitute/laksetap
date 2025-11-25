#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #### Labels to be used in the UI ####
  labels <- golem::get_golem_options(which = "labels")

  #### Make the title change with the tab ####
  output$tab_title <- shiny::renderUI({
    if (input$navbar == "monthly_mortality") {
      shiny::h2(labels$app_server$navbar_monthly_mortality)
    } else if (input$navbar == "cumulative_mortality") {
      shiny::h2(labels$app_server$navbar_cumulative_mortality)
    } else if (input$navbar == "prod_mortality") {
      shiny::h2(labels$app_server$navbar_prod_mortality)
    } else if (input$navbar == "calc_mortality") {
      shiny::h2(labels$app_server$navbar_calc_mortality)
    } else if (input$navbar == "losses") {
      shiny::h2(labels$app_server$navbar_losses)
    } else if (input$navbar == "about") {
      shiny::h2(labels$app_server$navbar_about)
    }
  })

  session$userData$active_tab <- shiny::reactive({
    input$navbar
  })

  #### Make the UI for the top bar content change on each tab ####
  mod_top_bar_server("top_bar_1")

  #### Modules ####
  mod_monthly_mortality_server("monthly_mortality_1")
  mod_cumulative_mortality_server("cumulative_mortality_1")
  mod_cohort_mortality_server("cohort_mortality_1")
  mod_losses_server("losses_1")
  mod_about_server("about_1")
}
