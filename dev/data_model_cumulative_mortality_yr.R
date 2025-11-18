#' create_cumulative_mortality_yr
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

create_cumulative_mortality_yr <- function(geo_group) {
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
    species = species,
    date = date,
    geo_group = geo_group,
    region = region,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )

  dat$year <- format(dat$date, "%Y")

  dat <- dat[order(dat$species, dat$region, dat$date), ]

  dat$mean <- NA
  dat$lci <- NA
  dat$uci <- NA

  # Generate cumulative mortality per species-region
  for (sp in species) {
    for (reg in region) {
      for (yr in unique(dat$year)) {
        idx <- which(dat$species == sp & dat$region == reg & dat$year == yr)
        monthly_values <- runif(length(idx), min = 0.5, max = 3) # random monthly mortality increments
        cumulative_values <- cumsum(monthly_values) # cumulative sum
        cumulative_values <- pmin(cumulative_values, 100) # cap at 100

        # assign mean
        dat$mean[idx] <- round(cumulative_values, 2)

        # Confidence intervals: ensure LCI < mean < UCI
        dat$lci[idx] <- round(
          pmax(cumulative_values - runif(length(idx), min = 1, max = 5), 0),
          2
        )
        dat$uci[idx] <- round(
          pmin(cumulative_values + runif(length(idx), min = 1, max = 5), 100),
          2
        )
      }
    }
  }

  return(dat)
}

dat_area <- create_cumulative_mortality_yr("area")
dat_county <- create_cumulative_mortality_yr("county")
dat_country <- create_cumulative_mortality_yr("country")

#' @format A data frame with rows equal to (species × regions × months) and 8 variables:
#' \describe{
#'   \item{species}{Fish species, either salmon or rainbow trout}
#'   \item{date}{Reporting month, ranging from 2020-01-01 to 2025-12-01}
#'   \item{geo_group}{Geographic grouping level: area, county, or country}
#'   \item{region}{The specific region name or code, depending on geo_group}
#'   \item{year}{Year extracted from the date (2021–2025), used for resetting cumulative values.}#'
#'   \item{mean}{Cumulative mortality percentage for the given month, capped between 0 and 100. Resets each year.}
#'   \item{lci}{Lower confidence interval for mortality, always less than mean and ≥ 0.}
#'   \item{uci}{Upper confidence interval for mortality, always greater than mean and ≤ 100.}
#' }

cumulative_mortality_yr_dummy_data <- dplyr::bind_rows(
  dat_area,
  dat_county,
  dat_country
) %>%
  dplyr::select(-year)

names(cumulative_mortality_yr_dummy_data) <- c(
  "species",
  "date",
  "geo_group",
  "region",
  "mean",
  "lci",
  "uci"
)

saveRDS(
  cumulative_mortality_yr_dummy_data,
  file = "inst/extdata/cumulative_mortality_dummy_data.Rds"
)
