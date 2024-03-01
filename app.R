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


ui <- fluidPage(
  tags$head(tags$style(HTML('* {font-family: "Futura PT Medium"};'))),
  titlePanel( 
    # creating NVI logo in the top of the app and the title following it
    windowTitle = "Laksefiskdødlighet",
    fluidRow(
      column(4, shiny::HTML(
            '<a href="https://www.vetinst.no/">
            <img src="vet-rgb-2.svg", alt="NVI logo" style="width:auto;height:40px;"></a>'          
      )),
    column(
      8,
      h3("Statistikk over tap og dødelighet av laks og regnbueørret", style = "color:#1b314f; font-style:bold")
    ))
  ),
  sidebarLayout(
    sidebarPanel(
      uiOutput("sidebar_content"),
      width = 2),
    mainPanel(
      navbarPage(title = "", id = "navbar",
        tabPanel(h5("Årlige tap"),
                 tabsetPanel(type = "tabs",
                             tabPanel("Tabell",
                                      br(),
                                      fluidRow(
                                        column(width = 6,
                                      selectizeInput("select_years_table1","Velg år:",
                                                     c("2023" = 2023,
                                                       "2022" = 2022,
                                                       "2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019),
                                                     selected = c(2023, 2022, 2021, 2020, 2019),
                                                     multiple = T)),
                                      column(width = 6,
                                      selectizeInput("select_area1", "Velg Omrade",
                                      c(1:13),
                                      selected = c(1:13),
                                      multiple = TRUE))
                                      ),
                                      DTOutput("table_losses"),
                             hr(),
                             p("Forklaring av tall: ‘Total’ viser det totale tapet. ‘Døde’ viser antall døde.
                             ‘Døde%’ viser hvor stor andel av det totale tapet som skyldes døde.
                             Tilsvarende gjelder for ‘Utkast%’, ‘Rømt%’ og ‘Annet%’. For forklaring av kategoriene,
                             se fanen ‘Om statistikken’.")),
                             tabPanel("Diagram", 
                                      br(),
                                      selectInput("select_year", "Velg år:", list(
                                        "År" = c(2023, 2022, 2021, 2020, 2019))),
                                      plotlyOutput("plot_losses"))),
                 br(),
                 #hr(),
                 br()
                 #,p("test")
        ),
        tabPanel(h5("Årlig dødelighet"),
                 tabsetPanel(type = "tabs",
                             tabPanel("Tabell",
                                      br(),
                                      selectizeInput("select_years_table2","Velg år:",
                                                     c("2023" = 2023,
                                                       "2022" = 2022,
                                                       "2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019),
                                                     selected = c(2023, 2022, 2021, 2020, 2019),
                                                     multiple = T),
                                      DTOutput("table_mortality"),
                                      #br(),
                                      hr(),
                                      #br(),
                                      p("I tabellen er prosent døde angitt for henholdsvis laks og regnbueørret.
                                        I disse tallene inngår ikke tap som følge av utkast, rømming eller «annet».
                                        Se for øvrig beskrivelse av beregningsmetode i fanen ‘Om statistikken’. 
                                        Produksjonsområder eller fylker med meget få lokaliteter er tatt ut av fremstillingen,
                                        for at det ikke skal være mulig å kjenne igjen enkelte lokaliteter.")),
                             tabPanel("Diagram", 
                                      br(),
                                      plotlyOutput("plot_mortality"),
                                      #br(),
                                      hr(),
                                      #br(),
                                      p("Produksjonsområder eller fylker med meget få lokaliteter er tatt ut av fremstillingen,
                                        for at det ikke skal være mulig å kjenne igjen enkelte lokaliteter.")))
        ),
        tabPanel(h5("Månedlige tap"),
                 tabsetPanel(type = "tabs",
                             tabPanel("Tabell",
                                      br(),
                                      selectizeInput("select_years_table3","Velg år:",
                                                     c("2023" = 2023,
                                                       "2022" = 2022,
                                                       "2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019),
                                                     selected = c(2023, 2022, 2021, 2020, 2019),
                                                     multiple = T),
                                      DTOutput("table_losses_month"),
                                      hr(),
                                      p("Forklaring av tall: ‘Total’ viser det totale tapet. 
                                        ‘Døde’ viser antall døde.
                             ‘Døde%’ viser hvor stor andel av det totale tapet som skyldes døde.
                             Tilsvarende gjelder for ‘Utkast%’, ‘Rømt%’ og ‘Annet%’. For forklaring av kategoriene,
                             se fanen ‘Om statistikken’.")),
                             tabPanel("Diagram",
                                      br(),
                                      fluidRow(
                                        column(width = 6,
                                      selectInput("select_year", "Velg år:", list(
                                        "År" = c(2023, 2022, 2021, 2020, 2019)))),
                                      column(width = 6,
                                      selectInput("select_month", "Velg måned:", list(
                                        "Måned" = c("01", "02", "03", "04", "05", "06",
                                                    "07", "08", "09", "10", "11", "12"))))),
                                      plotlyOutput("plot_losses_monthly"))),
                 br(),
                 #hr(),
                 br()
                 #,p("test")
        ),
        tabPanel(h5("Månedlig dødelighet"),
                 tabsetPanel(type = "tabs",
                             tabPanel("Tabell",
                                      br(),
                                      selectizeInput("select_years_table4","Velg år:",
                                                     c("2023" = 2023,
                                                       "2022" = 2022,
                                                       "2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019),
                                                     selected = c(2023, 2022, 2021, 2020, 2019),
                                                     multiple = T),
                                      DTOutput("table_mortality_month"),
                                      #br(),
                                      hr(),
                                      #br(),
                                      p("I tabellen er prosent døde angitt for henholdsvis laks og regnbueørret.
                                        I disse tallene inngår ikke tap som følge av utkast, rømming eller «annet».
                                        Se for øvrig beskrivelse av beregningsmetode i fanen ‘Om statistikken’.
                                        Produksjonsområder eller fylker med meget få lokaliteter er tatt ut av fremstillingen,
                                        for at det ikke skal være mulig å kjenne igjen enkelte lokaliteter.")),
                             tabPanel("Diagram",
                                      br(),
                                     fluidRow(
                                        column(width = 6,
                                      selectInput("select_year_mort", "Velg år:", list(
                                        "År" = c(2023, 2022, 2021, 2020, 2019)))),
                                      column(width = 6,
                                             selectInput("select_zone", "Velg zone:", list(
                                               "Zone" = c("1 & 2", "3", "4", "5", "6",
                                                          "7", "8", "9", "10", "11", "12 & 13")),
                                               multiple = TRUE))
                                      ),
                                      plotlyOutput("plot_mortality_month"),
                                      #br(),
                                      hr(),
                                      #br(),
                                      p("Produksjonsområder eller fylker med meget få lokaliteter er tatt ut av fremstillingen,
                                        for at det ikke skal være mulig å kjenne igjen enkelte lokaliteter.")))
        ),
        tabPanel(h5("Produksjonssykluser dødelighet"),
                 tabsetPanel(type = "tabs",
                             tabPanel("Tabell",
                                      br(),
                                      
                                      
                                      fluidRow(
                                      column(width = 4,
                                      selectizeInput("select_years_table5","Velg år:",
                                                     c("2023" = 2023,
                                                       "2022" = 2022,
                                                       "2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019),
                                                     selected = c(2023, 2022, 2021, 2020, 2019),
                                                     multiple = T)),
                                      
                                      column(width = 8,
                                             selectizeInput("select_locs","Velg område:",
                                                            c(1:13),
                                                            selected = c(1:13),
                                                            multiple = T)),
                                      ),
                                      DTOutput("table_cohort"),
                                      hr(),
                                      p("Forklaring av tall: ‘Total’ viser det totale tapet. ‘Døde’ viser antall døde.
                             ‘Døde%’ viser hvor stor andel av det totale tapet som skyldes døde.
                             Tilsvarende gjelder for ‘Utkast%’, ‘Rømt%’ og ‘Annet%’. For forklaring av kategoriene,
                             se fanen ‘Om statistikken’.")),
                             tabPanel("Diagram",
                                      br(),
                                        column(width = 6,
                                               selectInput("select_year_coh", "Velg år:", list(
                                                 "År" = c(2023, 2022, 2021, 2020, 2019)))),
                                      plotlyOutput("plot_cohort"))),
                 br(),
                 #hr(),
                 br()
                 #,p("test")
        ),
        tabPanel(h5("Kalkuler dødelighet"), value = "calc",
                              verbatimTextOutput("result_text"),
                                      plotOutput("mortality_plot")
                                      ),
      tabPanel(h5("Dødelighet utvidet periode"), value = "calc_cum",
                 verbatimTextOutput("result_text_cum"),
                 plotOutput("cumulative_risk_plot")
                
        ),
        tabPanel(h5("Om statistikken"),
                 
                 column(width = 9,
                        
               shiny::includeMarkdown("www/about.md")
                 
                 )) 
      )
    )
  )
)


server <- function(input, output) {
  
  observeEvent(input$navbar, {
    if (input$navbar == "calc") {
      output$sidebar_content <-
        renderUI(
          tagList(
              numericInput("beginning_count", "Number of Animals at the Beginning of the Month:", value = 100),
              numericInput("end_count", "Number of Animals at the End of the Month:", value = 90),
              numericInput("dead_count", "Number of Dead Animals During the Month:", value = 5),
              actionButton("calculate_button", "Calculate")
            )
        )
    } else if (input$navbar == "calc_cum") {
      output$sidebar_content <-
        renderUI(
      tagList(
      textInput("mortality_input_cum", "Enter Monthly Mortality Rates (comma-separated):", ""),
      actionButton("calculate_button_cum", "Calculate"))
        )
      }    else {
          output$sidebar_content <- renderUI(
            
            tagList(
              selectInput("species", "Velg art:",
                          c("Laks" = "salmon", #should match what is in the data set to use as a selection (for example, "salmon" matches salmon in losses)
                            "Regnbueørret" = "rainbowtrout"),
                          selected = c("salmon")),
              selectInput("geo_group", "Velg geografisk område:",
                          c("Fylke" = "fylke",
                            "Produksjonssone" = "zone",
                            "Norge" = "all"),
                          selected = c("zone")),
              hr(),
              helpText("Tallene er basert på månedlige innrapporteringer til Fiskeridirektoratet.
      Les mer om hvordan statistikken lages i fanen ‘Om statistikken’.
      Det er mulig å velge å se enten det totale tapet (fanen ‘Tap’),
      eller bare tap forårsaket av dødelighet (fanen ‘Dødelighet’)."))
          )
      }
    })
  
  
  #### colors ####
  myPallete <- c('#cd692c', '#98a762','#dac266','#886b9a')
  
  #### data ####
  
  laksetap_board <- board_connect()
  # this is the dataset used for the existing app.
  losses <- pin_read(laksetap_board, "vi2451/losses_and_mortality_yearly_data")
  
  # new datasets
  losses_monthly_data <- pin_read(laksetap_board, "vi2451/losses_monthly_data") %>%
    dplyr::mutate(area = dplyr::if_else(area == "Norway", "Norge", area)) %>% 
    dplyr::mutate(year =  as.factor(year(ym(year_month)))) 
  mortality_rates_monthly_data <- pin_read(laksetap_board, "vi2451/mortality_rates_monthly_data") %>% 
    dplyr::mutate(year =  as.factor(year(date))) %>%
    dplyr::mutate(month_name = month(date, label = TRUE))
  mortality_cohorts_data <- pin_read(laksetap_board, "vi2451/mortality_cohorts_data") %>%
    dplyr::mutate(area = dplyr::if_else(area == "Norway", "Norge", area)) %>%
    dplyr::mutate(viz = dplyr::if_else(area == "Norge", "all", viz))
  
  
  #### LOSSES yearly ####
  
  df_losses <-
    eventReactive(c(input$species, input$geo_group), {
      losses %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group)
    })
  
  # any changes you make to df_losses will affect both the table and the plot, 
  # if you want to use df_losses write df_losses()
  
  output$table_losses <- DT::renderDT(
    datatable(
      df_losses() %>%
        dplyr::select("year", "area", "losses", "doed", "p.doed", "ut", "p.ut", "romt", "p.romt", "ufor", "p.ufor") %>%
        dplyr::filter(!area == "Norway" & !area == "All" & year %in% input$select_years_table1 & area %in% input$select_area1),
      #filter = "top",
      rownames = F,
      colnames= c("År","Område", "Total", "Døde", "Døde%", "Utkast", "Utkast%", "Rømt", "Rømt%", "Annet", "Annet%"),
      selection = (list(mode = 'multiple',selected = "all",target ='column')),
      options = list(sDom  = '<"top">lrt<"bottom">ip',
                     scrollX = TRUE,
                     language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"))))
        #autoWidth =T, #columnDefs = list(list(searchable = FALSE, targets = c(1:10)),
                    # list(width='200px', targets = c(1))))))
  
  output$plot_losses <- renderPlotly(
    plot_ly(df_losses() %>% 
              dplyr::filter (!area == "Norway" & !area == "All" & year == input$select_year) %>%
              tidyr:: gather(type, n, c(doed, ut, romt, ufor)) %>% droplevels () %>% 
              dplyr:: mutate(perc = case_when (type == "doed" ~ p.doed,
                                               type == "ut" ~ p.ut,
                                               type == "romt" ~ p.romt,
                                               type == "ufor" ~ p.ufor)) %>%
              dplyr:: mutate (type = factor(type, levels = c("doed", "ut","romt", "ufor"), labels = c("Døde", "Utkast", "Rømt", "Annet"))),
            x = ~area,
            y= ~n,
            color = ~type, colors = myPallete, type = 'bar', legendgroup = ~type,
            hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                              "Antall: ", n,"<br>",
                                              "Prosentene: ",perc)) %>% 
      layout(barmode = 'stack',
             title = "",
             annotations=list(yref="paper",xref="paper",y=1.05,x=1.1, text="Velg tap:",showarrow=F, font=list(size=14,face="bold")),
             #title = input$select_year, # Should change when included change year
             yaxis = list(title = 'Antall (millioner)'),
             xaxis = list( title = "Område")))
  
  
  #### MORTALITY yearly ####
  
  output$table_mortality <- DT::renderDT (
    datatable(df_losses () %>%
                dplyr:: filter (!is.na(mort)) %>%
                dplyr:: select (year, area, mort) %>% # this has changed from previous year
                dplyr::filter(!area == "Norway" & !area == "All" & year %in% input$select_years_table2),
              #filter = "top",
              rownames = F,
              colnames= c( "År", "Område", "Dødelighet %"), # also here
              selection = (list(mode = 'multiple', selected = "all", target ='column')),
              options = list(sDom  = '<"top">lrt<"bottom">ip',
                             autoWidth = FALSE,
                             #columnDefs = list(list(width = '100px', targets = c(1, 2))),
                             scrollX = TRUE,
                             language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"))
    ))
  #, autoWidth = T, columnDefs = list(list(searchable = FALSE, targets = c(1:4)), list(width='150px', className = 'dt-left', targets = list("_all"))))))
  
  output$plot_mortality <- renderPlotly(
    plot_ly(df_losses() %>% 
              spread(year, mort) %>% 
              dplyr::filter (!is.na(`2023`) | !is.na(`2022`) | !is.na(`2021`) | !is.na(`2020`) | !is.na(`2019`)) %>% 
              dplyr::filter (!(area == "All"| area == "Norway")) %>%
              droplevels(),
            x = ~area, y = ~`2023`, name = "2023", type = 'scatter',
            mode = "markers", marker = list(color = "#253494"),
            hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                              "Prosentene: ", `2023`,"<br>")) %>%
      add_trace(x = ~area, y = ~`2022`, name = "2022",type = 'scatter',
                mode = "markers", marker = list(color = "#2c7fb8"),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", `2022`,"<br>")) %>%
      add_trace(x = ~area, y = ~`2021`, name = "2021",type = 'scatter',
                mode = "markers", marker = list(color = "#41b6c4"),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", `2021`,"<br>")) %>%
      add_trace(x = ~area, y = ~`2020`, name = "2020",type = 'scatter',
                mode = "markers", marker = list(color = "#a1dab4"),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", `2020`,"<br>")) %>%
      add_trace(x = ~area, y = ~`2019`, name = "2019",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", `2019`,"<br>")) %>%
      layout(title = "", 
             annotations=list(yref='paper',xref="paper",y=1.09,x=.2, text="Velg år:",showarrow=F, font=list(size=14,face="bold")),
             legend = list(orientation = "h", x= .25, y = 1.1),
             xaxis = list(title = "Område"),
             yaxis = list (title = "Dødelighet (%)", categoryarray = ~ area), 
             margin = list(l = 100)))
  
  
  ##### LOSSES monthly ####
  
  df_losses_month <-
    eventReactive(c(input$species, input$geo_group), {
      losses_monthly_data %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group) 
    })
  
  
  output$table_losses_month<- DT::renderDT(
    datatable(
      df_losses_month() %>%
        dplyr::filter(!area == "Norway" & !area == "All" & year %in% input$select_years_table3) %>%
        dplyr::select("year_month", "area", "losses", "doed", "p.doed", "ut", "p.ut", "romt", "p.romt", "ufor", "p.ufor"),
      #filter = "top",
      rownames = F,
      colnames= c("År","Område", "Total", "Døde", "Døde%", "Utkast", "Utkast%", "Rømt", "Rømt%", "Annet", "Annet%"),
      selection = (list(mode = 'multiple',selected = "all",target ='column')),
      options = list(sDom  = '<"top">lrt<"bottom">ip',
                     scrollX = TRUE,
                     language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"))))
  
  
  output$plot_losses_monthly <- renderPlotly(
    plot_ly(df_losses_month() %>% 
              dplyr::filter (!area == "Norway" & !area == "All" & year_month == paste0(input$select_year,"-", input$select_month)) %>%
              tidyr:: gather(type, n, c(doed, ut, romt, ufor)) %>% droplevels () %>% 
              dplyr:: mutate(perc = case_when (type == "doed" ~ p.doed,
                                               type == "ut" ~ p.ut,
                                               type == "romt" ~ p.romt,
                                               type == "ufor" ~ p.ufor)) %>%
              dplyr:: mutate (type = factor(type, levels = c("doed", "ut","romt", "ufor"), labels = c("Døde", "Utkast", "Rømt", "Annet"))),
            x = ~area,
            y= ~n,
            color = ~type, colors = myPallete, type = 'bar', legendgroup = ~type,
            hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                              "Antall: ", n,"<br>",
                                              "Prosentene: ",perc)) %>% 
      layout(barmode = 'stack',
             title = "",
             annotations=list(yref="paper",xref="paper",y=1.05,x=1.1, text="Velg tap:",showarrow=F, font=list(size=14,face="bold")),
             #title = input$select_year, # Should change when included change year
             yaxis = list(title = 'Antall (millioner)'),
             xaxis = list( title = "Område")))
    
  
  ##### MORTALITY monthly ####
  
  df_mort_month <-
    eventReactive(c(input$species, input$geo_group), {
      mortality_rates_monthly_data %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group) 
    })
  
  
  output$table_mortality_month <- DT::renderDT (
    datatable(df_mort_month() %>%
                dplyr:: filter (!is.na(median)) %>%
                dplyr::filter(!area == "Norway" & !area == "All" & year %in% input$select_years_table4) %>%
                dplyr:: select (date, area, q1, median, q3) %>%
                dplyr::mutate(q1 = round(q1, 2), median = round(median, 2), q3 = round(q3, 2)),
              #filter = "top",
              rownames = F,
              colnames= c( "Dato", "Område", "1 Krvartil", "Median", "3 Kvartil"), # also here
              selection = (list(mode = 'multiple', selected = "all", target ='column')),
              options = list(sDom  = '<"top">lrt<"bottom">ip',
                             autoWidth = FALSE,
                             #columnDefs = list(list(width = '100px', targets = c(1, 2))),
                             scrollX = TRUE,
                             language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"))
    ))


      observeEvent(input$species, {
     if (input$species == "rainbowtrout") {
       output$plot_mortality_month <- renderPlotly({
     p <- mortality_rates_monthly_data %>% 
              dplyr::filter(year %in% input$select_year_mort) %>%
              dplyr::filter(area %in% c(input$select_zone, "Norge")) %>%
              # ribbon for norway - enabled:
              #dplyr::mutate(q1 = if_else(area == "Norge", NA, q1)) %>% 
              #dplyr::mutate(q3 = if_else(area == "Norge", NA, q3)) %>%
      ggplot() +
      aes(x = month_name, y = median, color = area, group = area) +
      labs(title = "No data to display") +
      theme_minimal()+ 
      geom_blank() 

      plotly::ggplotly(p)

     })
      
    } else {
 
  output$plot_mortality_month <- renderPlotly({

     p <- mortality_rates_monthly_data %>% 
              dplyr::filter(year %in% input$select_year_mort) %>%
              dplyr::filter(area %in% c(input$select_zone, "Norge")) %>%
              # ribbon for norway - enabled:
              #dplyr::mutate(q1 = if_else(area == "Norge", NA, q1)) %>% 
              #dplyr::mutate(q3 = if_else(area == "Norge", NA, q3)) %>%
      ggplot() +
      aes(x = month_name, y = median, color = area, group = area) + 
      geom_line() +
       geom_ribbon(
         aes(
           ymin = .data$q1,
           ymax = .data$q3,
           fill = area
         ),
         linetype = 0,
         alpha = 0.1,
         show.legend = FALSE
       ) +
      theme_minimal() +
       guides(col = 
      guide_legend(title = "Område"))
     
     
     plotly::ggplotly(p)}
  )}
 

      })
     
 
  
  #### COHORTS ####
  df_cohorts <-
    eventReactive(c(input$species, input$geo_group), {
      mortality_cohorts_data %>%
        dplyr::filter(species == input$species &
                        viz == input$geo_group) 
    })
  
  
  output$table_cohort <- DT::renderDT (
    datatable(df_cohorts() %>%
                #dplyr:: filter (!is.na(median)) %>%
                dplyr::filter(
                  !area == "Norway" &
                    !area == "All"  &
                    year %in% input$select_years_table5 &
                    area %in% input$select_locs
                )  %>% 
                dplyr:: select (year, area, q1, mort, q3),
              #filter = "top",
              rownames = F,
              colnames= c("År","Område", "1 Kvartil", "Median", "3 Kvartil"),
              selection = (list(mode = 'multiple', selected = "all", target ='column')),
              options = list(sDom  = '<"top">lrt<"bottom">ip',
                             autoWidth = FALSE,
                             #columnDefs = list(list(width = '100px', targets = c(1, 2))),
                             scrollX = TRUE,
                             language = list(url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"))
    ))
  
  output$plot_cohort <- renderPlotly({
    
    p <- df_cohorts() %>%
      dplyr::filter(year == input$select_year_coh) %>%
      ggplot() +
      geom_segment(
        aes(color = area, x = area, xend = area, y = q1, yend=q3), size = 10) +
      geom_point(
        aes(x = area, y = mort, group = year),
        pch = 10, size = 9, fill = "black", stroke = 0.2) +
      labs(title = "Mortality of fish cohorts harvested in a year per zone and Norway (>= 12 months)",
           x = input$select_year_coh,
           y = "Mortality %") +
      theme_minimal() +
      theme(axis.text.x = element_blank()) +
      guides(fill = "none") 
    
    
    ggplotly(p)
    
  } 
  )
   
  
  #### CALCULATOR ####
  
  observeEvent(input$calculate_button, {
    # Calculate mortality rate
    ar_count <- input$end_count
    d_count <- input$dead_count
    mort_rate <- d_count / ar_count
    
    # Display the results
    output$result_text <- renderText({
      paste("Mortality Rate:", sprintf("%.2f%%", mort_rate * 100))
    })
    
    # Plot the mortality rate over time (placeholder plot)
    output$mortality_plot <- renderPlot({
      plot(1, type = "n", xlab = "", ylab = "", main = "Mortality Rate Over Time")
      text(1, 1, paste("Mortality Rate:", sprintf("%.2f%%", mort_rate * 100)), cex = 1.5)
    })
  })
  
  
  observeEvent(input$calculate_button_cum, {
    
    # Extract and convert monthly mortality rates
    mort_rates_cum <- as.numeric(unlist(strsplit(input$mortality_input_cum, ",")))
    
    # Calculate cumulative mortality risk
    sum_mort_rate_cum <- sum(mort_rates_cum)
    cum_risk_cum <- 1 - exp(-sum_mort_rate_cum)
    
    # Display the results
    output$result_text_cum <- renderText({
      paste("Cumulative Mortality Risk:", sprintf("%.2f%%", cum_risk_cum * 100))
    })
    
    # Plot the monthly mortality rates over time (placeholder plot)
    output$cumulative_risk_plot <- renderPlot({
      barplot(mort_rates_cum, names.arg = seq_along(mort_rates_cum), col = "steelblue", 
              main = "Monthly Mortality Rates",
              xlab = "Month", ylab = "Mortality Rate")
    })
  })
  
}

shinyApp(ui, server)

#runApp()





