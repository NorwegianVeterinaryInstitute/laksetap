#' cohort_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_cohort_mortality_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          shiny::br(),
          shiny::column(
            width = 6,
            select_year(
              id = ns("select_year_cohort"),
              resolution = "y"
            )
          ),
          shiny::br(),
          shiny::br(),
          shiny::br(),
          shiny::br(),
          plotly::plotlyOutput(ns("plot_cohort")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys("www/cohorts_plot_footer.md"))
        ),
        bslib::nav_panel(
          "Tabell",
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_cohorts_table")),
          shiny::div(
            DT::DTOutput(ns("table_cohort"))
          ),
          shiny::hr(),
          shiny::div(
            shiny::includeMarkdown(app_sys("www/cohorts_table_footer.md"))
          )
        )
      )
    )
  )
}

#' cohort_mortality Server Functions
#'
#' @noRd
mod_cohort_mortality_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #### Data ####

    #### Used in the plot ####

    mortality_cohorts_data_zone <- getOption("mortality_cohorts_data_zone")
    mortality_cohorts_data_fylke <- getOption("mortality_cohorts_data_fylke")
    mortality_cohorts_data_all <- getOption("mortality_cohorts_data_all")

    #### Used in the table ####
    mortality_cohorts_data <- getOption("mortality_cohorts_data")

    df_cohorts <-
      eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          mortality_cohorts_data |>
            dplyr::filter(
              species == session$userData$species() &
                viz == session$userData$geo_group()
            )
        }
      )

    #### UI for cohorts mortality table ####
    table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "zone") {
        render_input_for_cohorts_table(
          ns = ns,
          dat = df_cohorts(),
          viz = "zone"
        )
      } else if (session$userData$geo_group() == "fylke") {
        render_input_for_cohorts_table(
          ns = ns,
          dat = df_cohorts(),
          viz = "fylke"
        )
      } else {
        render_input_for_cohorts_table(
          ns = ns,
          dat = df_cohorts(),
          viz = "all"
        )
      }
    })

    output$tab_filter_cohorts_table <- shiny::renderUI({
      table_inputs_ui()
    }) |>
      bindEvent(table_inputs_ui())

    #### OUTPUTS ####

    #### Plot cohorts mortality ####
    output$plot_cohort <- plotly::renderPlotly({
      validate(need(
        session$userData$species() == "salmon",
        message = "Ingen data å vise"
      ))
      if (session$userData$geo_group() == "zone") {
        mortality_cohorts_data_zone |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          )
      } else if (session$userData$geo_group() == "fylke") {
        mortality_cohorts_data_fylke |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          )
      } else {
        mortality_cohorts_data_all |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          )
      }
    }) |>
      bindEvent(
        input$select_year_cohort,
        session$userData$species(),
        session$userData$geo_group()
      )

    #### Table cohorts mortality ####
    output$table_cohort <- DT::renderDT({
      if (session$userData$geo_group() == "all") {
        dat <- df_cohorts() |>
          dplyr::filter(
            year %in% input$select_years_cohort_table & area == "Norge"
          ) |>
          dplyr::select(year, area, q1, median, q3)
        table_cohorts_output(dat)
      } else {
        dat <- df_cohorts() |>
          dplyr::filter(
            year %in%
              input$select_years_cohort_table &
              area %in% input$select_area_cohort_table
          ) |>
          dplyr::select(year, area, q1, median, q3)

        table_cohorts_output(dat)
      }
    })
  })
}

## To be copied in the UI
# mod_cohort_mortality_ui("cohort_mortality_1")

## To be copied in the server
# mod_cohort_mortality_server("cohort_mortality_1")
