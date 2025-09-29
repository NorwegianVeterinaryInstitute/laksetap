#' monthly_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_monthly_mortality_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "container",
        bslib::navset_tab(
          bslib::nav_panel(
            "Diagram",
            br(),
            shiny::uiOutput(ns("tab_filter_monthly_plot")),
            plotly::plotlyOutput(ns("plot_mortality_month")),
            hr(),
            shiny::includeMarkdown(app_sys("app/www/mortality_monthly_plot_footer.md")),
          ),
          bslib::nav_panel(
            "Tabell",
            br(),
            shiny::uiOutput("tab_filter_m2"),
            shiny::div(
              DT::DTOutput(ns("table_mortality_month"))),
            hr(),
            shiny::div(
              shiny::includeMarkdown(app_sys("app/www/mortality_monthly_table_footer.md")))
          )
        ))
  )
}
    
#' monthly_mortality Server Functions
#'
#' @noRd 
mod_monthly_mortality_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_monthly_mortality_ui("monthly_mortality_1")
    
## To be copied in the server
# mod_monthly_mortality_server("monthly_mortality_1")
