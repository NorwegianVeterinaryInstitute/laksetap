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
                id = "select_year"
              )
            ),
            shiny::column(
              width = 6,
              shiny::selectInput(
                "select_month",
                "Velg måned:",
                list(
                  "Måned" = c(
                    "01",
                    "02",
                    "03",
                    "04",
                    "05",
                    "06",
                    "07",
                    "08",
                    "09",
                    "10",
                    "11",
                    "12"
                  )
                )
              )
            )
          ),
          plotly::plotlyOutput("plot_losses_monthly"),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/losses_monthly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Månedlige tap tabell",
          shiny::br(),
          shiny::uiOutput("tab_filter_m1"),
          shiny::div(
            DT::DTOutput("table_losses_month")
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
            id = "select_year_losses",
            resolution = "y"
          ),
          plotly::plotlyOutput("plot_losses"),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "www/losses_yearly_table_and_plot_footer.md"
          ))
        ),
        bslib::nav_panel(
          "Årlige tap tabell",
          shiny::br(),
          shiny::uiOutput("tab_filter"),
          shiny::div(
            DT::DTOutput("table_losses")
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
    df_losses <-
      eventReactive(c(input$species, input$geo_group), {
        losses %>%
          dplyr::filter(
            species == input$species &
              viz == input$geo_group
          )
      })

    #### UI for tab losses monthly ####
    observeEvent(input$geo_group, {
      if (input$geo_group == "zone") {
        output$tab_filter_m1 <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 4,
                  select_year(
                    id = "select_years_table3",
                    multiple = T
                  )
                ),
                column(
                  width = 4,
                  select_months(
                    id = "select_month_table3"
                  )
                ),
                column(
                  width = 4,
                  selectizeInput(
                    "select_area3",
                    "Velg flere områder",
                    c(1:13),
                    selected = c(1:13),
                    multiple = TRUE
                  )
                )
              )
            )
          )
      } else if (input$geo_group == "fylke") {
        output$tab_filter_m1 <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 4,
                  select_year(
                    id = "select_years_table3",
                    multiple = T
                  )
                ),
                column(
                  width = 4,
                  select_months(
                    id = "select_month_table3",
                  )
                ),
                column(
                  width = 4,
                  selectizeInput(
                    "select_area3",
                    "Velg flere områder",
                    c(
                      "Agder",
                      "Rogaland",
                      "Vestland",
                      "Møre og Romsdal",
                      "Trøndelag",
                      "Nordland",
                      "Troms",
                      "Finnmark"
                    ),
                    selected = c(
                      "Agder",
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
        output$tab_filter_m1 <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_table3",
                    multiple = T
                  )
                ),
                column(
                  width = 4,
                  select_months(
                    id = "select_month_table3",
                  )
                )
              )
            )
          )
      }
    })

    #### UI for tab losses yearly ####
    observeEvent(input$geo_group, {
      if (input$geo_group == "zone") {
        output$tab_filter <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_table1",
                    multiple = T,
                    resolution = "y"
                  )
                ),
                column(
                  width = 6,
                  selectizeInput(
                    "select_area1",
                    "Velg flere områder",
                    c(1:13),
                    selected = c(1:13),
                    multiple = TRUE
                  )
                )
              )
            )
          )
      } else if (input$geo_group == "fylke") {
        output$tab_filter <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_table1",
                    multiple = T,
                    resolution = "y"
                  )
                ),
                column(
                  width = 6,
                  selectizeInput(
                    "select_area1",
                    "Velg flere områder",
                    c(
                      "Agder",
                      "Rogaland",
                      "Vestland",
                      "Møre og Romsdal",
                      "Trøndelag",
                      "Nordland",
                      "Troms",
                      "Finnmark"
                    ),
                    selected = c(
                      "Agder",
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
        output$tab_filter <-
          renderUI(
            tagList(
              fluidRow(
                column(
                  width = 6,
                  select_year(
                    "select_years_table1",
                    multiple = T,
                    resolution = "y"
                  )
                )
              )
            )
          )
      }
    })


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
      )}else {
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
              year %in% input$select_years_table1 & area %in% input$select_area1
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
      )}
      

