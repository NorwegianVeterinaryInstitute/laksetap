head_block <- function() {
  shiny::tags$head(
    tags$html(lang = "no_NO"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$title("Laksetap - Statistikk over tap og dødelighet av laks og regnbueørret"),
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
      title = "Laksetap: Statistikk over tap og dødelighet",
      description = "Utforsk interaktiv statistikk over tap og dødelighet for laks og regnbueørret i Norge",
      url = "https://apps.vetinst.no/laksetap",
      image = "https://www.vetinst.no/_/image/5c4e853a-130b-4e7f-92a3-8ca38bec0b56:2dcf9428a329fc0044b412c55b8c9e471f742d65/block-1200-630/Logo-vetinst-open-graph-no-svg-1200x630.png.jpg",
      image_alt = "Veterinærinstituttets logo"
    )
}


ui <- tagList(
  head_block(),
  tag_manager(),
  meta_block(),
  div(class = "container",
  div(
    class = "d-flex flex-column p-4 gap-3", 
    style = "background-color: #d7f4ff",
    shiny::tags$div(
      tags$a(
        href = "https://www.vetinst.no/",
        style = "height:64px;", 
        tags$img(
          src = "vetinst-logo.png",
          alt = "Veterinærinstituttets logo",
          style = "height:64px;",
        )
      )
    ),
  div(style = "background-color:#d7f4ff;", #padding-left:15px;",
    shiny::tags$div(role="region", `aria-label`= "App Title",
    shiny::tags$h1(
      "Statistikk over tap og dødelighet av laks og regnbueørret",
      role = "heading",
      `aria-label` = "1",
    ),
    shiny::includeMarkdown("www/header_text.md")
  ))),
  bslib::page_navbar(
    title = "",
    # title = span(
    #   class = "custom-navbar-title",
    #   tags$span(class = "hamburger-label", "Menu")
    # ),
    
    id = "navbar",
    theme = bslib::bs_theme(primary = "#d7f4ff"),
   header = shiny::tagList(
     shiny::div(style = "padding: 1.5rem;",
     shiny::uiOutput("tab_title"),
     shiny::tags$br(),
     shiny::uiOutput("sidebar_content"),
   )),
   
    #### Tab 1: top level tab monthly mortality ####
    bslib::nav_panel(
      "Månedlig dødelighet %",
      value = "monthly_mortality",
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
    #bslib::nav_panel(
    #  "Årlige tap",
    #  bslib::navset_tab(

#      )
 #   ),
    #### Tab 2 top level tab yearly mortality####
    bslib::nav_panel(
      "Årlig dødelighet %",
      value = "yearly_mortality",
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
      "Produksjonssyklus dødelighet %",
      value = "prod_mortality",
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
      shiny::tags$h3("Resultat"),
      value = "calc",
      div(class = "formatted-output", textOutput("result_text")),
      plotOutput("mortality_plot")
    ),
    #### top level tab calculator_2 ####
    bslib::nav_panel(
      "Dødelighetskalkulator for utvidet periode",
      shiny::tags$h3("Resultat"),
      value = "calc_cum",
      plotOutput("cumulative_risk_plot"),
      div(class = "formatted-output", textOutput("result_text_cum"))
    ),
    #### top level tab for all losses ####
    bslib::nav_panel(
      "Tap",
      value = "losses",
      bslib::navset_tab(
        bslib::nav_panel(
          "Månedlige tap Diagram",
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
          "Månedlige tap Tabell",
          br(),
          uiOutput("tab_filter_m1"),
          DTOutput("table_losses_month"),
          hr(),
          shiny::includeMarkdown("www/tab1_table_and_plot_footer.md")
        ),
        bslib::nav_panel(
          "Årlige tap Diagram",
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
          "Årlige tap Tabell",
          br(),
          uiOutput("tab_filter"),
          DTOutput("table_losses"),
          hr(),
          shiny::includeMarkdown("www/tab3_table_and_plot_footer.md")
        ),
      )
    ),

    #### top level tab about####
    bslib::nav_panel(
      "Om statistikken",
      value = "about",
      bslib::navset_tab(
        bslib::nav_panel(
          "Datakilder",
          value = "about",
          column(
            width = 9,
            shiny::includeMarkdown("www/about.md")
          )
        ),
        
        

  )
)

)))