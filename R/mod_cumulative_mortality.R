#' cumulative_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import ggplot2
mod_cumulative_mortality_ui <- function(id) {
  ns <- shiny::NS(id)

  labels <- golem::get_golem_options(which = "labels")

  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          labels$modules$plot,
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_cumulative_mortality_plot")),
          plotly::plotlyOutput(ns("plot_cumulative_mortality")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "app/www/cumulative_mortality_yearly_plot_footer.md"
          )),
        ),
        bslib::nav_panel(
          labels$modules$table,
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_cumulative_mortality_table")),
          shiny::div(
            DT::DTOutput(ns("table_cumulative_mortality"))
          )
          #,
          #shiny::hr(),
          #shiny::div(
           # shiny::includeMarkdown(app_sys(
            #  "app/www/cumulative_mortality_yearly_table_footer.md"
            #))
          #)
        )
      )
    )
  )
}

#' monthly_mortality Server Functions
#'
#' @noRd
mod_cumulative_mortality_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #### DATA ####
    cumulative_mortality_yr_data <- getOption("cumulative_mortality_yr_data_lc")
    df_cumulative <-
      eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          cumulative_mortality_yr_data |>
            dplyr::filter(
              species == session$userData$species() &
                geo_group %in% c(session$userData$geo_group(), "country")
            )
        }
      )

    #### UI for tab cumulative mortality ####
    plot_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "area") {
        render_input_for_cumulative_mortality_plot(
          ns = ns,
          dat = df_cumulative(),
          geo_group = "area"
        )
      } else if (session$userData$geo_group() == "county") {
        render_input_for_cumulative_mortality_plot(
          ns = ns,
          dat = df_cumulative(),
          geo_group = "county"
        )
      } else {
        render_input_for_cumulative_mortality_plot(
          ns = ns,
          dat = df_cumulative(),
          geo_group = "country"
        )
      }
    }) |>
      bindEvent(session$userData$species(),
                session$userData$geo_group())

    output$tab_filter_cumulative_mortality_plot <- shiny::renderUI({
      plot_inputs_ui()
    }) |>
      bindEvent(plot_inputs_ui())

    table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "area") {
        render_input_for_cumulative_mortality_table(
          ns = ns,
          dat = df_cumulative(),
          geo_group = "area"
        )
      } else if (session$userData$geo_group() == "county") {
        render_input_for_cumulative_mortality_table(
          ns = ns,
          dat = df_cumulative(),
          geo_group = "county"
        )
      } else {
        render_input_for_cumulative_mortality_table(
          ns = ns,
          dat = df_cumulative(),
          geo_group = "country"
        )
      }
    })  |>
      bindEvent(session$userData$species(),
                session$userData$geo_group())

    output$tab_filter_cumulative_mortality_table <- shiny::renderUI({
      table_inputs_ui()
    }) |>
      bindEvent(table_inputs_ui())

    #### OUTPUTS ####

    #### Plot cumulative mortality ####
    output$plot_cumulative_mortality <- plotly::renderPlotly({
      req(df_cumulative())
      req(input$select_year_cumulative_mortality)
      req(input$select_region_cumulative_mortality_plot)

      p <- df_cumulative() |>
        dplyr::filter(year %in% input$select_year_cumulative_mortality) |>
        dplyr::filter(
          region %in% c(input$select_region_cumulative_mortality_plot)
        ) |>
        cumulative_mortality_plot()

      style_plotly(p)
    })

    #### Table cumulative mortality ####
    output$table_cumulative_mortality <- DT::renderDT({
      req(session$userData$geo_group())
      req(input$select_years_cumulative_mortality_table)
      #req(input$select_months_cumulative_mortality_table)
      dat <- df_cumulative() |>
        dplyr::filter(
          year %in% input$select_years_cumulative_mortality_table #,
          #month_name %in% input$select_months_cumulative_mortality_table
        ) |>
        dplyr::select(year, month_name, region, mean)

      if (session$userData$geo_group() != "country") {
        req(input$select_region_cumulative_mortality)
        dat <- dat |>
          dplyr::filter(region %in% input$select_region_cumulative_mortality)
      }

      cumulative_mortality_table(dat)
    })
  })
}

## To be copied in the UI
# mod_cumulative_mortality_ui1("cumulative_mortality_1")

## To be copied in the server
# mod_cumulative_mortality_server("cumulative_mortality_1")
