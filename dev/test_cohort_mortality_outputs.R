# Here we test the created dummy datasets with the functions
# from the fct_* files to make sure they work as expected.
# In order for this code to run, first run the fct functions
# to have them in the environment.

library(ggplot2)
library(dplyr)
library(plotly)
library(DT)

### Template cohort mortality

dat <- readRDS("inst/extdata/cohort_mortality_dummy_data.Rds")

#### Plot for cohort mortality

input_species <- "salmon"
input_geo_group <- c("area")
input_year <- 2022


to_plot <- dat |>
  dplyr::filter(species == input_species) |>
  dplyr::filter(year == input_year) |>
  dplyr::filter(geo_group %in% input_geo_group) |>
  dplyr::filter(region %in% input_region)

plot_cohorts_output(to_plot, input_year)

#### Table for cohort mortality

dat |>
  dplyr::filter(species == input_species) |>
  dplyr::filter(year %in% input_year) |>
  dplyr::filter(geo_group %in% input_geo_group) |>
  dplyr::select(year, region, q1, median, q3) |>
  cohorts_mortality_table()
