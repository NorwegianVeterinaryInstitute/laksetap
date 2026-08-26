#' chat UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_chat_ui <- function(id) {
  ns <- shiny::NS(id)

  labels <- golem::get_golem_options(which = "labels")

  shiny::tagList(
    shiny::div(
      class = "container",
      shiny::p(labels$modules$chat_disclaimer),
      shinychat::chat_mod_ui(
        ns("chat"),
        placeholder = labels$modules$chat_placeholder,
        width = "100%",
        height = "500px",
        fill = FALSE
      )
    )
  )
}

#' chat Server Functions
#'
#' @noRd
mod_chat_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    config <- golem::get_golem_options(which = "config")
    labels <- golem::get_golem_options(which = "labels")

    client <- ellmer::chat_ollama(
      model = config$mod_chat$ollama_model,
      base_url = config$mod_chat$ollama_base_url,
      system_prompt = chat_system_prompt(),
      params = ellmer::params(temperature = 0.2)
    )
    client$set_tools(build_chat_tools())

    shinychat::chat_mod_server(
      "chat",
      client = client,
      greeting = labels$modules$chat_greeting
    )
  })
}

## To be copied in the UI
# mod_chat_ui("chat_1")

## To be copied in the server
# mod_chat_server("chat_1")
