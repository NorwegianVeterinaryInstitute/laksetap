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

  labels <- golem::get_golem_options(which = "labels")

  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          labels$modules$plot,
          shiny::br(),
          shiny::uiOutput(ns("select_year_cohort_ui")),
          plotly::plotlyOutput(ns("plot_cohort")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys("app/www/cohorts_plot_footer.md"))
        ),
        bslib::nav_panel(
          labels$modules$table,
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_cohorts_table")),
          shiny::div(
            DT::DTOutput(ns("table_cohort"))
          )
          #,
          #shiny::hr(),
          #shiny::div(
           # shiny::includeMarkdown(app_sys("app/www/cohorts_table_footer.md"))
          #)
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
    labels <- golem::get_golem_options(which = "labels")

    #### Data ####

    cohort_mortality_data <- getOption("cohort_mortality_data")

    df_cohorts <-
      eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          cohort_mortality_data |>
            dplyr::filter(
              species == session$userData$species() &
                geo_group == session$userData$geo_group()
            )
        }
      )

    #### UI for select year ####
    output$select_year_cohort_ui <- shiny::renderUI({
      shiny::column(
        width = 6,
        select_year(
          id = ns("select_year_cohort"),
          dat = cohort_mortality_data
        )
      )
    }) |>
      bindEvent(session$userData$species(),
                session$userData$geo_group())

    #### UI for cohorts mortality table ####
    table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "area") {
        render_input_for_cohorts_table(
          ns = ns,
          dat = df_cohorts(),
          geo_group = "area"
        )
      } else if (session$userData$geo_group() == "county") {
        render_input_for_cohorts_table(
          ns = ns,
          dat = df_cohorts(),
          geo_group = "county"
        )
      } else {
        render_input_for_cohorts_table(
          ns = ns,
          dat = df_cohorts(),
          geo_group = "country"
        )
      }
    }) |>
      bindEvent(session$userData$species(),
                session$userData$geo_group())

    output$tab_filter_cohorts_table <- shiny::renderUI({
      table_inputs_ui()
    }) |>
      bindEvent(table_inputs_ui())

    #### OUTPUTS ####

    #### Plot cohorts mortality ####
    output$plot_cohort <- plotly::renderPlotly({
      # validate(need(
      #   session$userData$species() == "salmon",
      #   message = labels$modules$no_data_message
      # ))
      req(input$select_year_cohort)
      req(session$userData$species())
      req(session$userData$geo_group())
      p <- df_cohorts() |>
        dplyr::filter(year == input$select_year_cohort) |>
        plot_cohorts_output(
          input$select_year_cohort
        )
      style_plotly(p)
    }) |>
      bindEvent(
        input$select_year_cohort,
        session$userData$species(),
        session$userData$geo_group()
      )

    #### Table cohorts mortality ####
    output$table_cohort <- DT::renderDT({
      if (session$userData$geo_group() == "country") {
        dat <- df_cohorts() |>
          dplyr::filter(
            year %in% input$select_years_cohort_table,
            geo_group == session$userData$geo_group()
          ) |>
          dplyr::select(year, region, q1, median, q3)
        cohorts_mortality_table(dat)
      } else {
        dat <- df_cohorts() |>
          dplyr::filter(
            year %in%
              input$select_years_cohort_table &
              region %in% input$select_region_cohort_table
          ) |>
          dplyr::select(year, region, q1, median, q3)

        cohorts_mortality_table(dat)
      }
    })
  })
}

## To be copied in the UI
# mod_cohort_mortality_ui("cohort_mortality_1")

## To be copied in the server
# mod_cohort_mortality_server("cohort_mortality_1")
