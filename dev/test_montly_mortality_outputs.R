# Here we test the created dummy datasets with the functions
# from the fct_* files to make sure they work as expected.
# In order for this code to run, first run the fct functions 
# to have them in the environment.

library(ggplot2)
library(plotly)
library(DT)

dat <- readRDS("inst/data/monthly_mortality_dummy_data.rds")

#### Plot for monthly mortality

# data is first filtered on species and geo_group
# but we always keep the whole country, so that is hard-coded
# then it is filtered on years and specific areas 
# to make the plot

input_species = "salmon"
input_geo_group = "area"
input_year = c(2021, 2022)
# in the shiny inputs the country is always pre-selected.
input_area = c("Country", "area_1", "area_2")

my_palette_named <- c(
  "Country" = "#FF5447",
  "area_1" = "#59CD8B",
  "area_2" = "#95D9F3")

to_plot <- dat |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% c(input_geo_group, "country")) |> 
  dplyr::filter(year %in% input_year) |> 
  dplyr::filter(region %in% input_area) 

monthly_mortality_plot(to_plot) |> 
  style_plotly()


#### Table for monthly mortality

dat |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% input_geo_group) |> 
  dplyr::filter(year %in% input_year) |> 
  dplyr::select(year, month_name, region, q1, median, q3) |>
  monthly_mortality_table()
