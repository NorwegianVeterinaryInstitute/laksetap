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

# Static things

#### Colors ####
my_palette <- c("#FF5447", "#59CD8B", "#FFC6C2", "#1C4FB9")
my_palette_long <- c(
  "#FF5447", "#59CD8B", "#95D9F3", "#1C4FB9", "#FFC6C2",
  "#BCEED1", "#D7F4FF", "#C7D9FF", "#F7FDFF", "#091A3E",
  "#CC0E00", "#288550", "#1FC0FF", "#6892E8", "#BD990A",
  "#969FB1", "#D3DFF8", "#C0ECD3", "#0076A3", "#F5D34A"
)

#### Data ####

laksetap_board <- board_connect()

losses <- pin_read(laksetap_board, "vi2451/losses_and_mortality_yearly_data")
losses_monthly_data <- pin_read(laksetap_board, "vi2451/losses_monthly_data")
mortality_rates_monthly_data <- pin_read(laksetap_board, "vi2451/mortality_rates_monthly_data")
mortality_cohorts_data <- pin_read(laksetap_board, "vi2451/mortality_cohorts_data")

#### Functions ####
head_block <- function() {
  shiny::tags$head(
    tags$html(lang = "nb-NO"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$title("Laksetap - Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen"),
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
      title = "Laksetap: Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen",
      description = "Utforsk interaktiv statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen i Norge",
      url = "https://apps.vetinst.no/laksetap",
      image = "https://www.vetinst.no/_/image/5c4e853a-130b-4e7f-92a3-8ca38bec0b56:2dcf9428a329fc0044b412c55b8c9e471f742d65/block-1200-630/Logo-vetinst-open-graph-no-svg-1200x630.png.jpg",
      image_alt = "Veterinærinstituttets logo"
    )
}

select_year <- function(id, multiple = F, resolution = "m"){
  
  if (multiple) {
    text = "Velg flere år:"
  } else {
    text = "Velg år:"
  }
  
  if (resolution == "m") {
    selection <- c(
      "2025" = 2025,
      "2024" = 2024,
      "2023" = 2023,
      "2022" = 2022,
      "2021" = 2021,
      "2020" = 2020
    )
    
    selected <- c(2025)
  }
  
  if (resolution == "y") {
    selection <- c(
      "2024" = 2024,
      "2023" = 2023,
      "2022" = 2022,
      "2021" = 2021,
      "2020" = 2020
    )
    
    selected <- c(2024)
  }

  selectInput(
    id,
    text,
    selection,
    selected = selected, 
    multiple = multiple
  ) 
}


select_months <- function(id, multiple = T) {
  selectInput(
  id,
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
  selected = c("jan"),
  multiple = multiple
  )
}