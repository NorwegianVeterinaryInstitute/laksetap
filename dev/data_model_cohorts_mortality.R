#' create_cohorts_mortality
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

create_cohorts_mortality <- function(geo_group) {
  # species - string

  species <- c('salmon', 'rainbowtrout')

  # year - integer

  year <- c(2020, 2021, 2022, 2023, 2024)

  # geo_group - string

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

  dat <- expand.grid(
    species,
    year,
    geo_group,
    region,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )

  dat <- dat[sample(nrow(dat)), ]

  # mortality value - numeric between 10 and 40

  n <- nrow(dat)
  dat$median <- round(runif(n, min = 10, max = 40), 2)
  dat$q1 <- round(runif(n, min = 1, max = dat$median), 2)
  dat$q3 <- round(runif(n, min = dat$median, max = 80), 2)

  dat
}

dat_area <- create_cohorts_mortality("area")
dat_county <- create_cohorts_mortality("county")
dat_country <- create_cohorts_mortality("country")

#' @format A data frame with 90 rows and 5 variables:
#' \describe{
#'   \item{species}{Fish species, either salmon or rainbow trout}
#'   \item{year}{Year of harvesting, ranging from 2020 to 2024}
#'   \item{geo_group}{Geographic grouping level: area, county, or country}
#'   \item{region}{The specific region name or code, depending on geo_group}
#'   \item{median}{Median mortality measurements, randomly generated between 10 and 40}
#'   \item{q1}{First mortality measurement, randomly generated between 1 and 39}
#'   \item{q3}{Third quartile measurement, randomly generated between 41 and 80}
#' }

cohort_mortality_dummy_data <- dplyr::bind_rows(
  dat_area,
  dat_county,
  dat_country
)

names(cohort_mortality_dummy_data) <- c(
  "species",
  "year",
  "geo_group",
  "region",
  "median",
  "q1",
  "q3"
)

cohort_mortality_dummy_data <- cohort_mortality_dummy_data |>
  dplyr::mutate(region = factor(region))

saveRDS(
  cohort_mortality_dummy_data,
  file = "inst/extdata/cohort_mortality_dummy_data.Rds"
)

write.csv(
  cohort_mortality_dummy_data,
  file = "inst/extdata/cohort_mortality_dummy_data.csv",
  row.names = FALSE
)
