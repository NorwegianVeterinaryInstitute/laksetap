#' data_model_monthly_losses
#'
#' @param geo_group One of 'area', 'county', 'country'. Determines the geographic level of the data.
#'
#' @return A data frame containing fish mortality data across months and regions.
#' The `region` column reflects the value of the selected `geo_group`:
#' - For 'area': region values are area_1 to area_5
#' - For 'county': region values are county_1 to county_3
#' - For 'country': region value is "Country"

create_monthly_losses <- function(geo_group) {
  
  # species - string
  
  species <- c('salmon', 'rainbowtrout')
  
  # year_month - string
  
  dates <- seq.Date(from = as.Date("2020-01-01"), to = as.Date("2024-12-01"), by = "month")
  year_month <- format(dates, "%Y-%m")
  
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
    year_month,
    geo_group,
    region,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )
  
  dat <- dat[sample(nrow(dat)), ]
  
  # mortality value - numeric between 10 and 40
  
  n <- nrow(dat)
  dat$losses <- round(runif(n, min = 500000, max = 10000000))
  dat$dead <- round(runif(n, min = 500000, max = 8000000))
  dat$discarded <- round(runif(n, min = 100000, max = 5000000))
  dat$escaped <- round(runif(n, min = 0, max = 50000))
  dat$other <- round(runif(n, min = 50000, max = 5000000))
  
  dat
  
}

dat_area <- create_monthly_losses("area")
dat_county <- create_monthly_losses("county")
dat_country <- create_monthly_losses("country")

#' @format A data frame with 1,080 rows and 9 variables:
#' \describe{
#'   \item{species}{Fish species, either salmon or rainbow trout}
#'   \item{year}{Year of data collection, ranging from 2020 to 2024}
#'   \item{geo_group}{Geographic grouping level: area, county, or country}
#'   \item{region}{The specific region name or code, depending on geo_group}
#'   \item{losses}{The number of lost fish — categorized as dead, discarded, escaped, or other — was randomly generated to fall between 500,000 and 10,000,000}
#'   \item{dead}{The number of physically removed fish from the cage and recorded as dead due to various causes was randomly generated randomly generated to fall between 500,000 and 8,000,000}
#'   \item{discarded}{The number of downgraded fish sorted out at the slaughterhouse and deemed unfit for human consumption — for example due to sexual maturation, blemishes, or deformities — was randomly generated randomly generated to fall between 100,000 and 5,000,000}
#'   \item{escaped}{The number of escapted fish due to accidents was randomly generated to fall between 0 and 50,000}
#'   \item{other}{The number of lost fish due to due to reasons not covered by the other three categories was randomly generated to fall between 50,000 and 5,000,000}
#' }

monthly_losses_dummy_data <- dplyr::bind_rows(
  dat_area,
  dat_county,
  dat_country
)

names(monthly_losses_dummy_data) <- c(
  "species",
  "year_month",
  "geo_group",
  "region",
  "losses",
  "dead",
  "discarded",
  "escaped",
  "other"
)

