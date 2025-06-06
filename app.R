### Layout for app
library(here)
library(shiny)
library(dplyr)
library(DT)
library(plotly)
library(tidyr)
library(pins)
library(lubridate)
library(markdown)
library(metathis)

ui <- fluidPage(
  tags$head(
    tags$html(lang = "no"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  meta() %>%
    meta_social(
      title = "Laksefiskdødelighet",
      description = "Laksefiskdødelighet Shiny App",
      url = "https://connect.posit.vetinst.no/laksetap",
      image = "https://www.vetinst.no/_/image/5c4e853a-130b-4e7f-92a3-8ca38bec0b56:2dcf9428a329fc0044b412c55b8c9e471f742d65/block-1200-630/Logo-vetinst-open-graph-no-svg-1200x630.png.jpg",
      image_alt = "An image for social meda cards"
    ),
  headerPanel(
    # creating NVI logo in the top of the app and the title following it
    windowTitle = "Laksefiskdødelighet",
    fluidRow(
      class = "align-items-center",
      style = "height: 100px;",
      column(
        4,
        div(
          class = "d-flex align-items-center",
          tags$a(
            href = "https://www.vetinst.no/",
            tags$img(src = "vetinst-logo.png", alt = "NVI logo", style = "height:44px;")
          )
        )
      ),
      column(
        8,
        div(
          class = "d-flex align-items-center",
          # style = "height: 100px;",
          shiny::h2("Statistikk over tap og dødelighet av laks og regnbueørret", role = "region", `aria-label` = "App Title", style = "margin: 0")
        )
      )
    )
  ),
  sidebarLayout(
    sidebarPanel(
      uiOutput("sidebar_content"),
      width = 2
    ),
    mainPanel(
      navbarPage(
        title = "", id = "navbar",

        #### top level tab monthly losses ####
        tabPanel(
          "Månedlige tap",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              "Diagram",
              br(),
              fluidRow(
                column(
                  width = 6,
                  selectInput("select_year", "Velg år:", list("År" = c(
                    2024, 2023, 2022, 2021, 2020
                  )))
                ),
                column(
                  width = 6,
                  selectInput("select_month", "Velg måned:", list(
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
                  ))
                )
              ),
              plotlyOutput("plot_losses_monthly"),
              hr(),
              shiny::includeMarkdown("www/tab1_table_and_plot_footer.md")
            ),
            tabPanel(
              "Tabell",
              br(),
              uiOutput("tab_filter_m1"),
              DTOutput("table_losses_month"),
              hr(),
              shiny::includeMarkdown("www/tab1_table_and_plot_footer.md")
            )
          )
        ),
        #### top level tab monthly mortality ####
        tabPanel(
          "Månedlige dødsrater",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              "Diagram",
              br(),
              fluidRow(
                column(
                  width = 6,
                  selectInput("select_year_mort", "Velg år:", list("År" = c(
                    2024, 2023, 2022, 2021, 2020
                  )))
                ),
                column(
                  width = 6,
                  selectInput("select_zone", "Velg zone:", list(
                    "Zone" = c(
                      "1", "2", "3", "4", "5", "6",
                      "7", "8", "9", "10", "11", "12 & 13"
                    )
                  ),
                  multiple = TRUE
                  )
                )
              ),
              plotlyOutput("plot_mortality_month"),
              hr(),
              shiny::includeMarkdown("www/tab2_plot_footer.md")
            ),
            tabPanel(
              "Tabell",
              br(),
              uiOutput("tab_filter_m2"),
              DTOutput("table_mortality_month"),
              hr(),
              shiny::includeMarkdown("www/tab2_table_footer.md")
            )
          )
        ),
        #### top level tab yearly losses ####
        tabPanel(
          "Årlige tap",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              "Diagram",
              br(),
              selectInput("select_year_losses", "Velg år:", list("År" = c(
                2024, 2023, 2022, 2021, 2020
              ))),
              plotlyOutput("plot_losses"),
              hr(),
              shiny::includeMarkdown("www/tab3_table_and_plot_footer.md")
            ),
            tabPanel(
              "Tabell",
              br(),
              uiOutput("tab_filter"),
              DTOutput("table_losses"),
              hr(),
              shiny::includeMarkdown("www/tab3_table_and_plot_footer.md")
            )
          )
        ),
        #### top level tab yearly mortality####
        tabPanel(
          "Årlig dødelighet",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              "Diagram",
              br(),
              plotlyOutput("plot_mortality"),
              hr(),
              shiny::includeMarkdown("www/tab4_table_and_plot_footer.md")
            ),
            tabPanel(
              "Tabell",
              br(),
              uiOutput("tab_filter_2"),
              DTOutput("table_mortality"),
              hr(),
              shiny::includeMarkdown("www/tab4_table_and_plot_footer.md")
            )
          )
        ),
        #### top level tab cohorts####
        tabPanel(
          "Produksjonssykluser dødelighet",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              "Diagram",
              br(),
              column(
                width = 6,
                selectInput(
                  "select_year_coh", "Velg år:",
                  list("År" = c(2024, 2023, 2022, 2021, 2020))
                )
              ),
              br(),
              br(),
              br(),
              br(),
              plotlyOutput("plot_cohort"),
              hr(),
              shiny::includeMarkdown("www/tab5_plot_footer.md")
            ),
            tabPanel(
              "Tabell",
              br(),
              uiOutput("tab_filter_c"),
              DTOutput("table_cohort"),
              hr(),
              shiny::includeMarkdown("www/tab5_table_footer.md")
            )
          )
        ),
        #### top level tab calculator####
        tabPanel(
          "Dødelighetskalkulator",
          value = "calc",
          verbatimTextOutput("result_text"),
          plotOutput("mortality_plot")
        ),
        #### top level tab calculator_2 ####
        tabPanel(
          "Dødelighetskalkulator for utvidet periode",
          value = "calc_cum",
          plotOutput("cumulative_risk_plot"),
          verbatimTextOutput("result_text_cum")
        ),
        #### top level tab about####
        tabPanel(
          "Om statistikken",
          column(
            width = 9,
            shiny::includeMarkdown("www/about.md")
          )
        )
      )
    )
  )
)

