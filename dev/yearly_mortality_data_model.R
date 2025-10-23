#' yearly_mortality_data_model
#'
#' @param geo_group one of 'area', 'county', 'country'
#'
#' @returns a data frame per geo group
#' geo groups are the three levels at which
#' data is created, area, county, and country
#'
create_yearly_mortality <- function(geo_group){
  
  # species - string
  
  species <- c('salmon', 'rainbowtrout')
  
  # year - integer
  
  year <- c(2020, 2021, 2022, 2023, 2024)
  
  
  if (geo_group == "area"){
    # area - string
    area <- c("1", "2", "3", "4", "5")
  }
  else if (geo_group == 'county'){
    # county - string
    area <- c('county_1', "county_2", "county_3")
  } else {
    # country - string
    area <- c("Country")
  }
  
  # mortality value - numeric between 0 and 1
  
  mort <- round(runif(10, min = 0.1, max = 0.4), 2)
  
  
  dat <- expand.grid(species,
                     year,
                     geo_group,
                     area,
                     mort)
  
  dat
  
}

dat_1 <- create_yearly_mortality(geo_group = "area")
dat_2 <- create_yearly_mortality(geo_group = "county")
dat_3 <- create_yearly_mortality(geo_group = "country")


#' @format A data frame with 900 rows and 5 variables:
#' \describe{
#'   \item{species}{species is fish species, either salmon or rainbotrout}
#'   \item{year}{year demo data has range from 2020 to 2024}
#'   \item{geo_group}{geo_group are the three levels at which
#'    data is created, area, county, and country}
#'   \item{area}{area is the value of each geo_group, an area number,
#'   a county name, and a country name}
#'   \item{mort}{mort a measurement of fish mortality generated as a random
#'   distribution between values 0.1 and 0.4}
#' }
yearly_mortality_dummy_data <- dplyr::bind_rows(dat_1, dat_2, dat_3)

names(yearly_mortality_dummy_data) <- c("species", "year", "geo_group",
                                        "area", "mort")
