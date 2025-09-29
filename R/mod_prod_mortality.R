#' prod_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_prod_mortality_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' prod_mortality Server Functions
#'
#' @noRd 
mod_prod_mortality_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_prod_mortality_ui("prod_mortality_1")
    
## To be copied in the server
# mod_prod_mortality_server("prod_mortality_1")
