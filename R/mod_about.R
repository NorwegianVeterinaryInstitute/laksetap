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
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          "Om Statistikken",
          shiny::column(
            width = 9,
            shiny::includeMarkdown(app_sys("app/www/about.md"))
          )
        ),
        bslib::nav_panel(
          "Nedlasting",
          shiny::column(
            width = 9,
            shiny::tags$div(
              shiny::includeMarkdown(app_sys("app/www/download.md")),
              shiny::radioButtons(
                inputId = ns("which_dataset"),
                label = "Velg dataset å laste ned:",
                choices = list(
                  "Månedlig dødelighet %" = "monthly_mortality_data",
                  "Årlig dødelighet %" = "yearly_mortality_data",
                  "Årlige tapstall" = "yearly_losses_data",
                  "Månedlige tapstall" = "monthly_losses_data",
                  "Produksjonssyklus dødelighet %" = "cohort_mortality_data_area"
                ),
                selected = "monthly_mortality_data"
              ),
              shiny::downloadButton(
                ns("download_csv"),
                "Last ned valgt dataset (CSV)"
                
              ), 
              shiny::downloadButton(
                ns("download_json"),
                "Last ned valgt dataset (JSON)")
            )
          )
        )
      )
    )
  )
}
#' about Server Functions
#'
#' @noRd
mod_about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #### Data (read from options) ####
    datasets_list <- list(
      monthly_mortality_data = getOption("monthly_mortality_data"),
      yearly_mortality_data = getOption("yearly_mortality_data"),
      yearly_losses_data = getOption("yearly_losses_data"),
      monthly_losses_data = getOption("monthly_losses_data"),
      cohort_mortality_data_area = getOption("cohort_mortality_data_area")
    )
    
    # Reactive for selected dataset
    selected_dataset <- reactive({
      req(input$which_dataset)
      input$which_dataset
    })
    
    #### Download handler for selected dataset - CSV ####
    output$download_csv <- shiny::downloadHandler(
      filename = function() {
        paste0(selected_dataset(), "_", Sys.Date(), ".csv")
      },
      content = function(file) {
        dat <- datasets_list[[selected_dataset()]]
        if (is.null(dat)) {
          # write a small CSV with message
          msg <- tibble::tibble(
            message = paste("Dataset", selected_dataset(), "is not available")
          )
          readr::write_csv(msg, file)
        } else {
          # attempt to write dataset
          readr::write_csv(dat, file)
        }
      },
      contentType = "text/csv"
    )
    
    #### Download handler for selected dataset - JSON ####
    output$download_json <- shiny::downloadHandler(
      filename = function() {
        paste0(selected_dataset(), "_", Sys.Date(), ".json")
      },
      content = function(file) {
        dat <- datasets_list[[selected_dataset()]]
        if (is.null(dat)) {
          # Write a small JSON with message
          msg <- list(message = paste("Dataset", selected_dataset(), "is not available"))
          jsonlite::write_json(msg, path = file, pretty = TRUE, auto_unbox = TRUE)
        } else {
          # Write dataset as JSON
          jsonlite::write_json(dat, path = file, pretty = TRUE, auto_unbox = TRUE)
        }
      },
      contentType = "application/json"
    )
    
  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
