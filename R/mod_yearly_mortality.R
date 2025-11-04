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
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          shiny::br(),
          #shiny::uiOutput(ns("tab_filter_mortality_year_plot")),
          plotly::plotlyOutput(ns("plot_mortality_year")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/mortality_yearly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Tabell",
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_mortality_year_table")),
          shiny::div(
            DT::DTOutput(ns("table_mortality_year"))
          ),
          shiny::hr(),
          shiny::div(
            shiny::includeMarkdown(app_sys(
              "www/mortality_yearly_table_and_plot_footer.md"
            ))
          )
        )
      )
    )
  )
}

#' yearly_mortality Server Functions
#'
#' @noRd
mod_yearly_mortality_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #### Data ####
    yearly_mortality_data <- getOption("yearly_mortality_data")
    df_losses <-
      shiny::eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          yearly_mortality_data |>
            dplyr::filter(
              species == session$userData$species() &
                geo_group == session$userData$geo_group()
            )
        }
      )

    #### UI for tab mortality yearly ####
    inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "area") {
        render_input_for_mortality_year(
          ns = ns,
          dat = df_losses(),
          geo_group = "area"
        )
      } else if (session$userData$geo_group() == "county") {
        render_input_for_mortality_year(
          ns = ns,
          dat = df_losses(),
          geo_group = "county"
        )
      } else {
        render_input_for_mortality_year(
          ns = ns,
          dat = df_losses(),
          geo_group = "country"
        )
      }
    }) |>
      bindEvent(session$userData$geo_group())

    output$tab_filter_mortality_year_table <- shiny::renderUI({
      inputs_ui()
    }) |>
      bindEvent(inputs_ui())

    #### Plot mortality yearly ####
    output$plot_mortality_year <- plotly::renderPlotly({
      #### This should be resolved on the data level ####
      dat <- df_losses() |>
        tidyr::spread(year, mort) |>
        dplyr::filter(
          !is.na(`2024`) |
            !is.na(`2023`) |
            !is.na(`2022`) |
            !is.na(`2021`) |
            !is.na(`2020`)
        ) |>
        dplyr::filter(!(area == "All" | area == "Norway")) |>
        dplyr::filter(area != "Agder") |>
        dplyr::filter(area != "1", area != "13") |>
        droplevels()
      plot_yearly_mortality_outputs(dat)
    }) |>
      bindEvent(
        df_losses()
      )

    #### Table mortality yearly ####
    mortality_year_filter_data <- shiny::reactive({
      if (session$userData$geo_group() != "all") {
        df_losses() |>
          dplyr::filter(!is.na(mort)) |>
          dplyr::select(year, area, mort) |>
          dplyr::filter(year %in% input$select_years_mortality_year)
      } else {
        df_losses() |>
          dplyr::filter(!is.na(mort)) |>
          dplyr::select(year, area, mort) |>
          dplyr::filter(
            year %in%
              input$select_years_mortality_year &
              area %in% input$select_area_mortality_year
          )
      }
    }) |>
      bindEvent(
        session$userData$geo_group(),
        df_losses(),
        input$select_years_mortality_year,
        input$select_area_mortality_year
      )

    output$table_mortality_year <- DT::renderDT(
      table_yearly_mortality_outputs(mortality_year_filter_data()),
    ) |>
      bindEvent(mortality_year_filter_data())
  })
}

#### MORTALITY yearly ####

## To be copied in the UI
# mod_yearly_mortality_ui("yearly_mortality_1")

## To be copied in the server
# mod_yearly_mortality_server("yearly_mortality_1")
