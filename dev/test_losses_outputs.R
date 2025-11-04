# Here we test the created dummy datasets with the functions
# from the fct_* files to make sure they work as expected.
# In order for this code to run, first run the fct functions 
# to have them in the environment.

library(ggplot2)
library(plotly)
library(DT)

dat_m <- readRDS("inst/data/monthly_losses_dummy_data.Rds")
dat_y <- readRDS("inst/data/yearly_losses_dummy_data.Rds")

#### Plot for monthly losses

input_species = "salmon"
input_geo_group = "area"
input_year = 2022
input_month = c("01")

my_palette <- c("#FF5447", "#59CD8B", "#FFC6C2", "#1C4FB9")

to_plot <- dat_m |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% input_geo_group) |> 
  losses_data_pivot_longer() |> 
  losses_data_prep_plot(input_year, input_month, resolution = 'm')  

losses_plot(to_plot) |> 
  style_plotly()

#### Table for monthly losses

dat_m |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% input_geo_group) |> 
  dplyr::filter(year %in% input_year) |> 
  dplyr::filter(month_name %in% input_month) |> 
  losses_data_prep_table(resolution = 'm') |> 
  losses_table(resolution = 'm')

#### Table for monthly losses

dat_y |> 
  dplyr::filter(species == input_species) |> 
  dplyr::filter(geo_group %in% input_geo_group) |> 
  dplyr::filter(year %in% input_year) |> 
  losses_data_prep_table(resolution = 'y') |> 
  losses_table(resolution = 'y')
