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
input_geo_group = "area"
input_year = 2021
# in the shiny inputs the country is always pre-selected.
input_area = c("Country", "area_1", "area_2")

vi_palette_named <- c(
  "Country" = "#FF5447",
  "area_1" = "#59CD8B",
  "area_2" = "#95D9F3"
)

Sys.setlocale("LC_TIME", "no_NO.UTF-8")
dat <- dat |>
  dplyr::mutate(year = format(date, "%Y")) |>
  dplyr::mutate(month_name = format(date, "%b"))

to_plot <- dat |>
  dplyr::filter(species == input_species) |>
  dplyr::filter(geo_group %in% c(input_geo_group, "country")) |>
  dplyr::filter(year %in% input_year) |>
  dplyr::filter(region %in% input_area)

cumulative_mortality_plot(to_plot) |> 
  style_plotly()

#### Table for cohort mortality

dat |>
  dplyr::filter(species == input_species) |>
  dplyr::filter(year %in% input_year) |>
  dplyr::filter(geo_group %in% input_geo_group) |>
  dplyr::select(year, month_name, region, mean) |> 
  cumulative_mortality_table()
