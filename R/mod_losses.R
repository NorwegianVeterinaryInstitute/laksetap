#' losses UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_losses_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          "Månedlige tap diagram",
          shiny::br(),
          shiny::fluidRow(
            shiny::column(
              width = 6,
              select_year(
                id = ns("select_year_monthly_losses"),
              )
            ),
            shiny::column(
              width = 6,
              select_months(
                id = ns("select_month_monthly_losses"),
                digit = TRUE,
                multiple = FALSE
              )
            )
          ),
          plotly::plotlyOutput(ns("plot_losses_monthly")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/losses_monthly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Månedlige tap tabell",
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_monthly_losses_table")),
          shiny::div(
            DT::DTOutput(ns("table_losses_month"))
          ),
          shiny::hr(),
          shiny::div(
            shiny::includeMarkdown(app_sys(
              "www/losses_monthly_table_and_plot_footer.md"
            ))
          )
        ),
        bslib::nav_panel(
          "Årlige tap diagram",
          shiny::br(),
          select_year(
            id = ns("select_year_yearly_losses"),
            resolution = "y"
          ),
          plotly::plotlyOutput(ns("plot_losses")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/losses_yearly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Årlige tap tabell",
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_yearly_losses_table")),
          shiny::div(
            DT::DTOutput(ns("table_losses_year"))
          ),
          shiny::hr(),
          shiny::div(
            shiny::includeMarkdown(app_sys(
              "www/losses_yearly_table_and_plot_footer.md"
            ))
          )
        ),
      )
    )
  )
}

#' losses Server Functions
#'
#' @noRd
mod_losses_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    #### Data ####
    #### Monthly losses ####
    monthly_losses_data <- getOption("monthly_losses_data")
    df_losses_month <-
      shiny::eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          monthly_losses_data |>
            dplyr::filter(
              species == session$userData$species() &
                geo_group == session$userData$geo_group()
            )
        }
      )

    #### Yearly losses ####
    yearly_losses_data <- getOption("yearly_losses_data")
    df_losses <-
      shiny::eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          yearly_losses_data |>
            dplyr::filter(
              species == session$userData$species() &
                geo_group == session$userData$geo_group()
            )
        }
      )

    #### UI for table losses monthly ####
    monthly_table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "area") {
        render_input_for_losses_monthly_table(
          ns = ns,
          dat = df_losses_month(),
          geo_group = "area"
        )
      } else if (session$userData$geo_group() == "county") {
        render_input_for_losses_monthly_table(
          ns = ns,
          dat = df_losses_month(),
          geo_group = "county"
        )
      } else {
        render_input_for_losses_monthly_table(
          ns = ns,
          dat = df_losses_month(),
          geo_group = "country"
        )
      }
    })

    output$tab_filter_monthly_losses_table <- shiny::renderUI({
      monthly_table_inputs_ui()
    }) |>
      bindEvent(monthly_table_inputs_ui())

    #### UI for table losses yearly ####
    yearly_table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "area") {
        render_input_for_losses_yearly_table(
          ns = ns,
          dat = df_losses(),
          geo_group = "area"
        )
      } else if (session$userData$geo_group() == "county") {
        render_input_for_losses_yearly_table(
          ns = ns,
          dat = df_losses(),
          geo_group = "county"
        )
      } else {
        render_input_for_losses_yearly_table(
          ns = ns,
          dat = df_losses(),
          geo_group = "country"
        )
      }
    })

    output$tab_filter_yearly_losses_table <- shiny::renderUI({
      yearly_table_inputs_ui()
    }) |>
      bindEvent(yearly_table_inputs_ui())

    #### OUTPUTS ####
    #### Losses monthly ####
    output$table_losses_month <- DT::renderDT({
      if (session$userData$geo_group() == "country") {
        dat <- losses_data_prep_table(df_losses_month(), resolution='m') |>
          dplyr::filter(
            area == "Norge" &
              year %in% input$select_years_losses_monthly_table,
            month_name %in% input$select_months_losses_monthly_table
          )

        losses_table(dat, resolution = "m")
      } else {
        dat <- losses_data_prep_table(df_losses_month(), resolution='m') |>
          dplyr::filter(
            year %in%
              input$select_years_losses_monthly_table,
            month_name %in% input$select_months_losses_monthly_table,
            region %in% input$select_area_losses_monthly_table
          )

        losses_table(dat, resolution = "m")
      }
    })

    output$plot_losses_monthly <- plotly::renderPlotly({
      dat <- losses_data_prep_plot(
        df_losses_month(),
        input$select_year_monthly_losses,
        input$select_month_monthly_losses,
        resolution = "m"
      )

      losses_plot(dat)
    })

    #### Losses yearly ####

    output$table_losses_year <- DT::renderDT({
      if (session$userData$geo_group() == "all") {
        dat <- losses_data_prep_table(
          df_losses(), resolution = "y") |> 
          dplyr::filter(
            year %in% input$select_years_losses_year_table
          )

        losses_table(dat, resolution = "y")
      } else {
        losses_data_prep_table(
          df_losses(), resolution = "y") |> 
          dplyr::filter(
            year %in%
              input$select_years_losses_year_table,
            area %in% input$select_region_losses_year_table
          )

        losses_table(dat, resolution = "y")
      }
    })

    #### Yearly losses plot ####
    output$plot_losses <- plotly::renderPlotly({
      dat <- losses_data_prep_plot(
        df_losses(),
        input$select_year_yearly_losses,
        resolution = "y"
      )

      losses_plot(dat)
    })
  })
}

## To be copied in the UI
# mod_losses_ui("losses_1")

## To be copied in the server
# mod_losses_server("losses_1")
