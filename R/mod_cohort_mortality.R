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
          shiny::includeMarkdown(app_sys("www/cohorts_plot_footer.md"))
        ),
        bslib::nav_panel(
          labels$modules$table,
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
    labels <- golem::get_golem_options(which = "labels")

    #### Data ####

    #### Used in the plot ####

    cohort_mortality_data_area_salmon <- getOption(
      "cohort_mortality_data_area_salmon"
    )
    cohort_mortality_data_county_salmon <- getOption(
      "cohort_mortality_data_county_salmon"
    )
    cohort_mortality_data_country_salmon <- getOption(
      "cohort_mortality_data_country_salmon"
    )
    cohort_mortality_data_area_rainbotrout <- getOption(
      "cohort_mortality_data_area_rainbotrout"
    )
    cohort_mortality_data_county_rainbotrout <- getOption(
      "cohort_mortality_data_county_rainbotrout"
    )
    cohort_mortality_data_country_rainbotrout <- getOption(
      "cohort_mortality_data_country_rainbotrout"
    )

    #### Used in the table ####
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
    })

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
    })

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
      if (
        session$userData$species() == "salmon" &
          session$userData$geo_group() == "area"
      ) {
        cohort_mortality_data_area_salmon |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          ) |>
          style_plotly(legend = FALSE)
      } else if (
        session$userData$species() == "salmon" &
          session$userData$geo_group() == "county"
      ) {
        cohort_mortality_data_county_salmon |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          ) |>
          style_plotly(legend = FALSE)
      } else if (
        session$userData$species() == "salmon" &
          session$userData$geo_group() == "county"
      ) {
        cohort_mortality_data_country_salmon |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          ) |>
          style_plotly(legend = FALSE)
      } else if (
        session$userData$species() == "rainbowtrout" &
          session$userData$geo_group() == "area"
      ) {
        cohort_mortality_data_area_rainbowtrout |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          ) |>
          style_plotly(legend = FALSE)
      } else if (
        session$userData$species() == "rainbowtrout" &
          session$userData$geo_group() == "county"
      ) {
        cohort_mortality_data_county_rainbowtrout |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          ) |>
          style_plotly(legend = FALSE)
      } else {
        cohort_mortality_data_country_rainbowtrout |>
          dplyr::filter(year == input$select_year_cohort) |>
          plot_cohorts_output(
            input$select_year_cohort
          ) |>
          style_plotly(legend = FALSE)
      }
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
            year %in% input$select_years_cohort_table & country == "Norge"
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
