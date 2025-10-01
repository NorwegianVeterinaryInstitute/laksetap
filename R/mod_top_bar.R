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

    output$top_bar <- shiny::renderUI({
      if (session$userData$active_tab() != "about") {
        shiny::tagList(
          shiny::fluidRow(
            shiny::column(
              width = 6,
              shiny::selectInput(
                ns("species"),
                "Velg art:",
                c("Laks" = "salmon", "Regnbueørret" = "rainbowtrout"),
                selected = c("salmon")
              )
            ),
            shiny::column(
              width = 6,
              shiny::selectInput(
                ns("geo_group"),
                "Velg geografisk område:",
                c(
                  "Fylke" = "fylke",
                  "Produksjonsområde" = "zone",
                  "Norge" = "all"
                ),
                selected = c("zone")
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
          choices = c("Norge" = "all")
        )
      } else {
        updateSelectInput(
          inputId = "geo_group",
          choices = c(
            "Fylke" = "fylke",
            "Produksjonsområde" = "zone",
            "Norge" = "all"
          )
        )
      }
    })

    session$userData$species <- shiny::reactiveVal('salmon')
    observeEvent(input$species, {
      session$userData$species(input$species)
    })
    session$userData$geo_group <- shiny::reactiveVal('fylke')
    observeEvent(input$geo_group, {
      session$userData$geo_group(input$geo_group)
    })
  })
}

## To be copied in the UI
# mod_top_bar_ui("top_bar_1")

## To be copied in the server
# mod_top_bar_server("top_bar_1")
