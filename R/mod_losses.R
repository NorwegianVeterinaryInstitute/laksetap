#' losses UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_losses_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(class = "container",
        bslib::navset_tab(
          bslib::nav_panel(
            "Månedlige tap diagram",
            shiny::br(),
            shiny::fluidRow(
              shiny::column(
                width = 6,
                select_year(
                  id = "select_year"
                )
              ),
              shiny::column(
                width = 6,
                shiny::selectInput(
                  "select_month",
                  "Velg måned:",
                  list(
                    "Måned" = c(
                      "01",
                      "02",
                      "03",
                      "04",
                      "05",
                      "06",
                      "07",
                      "08",
                      "09",
                      "10",
                      "11",
                      "12"
                    )
                  )
                )
              )
            ),
            plotly::plotlyOutput("plot_losses_monthly"),
            shiny::hr(),
            shiny::includeMarkdown(app_sys("www/losses_monthly_table_and_plot_footer.md"))
          ),
          bslib::nav_panel(
            "Månedlige tap tabell",
            shiny::br(),
            shiny::uiOutput("tab_filter_m1"),
            shiny::div(
              DT::DTOutput("table_losses_month")),
            shiny::hr(),
            shiny::div(
              shiny::includeMarkdown(app_sys("www/losses_monthly_table_and_plot_footer.md")))
          ),
          bslib::nav_panel(
            "Årlige tap diagram",
            shiny::br(),
            select_year(
              id = "select_year_losses",
              resolution = "y"
            ),
            plotly::plotlyOutput("plot_losses"),
            shiny::hr(),
            shiny::includeMarkdown(app_sys("www/losses_yearly_table_and_plot_footer.md"))
          ),
          bslib::nav_panel(
            "Årlige tap tabell",
            shiny::br(),
            shiny::uiOutput("tab_filter"),
            shiny::div(
              DT::DTOutput("table_losses")),
            shiny::hr(),
            shiny::div(
              shiny::includeMarkdown(app_sys("www/losses_yearly_table_and_plot_footer.md")))
          ),
        )
    )
  )
}
    
#' losses Server Functions
#'
#' @noRd 
mod_losses_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_losses_ui("losses_1")
    
## To be copied in the server
# mod_losses_server("losses_1")
