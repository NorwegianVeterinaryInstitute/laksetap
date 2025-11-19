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

  labels <- golem::get_golem_options(which = "labels")

  choices = c(
    "monthly_mortality_data",
    "cumulative_mortality_data",
    "monthly_losses_data",
    "yearly_losses_data",
    "cohort_mortality_data_area"
  )
  names(choices) <- c(
    labels$modules$monthly_mortality_data,
    labels$modules$cumulative_mortality_data,
    labels$modules$monthly_losses_data,
    labels$modules$yearly_losses_data,
    labels$modules$cohort_mortality_data_area
  )

  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          labels$modules$about,
          shiny::column(
            width = 9,
            shiny::includeMarkdown(app_sys("app/www/about.md"))
          )
        ),
        bslib::nav_panel(
          labels$modules$download,
          shiny::column(
            width = 9,
            shiny::tags$div(
              shiny::includeMarkdown(app_sys("app/www/download.md")),
              shiny::radioButtons(
                inputId = ns("which_dataset"),
                label = labels$modules$radio_button,
                choices = choices,
                selected = choices[[1]]
              ),
              shiny::downloadButton(
                ns("download_csv"),
                label = labels$modules$download_button_csv
              ),
              shiny::downloadButton(
                ns("download_json"),
                label = labels$modules$download_button_json
              )
            ),
            shiny::br(),
            shiny::tags$div(
              shiny::downloadButton(
                ns("download_excel"),
                label = labels$modules$download_button_excel
              )
            )
          ),
          shiny::includeMarkdown(app_sys("app/www/license.md"))
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
      cumulative_mortality_data = getOption("cumulative_mortality_data"),
      monthly_losses_data = getOption("monthly_losses_data"),
      yearly_losses_data = getOption("yearly_losses_data"),
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
          msg <- list(
            message = paste("Dataset", selected_dataset(), "is not available")
          )
          jsonlite::write_json(
            msg,
            path = file,
            pretty = TRUE,
            auto_unbox = TRUE
          )
        } else {
          # Write dataset as JSON
          jsonlite::write_json(
            dat,
            path = file,
            pretty = TRUE,
            auto_unbox = TRUE
          )
        }
      },
      contentType = "application/json"
    )

    #### Calculator download ####

    output$download_excel <- downloadHandler(
      filename = function() {
        "fish_mortality_calculator.xlsm"
      },
      content = function(file) {
        source_file <- app_sys("app/www/fish_mortality_calculator.xlsm")

        file.copy(source_file, file)
      }
    )
  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
