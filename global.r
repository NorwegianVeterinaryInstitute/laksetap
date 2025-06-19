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
