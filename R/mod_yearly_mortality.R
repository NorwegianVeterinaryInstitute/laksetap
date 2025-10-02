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
          plotly::plotlyOutput("plot_mortality"),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/mortality_yearly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Tabell",
          shiny::br(),
          shiny::uiOutput("tab_filter_mortality"),
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
    observeEvent(input$geo_group, {
      if (input$geo_group == "zone") {
        output$tab_filter_mortality <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_mortality_year",
                    multiple = T,
                    resolution = "y"
                  )
                ),
                column(
                  width = 6,
                  selectizeInput(
                    "select_area_mortality_year",
                    "Velg flere områder",
                    c(2:12),
                    selected = c(2:12),
                    multiple = TRUE
                  )
                )
              )
            )
          )
      } else if (input$geo_group == "fylke") {
        output$tab_filter_mortality <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_mortality_year",
                    multiple = T,
                    resolution = "y"
                  )
                ),
                column(
                  width = 6,
                  selectizeInput(
                    "select_area_mortality_year",
                    "Velg flere områder",
                    c(
                      #"Agder",
                      "Rogaland",
                      "Vestland",
                      "Møre og Romsdal",
                      "Trøndelag",
                      "Nordland",
                      "Troms",
                      "Finnmark"
                    ),
                    selected = c(
                      #"Agder",
                      "Rogaland",
                      "Vestland",
                      "Møre og Romsdal",
                      "Trøndelag",
                      "Nordland",
                      "Troms",
                      "Finnmark"
                    ),
                    multiple = TRUE
                  )
                )
              )
            )
          )
      } else {
        output$tab_filter_mortality <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_mortality_year",
                    multiple = T,
                    resolution = "y"
                  )
                )
              )
            )
          )
      }
    })

    output$plot_mortality <- plotly::renderPlotly(
      plot_ly(
        df_losses() %>%
          spread(year, mort) %>%
          dplyr::filter(
            !is.na(`2024`) |
              !is.na(`2023`) |
              !is.na(`2022`) |
              !is.na(`2021`) |
              !is.na(`2020`)
          ) %>%
          dplyr::filter(!(area == "All" | area == "Norway")) %>%
          dplyr::filter(area != "Agder") %>%
          dplyr::filter(area != "1", area != "13") %>%
          droplevels(),
        x = ~area,
        y = ~`2024`,
        name = "2024",
        type = "scatter",
        mode = "markers",
        marker = list(color = "#1C4FB9"),
        hoverinfo = "text",
        text = ~ paste(
          "Område: ",
          area,
          "<br>",
          "Prosent: ",
          `2024`,
          "<br>",
          "Aar: 2024"
        )
      ) %>%
        add_trace(
          x = ~area,
          y = ~`2023`,
          name = "2023",
          type = "scatter",
          mode = "markers",
          marker = list(color = "#95D9F3"),
          hoverinfo = "text",
          text = ~ paste(
            "Område: ",
            area,
            "<br>",
            "Prosent: ",
            `2023`,
            "<br>",
            "Aar: 2023"
          )
        ) %>%
        add_trace(
          x = ~area,
          y = ~`2022`,
          name = "2022",
          type = "scatter",
          mode = "markers",
          marker = list(color = "#59CD8B"),
          hoverinfo = "text",
          text = ~ paste(
            "Område: ",
            area,
            "<br>",
            "Prosent: ",
            `2022`,
            "<br>",
            "Aar: 2022"
          )
        ) %>%
        add_trace(
          x = ~area,
          y = ~`2021`,
          name = "2021",
          type = "scatter",
          mode = "markers",
          marker = list(color = "#BCEED1"),
          hoverinfo = "text",
          text = ~ paste(
            "Område: ",
            area,
            "<br>",
            "Prosent: ",
            `2021`,
            "<br>",
            "Aar: 2021"
          )
        ) %>%
        add_trace(
          x = ~area,
          y = ~`2020`,
          name = "2020",
          type = "scatter",
          mode = "markers",
          marker = list(color = "#FF5447"),
          hoverinfo = "text",
          text = ~ paste(
            "Område: ",
            area,
            "<br>",
            "Prosent: ",
            `2020`,
            "<br>",
            "Aar: 2020"
          )
        ) %>%
        layout(
          title = "",
          annotations = list(
            yref = "paper",
            xref = "paper",
            y = 1.09,
            x = .2,
            text = "Velg år:",
            showarrow = F,
            font = list(size = 14, face = "bold")
          ),
          legend = list(orientation = "h", x = .25, y = 1.1),
          xaxis = list(title = "Område"),
          yaxis = list(title = "Dødelighet (%)", categoryarray = ~area),
          margin = list(l = 100)
        ) %>%
        config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
    )
  })
}

#### MORTALITY yearly ####

## To be copied in the UI
# mod_yearly_mortality_ui("yearly_mortality_1")

## To be copied in the server
# mod_yearly_mortality_server("yearly_mortality_1")