#####
server <- function(input, output) {
  #### UI for tab losses monthly ####
  observeEvent(input$geo_group, {
    if (input$geo_group == "zone") {
      output$tab_filter_m1 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 4,
                selectizeInput(
                  "select_years_table3",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_month_table3",
                  "Velg flere måneder:",
                  c(
                    "jan",
                    "feb",
                    "mar",
                    "apr",
                    "mai",
                    "jun",
                    "jul",
                    "aug",
                    "sep",
                    "okt",
                    "nov",
                    "des"
                  ),
                  selected = c(
                    "jan"
                  ),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_area3",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table3",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_month_table3",
                  "Velg flere måneder:",
                  c(
                    "jan",
                    "feb",
                    "mar",
                    "apr",
                    "mai",
                    "jun",
                    "jul",
                    "aug",
                    "sep",
                    "okt",
                    "nov",
                    "des"
                  ),
                  selected = c(
                    "jan"
                  ),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_area3",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table3",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_month_table3",
                  "Velg flere måneder:",
                  c(
                    "jan",
                    "feb",
                    "mar",
                    "apr",
                    "mai",
                    "jun",
                    "jul",
                    "aug",
                    "sep",
                    "okt",
                    "nov",
                    "des"
                  ),
                  selected = c(
                    "jan"
                  ),
                  multiple = T
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
      output$tab_filter_m2 <-
        renderUI(
          tagList(
            fluidRow(
              column(
                width = 4,
                selectizeInput(
                  "select_years_table4",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_month_table4",
                  "Velg flere måneder:",
                  c(
                    "jan",
                    "feb",
                    "mar",
                    "apr",
                    "mai",
                    "jun",
                    "jul",
                    "aug",
                    "sep",
                    "okt",
                    "nov",
                    "des"
                  ),
                  selected = c(
                    "jan"
                  ),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_area4",
                  "Velg område",
                  c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12 & 13"),
                  selected = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12 & 13"),
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
                selectizeInput(
                  "select_years_table4",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_month_table4",
                  "Velg flere måneder:",
                  c(
                    "jan",
                    "feb",
                    "mar",
                    "apr",
                    "mai",
                    "jun",
                    "jul",
                    "aug",
                    "sep",
                    "okt",
                    "nov",
                    "des"
                  ),
                  selected = c(
                    "jan"
                  ),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_area4",
                  "Velg Område:",
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
                selectizeInput(
                  "select_years_table4",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 4,
                selectizeInput(
                  "select_month_table4",
                  "Velg flere måneder:",
                  c(
                    "jan",
                    "feb",
                    "mar",
                    "apr",
                    "mai",
                    "jun",
                    "jul",
                    "aug",
                    "sep",
                    "okt",
                    "nov",
                    "des"
                  ),
                  selected = c(
                    "jan"
                  ),
                  multiple = T
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
                selectizeInput(
                  "select_years_table1",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_area1",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table1",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_area1",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table1",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
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
                selectizeInput(
                  "select_years_table2",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_area2",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table2",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_area2",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table2",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
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
                selectizeInput(
                  "select_years_table5",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_locs",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table5",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              ),
              column(
                width = 6,
                selectizeInput(
                  "select_locs",
                  "Velg Omrade",
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
                selectizeInput(
                  "select_years_table5",
                  "Velg flere år:",
                  c(
                    "2024" = 2024,
                    "2023" = 2023,
                    "2022" = 2022,
                    "2021" = 2021,
                    "2020" = 2020
                  ),
                  selected = c(2024),
                  multiple = T
                )
              )
            )
          )
        )
    }
  })

  observeEvent(input$navbar, {
    if (input$navbar == "calc") {
      output$sidebar_content <-
        renderUI(
          tagList(
            shiny::h4("Beregn dødelighetsrate"),
            numericInput("beginning_count",
              "Antall fisk ved periodens start (f.eks. uke, måned)",
              value = 100
            ),
            numericInput("end_count", "Antall fisk ved periodens slutt", value = 90),
            numericInput("dead_count", "Antall døde fisk i løpet av perioden", value = 5),
            actionButton("calculate_button", "Kalkuler")
          )
        )
    } else if (input$navbar == "calc_cum") {
      output$sidebar_content <-
        renderUI(
          tagList(
            shiny::h4("Beregn akkumulert dødlighetsrisiko for en tidsperiode"),
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
              "Fyll inn dødsrate for flere perioder (separer perioder ved å bruke komma, og bruk et punktum i stedet for et komma for desimaltall, f.eks. 0.5, 1, 1.5, 2):",
              ""
            ),
            actionButton("calculate_button_cum", "Kalkuler")
          )
        )
    } else {
      output$sidebar_content <- renderUI(
        tagList(
          selectInput("species", "Velg art:",
            c(
              "Laks" = "salmon", # should match what is in the data set to use as a selection (for example, "salmon" matches salmon in losses)
              "Regnbueørret" = "rainbowtrout"
            ),
            selected = c("salmon")
          ),
          selectInput("geo_group", "Velg geografisk område:",
            c(
              "Fylke" = "fylke",
              "Produksjonssone" = "zone",
              "Norge" = "all"
            ),
            selected = c("zone")
          ),
          hr(),
          shiny::includeMarkdown("www/sidebar_text.md")
        )
      )
    }
  })


  #### colors ####
  my_palette <- c("#FF5447", "#59CD8B", "#FFDAD4", "#1C4FB9")
  my_palette_long <- c(
    "#FF5447", "#59CD8B", "#95D9F3", "#1C4FB9", "#FFDAD4",
    "#BCEED1", "#D7F4FF", "#C7D9FF", "#F7FDFF", "#091A3E",
    "#FF897F", "#46A36B", "#AFD8FF", "#6B87D6", "#3C7383",
    "#FFD1BF", "#E8F0FF", "#E6F9F2", "#ACE2F7", "#0C2F5B"
  )

  #### data ####

  laksetap_board <- board_connect()
  # this is the dataset used for the existing app.
  losses <- pin_read(laksetap_board, "vi2451/losses_and_mortality_yearly_data")

  # new datasets
  losses_monthly_data <- pin_read(laksetap_board, "vi2451/losses_monthly_data")
  mortality_rates_monthly_data <- pin_read(laksetap_board, "vi2451/mortality_rates_monthly_data")
  mortality_cohorts_data <- pin_read(laksetap_board, "vi2451/mortality_cohorts_data")

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
            scrollX = TRUE,
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
            scrollX = TRUE,
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
            scrollX = TRUE,
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
            scrollX = TRUE,
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
      hoverinfo = "text", text = ~ paste(
        "Område: ", area, "<br>",
        "Antall: ", n, "<br>",
        "Prosent: ", perc
      )
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        annotations = list(yref = "paper", xref = "paper", y = 1.05, x = 1.1, text = "Velg tap:", showarrow = F, font = list(size = 14, face = "bold")),
        # title = input$select_year, # Should change when included change year
        yaxis = list(title = "Antall (millioner)"),
        xaxis = list(title = "Område")
      )
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
      )
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
            scrollX = TRUE,
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
            scrollX = TRUE,
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
      hoverinfo = "text", text = ~ paste(
        "Område: ", area, "<br>",
        "Antall: ", n, "<br>",
        "Prosent: ", perc
      )
    ) %>%
      layout(
        barmode = "stack",
        title = NULL,
        annotations = list(yref = "paper", xref = "paper", y = 1.05, x = 1.1, text = "Velg tap:", showarrow = F, font = list(size = 14, face = "bold")),
        # title = input$select_year, # Should change when included change year
        yaxis = list(title = "Antall (millioner)"),
        xaxis = list(title = "Område"),
        showlegend = TRUE
      )
  )


  ##### MORTALITY monthly ####

  df_mort_month <-
    eventReactive(c(input$species, input$geo_group), {
      mortality_rates_monthly_data %>%
        dplyr::filter(species == input$species &
          viz == input$geo_group)
    })


  output$table_mortality_month <- DT::renderDT({
    if (input$geo_group == "all") {
      df_mort_month() %>%
        dplyr::filter(!is.na(median)) %>%
        dplyr::filter(
          # !area == "All" &
          year %in% input$select_years_table4 &
            area == "Norge" &
            month_name %in% input$select_month_table4
        ) %>%
        dplyr::select(year, month_name, area, q1, median, q3) %>%
        dplyr::mutate(
          q1 = round(q1, 2),
          median = round(median, 2),
          q3 = round(q3, 2)
        ) %>%
        datatable(
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
            scrollX = TRUE,
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
    } else {
      df_mort_month() %>%
        dplyr::filter(!is.na(median)) %>%
        dplyr::filter(
          # !area == "Norge" &
          # !area == "All" &
          year %in% input$select_years_table4 &
            area %in% input$select_area4 &
            month_name %in% input$select_month_table4
        ) %>%
        dplyr::select(year, month_name, area, q1, median, q3) %>%
        dplyr::mutate(
          q1 = round(q1, 2),
          median = round(median, 2),
          q3 = round(q3, 2)
        ) %>%
        datatable(
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
            scrollX = TRUE,
            language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json")
          )
        )
    }
  })

  #### dead plots for monthly mortality ####

  observeEvent(input$species, {
    if (input$species == "rainbowtrout") {
      output$plot_mortality_month <- renderPlotly({
        p <- ggplot() +
          geom_blank() +
          labs(title = "Ingen data å vise") +
          theme_minimal()

        plotly::ggplotly(p)
      })
    } else {
      output$plot_mortality_month <- renderPlotly({
        p <- mortality_rates_monthly_data %>%
          dplyr::filter(year %in% input$select_year_mort) %>%
          dplyr::filter(area %in% c(input$select_area, "Norge")) %>%
          # ribbon for norway - enabled:
          # dplyr::mutate(q1 = if_else(area == "Norge", NA, q1)) %>%
          # dplyr::mutate(q3 = if_else(area == "Norge", NA, q3)) %>%
          ggplot() +
          aes(x = month_name, y = median, group = area) +
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
          scale_color_manual(values = my_palette_long) +
          scale_fill_manual(values = my_palette_long) +
          guides(
            col =
              guide_legend(title = "Område"), fill = FALSE
          )


        plotly::ggplotly(p)
      })
    }
  })

  observeEvent(input$geo_group, {
    if (input$geo_group == "all" | input$geo_group == "fylke") {
      output$plot_mortality_month <- renderPlotly({
        p <- ggplot() +
          geom_blank() +
          labs(title = "Ingen data å vise") +
          theme_minimal()


        plotly::ggplotly(p)
      })
    } else {
      output$plot_mortality_month <- renderPlotly({
        p <- mortality_rates_monthly_data %>%
          dplyr::filter(year %in% input$select_year_mort) %>%
          dplyr::filter(area %in% c(input$select_zone, "Norge")) %>%
          # ribbon for norway - enabled:
          # dplyr::mutate(q1 = if_else(area == "Norge", NA, q1)) %>%
          # dplyr::mutate(q3 = if_else(area == "Norge", NA, q3)) %>%
          ggplot() +
          aes(x = month_name, y = median, group = area) +
          labs(x = "Måned", y = "Dødelighet (%)") +
          geom_line(
            aes(
              color = factor(area)
            )
          ) +
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
          scale_color_manual(values = my_palette_long) +
          scale_fill_manual(values = my_palette_long) +
          guides(
            col =
              guide_legend(title = "Område"), fill = FALSE
          )


        plotly::ggplotly(p)
      })
    }
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
            scrollX = TRUE,
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
            scrollX = TRUE,
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
            size = 10
          ) +
          scale_color_gradient(low = "#C7D9FF", high = "#1C4FB9") +
          geom_point(
            aes(x = area, y = median, group = year, text = tooltip),
            size = 1, fill = "black", stroke = 0.2
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


        ggplotly(p, tooltip = "text")
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
            size = 10
          ) +
          scale_color_gradient(low = "#C7D9FF", high = "#1C4FB9") +
          geom_point(
            aes(x = area, y = median, group = year, text = tooltip),
            size = 1, fill = "black", stroke = 0.2
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


        ggplotly(p, tooltip = "text")
      })
    }
  })


  #### CALCULATOR ####
  #### Tab 1 ####
  observeEvent(input$calculate_button, {
    ar_count <- (input$beginning_count + input$end_count) / 2
    mort_rate <- input$dead_count / ar_count

    output$result_text <- renderText({
      paste("Dødsrate:", sprintf("%.2f%%", mort_rate * 100))
    })

    # output$mortality_plot <- renderPlot({
    #   plot(1, type = "n", xlab = "", ylab = "", main = "Mortality Rate Over Time")
    #   text(1, 1, paste("Mortality Rate:", sprintf("%.2f%%", mort_rate * 100)), cex = 1.5)
    # })
  })
  #### Tab 2 ####
  observeEvent(input$calculate_button_cum, {
    mort_rates_cum <- as.numeric(unlist(strsplit(input$mortality_input_cum, ","))) / 100
    cum_rate <- cumsum(mort_rates_cum)
    cum_risks <- 1 - exp(-cum_rate)

    period_label <- switch(input$period_type,
      "day" = "Dag",
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

shinyApp(ui, server)
