head_block <- function() {
  shiny::tags$head(
    tags$html(lang = "no"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  )
}

tag_manager <- function() {
  shiny::tags$head(shiny::HTML(
    '<!-- Seeds Consulting Tag Manager -->
      <script>
        var _mtm = (window._mtm = window._mtm || []);
        _mtm.push({ "mtm.startTime": new Date().getTime(), event: "mtm.Start" }); # nolint
        (function () {
          var d = document,
            g = d.createElement("script"),
            s = d.getElementsByTagName("script")[0];
          g.async = true;
          g.src = "https://stats.vetinst.no/js/container_R9v9ZduS.js";
          s.parentNode.insertBefore(g, s);
        })();
      </script>
      <!-- End Seeds Consulting Tag Manager -->'
  ))
}

meta_block <- function() {
  metathis::meta() |>
    metathis::meta_social(
      title = "Laksetap",
      description = "Laksefiskdødelighet Shiny App",
      url = "https://connect.posit.vetinst.no/laksetap",
      image = "https://www.vetinst.no/_/image/5c4e853a-130b-4e7f-92a3-8ca38bec0b56:2dcf9428a329fc0044b412c55b8c9e471f742d65/block-1200-630/Logo-vetinst-open-graph-no-svg-1200x630.png.jpg", # nolint
      image_alt = "An image for social meda cards"
    )
}

ui <- tagList(
  head_block(),
  tag_manager(),
  meta_block(),
  div(
    class = "d-flex flex-wrap justify-content-start align-items-center p-2 gap-3", # nolint
    style = "background-color: #d7f4ff",
    shiny::tags$div(
      tags$a(
        href = "https://www.vetinst.no/",
        tags$img(
          src = "vetinst-logo.png",
          alt = "NVI logo",
          style = "height:44px;"
        )
      )
    ),
    shiny::tags$div(
      class = "fs-5 fw-bold text-center",
      "Statistikk over tap og dødelighet av laks og regnbueørret",
      role = "region",
      `aria-label` = "App Title"
    )
  ),
  bslib::page_navbar(
    title = NULL,
    id = "navbar",
    sidebar = bslib::sidebar(shiny::uiOutput("sidebar_content")),
    #### top level tab monthly losses ####
    bslib::nav_spacer(),
    bslib::nav_panel(
      "Månedlige tap",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          br(),
          fluidRow(
            column(
              width = 6,
              selectInput(
                "select_year",
                "Velg år:",
                list(
                  "År" = c(
                    2024,
                    2023,
                    2022,
                    2021,
                    2020
                  )
                )
              )
            ),
            column(
              width = 6,
              selectInput(
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
          plotlyOutput("plot_losses_monthly"),
          hr(),
          shiny::includeMarkdown("www/tab1_table_and_plot_footer.md")
        ),
        bslib::nav_panel(
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
    bslib::nav_panel(
      "Månedlige dødsrater",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          br(),
          fluidRow(
            column(
              width = 6,
              selectInput(
                "select_year_mort",
                "Velg år:",
                list(
                  "År" = c(
                    2024,
                    2023,
                    2022,
                    2021,
                    2020
                  )
                )
              )
            ),
            column(
              width = 6,
              selectInput(
                "select_zone",
                "Velg zone:",
                list(
                  "Zone" = c(
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "10",
                    "11",
                    "12 & 13"
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
        bslib::nav_panel(
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
    bslib::nav_panel(
      "Årlige tap",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          br(),
          selectInput(
            "select_year_losses",
            "Velg år:",
            list(
              "År" = c(
                2024,
                2023,
                2022,
                2021,
                2020
              )
            )
          ),
          plotlyOutput("plot_losses"),
          hr(),
          shiny::includeMarkdown("www/tab3_table_and_plot_footer.md")
        ),
        bslib::nav_panel(
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
    bslib::nav_panel(
      "Årlig dødelighet",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          br(),
          plotlyOutput("plot_mortality"),
          hr(),
          shiny::includeMarkdown("www/tab4_table_and_plot_footer.md")
        ),
        bslib::nav_panel(
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
    bslib::nav_panel(
      "Produksjonssykluser dødelighet",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          br(),
          column(
            width = 6,
            selectInput(
              "select_year_coh",
              "Velg år:",
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
        bslib::nav_panel(
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
    bslib::nav_panel(
      "Dødelighetskalkulator",
      value = "calc",
      verbatimTextOutput("result_text"),
      plotOutput("mortality_plot")
    ),
    #### top level tab calculator_2 ####
    bslib::nav_panel(
      "Dødelighetskalkulator for utvidet periode",
      value = "calc_cum",
      plotOutput("cumulative_risk_plot"),
      verbatimTextOutput("result_text_cum")
    ),
    #### top level tab about####
    bslib::nav_panel(
      "Om statistikken",
      column(
        width = 9,
        shiny::includeMarkdown("www/about.md")
      )
    ),
    bslib::nav_item()
  )
)
