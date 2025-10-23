#' create_yearly_mortality
#' @title Create Yearly Mortality Data Model with Dummy Data
#' Function to create the yearly mortality data model
#' and fill in dummy data used for testing and development
#'
#' @param geo_group One of 'area', 'county', 'country'.
#' Determines the geographic level of the data.
#'
#' @return A data frame containing fish mortality data across years and regions.
#' The `region` column reflects the value of the selected `geo_group`:
#' - For 'area': region values are area_1 to area_5
#' - For 'county': region values are county_1 to county_3
#' - For 'country': region value is "Country"
create_yearly_mortality <- function(geo_group) {
  # species - string

  species <- c('salmon', 'rainbowtrout')

  # year - integer

  year <- c(2020, 2021, 2022, 2023, 2024)

  if (geo_group == "area") {
    # area - string
    region <- c("area_1", "area_2", "area_3", "area_4", "area_5")
  } else if (geo_group == 'county') {
    # county - string
    region <- c('county_1', "county_2", "county_3")
  } else {
    # country - string
    region <- c("Country")
  }

  # mortality value - numeric between 0 and 1

  mort <- round(runif(10, min = 0.1, max = 0.4), 2)

  dat <- expand.grid(
    species,
    year,
    geo_group,
    region,
    mort,
    KEEP.OUT.ATTRS = FALSE
  )

  dat
}

dat_area <- create_yearly_mortality("area")
dat_county <- create_yearly_mortality("county")
dat_country <- create_yearly_mortality("country")

#' @format A data frame with 90 rows and 5 variables:
#' \describe{
#'   \item{species}{Fish species, either salmon or rainbow trout}
#'   \item{year}{Year of data collection, ranging from 2020 to 2024}
#'   \item{geo_group}{Geographic grouping level: area, county, or country}
#'   \item{region}{The specific region name or code, depending on geo_group}
#'   \item{mort}{Mortality measurement, randomly generated between 0.1 and 0.4}
#' }
yearly_mortality_dummy_data <- dplyr::bind_rows(
  dat_area,
  dat_county,
  dat_country
)

names(yearly_mortality_dummy_data) <- c(
  "species",
  "year",
  "geo_group",
  "region",
  "mort"
)