#### Yearly losses plot ####
        output$plot_losses <- renderPlotly(
    plot_ly(
      df_losses() %>%
        dplyr::filter(
          !area == "Norway" & !area == "All" & year == input$select_year_losses
        ) %>%
        tidyr::gather(type, n, c(doed, ut, romt, ufor)) %>%
        droplevels() %>%
        dplyr::mutate(
          perc = case_when(
            type == "doed" ~ p.doed,
            type == "ut" ~ p.ut,
            type == "romt" ~ p.romt,
            type == "ufor" ~ p.ufor
          )
        ) %>%
        dplyr::mutate(
          type = factor(
            type,
            levels = c("doed", "ut", "romt", "ufor"),
            labels = c("Døde", "Utkast", "Rømt", "Annet")
          )
        ),
      x = ~area,
      y = ~n,
      color = ~type,
      colors = my_palette,
      type = "bar",
      legendgroup = ~type,
      textposition = "none",
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Antall: ",
        n,
        "<br>"
      )
    ) %>%
      layout(
        legend = list(
          orientation = "h", # horizontal
          x = 0.5,
          y = 1.1,
          xanchor = "center"
        ),
        barmode = "stack",
        title = "",
        annotations = list(
          yref = "paper",
          xref = "paper",
          y = 1.05,
          x = 1.1,
          text = "Velg tap:",
          showarrow = F,
          font = list(size = 14, face = "bold")
        ),
        # title = input$select_year, # Should change when included change year
        yaxis = list(title = "Antall (millioner)"),
        xaxis = list(title = "Område")
      ) %>%
      config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
  )

#### losses monthly ####
    
      ##### LOSSES monthly ####

  df_losses_month <-
    eventReactive(c(input$species, input$geo_group), {
      losses_monthly_data %>%
        dplyr::filter(
          species == input$species &
            viz == input$geo_group
        )
    })

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

  output$plot_losses_monthly <- renderPlotly(
    plot_ly(
      df_losses_month() %>%
        dplyr::filter(
          !area == "Norway" &
            !area == "All" &
            year_month == paste0(input$select_year, "-", input$select_month)
        ) %>%
        tidyr::gather(type, n, c(doed, ut, romt, ufor)) %>%
        droplevels() %>%
        dplyr::mutate(
          perc = case_when(
            type == "doed" ~ p.doed,
            type == "ut" ~ p.ut,
            type == "romt" ~ p.romt,
            type == "ufor" ~ p.ufor
          )
        ) %>%
        dplyr::mutate(
          type = factor(
            type,
            levels = c("doed", "ut", "romt", "ufor"),
            labels = c("Døde", "Utkast", "Rømt", "Annet")
          )
        ),
      x = ~area,
      y = ~n,
      color = ~type,
      colors = my_palette,
      type = "bar",
      legendgroup = ~type,
      textposition = "none",
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Antall: ",
        n,
        "<br>"
      )
    ) %>%
      layout(
        legend = list(
          orientation = "h", # horizontal
          x = 0.5,
          y = 1.1,
          xanchor = "center"
        ),
        barmode = "stack",
        title = NULL,
        annotations = list(
          yref = "paper",
          xref = "paper",
          y = 1.05,
          x = 1.1,
          text = "Velg tap:",
          showarrow = F,
          font = list(size = 14, face = "bold")
        ),
        # title = input$select_year, # Should change when included change year
        yaxis = list(title = "Antall (millioner)"),
        xaxis = list(title = "Område"),
        showlegend = TRUE
      ) %>%
      config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
  )
  })
}

## To be copied in the UI
# mod_losses_ui("losses_1")

## To be copied in the server
# mod_losses_server("losses_1")
