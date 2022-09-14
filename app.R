### Layout for app 
library(here)
library(shiny)
library(dplyr)
library(DT)
library(plotly)
library(tidyr)

#import data
#original = read.csv("Data/losses_2022-08-09.csv", sep = ";", dec = ",", encoding = "UTF-8")
original = read.csv(here("formatted_data", "losses_2022-08-09.csv"), sep = ";", dec = ",", encoding = "UTF-8")

new_rows = original %>% 
  filter(area == "Norway") %>% 
  mutate(viz = "all", 
         area = "Norge")
losses = dplyr::bind_rows(original, new_rows)

losses$area <- factor (
  losses$area,
  levels = c("All","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13",
             "Agder","Møre og Romsdal", "Nordland", "Rogaland", "Troms og Finnmark",
             "Trøndelag", "Vestland", "Viken", "Norge", "Norway"))

ui <- fluidPage(
  titlePanel( 
    windowTitle = "Laksefiskdødlighet",# creating NVI logo in the top of the app and the title following it
    fluidRow(
      column(4, img(src="vetinstlogo_rgb_sortekst_stor.png", height='60',width='279')),
      column(8,h3("Statistikk over tap og dødelighet av laks og regnbueørret", style = "color:#1b314f; font-style:bold")))
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
                                                     c("2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019,
                                                       "2018" = 2018,
                                                       "2017" = 2017),
                                                     selected = c(2021, 2020, 2019, 2018, 2017),
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
                                        "År" = c(2021, 2020, 2019, 2018, 2017))),
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
                                                     c("2021" = 2021,
                                                       "2020" = 2020,
                                                       "2019" = 2019,
                                                       "2018" = 2018,
                                                       "2017" = 2017),
                                                     selected = c(2021, 2020, 2019, 2018, 2017),
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
        fluid = T,
        tabPanel(h5("Om statistikken"),
                 
                 column(width = 9,
                        
                 h4("Datakilder"),
                 
                 p("Tap av laksefisk gjennom produksjonen i sjø fra utsett til slakting rapporteres inn 
                   til Fiskeridirektoratet, fordelt på dødfisk, utkast, rømming og «annet».
                   Dødfisk omfatter dødelighet som skyldes sykdom og skader mv.
                   Smittsomme sykdommer er en av de viktigste biologiske og økonomiske
                   tapsfaktorene i fiskeoppdrett. Utkast er skrapfisk som sorteres ut ved slakting.
                   «Annet» kan omfatte dødelighetsepisoder som oppstår ved lusebehandling og annen håndtering,
                   men også fisk som avlives i forbindelse med sykdomsbekjempelse."),
                 
                 p("Det er disse tallene som ligger til grunn for tabellene presentert her."),
                 
                 h4("Databearbeiding"),
                 
                 p("Det finnes to ulike tabeller, der tallene for ‘Tap’ og ‘Dødelighet’ er beregnet og presenteres på ulik vis:"), 
                 
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
                 
                 p("Geografisk område: Det er mulig å velge om en vil se tallene samlet på fylke,
                 produksjonssone eller nasjonalt nivå. Det benyttes gjeldende fylkesgrenser.
                 For fylker som er slått sammen, presenteres historiske data med dagens fylkesgrenser.
                 Produksjonssoner viser til de 13 produksjonssoner som er definert i forskrift om
                 produksjonsområder (FOR-2017-01-16-61).Produksjonsområder eller fylker med meget få
                 lokaliteter er tatt ut av fremstillingen, for at det ikke skal være mulig å kjenne igjen enkelte lokaliteter."),
                 
                 h4("Kontakt"),
                 
                 p("Dersom du har spørsmål eller kommentarer til tabellene, vennligst ta kontakt med  ",
                   a(href = 'mailto:victor.oliveira@vetinst.no', "Victor H.S. Oliveira ", .noWS = "outside"),
                   "(teknisk ansvarlig) eller ", a(href = "mailto:Hege.Lokslett@vetinst.no", "Hege Løkslett ", .noWS = "outside"),
                   "(faglig ansvarlig).")
                 
                 )) 
      )
    )
  )
)


server <- function(input, output) {
  df_losses = eventReactive(c(input$species, input$geo_group), {losses %>% 
      dplyr::filter(species == input$species & viz == input$geo_group)})
  #any changes you make to df_losses will affect both the table and the plot, if you want to use df_losses write df_losses()
  
  output$table_losses <- DT::renderDT(
    datatable(
      df_losses () %>%
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
  
  myPallete <- c('#fb8072', '#8dd3c7','#ffffb3','#bebada')
  output$plot_losses <- renderPlotly(
    plot_ly(df_losses () %>% 
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
                dplyr::filter (!is.na(`2021`) | !is.na(`2020`) | !is.na(`2019`) | !is.na(`2018`) | !is.na(`2017`)) %>% 
                dplyr::filter (!(area == "All"| area == "Norway")) %>%
                droplevels(),
              x = ~area, y = ~`2021`, name = "2021", type = 'scatter',
              mode = "markers", marker = list(color = "#253494"),
              hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                "Prosentene: ", `2021`,"<br>")) %>%
        add_trace(x = ~area, y = ~`2020`, name = "2020",type = 'scatter',
                  mode = "markers", marker = list(color = "#2c7fb8"),
                  hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                    "Prosentene: ", `2020`,"<br>")) %>%
        add_trace(x = ~area, y = ~`2019`, name = "2019",type = 'scatter',
                  mode = "markers", marker = list(color = "#41b6c4"),
                  hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                    "Prosentene: ", `2019`,"<br>")) %>%
        add_trace(x = ~area, y = ~`2018`, name = "2018",type = 'scatter',
                  mode = "markers", marker = list(color = "#a1dab4"),
                  hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                    "Prosentene: ", `2018`,"<br>")) %>%
        add_trace(x = ~area, y = ~`2017`, name = "2017",type = 'scatter',
                  mode = "markers", marker = list(color = '#feb24c'),
                  hoverinfo = "text", text = ~paste("Område: ", area, "<br>",
                                                    "Prosentene: ", `2017`,"<br>")) %>%
        layout(title = "", 
               annotations=list(yref='paper',xref="paper",y=1.09,x=.2, text="Velg år:",showarrow=F, font=list(size=14,face="bold")),
               legend = list(orientation = "h", x= .25, y = 1.1),
               xaxis = list(title = "Område"),
               yaxis = list (title = "Dødelighet (%)", categoryarray = ~ area), 
               margin = list(l = 100)))
   
}

shinyApp(ui, server)

#runApp()





