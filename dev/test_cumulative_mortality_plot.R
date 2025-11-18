# Here we test the created dummy datasets with the functions
# from the fct_* files to make sure they work as expected.
# In order for this code to run, first run the fct functions
# to have them in the environment.

library(ggplot2)
library(dplyr)
library(plotly)
library(DT)

### Template cohort mortality

dat <- readRDS("inst/extdata/cumulative_mortality_dummy_data.Rds")

#### Plot for cohort mortality

input_species = "salmon"
input_geo_group = c("area")
input_year = 2021
input_region = "area_1"

Sys.setlocale("LC_TIME", "no_NO.UTF-8")
dat <- dat |>
  dplyr::mutate(year = format(date, "%Y")) |>
  dplyr::mutate(month_name = format(date, "%b"))

to_plot <- dat |>
  dplyr::filter(species == input_species) |>
  dplyr::filter(year == input_year) |>
  dplyr::filter(geo_group %in% input_geo_group) |>
  dplyr::filter(region %in% input_region)

plot_cumulative_mortality <- function(dat) {
  dat |>
    ggplot() +
    aes(x = date, y =  mean) +
    geom_line(size = 2) +
    geom_ribbon(
      aes(ymin = lci, ymax = uci, fill = year),
      alpha = 0.4,
      color = NA
    )
}

plot_cumulative_mortality(to_plot)

#### Table for cohort mortality

dat |>
  dplyr::filter(species == input_species) |>
  dplyr::filter(year %in% input_year) |>
  dplyr::filter(geo_group %in% input_geo_group) |>
  dplyr::select(year, month_name, region, mean) |> 
  DT::datatable()
  
  
  #cumulative_mortality_table()
