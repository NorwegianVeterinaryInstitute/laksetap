#' load_data
#' @description Function to load data for the app depending on the
#' environment prod or dev as set up by golem.app.prod option
#'
#' @export
load_data <- function() {
  env <- getOption("golem.app.prod")
  data_env <- Sys.getenv("data_env")

  if (env) {
    laksetap_board <- pins::board_connect()

    # read dev data for app
    if (data_env == "dev") {
      monthly_mortality_data <- pins::pin_read(
        laksetap_board,
        "vi2108/monthly_mortality_app_data_dev"
      )
      monthly_mortality_data_lc <- locale_columns(
        monthly_mortality_data
      )

      cumulative_mortality_yr_data <- pins::pin_read(
        laksetap_board,
        "vi2108/cumulative_mortality_yr_app_data_dev"
      )

      cumulative_mortality_yr_data_lc <- locale_columns(
        cumulative_mortality_yr_data
      )

      monthly_losses_data <- pins::pin_read(
        laksetap_board,
        "vi2108/monthly_losses_app_data_dev"
      )

      monthly_losses_data_lc <- monthly_losses_locale_columns(
        monthly_losses_data
      )

      monthly_losses_data_long <- losses_data_pivot_longer(
        monthly_losses_data_lc
      )

      yearly_losses_data <- pins::pin_read(
        laksetap_board,
        "vi2108/yearly_losses_app_data_dev"
      )

      yearly_losses_data_long <- losses_data_pivot_longer(yearly_losses_data)

      cohort_mortality_data <- pins::pin_read(
        laksetap_board,
        "vi2108/cohort_mortality_app_data_dev"
      )
    } else {
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

      monthly_losses_data_long <- losses_data_pivot_longer(
        monthly_losses_data_lc
      )

      yearly_losses_data <- pins::pin_read(
        laksetap_board,
        "vi2108/yearly_losses_app_data"
      )

      yearly_losses_data_long <- losses_data_pivot_longer(yearly_losses_data)

      cohort_mortality_data <- pins::pin_read(
        laksetap_board,
        "vi2108/cohort_mortality_app_data"
      )
    }
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

#' losses_data_pivot_longer
#' @description The losses data is in wide format which is OK for the table
#' but needs to be in long format for ggplot2 to make the bar chart
#'
#' @param dat a data frame
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


#' data_as_of_date
#' @description End of the latest month present in the monthly mortality
#' data (the `date` column holds the first of each month), used to tell
#' users how current the app's data is.
#'
#' @returns a character string, formatted dd.mm.yyyy
#'
#' @noRd
data_as_of_date <- function() {
  monthly_mortality_data <- getOption("monthly_mortality_data_lc")
<<<<<<< HEAD
  last_month_start <- max(monthly_mortality_data$date, na.rm = TRUE)
  end_of_month <- seq(last_month_start, by = "1 month", length.out = 2)[2] - 1
  format(end_of_month, "%d.%m.%Y")
=======
  format(max(monthly_mortality_data$date, na.rm = TRUE), "%d.%m.%Y")
>>>>>>> 4364e58cf0c1e9f11cb748c23a54fafd527d52aa
}


#' render_footer_md
#' @description Reads a footer markdown file and substitutes the
#' `{{DATA_DATE}}` placeholder with `data_as_of_date()` before rendering,
#' as a drop-in replacement for `shiny::includeMarkdown()`. Mirrors
#' `shiny::includeMarkdown()`'s own use of `markdown::mark()` (same
#' rendering backend, same explicit UTF-8 handling) since the substitution
#' has to happen on the raw text rather than the file path.
#'
#' @param path path to a markdown file, as returned by app_sys()
#'
#' @returns rendered markdown HTML
#'
#' @noRd
render_footer_md <- function(path) {
  txt <- readr::read_file(path)
  txt <- gsub("{{DATA_DATE}}", data_as_of_date(), txt, fixed = TRUE)
  html <- markdown::mark(text = txt, output = NULL)
  Encoding(html) <- "UTF-8"
  shiny::HTML(html)
}


#' locale_columns
#' @description function to prepare columns for time variables
#' in locale of country used in plots and tables
#'
#' @param dat a data frame
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
#' @param dat a data frame
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
