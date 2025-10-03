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
          shiny::uiOutput("tab_filter_mortality_year_plot"),
          plotly::plotlyOutput("plot_mortality"),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/mortality_yearly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Tabell",
          shiny::br(),
          shiny::uiOutput("tab_filter_mortality_year_table"),
          shiny::div(
            DT::DTOutput("table_mortality")
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
    losses <- getOption("losses")
    df_losses <-
      eventReactive(c(input$species, input$geo_group), {
        losses |>
          dplyr::filter(
            species == input$species &
              viz == input$geo_group
          )
      })

    #### UI for tab mortality yearly ####
    #### Plot and table currently share the same UI ####
    inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "zone") {
        render_input_for_mortality_year(
          ns = ns,
          dat = df_losses(),
          viz = "zone"
        )
      } else if (session$userData$geo_group() == "fylke") {
        render_input_for_mortality_year(
          ns = ns,
          dat = df_losses(),
          viz = "fylke"
        )
      } else {
        render_input_for_mortality_year(
          ns = ns,
          dat = df_losses(),
          viz = "all"
        )
      }
    }) |>
      bindEvent(session$userData$geo_group())

    output$tab_filter_mortality_month_plot <- shiny::renderUI({
      inputs_ui()
    }) |>
      bindEvent(inputs_ui())
      
    output$tab_filter_mortality_month_table <- shiny::renderUI({
      inputs_ui()
    }) |>
      bindEvent(inputs_ui())

    #### Plot mortality yearly ####
    output$plot_mortality <- plotly::renderPlotly(
      #### This should be resolved on the dat level ####
      dat <- df_losses |>
        spread(year, mort)  |>  
        dplyr::filter(
          !is.na(`2024`) |
            !is.na(`2023`) |
            !is.na(`2022`) |
            !is.na(`2021`) |
            !is.na(`2020`)
        )  |>
        dplyr::filter(!(area == "All" | area == "Norway"))  |>
        dplyr::filter(area != "Agder")  |>
        dplyr::filter(area != "1", area != "13")  |>
        droplevels()

        plot_yearly_mortality_outputs(dat)
    )
      #### Table mortality yearly ####
      ##### Yearly tables need to observe for Norge #####
  observeEvent(input$geo_group, {
    if (input$geo_group == "all") {
      output$table_mortality <- DT::renderDT(
        datatable(
          df_losses() |>
            dplyr::filter(!is.na(mort)) |>
            dplyr::select(year, area, mort) |> # this has changed from previous year
            dplyr::filter(year %in% input$select_years_table2),
          # filter = "top",
          rownames = F,
          colnames = c("År", "Område", "Dødelighet %"),
          # also here
          selection = (list(
            mode = "multiple",
            selected = "all",
            target = "column"
          )),
          options = list(
            sDom = '<"top">lrt<"bottom">ip',
            autoWidth = FALSE,
            # columnDefs = list(list(width = '100px', targets = c(1, 2))),
            scrollX = FALSE,
            language = list(
              url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
            )
          )
        )
      )
    } else {
      output$table_mortality <- DT::renderDT(
        datatable(
          df_losses() |>
            dplyr::filter(!is.na(mort)) |>
            dplyr::select(year, area, mort) |> # this has changed from previous year
            dplyr::filter(
              year %in% input$select_years_table2 & area %in% input$select_area2
            ),
          # filter = "top",
          rownames = F,
          colnames = c("År", "Område", "Dødelighet %"),
          # also here
          selection = (list(
            mode = "multiple",
            selected = "all",
            target = "column"
          )),
          options = list(
            sDom = '<"top">lrt<"bottom">ip',
            autoWidth = FALSE,
            # columnDefs = list(list(width = '100px', targets = c(1, 2))),
            scrollX = FALSE,
            language = list(
              url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
            )
          )
        )
      )
    }
  })
})
}

#### MORTALITY yearly ####

## To be copied in the UI
# mod_yearly_mortality_ui("yearly_mortality_1")

## To be copied in the server
# mod_yearly_mortality_server("yearly_mortality_1")
