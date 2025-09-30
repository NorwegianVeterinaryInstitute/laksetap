#' cohort_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_cohort_mortality_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(class = "container",
        bslib::navset_tab(
          bslib::nav_panel(
            "Diagram",
            shiny::br(),
            shiny::column(
              width = 6,
              select_year(
                id = "select_year_coh",
                resolution = "y"
              )
            ),
            shiny::br(),
            shiny::br(),
            shiny::br(),
            shiny::br(),
            plotly::plotlyOutput("plot_cohort"),
            shiny::hr(),
            shiny::includeMarkdown(app_sys("www/cohorts_plot_footer.md"))
          ),
          bslib::nav_panel(
            "Tabell",
            shiny::br(),
            shiny::uiOutput("tab_filter_c"),
            shiny::div(
              DT::DTOutput("table_cohort")),
            shiny::hr(),
            shiny::div(
              shiny::includeMarkdown(app_sys("www/cohorts_table_footer.md")))
          )
        )
    )
  )
}
    
#' cohort_mortality Server Functions
#'
#' @noRd 
mod_cohort_mortality_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_cohort_mortality_ui("cohort_mortality_1")
    
## To be copied in the server
# mod_cohort_mortality_server("cohort_mortality_1")
