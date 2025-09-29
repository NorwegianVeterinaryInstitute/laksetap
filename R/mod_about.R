#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_about_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::nav_panel(
      "Om statistikken",
      value = "about",
      div(class = "container",
          style = "padding-left: 1.5rem",
          column(
            width = 9,
            shiny::includeMarkdown("app/www/about.md")
          ))
    )
  )
}
    
#' about Server Functions
#'
#' @noRd 
mod_about_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_about_ui("about_1")
    
## To be copied in the server
# mod_about_server("about_1")
