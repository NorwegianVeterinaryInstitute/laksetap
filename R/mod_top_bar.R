#' top_bar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_top_bar_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::uiOutput(ns("top_bar"))
  )
}

#' top_bar Server Functions
#'
#' @noRd
mod_top_bar_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    labels <- golem::get_golem_options(which = "labels")
    config <- golem::get_golem_options(which = "config")

    species_choices <- config$mod_top_bar$species_choices
    names(species_choices) <- labels$input_species$species

    geo_group_choices <- config$mod_top_bar$geo_group_choices
    names(geo_group_choices) <- labels$input_species$geo_group

    output$top_bar <- shiny::renderUI({
      if (session$userData$active_tab() != "about") {
        shiny::tagList(
          shiny::fluidRow(
            shiny::column(
              width = 6,
              shiny::selectInput(
                ns("species"),
                label = labels$input_species$select_species,
                choices = species_choices,
                selected = species_choices[[1]]
              )
            ),
            shiny::column(
              width = 6,
              shiny::selectInput(
                ns("geo_group"),
                label = labels$input_species$select_geo_group,
                choices = geo_group_choices,
                selected = geo_group_choices[[1]]
              )
            ),
          )
        )
      } else {
        NULL
      }
    })

    ##### UI updates because the dropdowns are not the same between species ####
    observeEvent(input$species, {
      if (input$species == "rainbowtrout") {
        updateSelectInput(
          inputId = "geo_group",
          choices = geo_group_choices[[3]]
        )
      } else {
        updateSelectInput(
          inputId = "geo_group",
          choices = geo_group_choices
        )
      }
    })

    session$userData$species <- shiny::reactiveVal('salmon')
    observeEvent(input$species, {
      session$userData$species(input$species)
    })
    session$userData$geo_group <- shiny::reactiveVal('area')
    observeEvent(input$geo_group, {
      session$userData$geo_group(input$geo_group)
    })
  })
}

## To be copied in the UI
# mod_top_bar_ui("top_bar_1")

## To be copied in the server
# mod_top_bar_server("top_bar_1")
