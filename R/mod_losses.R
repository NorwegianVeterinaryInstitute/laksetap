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
  ns <- NS(id)
  tagList(
 
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
