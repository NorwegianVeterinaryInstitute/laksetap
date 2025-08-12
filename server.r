server <- function(input, output) {
  
  #### Make the title change with the tab ####
  output$tab_title  <- renderUI({
    if(input$navbar == "monthly_mortality") {
      shiny::h2("Månedlig dødelighet %")
    } else if(input$navbar == "yearly_mortality") {
      shiny::h2("Årlig dødelighet %")
    } else if (input$navbar == "prod_mortality") {
      shiny::h2("Produksjonssyklus dødelighet %")
    } else if (input$navbar == "calc_main") {
      shiny::h2("Dødelighetskalkulator")
    } else if (input$navbar == "losses") {
      shiny::h2("Tapstall")
    } else if (input$navbar == "about") {
      shiny::h2("Om statistikken")
    }
  }
  )
  
  #### Make the UI for the top bar content change on each tab ####
  output$top_bar  <- renderUI({
    if (input$navbar == "monthly_mortality" |
        input$navbar == "yearly_mortality" |
        input$navbar == "losses") {
      tagList(
        fluidRow(
          column(width = 6,
                 selectInput("species", "Velg art:",
                             c("Laks" = "salmon",
                               "Regnbueørret" = "rainbowtrout"),
                             selected = c("salmon")
                 )),
          column(width = 6,
                 selectInput("geo_group", "Velg geografisk område:",
                             c("Fylke" = "fylke",
                               "Produksjonssone" = "zone",
                               "Norge" = "all"),
                             selected = c("zone")
                 )),
        )
      )
      
    } else {
      NULL
    } 
  })
  
  
  #### Calculator UI - separate because we are rendering on tabset ####
  output$calc_banner <- renderUI({
    if (input$calc_nav == "calc") {
      tagList(
        shiny::div(style="padding-left: 1rem; padding-top: 3rem;",
                   shiny::h3("Beregn dødelighetsrate"),
                   shiny::p("Kalkulatoren godtar verdier mellom 0 og 200.000."),
                   bslib::layout_column_wrap(class = "d-flex align-items-end",
                                             width = 1/4,
                                             numericInput("beginning_count",
                                                          "Antall fisk ved periodens start (f.eks. uke, måned)",
                                                          value = 100, 
                                                          min = 1, 
                                                          max = 200000),
                                             numericInput("end_count", "Antall fisk ved periodens slutt", 
                                                          value = 90, 
                                                          min = 0, 
                                                          max = 200000),
                                             numericInput("dead_count", "Antall døde fisk i løpet av perioden", 
                                                          value = 5, min = 0, 
                                                          max = 200000),
                                             actionButton("calculate_button", "Kalkuler", class = "btn btn-primary")
                   )
        ))
      
    } else if (input$calc_nav == "calc_cum") {
      tagList(
        shiny::div(style="padding-left: 1rem; padding-top: 3rem;",
                   shiny::h3("Beregn akkumulert dødlighetsrisiko for en tidsperiode"),
                   bslib::layout_column_wrap(class = "d-flex align-items-end",
                                             width = 1/3,
                                             selectInput(
                                               "period_type",
                                               "Velg periode:",
                                               choices = c(
                                                 "Ukentlige" = "week",
                                                 "Månedlige" = "month"
                                               ),
                                               selected = "month"
                                             ),
                                             
                                             textInput(
                                               "mortality_input_cum",
                                               "Fyll inn dødsrate for flere perioder. Dødsrate kan ikke være lavere enn 0, eller høyere enn 2. Separer perioder ved å bruke komma, og bruk et punktum i stedet for et komma for desimaltall, f.eks. 0.5, 1, 1.5, 2:",
                                               "1"
                                             ),
                                             
                                             actionButton("calculate_button_cum", "Kalkuler",  class = "btn btn-primary")
                   )
        ))
    } else (NULL)
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
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal", "Trøndelag",
                    "Nordland", "Troms", "Finnmark"
                  ),
                  selected = c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal", "Trøndelag",
                    "Nordland", "Troms", "Finnmark"
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
  
  #### UI for tab mortality monthly ####
  
  observeEvent(input$geo_group, {
    if (input$geo_group == "zone") {
      output$tab_filter_monthly_plot <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 4,
                select_year(
                  "select_years_plot4", 
                  multiple = T)
              ),
              column(
                width = 4,
                selectInput(
                  "select_area_plot4",
                  "Velg flere områder",
                  c("1 & 2", "3", "4", "5", "6", "7", "8", "9", 
                    "10", "11", "12 & 13", "Norge"),
                  selected = c("Norge"),
                  multiple = TRUE
                )
              )
            )
          )
        )
    } else if (input$geo_group == "fylke") {
      output$tab_filter_monthly_plot <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 4,
                select_year(
                  "select_years_plot4",
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectInput(
                  "select_area_plot4",
                  "Velg flere områder:",
                  c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark", "Norge"
                  ),
                  selected = c("Norge"),
                  multiple = TRUE
                )
              )
            )
          )
        )
    } else {
      output$tab_filter_monthly_plot <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_plot4", 
                  multiple = T
                )
              )
            )
          )
        )
    }
  })
  
  observeEvent(input$geo_group, {
    if (input$geo_group == "zone") {
      output$tab_filter_m2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 4,
                select_year(
                  "select_years_table4",
                  multiple = T
                )
              ),
              column(
                width = 4,
                select_months(
                  id = "select_month_table4"
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_area4",
                  "Velg flere områder",
                  c("1 & 2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12 & 13"),
                  selected = c("1 & 2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12 & 13"),
                  multiple = TRUE
                )
              )
            )
          )
        )
    } else if (input$geo_group == "fylke") {
      output$tab_filter_m2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 4,
                select_year(
                  "select_years_table4",
                  multiple = T
                )
              ),
              column(
                width = 4,
                select_months(
                  id = "select_month_table4",
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_area4",
                  "Velg flere områder:",
                  c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  selected = c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  multiple = TRUE
                )
              )
            )
          )
        )
    } else {
      output$tab_filter_m2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table4",
                  multiple = T
                )
              ),
              column(
                width = 4,
                select_months(
                  id = "select_month_table4"
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
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  selected = c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
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
  
  #### UI for tab mortality yearly ####
  observeEvent(input$geo_group, {
    if (input$geo_group == "zone") {
      output$tab_filter_2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table2",
                  multiple = T,
                  resolution = "y"
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_area2",
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
      output$tab_filter_2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table2",
                  multiple = T,
                  resolution = "y"
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_area2",
                  "Velg flere områder",
                  c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  selected = c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  multiple = TRUE
                )
              )
            )
          )
        )
    } else {
      output$tab_filter_2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table2",
                  multiple = T,
                  resolution = "y"
                )
              )
            )
          )
        )
    }
  })
  
  
  #### UI for tab cohorts  ####
  observeEvent(input$geo_group, {
    if (input$geo_group == "zone") {
      output$tab_filter_c <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table5",
                  multiple = T,
                  resolution = "y"
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_locs",
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
      output$tab_filter_c <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table5",
                  multiple = T,
                  resolution = "y"
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_locs",
                  "Velg flere områder",
                  c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  selected = c(
                    "Agder", "Rogaland", "Vestland", "Møre og Romsdal",
                    "Trøndelag", "Nordland", "Troms", "Finnmark"
                  ),
                  multiple = TRUE
                )
              )
            )
          )
        )
    } else {
      output$tab_filter_c <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 6,
                select_year(
                  "select_years_table5",
                  multiple = T,
                  resolution = "y"
                )
              )
            )
          )
        )
    }
  })
  

  #### LOSSES yearly ####
  
  df_losses <-
    eventReactive(c(input$species, input$geo_group), {
      losses %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group)
    })
  
  # any changes you make to df_losses will affect both the table and the plot,
  # if you want to use df_losses write df_losses()
  
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
      )

      output$table_mortality <- DT::renderDT(
        datatable(
          df_losses() %>%
            dplyr::filter(!is.na(mort)) %>%
            dplyr::select(year, area, mort) %>% # this has changed from previous year
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
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
              year %in% input$select_years_table1 &
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
      )
      
      output$table_mortality <- DT::renderDT(
        datatable(
          df_losses() %>%
            dplyr::filter(!is.na(mort)) %>%
            dplyr::select(year, area, mort) %>% # this has changed from previous year
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
      )
    }
  })
  
  
  
  output$plot_losses <- renderPlotly(
    plot_ly(
      df_losses() %>%
        dplyr::filter(!area == "Norway" & !area == "All" & year == input$select_year_losses) %>%
        tidyr::gather(type, n, c(doed, ut, romt, ufor)) %>% droplevels() %>%
        dplyr::mutate(perc = case_when(
          type == "doed" ~ p.doed,
          type == "ut" ~ p.ut,
          type == "romt" ~ p.romt,
          type == "ufor" ~ p.ufor
        )) %>%
        dplyr::mutate(type = factor(type, levels = c("doed", "ut", "romt", "ufor"), labels = c("Døde", "Utkast", "Rømt", "Annet"))),
      x = ~area,
      y = ~n,
      color = ~type, colors = my_palette, type = "bar", legendgroup = ~type,
      textposition = "none",
      hoverinfo = "text", text = ~ paste(
        "Område: ", area, "<br>",
        "Antall: ", n, "<br>"
      )
    ) %>%
      layout(
        legend = list(
          orientation = "h",  # horizontal
          x = 0.5,
          y = 1.1,
          xanchor = "center"
        ),
        barmode = "stack",
        title = "",
        annotations = list(yref = "paper", xref = "paper", y = 1.05, x = 1.1, text = "Velg tap:", showarrow = F, font = list(size = 14, face = "bold")),
        # title = input$select_year, # Should change when included change year
        yaxis = list(title = "Antall (millioner)"),
        xaxis = list(title = "Område")) %>% 
      config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
  )
  
  
  #### MORTALITY yearly ####
  
  output$plot_mortality <- renderPlotly(
    plot_ly(
      df_losses() %>%
        spread(year, mort) %>%
        dplyr::filter(!is.na(`2024`) | !is.na(`2023`) | !is.na(`2022`) | !is.na(`2021`) | !is.na(`2020`)) %>%
        dplyr::filter(!(area == "All" | area == "Norway")) %>%
        droplevels(),
      x = ~area, y = ~`2024`, name = "2024", type = "scatter",
      mode = "markers", marker = list(color = "#1C4FB9"),
      hoverinfo = "text", text = ~ paste(
        "Område: ", area, "<br>",
        "Prosent: ", `2024`, "<br>",
        "Aar: 2024"
      )
    ) %>%
      add_trace(
        x = ~area, y = ~`2023`, name = "2023", type = "scatter",
        mode = "markers", marker = list(color = "#95D9F3"),
        hoverinfo = "text", text = ~ paste(
          "Område: ", area, "<br>",
          "Prosent: ", `2023`, "<br>",
          "Aar: 2023"
        )
      ) %>%
      add_trace(
        x = ~area, y = ~`2022`, name = "2022", type = "scatter",
        mode = "markers", marker = list(color = "#59CD8B"),
        hoverinfo = "text", text = ~ paste(
          "Område: ", area, "<br>",
          "Prosent: ", `2022`, "<br>",
          "Aar: 2022"
        )
      ) %>%
      add_trace(
        x = ~area, y = ~`2021`, name = "2021", type = "scatter",
        mode = "markers", marker = list(color = "#BCEED1"),
        hoverinfo = "text", text = ~ paste(
          "Område: ", area, "<br>",
          "Prosent: ", `2021`, "<br>",
          "Aar: 2021"
        )
      ) %>%
      add_trace(
        x = ~area, y = ~`2020`, name = "2020", type = "scatter",
        mode = "markers", marker = list(color = "#FF5447"),
        hoverinfo = "text", text = ~ paste(
          "Område: ", area, "<br>",
          "Prosent: ", `2020`, "<br>",
          "Aar: 2020"
        )
      ) %>%
      layout(
        title = "",
        annotations = list(yref = "paper", xref = "paper", y = 1.09, x = .2, text = "Velg år:", showarrow = F, font = list(size = 14, face = "bold")),
        legend = list(orientation = "h", x = .25, y = 1.1),
        xaxis = list(title = "Område"),
        yaxis = list(title = "Dødelighet (%)", categoryarray = ~area),
        margin = list(l = 100)
      ) %>%       config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
  )
  
  
  ##### LOSSES monthly ####
  
  df_losses_month <-
    eventReactive(c(input$species, input$geo_group), {
      losses_monthly_data %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group)
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
    }
  })
  
  
  output$plot_losses_monthly <- renderPlotly(
    plot_ly(
      df_losses_month() %>%
        dplyr::filter(!area == "Norway" & !area == "All" & year_month == paste0(input$select_year, "-", input$select_month)) %>%
        tidyr::gather(type, n, c(doed, ut, romt, ufor)) %>% droplevels() %>%
        dplyr::mutate(perc = case_when(
          type == "doed" ~ p.doed,
          type == "ut" ~ p.ut,
          type == "romt" ~ p.romt,
          type == "ufor" ~ p.ufor
        )) %>%
        dplyr::mutate(type = factor(type, levels = c("doed", "ut", "romt", "ufor"), labels = c("Døde", "Utkast", "Rømt", "Annet"))),
      x = ~area,
      y = ~n,
      color = ~type, colors = my_palette, type = "bar", legendgroup = ~type,
      textposition = "none",
      hoverinfo = "text", text = ~ paste(
        "Område: ", area, "<br>",
        "Antall: ", n, "<br>"
      )
    ) %>%
      layout(
        legend = list(
          orientation = "h",  # horizontal
          x = 0.5,
          y = 1.1,
          xanchor = "center"
        ),
        barmode = "stack",
        title = NULL,
        annotations = list(yref = "paper", xref = "paper", y = 1.05, x = 1.1, text = "Velg tap:", showarrow = F, font = list(size = 14, face = "bold")),
        # title = input$select_year, # Should change when included change year
        yaxis = list(title = "Antall (millioner)"),
        xaxis = list(title = "Område"),
        showlegend = TRUE
      ) %>%       config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
  )
  
  
  ##### MORTALITY monthly ####
  
  df_mort_month <-
    eventReactive(c(input$species, input$geo_group), {
      mortality_rates_monthly_data %>%
        dplyr::filter(species == input$species &
                        viz %in% c(input$geo_group, "all"))
    })
  
  
  output$table_mortality_month <- DT::renderDT({
    req(input$geo_group)
    req(input$select_years_table4)
    req(input$select_month_table4)
    dat <- df_mort_month() %>%
        dplyr::filter(!is.na(median)) %>%
        dplyr::filter(
          year %in% input$select_years_table4,
            month_name %in% input$select_month_table4
        ) %>%
        dplyr::select(year, month_name, area, q1, median, q3) %>%
        dplyr::mutate(
          q1 = round(q1, 2),
          median = round(median, 2),
          q3 = round(q3, 2)
        ) 
    if(input$geo_group != "all") {
      req(input$select_area4)
      dat <- dat |>  dplyr::filter(area %in% input$select_area4) }
    
        datatable(dat,
          rownames = F,
          colnames = c("År", "Måned", "Område", "1 Kvartil %", "Median %", "3 Kvartil %"),
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
  })
  
  
  observeEvent(input$species, {
  
    if (input$species == "rainbowtrout") {
      updateSelectInput(inputId = "geo_group", choices = c("Norge" = "all"))
    } else {
      updateSelectInput(inputId = "geo_group", choices = c("Fylke" = "fylke", 
                                                           "Produksjonssone" = "zone", 
                                                           "Norge" = "all"))
    }
  })
  
  output$plot_mortality_month <- renderPlotly({
        req(df_mort_month())
        req(input$select_years_plot4)
        req(input$select_area_plot4)
        p <- df_mort_month() %>%
          dplyr::filter(year %in% input$select_years_plot4) %>%
          dplyr::filter(area %in% c(input$select_area_plot4)) %>%
          # ribbon for norway - enabled:
          # dplyr::mutate(q1 = if_else(area == "Norge", NA, q1)) %>%
          # dplyr::mutate(q3 = if_else(area == "Norge", NA, q3)) %>%
          ggplot() +
          aes(x = date, y = median, group = area) +
          labs(x = "Måned", y = "Dødelighet (%)") +
          geom_line(aes(
             color = factor(area)
           )) +
          geom_ribbon(
            aes(
              ymin = .data$q1,
              ymax = .data$q3,
              fill = factor(area)
            ),
            linetype = 0,
            alpha = 0.1,
            show.legend = FALSE
          ) +
          theme_minimal() +
          scale_color_manual(values = my_palette_named) +
          scale_fill_manual(values = my_palette_named) +
          guides(
            col =
              guide_legend(title = "Område"), fill = FALSE
          )  
        #browser()
        plotly::ggplotly(p) %>% layout(
          legend = list(
            orientation = "h",  # horizontal
            x = 0.5,
            y = 1.1,
            xanchor = "center"
          )) %>%       
          config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
        
      }) 

  #### COHORTS ####
  df_cohorts <-
    eventReactive(c(input$species, input$geo_group), {
      mortality_cohorts_data %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group)
    })
  
  
  output$table_cohort <- DT::renderDT({
    if (input$geo_group == "all") {
      df_cohorts() %>%
        dplyr::filter(
          year %in% input$select_years_table5 &
            area == "Norge"
        ) %>%
        dplyr::select(year, area, q1, median, q3) %>%
        datatable(
          # filter = "top",
          rownames = F,
          colnames = c("År", "Område", "1 Kvartil %", "Median %", "3 Kvartil %"),
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
    } else {
      df_cohorts() %>%
        dplyr::filter(
          year %in% input$select_years_table5 &
            area %in% input$select_locs
        ) %>%
        dplyr::select(year, area, q1, median, q3) %>%
        datatable(
          # filter = "top",
          rownames = F,
          colnames = c("År", "Område", "1 Kvartil %", "Median %", "3 Kvartil %"),
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
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
    }
  })
  
  
  #### dead plots for cohorts mortality ####
  
  observeEvent(input$species, {
    if (input$species == "rainbowtrout") {
      output$plot_cohort <- renderPlotly({
        p <-
          ggplot() +
          geom_blank() +
          labs(title = "Ingen data å vise") +
          theme_minimal()
        
        ggplotly(p)
      })
    } else {
      output$plot_cohort <- renderPlotly({
        p <- df_cohorts() %>%
          dplyr::filter(year == input$select_year_coh, area != "13", area != "All") %>%
          dplyr::mutate(
            q1 = round(q1, 1),
            q3 = round(q3, 1),
            median = round(median, 1)
          ) %>%
          # constuct tooltip
          dplyr::mutate(tooltip = paste0(
            "Area: ", area,
            "<br>Q1: ", q1,
            "<br>Median: ", median,
            "<br>Q3: ", q3
          )) %>%
          ggplot() +
          geom_segment(
            aes(color = as.numeric(factor(area)), x = area, xend = area, y = q1, yend = q3),
            linewidth = 10
          ) +
          scale_color_gradient(low = "#C7D9FF", high = "#1C4FB9") +
          geom_point(
            aes(x = area, y = median, group = year, text = tooltip),
            linewidth = 1, fill = "black", stroke = 0.2
          ) +
          geom_text(aes(x = area, y = median, group = year, label = area), nudge_y = 1) +
          labs(
            title = "Fullførte produksjonssykluser (>= 8 måneder)",
            x = input$select_year_coh,
            y = "Dødelighet %"
          ) +
          theme_minimal() +
          theme(axis.text.x = element_blank(), legend.position = "none") +
          guides(fill = "none")
        
        
        ggplotly(p, tooltip = "text") %>%       config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
      })
    }
  })
  
  observeEvent(input$geo_group, {
    if (input$geo_group == "fylke" | input$geo_group == "all") {
      output$plot_cohort <- renderPlotly({
        p <-
          ggplot() +
          geom_blank() +
          labs(title = "Ingen data å vise") +
          theme_minimal()
        
        ggplotly(p)
      })
    } else {
      output$plot_cohort <- renderPlotly({
        p <- df_cohorts() %>%
          dplyr::filter(year == input$select_year_coh, area != "13", area != "All") %>%
          dplyr::mutate(
            q1 = round(q1, 1),
            q3 = round(q3, 1),
            median = round(median, 1)
          ) %>%
          # constuct tooltip
          dplyr::mutate(tooltip = paste0(
            "Area: ", area,
            "<br>Q1: ", q1,
            "<br>Median: ", median,
            "<br>Q3: ", q3
          )) %>%
          ggplot() +
          geom_segment(
            aes(color = as.numeric(factor(area)), x = area, xend = area, y = q1, yend = q3),
            linewidth = 10
          ) +
          scale_color_gradient(low = "#C7D9FF", high = "#1C4FB9") +
          geom_point(
            aes(x = area, y = median, group = year, text = tooltip),
            linewidth = 1, fill = "black", stroke = 0.2
          ) +
          geom_text(aes(x = area, y = median, group = year, label = area), nudge_y = 1) +
          labs(
            title = "Fullførte produksjonssykluser (>= 8 måneder)",
            x = input$select_year_coh,
            y = "Dødelighet %"
          ) +
          theme_minimal() +
          theme(axis.text.x = element_blank(), legend.position = "none") +
          guides(fill = "none")
        
        
        ggplotly(p, tooltip = "text") %>%       config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
      })
    }
  })
  
  
  #### CALCULATOR ####
  #### Tab 1 ####
  observeEvent(input$calculate_button, {
    ar_count <- (input$beginning_count + input$end_count) / 2
    mort_rate <- input$dead_count / ar_count
    mort_risk <- 1 - exp(-mort_rate)
    
    output$result_text <- renderText({
      paste("Dødelighet:", sprintf("%.2f%%", mort_risk * 100))
    })
    
    # output$mortality_plot <- renderPlot({
    #   plot(1, type = "n", xlab = "", ylab = "", main = "Mortality Rate Over Time")
    #   text(1, 1, paste("Mortality Rate:", sprintf("%.2f%%", mort_rate * 100)), cex = 1.5)
    # })
  })
  #### Tab 2 ####
  observeEvent(input$calculate_button_cum, {
    nums <- suppressWarnings(as.numeric(unlist(strsplit(input$mortality_input_cum, ","))))

    # check that all inputs are numbers
    if (any(is.na(nums))) {
      showNotification("Én eller flere inndata er ikke numeriske.", 
                       type = "error")
      return()
    }
    
    # check that no number is bigger than 2 and smaller then 0 
    min_rate = 0
    max_rate = 2
    
    between_result <- between(nums, min_rate, max_rate)
    
    if (!all(between_result)) {
      showNotification("Dødsrate kan ikke være lavere enn 0, eller høyere enn 2.", 
                       type = "error")
      return()
    }
    
    mort_rates_cum <- nums / 100 
    cum_rate <- cumsum(mort_rates_cum)
    cum_risks <- 1 - exp(-cum_rate)
    
    period_label <- switch(input$period_type,
                           "week" = "Uke",
                           "month" = "Måned"
    )
    
    output$cumulative_risk_plot <- renderPlot({
      par(mfrow = c(2, 1))
      
      barplot(mort_rates_cum * 100,
              names.arg = seq_along(mort_rates_cum), col = "#1C4FB9",
              main = "",
              xlab = period_label, ylab = "Dødsrate (%)"
      )
      
      plot(cum_risks * 100,
           type = "o", col = "#FF5447", pch = 20, lty = 1,
           main = "Dødelighet over tid",
           xlab = period_label, ylab = "Dødelighet (%)",
           ylim = c(0, max(cum_risks * 100) * 1.1),
           xaxt = "n"
      )
      axis(1, at = 1:length(cum_risks), labels = seq_along(cum_risks))
    })
    
    output$result_text_cum <- renderText({
      paste("Dødelighet for den siste registrerte perioden", sprintf("%.2f%%", tail(cum_risks * 100, 1)))
    })
  })
}
