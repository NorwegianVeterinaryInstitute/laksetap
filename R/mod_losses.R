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
            id = ns("select_year_losses"),
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
            DT::DTOutput(ns("table_losses"))
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
    losses_monthly_data <- getOption("losses_monthly_data")
    df_losses_month <-
      shiny::eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          losses_monthly_data |>
            dplyr::filter(
              species == session$userData$species() &
                viz == session$userData$geo_group()
            )
        }
      )

    #### Yearly losses ####
    losses <- getOption("losses")
    df_losses <-
      shiny::eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          losses |>
            dplyr::filter(
              species == session$userData$species() &
                viz == session$userData$geo_group()
            )
        }
      )

    #### UI for table losses monthly ####
    montly_table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "zone") {
        render_input_for_losses_montly_table(
          ns = ns,
          dat = df_losses_month(),
          viz = "zone"
        )
      } else if (session$userData$geo_group() == "fylke") {
        render_input_for_losses_montly_table(
          ns = ns,
          dat = df_losses_month(),
          viz = "fylke"
        )
      } else {
        render_input_for_losses_montly_table(
          ns = ns,
          dat = df_losses_month(),
          viz = "all"
        )
      }
    })

    output$tab_filter_monthly_losses_table <- shiny::renderUI({
      montly_table_inputs_ui()
    }) |>
      bindEvent(montly_table_inputs_ui())

    #### UI for table losses yearly ####
    yearly_table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "zone") {
        render_input_for_losses_yearly_table(
          ns = ns,
          dat = df_losses(),
          viz = "zone"
        )
      } else if (session$userData$geo_group() == "fylke") {
        render_input_for_losses_yearly_table(
          ns = ns,
          dat = df_losses(),
          viz = "fylke"
        )
      } else {
        render_input_for_losses_yearly_table(
          ns = ns,
          dat = df_losses(),
          viz = "all"
        )
      }
    })

    output$tab_filter_yearly_losses_table <- shiny::renderUI({
      yearly_table_inputs_ui()
    }) |>
      bindEvent(yearly_table_inputs_ui())

    #### OUTPUTS ####

    #### Yearly losses table ####
    ##### Yearly tables need to observe for Norge #####
    observeEvent(input$geo_group, {
      if (input$geo_group == "all") {
        output$table_losses <- DT::renderDT(
          datatable(
            df_losses() %>%
              dplyr::select(
                "year",
                "area",
                "losses",
                "doed",
                "ut",
                "romt",
                "ufor"
              ) %>%
              dplyr::filter(
                year %in% input$select_years_table1
              ),
            # filter = "top",
            rownames = F,
            colnames = c(
              "År",
              "Område",
              "Total",
              "Døde",
              "Utkast",
              "Rømt",
              "Annet"
            ),
            selection = (list(
              mode = "multiple",
              selected = "all",
              target = "column"
            )),
            options = list(
              sDom = '<"top">lrt<"bottom">ip',
              scrollX = FALSE,
              language = list(
                url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
              )
            )
          )
        )
      } else {
        output$table_losses <- DT::renderDT(
          datatable(
            df_losses() %>%
              dplyr::select(
                "year",
                "area",
                "losses",
                "doed",
                "ut",
                "romt",
                "ufor"
              ) %>%
              dplyr::filter(
                year %in%
                  input$select_years_table1 &
                  area %in% input$select_area1
              ),
            # filter = "top",
            rownames = F,
            colnames = c(
              "År",
              "Område",
              "Total",
              "Døde",
              "Utkast",
              "Rømt",
              "Annet"
            ),
            selection = (list(
              mode = "multiple",
              selected = "all",
              target = "column"
            )),
            options = list(
              sDom = '<"top">lrt<"bottom">ip',
              scrollX = FALSE,
              language = list(
                url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
              )
            )
          )
        )
      }
    })

    #### Yearly losses plot ####
    output$plot_losses <- plotly::renderPlotly({
      dat <- losses_data_prep(
        df_losses(),
        input$select_year_monthly_losses,
        resolution = "y"
      )

      losses_plot(dat)
    })

    #### losses monthly ####

    output$table_losses_month <- DT::renderDT({
      if (input$geo_group == "all") {
        df_losses_month() %>%
          dplyr::filter(
            !area == "All" &
              year %in% input$select_years_table3 &
              area == "Norge" &
              month_name %in% input$select_month_table3
          ) %>%
          dplyr::select(
            "year",
            "month_name",
            "area",
            "losses",
            "doed",
            "ut",
            "romt",
            "ufor"
          ) %>%
          datatable(
            # filter = "top",
            rownames = F,
            colnames = c(
              "År",
              "Måned",
              "Område",
              "Total",
              "Døde",
              "Utkast",
              "Rømt",
              "Annet"
            ),
            selection = (list(
              mode = "multiple",
              selected = "all",
              target = "column"
            )),
            options = list(
              sDom = '<"top">lrt<"bottom">ip',
              scrollX = FALSE,
              language = list(
                url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
              )
            )
          )
      } else {
        df_losses_month() %>%
          dplyr::filter(
            !area == "All" &
              year %in% input$select_years_table3 &
              area %in% input$select_area3 &
              month_name %in% input$select_month_table3
          ) %>%
          dplyr::select(
            "year",
            "month_name",
            "area",
            "losses",
            "doed",
            "ut",
            "romt",
            "ufor"
          ) %>%
          datatable(
            # filter = "top",
            rownames = F,
            colnames = c(
              "År",
              "Måned",
              "Område",
              "Total",
              "Døde",
              "Utkast",
              "Rømt",
              "Annet"
            ),
            selection = (list(
              mode = "multiple",
              selected = "all",
              target = "column"
            )),
            options = list(
              sDom = '<"top">lrt<"bottom">ip',
              scrollX = FALSE,
              language = list(
                url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
              )
            )
          )
      }
    })

    output$plot_losses_monthly <- plotly::renderPlotly({
      dat <- losses_data_prep(
        df_losses_month(),
        input$select_year_monthly_losses,
        input$select_month_monthly_losses,
        resolution = "m"
      )

      losses_plot(dat)
    })
  })
}

## To be copied in the UI
# mod_losses_ui("losses_1")

## To be copied in the server
# mod_losses_server("losses_1")
