### Layout for app 
library(here)
library(shiny)
library(dplyr)
library(DT)
library(plotly)
library(tidyr)
library(pins)
library(lubridate)




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
      selectInput("species", "Velg art:",
                  c("Laks" = "salmon", #should match what is in the data set to use as a selection (for example, "salmon" matches salmon in losses)
                    "Regnbueørret" = "rainbowtrout"),
                  selected = c("salmon")),
      selectInput("geo_group", "Velg geografisk område:",
                  c("Fylke" = "fylke",
                    "Produksjonssone" = "zone",
                    "Norge" = "all"),
                  selected = c("all")),
      hr(),
      helpText("Tallene er basert på månedlige innrapporteringer til Fiskeridirektoratet.
      Les mer om hvordan statistikken lages i fanen ‘Om statistikken’.
      Det er mulig å velge å se enten det totale tapet (fanen ‘Tap’),
      eller bare tap forårsaket av dødelighet (fanen ‘Dødelighet’)."),
      width = 2),
    mainPanel(
      navbarPage(title = "",
        tabPanel(h5("Tap"),
                 tabsetPanel(type = "tabs",
                             tabPanel("Tabell",
                                      br(),
                                      selectizeInput("select_years_table1","Velg år:",
                                                     c("2023" = 2023,
                                                       "2022" = 2022,
                                                       "2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019),
                                                     selected = c(2023, 2022, 2021, 2020, 2019),
                                                     multiple = T),
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
        tabPanel(h5("Dødelighet"),
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
        tabPanel(h5("Tap Måned"),
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
        tabPanel(h5("Dødelighet Måned"),
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
                                      selectInput("select_year_mort", "Velg år:", list(
                                        "År" = c(2023, 2022, 2021, 2020, 2019))),
                                      plotlyOutput("plot_mortality_month"),
                                      #br(),
                                      hr(),
                                      #br(),
                                      p("Produksjonsområder eller fylker med meget få lokaliteter er tatt ut av fremstillingen,
                                        for at det ikke skal være mulig å kjenne igjen enkelte lokaliteter.")))
        ),
        # tabPanel(h5("Cohort"),
        #          tabsetPanel(type = "tabs",
        #                      tabPanel("Tabell",
        #                               br(),
        #                               selectizeInput("select_years_table5","Velg år:",
        #                                              c("2023" = 2023,
        #                                                "2022" = 2022,
        #                                                "2021" = 2021,
        #                                                "2020" = 2020,
        #                                                "2019" = 2019),
        #                                              selected = c(2023, 2022, 2021, 2020, 2019),
        #                                              multiple = T),
        #                               DTOutput("table_losses"),
        #                               hr(),
        #                               p("Forklaring av tall: ‘Total’ viser det totale tapet. ‘Døde’ viser antall døde.
        #                      ‘Døde%’ viser hvor stor andel av det totale tapet som skyldes døde.
        #                      Tilsvarende gjelder for ‘Utkast%’, ‘Rømt%’ og ‘Annet%’. For forklaring av kategoriene,
        #                      se fanen ‘Om statistikken’.")),
        #                      tabPanel("Diagram", 
        #                               br(),
        #                               selectInput("select_year", "Velg år:", list(
        #                                 "År" = c(2023, 2022, 2021, 2020, 2019))),
        #                               plotlyOutput("plot_losses"))),
        #          br(),
        #          #hr(),
        #          br()
        #          #,p("test")
        # ),
        # tabPanel(h5("Calculator"),
        #          tabsetPanel(type = "tabs",
        #                      tabPanel("Tabell",
        #                               br(),
        #                               selectizeInput("select_years_table6","Velg år:",
        #                                              c("2023" = 2023,
        #                                                "2022" = 2022,
        #                                                "2021" = 2021,
        #                                                "2020" = 2020,
        #                                                "2019" = 2019),
        #                                              selected = c(2023, 2022, 2021, 2020, 2019),
        #                                              multiple = T),
        #                               DTOutput("table_losses"),
        #                               hr(),
        #                               p("Forklaring av tall: ‘Total’ viser det totale tapet. ‘Døde’ viser antall døde.
        #                      ‘Døde%’ viser hvor stor andel av det totale tapet som skyldes døde.
        #                      Tilsvarende gjelder for ‘Utkast%’, ‘Rømt%’ og ‘Annet%’. For forklaring av kategoriene,
        #                      se fanen ‘Om statistikken’.")),
        #                      tabPanel("Diagram", 
        #                               br(),
        #                               selectInput("select_year", "Velg år:", list(
        #                                 "År" = c(2023, 2022, 2021, 2020, 2019))),
        #                               plotlyOutput("plot_losses"))),
        #          br(),
        #          #hr(),
        #          br()
        #          #,p("test")
        # ),
        #fluid = T,
        tabPanel(h5("Om statistikken"),
                 
                 column(width = 9,
                        
                 h4("Datakilder"),
                 
                 p("Tap av laksefisk gjennom produksjonen i sjø fra utsett til slakting som er rapportert til Fiskeridirektoratet per januar 2024. 
                 Tapene er fordelt på dødfisk, utkast, rømming og «annet». Dødfisk omfatter dødelighet som skyldes sykdom og skader osv. 
                   Dødfisk omfatter dødelighet som skyldes sykdom og skader osv.
                   Smittsomme sykdommer er en av de viktigste biologiske og økonomiske
                   tapsfaktorene i fiskeoppdrett. Utkast er skrapfisk som sorteres ut ved slakting.
                   «Annet» kan omfatte dødelighetsepisoder som oppstår ved lusebehandling og annen håndtering,
                   men også fisk som avlives i forbindelse med sykdomsbekjempelse."),
                 
                 p("Det er disse tallene som ligger til grunn for tabellene presentert her."),
                 
                 h4("Databearbeiding"),
                 
                 p("Det finnes to ulike tabeller, der tallene for ‘Tap’ og ‘Dødelighet’ er beregnet og presentert på ulikt vis:"), 
                 
                 p("I beregningene av ‘Tap’ inngår data fra all sjøsatt laks og regnbueørret, inklusive matfisk, stamfisk,
                   fisk fra forsknings- og utviklingskonsesjoner, undervisningskonsesjoner med flere.
                   Disse tallene viser hvor mange fisk som har dødd, blitt kassert, rømt osv per år.
                   Prosentene viser til hvor stor andel den pågjeldende kategorien utgjør av det
                   totale tapet (for eksempel hvor stor andel av tapet som utgjøres av dødelighet, utkast eller rømming)."),
                 
                 p("I beregningene av ‘Dødelighet’ er prosent døde angitt for henholdsvis laks og regnbueørret.
                   I disse tallene inngår ikke tap som følge av utkast, rømming eller «annet».
                   Beregningene er foretatt ved bruk av rater, som tillater at populasjonen av
                   fisk som kan dø endrer seg måned for måned. Først blir den månedlige dødsraten
                   for hver lokalitet beregnet, og disse ratene blir deretter brukt til å beregne
                   gjennomsnittet for hver måned. Dette gjennomsnittet blir til slutt summert og
                   deretter konvertert til prosent dødfisk hvert år."),
                 
                 p("Geografisk område: Det er mulig å velge om en vil se tallene samlet for fylke,
                 produksjonssone eller på nasjonalt nivå. Det benyttes gjeldende fylkesgrenser.
                 For fylker som er slått sammen, presenteres historiske data med dagens fylkesgrenser.
                 Produksjonssonene viser til de 13 produksjonssoner som er definert i forskrift om
                 produksjonsområder (FOR-2017-01-16-61).Produksjonsområder eller fylker med meget få
                 lokaliteter er tatt ut av fremstillingen, for at det ikke skal være mulig å kjenne igjen enkelt lokaliteter."),
                 
                 h4("Referanser"),
                 
                 p("Toft, N., Agger, J. F., Houe, H., & Bruun, J. (2004). Measures of disease frequency. In H. Houe, A. K. Ersbøll, & N. Toft (Eds.), Introduction to Veterinary Epidemiology (pp. 77–93). Frederiksberg, Denmark: Biofolia."),
                 
                 p("Bang Jensen, B., Qviller, L. & Toft, N. (2020). Spatio-temporal variations in mortality during the seawater production phase of Atlantic salmon (Salmo salar) in Norway. J. Fish Dis. 43, 445–457."),
                 
                 h4("Kontakt"),
                 
                 p("Dersom du har spørsmål eller kommentarer til tabellene, vennligst ta kontakt med  ",
                   a(href = 'mailto:edgar.brun@vetinst.no', "Edgar Brun ", .noWS = "outside"),
                   "(avdelingsdirektør, fiskehelse og fiskevelferd).")
                 
                 )) 
      )
    )
  )
)


server <- function(input, output) {
  
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
  
  output$table_losses <- DT::renderDT(
    datatable(
      df_losses() %>%
        dplyr::select("year", "area", "losses", "doed", "p.doed", "ut", "p.ut", "romt", "p.romt", "ufor", "p.ufor") %>%
        dplyr::filter(!area == "Norway" & !area == "All" & year %in% input$select_years_table1),
      #filter = "top",
      rownames = F,
      colnames= c("År","Område", "Total", "Døde", "Døde%", "Utkast", "Utkast%", "Rømt", "Rømt%", "Annet", "Annet%"),
      selection = (list(mode = 'multiple',selected = "all",target ='column')),
      options = list(sDom  = '<"top">lrt<"bottom">ip',
                     scrollX = TRUE,
                     language = list(url = "//cdn.datatables.net/plug-ins/1.10.20/i18n/Norwegian-Bokmal.json"))))
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
                             language = list(url = "//cdn.datatables.net/plug-ins/1.10.20/i18n/Norwegian-Bokmal.json"))
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
                     language = list(url = "//cdn.datatables.net/plug-ins/1.10.20/i18n/Norwegian-Bokmal.json"))))
  
  
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
                dplyr:: select (year, area, median) %>% # 
                dplyr::filter(!area == "Norway" & !area == "All" & year %in% input$select_years_table4),
              #filter = "top",
              rownames = F,
              colnames= c( "År", "Område", "Dødelighet %"), # also here
              selection = (list(mode = 'multiple', selected = "all", target ='column')),
              options = list(sDom  = '<"top">lrt<"bottom">ip',
                             autoWidth = FALSE,
                             #columnDefs = list(list(width = '100px', targets = c(1, 2))),
                             scrollX = TRUE,
                             language = list(url = "//cdn.datatables.net/plug-ins/1.10.20/i18n/Norwegian-Bokmal.json"))
    ))
  
  output$plot_mortality_month <- renderPlotly(
    plot_ly(df_mort_month() %>% 
              dplyr::filter (year %in% input$select_year_mort) %>%
              spread(month_name, median) %>% 
            #  dplyr::filter (!is.na(`2023`) | !is.na(`2022`) | !is.na(`2021`) | !is.na(`2020`) | !is.na(`2019`)) %>%
              dplyr::filter (!(area == "All"| area == "Norway")) %>%
              droplevels(),
            x = ~area, y = ~ Jan, name = "Jan", type = 'scatter',
            mode = "markers", marker = list(color = "#253494"),
            hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                              "Prosentene: ", "Jan","<br>")) %>%
      add_trace(x = ~area, y = ~ Feb, name = "Feb",type = 'scatter',
                mode = "markers", marker = list(color = "#2c7fb8"),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Feb","<br>")) %>%
      add_trace(x = ~area, y = ~ Mar, name = "Mar",type = 'scatter',
                mode = "markers", marker = list(color = "#41b6c4"),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Mar","<br>")) %>%
      add_trace(x = ~area, y = ~ Apr, name = "Apr",type = 'scatter',
                mode = "markers", marker = list(color = "#a1dab4"),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Apr","<br>")) %>%
      add_trace(x = ~area, y = ~ May, name = "May",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "May","<br>")) %>%
      add_trace(x = ~area, y = ~ Jun, name = "Jun",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Jun","<br>")) %>%
      add_trace(x = ~area, y = ~ Jul, name = "Jul",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", Jul,"<br>")) %>%
      add_trace(x = ~area, y = ~ Aug, name = "Aug",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Aug","<br>")) %>%
      add_trace(x = ~area, y = ~ Sep, name = "Sep",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Sep","<br>")) %>%
      add_trace(x = ~area, y = ~ Oct, name = "Oct",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Oct","<br>")) %>%
      add_trace(x = ~area, y = ~ Nov, name = "Nov",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", Nov,"<br>")) %>%
      add_trace(x = ~area, y = ~ Dec, name = "Dec",type = 'scatter',
                mode = "markers", marker = list(color = '#feb24c'),
                hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                  "Prosentene: ", "Dec","<br>")) %>%
      
      layout(title = "", 
             annotations=list(yref='paper',xref="paper",y=1.09,x=.2, text="Velg år:",showarrow=F, font=list(size=14,face="bold")),
             legend = list(orientation = "h", x= .25, y = 1.1),
             xaxis = list(title = "Område"),
             yaxis = list (title = "Dødelighet (%)", categoryarray = ~ area), 
             margin = list(l = 100)))
  
  
  
   
   
}

shinyApp(ui, server)

#runApp()





