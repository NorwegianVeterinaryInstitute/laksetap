#' create_monthly_mortality
#' @title Create Monthly Mortality Data Model with Dummy Data
#' Function to create monthly mortality data model
#' and fill in dummy data used for testing and development
#'
#' @param geo_group One of 'area', 'county', 'country'.
#' Determines the geographic level of the data.
#'
#' @return A data frame containing fish mortality data across months and regions.
#' The `region` column reflects the value of the selected `geo_group`:
#' - For 'area': region values are area_1 to area_5
#' - For 'county': region values are county_1 to county_3
#' - For 'country': region value is "Country"

create_monthly_mortality <- function(geo_group) {
  
  # species - string

  species <- c('salmon', 'rainbowtrout')

  # date - Date

  date <- seq.Date(
    from = as.Date("2020-01-01"),
    to = as.Date("2024-12-01"),
    by = "month"
  )

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
    date,
    geo_group,
    region,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )
  
  dat <- dat[sample(nrow(dat)), ]
  
  n <- nrow(dat)
  dat$median_mort <- round(runif(n, min = 0.5, max = 1.5), 2)
  dat$q1_mort <- round(runif(n, min = 0.1, max = 0.49), 2)
  dat$q3_mort <- round(runif(n, min = 1.51, max = 2.5), 2)

  dat
}

dat_area <- create_monthly_mortality("area")
dat_county <- create_monthly_mortality("county")
dat_country <- create_monthly_mortality("country")

#' @format A data frame with 1,080 rows and 7 variables:
#' \describe{
#'   \item{species}{Fish species, either salmon or rainbow trout}
#'   \item{date}{Reporting month, ranging from 2020-01-01 to 2024-12-01}
#'   \item{geo_group}{Geographic grouping level: area, county, or country}
#'   \item{region}{The specific region name or code, depending on geo_group}
#'   \item{median_mort}{Median mortality measurement, randomly generated between 0.5 and 1.5}
#'   \item{q1_mort}{First quartile mortality measurement, randomly generated between 0.1 and 0.49}
#'   \item{q3_mort}{Third quartile mortality measurement, randomly generated between 1.51 mortality and 2.5}
#' }

monthly_mortality_dummy_data <- dplyr::bind_rows(
  dat_area,
  dat_county,
  dat_country
)

names(monthly_mortality_dummy_data) <- c(
  "species",
  "date",
  "geo_group",
  "region",
  "median_mort",
  "q1_mort",
  "q3_mort"
)
