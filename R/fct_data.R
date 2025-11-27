#' load_data
#' @description Function to load data for the app depending on the
#' environment prod or dev as set up by golem.app.prod option
#'
#' @export
load_data <- function() {
  env <- getOption("golem.app.prod")

  if (env) {
    laksetap_board <- pins::board_connect()

    monthly_mortality_data <- pins::pin_read(
      laksetap_board,
      "vi2108/monthly_mortality_app_data"
    )
    monthly_mortality_data_lc <- locale_columns(
      monthly_mortality_data
    )

    cumulative_mortality_yr_data <- pins::pin_read(
      laksetap_board,
      "vi2108/cumulative_mortality_yr_app_data"
    )

    cumulative_mortality_yr_data_lc <- locale_columns(
      cumulative_mortality_yr_data
    )

    monthly_losses_data <- pins::pin_read(
      laksetap_board,
      "vi2108/monthly_losses_app_data"
    )

    monthly_losses_data_lc <- monthly_losses_locale_columns(
      monthly_losses_data
    )

    monthly_losses_data_long <- losses_data_pivot_longer(monthly_losses_data_lc)

    yearly_losses_data <- pins::pin_read(
      laksetap_board,
      "vi2108/yearly_losses_app_data"
    )

    yearly_losses_data_long <- losses_data_pivot_longer(yearly_losses_data)

    # Cohort data require multiple transformation because
    # of need for ordered factor. Should be improved.
    cohort_mortality_data <- pins::pin_read(
      laksetap_board,
      "vi2108/cohort_mortality_app_data"
    )

    cohort_mortality_data <- prep_cohorts_data(cohort_mortality_data)
  } else {
    monthly_mortality_data <- readRDS(
      app_sys(
        "extdata",
        "monthly_mortality_dummy_data.Rds"
      )
    )

    monthly_mortality_data_lc <- locale_columns(
      monthly_mortality_data
    )

    cumulative_mortality_yr_data <- readRDS(
      app_sys(
        "extdata",
        "cumulative_mortality_dummy_data.Rds"
      )
    )

    cumulative_mortality_yr_data_lc <- locale_columns(
      cumulative_mortality_yr_data
    )

    monthly_losses_data <- readRDS(
      app_sys(
        "extdata",
        "monthly_losses_dummy_data.Rds"
      )
    )

    monthly_losses_data_lc <- monthly_losses_locale_columns(
      monthly_losses_data
    )

    monthly_losses_data_long <- losses_data_pivot_longer(monthly_losses_data_lc)

    yearly_losses_data <- readRDS(
      app_sys(
        "extdata",
        "yearly_losses_dummy_data.Rds"
      )
    )

    yearly_losses_data_long <- losses_data_pivot_longer(yearly_losses_data)

    cohort_mortality_data <- readRDS(
      app_sys(
        "extdata",
        "cohort_mortality_dummy_data.Rds"
      )
    )
    cohort_mortality_data <- prep_cohorts_data(cohort_mortality_data)
  }

  options(yearly_losses_data = yearly_losses_data)
  options(monthly_losses_data = monthly_losses_data)
  options(monthly_losses_data_lc = monthly_losses_data_lc)
  options(yearly_losses_data_long = yearly_losses_data_long)
  options(monthly_losses_data_long = monthly_losses_data_long)
  options(cumulative_mortality_yr_data = cumulative_mortality_yr_data)
  options(cumulative_mortality_yr_data_lc = cumulative_mortality_yr_data_lc)
  options(monthly_mortality_data = monthly_mortality_data)
  options(monthly_mortality_data_lc = monthly_mortality_data_lc)
  options(cohort_mortality_data = cohort_mortality_data)
}

#' prep_cohorts_data
#' @description Function to prepare the cohorts dataset for plotting
#'
#' @param dat a data frame
#'
#' @returns a formatted dataframe
prep_cohorts_data <- function(dat) {
  labels <- golem::get_golem_options(which = "labels")
  
  dat |>
    dplyr::mutate(
      tooltip = paste0(
        labels$tooltips$region,
        region,
        labels$tooltips$q1,
        q1,
        labels$tooltips$median,
        median,
        labels$tooltips$q3,
        q3
      )
    )
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
losses_data_pivot_longer <- function(dat) {
  dat |>
    tidyr::pivot_longer(
      cols = c("dead", "discarded", "escaped", "other"),
      names_to = "type",
      values_to = "n"
    ) |>
    dplyr::mutate(
      type = factor(
        type,
        levels = c("dead", "discarded", "escaped", "other"),
        labels = c("Døde", "Utkast", "Rømt", "Annet")
      )
    )
}


#' locale_columns
#' @description function to prepare columns for time variables
#' in locale of country used in plots and tables
#'
#' @param dat
#'
#' @returns a data frame
#'
#' @noRd
locale_columns <- function(dat) {
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
monthly_losses_locale_columns <- function(dat) {
  Sys.setlocale("LC_TIME", "nb_NO.UTF-8")

  dat |>
    dplyr::mutate(year_month = format(date, "%Y-%m")) |>
    dplyr::mutate(year = format(date, "%Y")) |>
    dplyr::mutate(month_name = format(date, "%b"))
}
