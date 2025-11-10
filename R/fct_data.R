#' load_data
#' @description Function to load data for the app depending on the
#' environment prod or dev as set up by golem.app.prod option
#' 
#' @export
#' 
#' @noRd
load_data <- function() {
  env <- getOption("golem.app.prod")

  if (env == TRUE) {
    laksetap_board <- pins::board_connect()

    losses <- pins::pin_read(
      laksetap_board,
      "vi2451/losses_and_mortality_yearly_data"
    )
    
    losses_monthly_data <- pins::pin_read(
      laksetap_board,
      "vi2451/losses_monthly_data"
    )
    
    mortality_rates_monthly_data <- pins::pin_read(
      laksetap_board,
      "vi2451/mortality_rates_monthly_data"
    )
    
    mortality_cohorts_data <- pins::pin_read(
      laksetap_board,
      "vi2451/mortality_cohorts_data"
    )

    mortality_cohorts_data_area <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'area'
    )
    
    mortality_cohorts_data_county <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'county'
    )

    mortality_cohorts_data_all <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'country'
    )
  } else {

    yearly_losses_data <- readRDS(
      app_sys(
        "data", "yearly_losses_dummy_data.Rds")
      )
    
    monthly_losses_data <- readRDS(
      app_sys(
        "data", "monthly_losses_dummy_data.Rds")
      )
    
    monthly_losses_data_lc <-monthly_mortality_losses_columns(monthly_losses_data)
    
    
    yearly_losses_data_long <- losses_data_pivot_longer(yearly_losses_data)
    
    monthly_losses_data_long <- losses_data_pivot_longer(monthly_losses_data_lc)
    
    yearly_mortality_data <- readRDS(
      app_sys(
        "data", "yearly_mortality_dummy_data.Rds")
      )
    
    monthly_mortality_data <- readRDS(
      app_sys(
        "data", "monthly_mortality_dummy_data.Rds")
    ) 
    
    monthly_mortality_data_lc <- monthly_mortality_locale_columns(monthly_mortality_data)
    
    cohort_mortality_data <- readRDS(
      app_sys(
        "data", "cohort_mortality_dummy_data.Rds")
    )

    cohort_mortality_data_area <- prep_cohorts_data(
      cohort_mortality_data,
      geo_group = 'area'
    )
    
    cohort_mortality_data_county <- prep_cohorts_data(
      cohort_mortality_data,
      geo_group = 'county'
    )

    cohort_mortality_data_country <- prep_cohorts_data(
      cohort_mortality_data,
      geo_group = 'country'
    )
  }

  options(yearly_losses_data = yearly_losses_data)
  options(monthly_losses_data = monthly_losses_data)
  options(monthly_losses_data_lc = monthly_losses_data_lc)
  options(yearly_losses_data_long = yearly_losses_data_long)
  options(monthly_losses_data_long = monthly_losses_data_long)
  options(yearly_mortality_data = yearly_mortality_data)
  options(monthly_mortality_data = monthly_mortality_data)
  options(monthly_mortality_data_lc = monthly_mortality_data_lc)
  options(cohort_mortality_data = cohort_mortality_data)
  options(cohort_mortality_data_area = cohort_mortality_data_area)
  options(cohort_mortality_data_county = cohort_mortality_data_county)
  options(cohort_mortality_data_country = cohort_mortality_data_country)
}

#' prep_cohorts_data
#' @description Function to prepare the cohorts dataset for plotting
#'
#' @param dat 
#' @param geo_group 
#'
#' @returns a formatted dataframe
prep_cohorts_data <- function(dat, geo_group) {
  
  env <- getOption("golem.app.prod")
  
  
  if (env == TRUE){
    levels = c(
      "1 & 2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12 & 13")
  } else {
    levels = c("area_1", "area_2", "area_3" , "area_4", "area_5")
  }
  
  if (geo_group == "area") {
    prep_dat <- dat |>
      dplyr::filter(geo_group == "area") |>
      dplyr::mutate(
        region = factor(
          region,
          levels = levels
        )
      ) |>
      # constuct tooltip
      dplyr::mutate(
        tooltip = paste0(
          "Area: ",
          region,
          "<br>Q1: ",
          q1,
          "<br>Median: ",
          median,
          "<br>Q3: ",
          q3
        )
      )
  } else if (geo_group == "county") {
    prep_dat <- dat |>
      dplyr::filter(geo_group == "county") |>
      # constuct tooltip
      dplyr::mutate(
        tooltip = paste0(
          "Area: ",
          region,
          "<br>Q1: ",
          q1,
          "<br>Median: ",
          median,
          "<br>Q3: ",
          q3
        )
      )
  } else {
    prep_dat <- dat |>
      dplyr::filter(geo_group == "country") |>
      # constuct tooltip
      dplyr::mutate(
        tooltip = paste0(
          "Area: ",
          region,
          "<br>Q1: ",
          q1,
          "<br>Median: ",
          median,
          "<br>Q3: ",
          q3
        )
      )
  }
}


#' losses_data_pivot_longer
#' @description The losses data is in wide format which is OK for the table
#' but needs to be in long format for ggplot2 to make the bar chart
#'
#' @param dat 
#'
#' @returns a data frame in long format
#'
#' @noRd
losses_data_pivot_longer <- function(dat){
  dat |> 
    tidyr::pivot_longer( cols = c("dead", "discarded", "escaped", "other"),
                         names_to = "type",
                         values_to = "n"
    ) |> 
    dplyr::mutate(
      type = factor(
        type,
        levels = c("dead", "discarded", "escaped", "other"),
        labels = c("Døde", "Utkast", "Rømt", "Annet")
      ))
  
}


#' monthly_mortality_locale_columns
#' @description function to prepare columns for time variables
#' in locale of country used in plots and tables
#'
#' @param dat 
#'
#' @returns a data frame
#' 
#' @noRd
monthly_mortality_locale_columns <- function(dat){
Sys.setlocale("LC_TIME", "nb_NO.UTF-8")
dat |> 
  dplyr::mutate(year = format(date, "%Y")) |> 
  dplyr::mutate(month_name = format(date, "%b"))

}


#' monthly_losses_locale_columns
#' @description function to prepare columns for time variables
#' in locale of country used in plots and tables
#'
#' @param dat 
#'
#' @returns a data frame
#' 
#' @noRd
monthly_mortality_losses_columns <- function(dat){
Sys.setlocale("LC_TIME", "nb_NO.UTF-8")

dat |> 
  dplyr::mutate(year_month = format(date, "%Y-%m")) |> 
  dplyr::mutate(year = format(date, "%Y")) |> 
  dplyr::mutate(month_name = format(date, "%b"))}