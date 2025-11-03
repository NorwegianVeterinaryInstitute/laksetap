# Here we test the created dummy datasets with the functions
# from the fct_* files to make sure they work as expected.
# In order for this code to run, first run the fct functions 
# to have them in the environment.

library(ggplot2)
library(plotly)
library(DT)



dat_m <- readRDS("inst/data/monthly_losses_dummy_data.Rds")
dat_y <- readRDS("inst/data/yearly_losses_dummy_data.Rds")

#### Plot for montly mortality

# data is first filtered on species and geo_group
# but we always keep the whole country, so that is hard-codded
# then it is filtered on years and specific areas 
# to make the plot

input_species = "salmon"
input_geo_group = "area"
input_year = 2022
input_month = c("01")

my_palette <- c("#FF5447", "#59CD8B", "#FFC6C2", "#1C4FB9")

to_plot <- dat_m |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% input_geo_group) |> 
  dplyr::filter(year %in% input_year) |> 
  dplyr::filter(month %in% input_month) 



#### Table for monthly mortality

dat |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% input_geo_group) |> 
  dplyr::filter(year %in% input_year) |> 
  dplyr::select(year, month_name, region, q1, median, q3) |>
  montly_mortality_table()
