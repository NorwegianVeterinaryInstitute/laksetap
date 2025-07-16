ui <- tagList(
  head_block(),
  tag_manager(),
  meta_block(),
  div(class = "container",
      div(
        class = "d-flex flex-column p-4 gap-3", 
        style = "background-color: #d7f4ff",
        shiny::tags$div(class = "logo-wrapper",
        shiny::tags$a(href = "#main-content", class = "skip-link", "Hopp til hovetinnhold"),
        shiny::tags$a(
            href = "https://www.vetinst.no/",
            style = "height:64px;", 
            tags$img(
              src = "vetinst-logo-no.svg",
              alt = "Veterinærinstituttets logo",
              style = "height:64px;",
            )
          ),
        ),
        div(style = "background-color:#d7f4ff;", #padding-left:15px;",
            shiny::tags$div(role="region", `aria-label`= "App Title",
                            shiny::tags$h1(
                              "Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen",
                              role = "heading",
                              `aria-label` = "1",
                            ),
                            shiny::includeMarkdown("www/header_text.md")
            ))),
      shiny::tags$div(id = "main-content", role="region", `aria-label`= "main",
      bslib::page_navbar(
        title = "",
        # title = span(
        #   class = "custom-navbar-title",
        #   tags$span(class = "hamburger-label", "Menu")
        # ),
        footer = tags$footer(
          shiny::tags$div(role="region", `aria-label`= "footer",
          shiny::includeHTML("www/footer.html")),
        ),
        id = "navbar",
        theme = bslib::bs_theme(primary = "#d7f4ff"),
        header = shiny::tagList(
          shiny::div(style = "padding: 1.5rem;",
                     shiny::uiOutput("tab_title"),
                     shiny::tags$br(),
                     shiny::uiOutput("top_bar"),
          )),
        
        #### Tab 1: top level tab monthly mortality ####
        bslib::nav_panel(
          "Månedlig dødelighet %",
          value = "monthly_mortality",
          bslib::navset_tab(
            bslib::nav_panel(
              "Diagram",
              br(),
              # fluidRow(
              #   column(
              #     width = 6,
              #     selectInput(
              #       "select_year_mort",
              #       "Velg år:",
              #       list(
              #         "År" = c(
              #           2024,
              #           2023,
              #           2022,
              #           2021,
              #           2020
              #         )
              #       )
              #     )
              #   ),
              #   column(
              #     width = 6,
              #     selectInput(
              #       "select_sone",
              #       "Velg zone:",
              #       list(
              #         "Zone" = c(
              #           "1",
              #           "2",
              #           "3",
              #           "4",
              #           "5",
              #           "6",
              #           "7",
              #           "8",
              #           "9",
              #           "10",
              #           "11",
              #           "12 & 13"
              #         )
              #       ),
              #       multiple = TRUE
              #     )
              #   )
              # ),
              uiOutput("tab_filter_monthly_plot"),
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
        #### Tab 3: Top level tab cohorts####
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
        #### Tab 4: Top level tab calculator####
        bslib::nav_panel(
          "Dødelighetskalkulator",
          value = "calc_main",
          bslib::navset_tab(
            id = "calc_nav",
            header = shiny::uiOutput("calc_banner"),
            bslib::nav_panel(
              "Dødelighetskalkulator",
              shiny::tags$h3("Resultat"),
              value = "calc",
              div(class = "formatted-output", textOutput("result_text")),
              plotOutput("mortality_plot")
            ),
            bslib::nav_panel(
              "Dødelighetskalkulator for utvidet periode",
              shiny::tags$h3("Resultat"),
              value = "calc_cum",
              plotOutput("cumulative_risk_plot"),
              div(class = "formatted-output", textOutput("result_text_cum"))
            ))),
        
        #### Tab 5: Top level tab for all losses ####
        bslib::nav_panel(
          "Tapstall",
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
        
        #### Tab 6: Top level tab about####
        bslib::nav_panel(
          "Om statistikken",
          value = "about",
          column(
            width = 9,
            shiny::includeMarkdown("www/about.md")
          )
        ),
      ))))
