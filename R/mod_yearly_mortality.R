#' yearly_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_yearly_mortality_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(class = "container",
        bslib::navset_tab(
          bslib::nav_panel(
            "Diagram",
            shiny::br(),
            plotly::plotlyOutput("plot_mortality"),
            shiny::hr(),
            shiny::includeMarkdown(app_sys("www/mortality_yearly_table_and_plot_footer.md"))
          ),
          bslib::nav_panel(
            "Tabell",
            shiny::br(),
            shiny::uiOutput("tab_filter_2"),
            shiny::div(
              DT::DTOutput("table_mortality")),
            shiny::hr(),
            shiny::div(
              shiny::includeMarkdown(app_sys("www/mortality_yearly_table_and_plot_footer.md")))
          )
        )
    )
  )
}
    
#' yearly_mortality Server Functions
#'
#' @noRd 
mod_yearly_mortality_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_yearly_mortality_ui("yearly_mortality_1")
    
## To be copied in the server
# mod_yearly_mortality_server("yearly_mortality_1")
