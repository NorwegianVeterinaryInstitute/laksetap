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
  ns <- NS(id)
  tagList(
 
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
