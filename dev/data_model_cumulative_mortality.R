#' create_yearly_mortality
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

create_cumulative_mortality <- function(geo_group) {
  # species - string

  species <- c('salmon', 'rainbowtrout')

  # date

  date <- seq.Date(
    from = as.Date("2021-01-01"),
    to = as.Date("2025-12-01"),
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

  # mortality value - numeric between 10 and 40

  n <- nrow(dat)
  dat$mean <- cumsum(seq(from = 0.1, by = 0.15, length.out = n))
  dat$lci <- dat$mean - round(runif(n, min = 0, max = dat$mean), 2)
  dat$uci <- dat$mean + round(runif(n, min =  dat$mean, max = dat$mean*1.5), 2)
  dat
}

dat_area <- create_cumulative_mortality("area")
dat_county <- create_cumulative_mortality("county")
dat_country <- create_cumulative_mortality("country")

#' @format A data frame with 90 rows and 5 variables:
#' \describe{
#'   \item{species}{Fish species, either salmon or rainbow trout}
#'   \item{date}{Reporting month, ranging from 2020-01-01 to 2024-12-01}
#'   \item{geo_group}{Geographic grouping level: area, county, or country}
#'   \item{region}{The specific region name or code, depending on geo_group}
#'   \item{mean}{Mortality mean measurement, randomly generated between 0.1 and 0.4}
#'   \item{lci}{Lower confidence interval, randomly generated between 0.1 and 0.49}
#'   \item{uci}{Upper confidence interval, randomly generated between 0.51 and 1.5}
#' }

cumulative_mortality_dummy_data <- dplyr::bind_rows(
  dat_area,
  dat_county,
  dat_country
)

names(cumulative_mortality_dummy_data) <- c(
  "species",
  "date",
  "geo_group",
  "region",
  "mean",
  "lci",
  "uci"
)

saveRDS(
  cumulative_mortality_dummy_data,
  file = "inst/extdata/cumulative_mortality_dummy_data.Rds"
)
