#' load_data
#' Function to load data for the app depending on the
#' environment prod or dev as set up by golem.app.prod option
#' @export
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
    # TODO fix correct datasets across the app
    # losses are now in separate sources
    losses <- readRDS(
      app_sys(
        "data/losses_and_mortality_yearly_data.rds",
      ))
    losses_monthly_data <- readRDS(
      system.file(
        "extdata",
        "losses_monthly_data.rds",
        package = "laksetap"
      )
    )
    mortality_rates_monthly_data <- readRDS(
      app_sys("data/monthly_mortality_dummy_data.Rds")
    )
    mortality_cohorts_data <- readRDS(
      app_sys("data/losses.rds")
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
  }

  options(losses = losses)
  options(losses_monthly_data = losses_monthly_data)
  options(mortality_cohorts_data = mortality_cohorts_data)
  options(mortality_cohorts_data_area = mortality_cohorts_data_area)
  options(mortality_cohorts_data_county = mortality_cohorts_data_county)
  options(mortality_cohorts_data_country = mortality_cohorts_data_country)
  options(mortality_rates_monthly_data = mortality_rates_monthly_data)
}

#' prep_cohorts_data
#' Function to prepare the cohorts dataset for plotting
#'
#' @param dat 
#' @param geo_group 
#'
#' @returns a formatted dataframe
prep_cohorts_data <- function(dat, geo_group) {
  if (geo_group == "area") {
    prep_dat <- dat |>
      dplyr::filter(geo_group == "area") |>
      dplyr::mutate(
        area = factor(
          area,
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
            "12 & 13",
            "Norge"
          )
        )
      ) |>
      dplyr::mutate(
        q1 = round(q1, 1),
        q3 = round(q3, 1),
        median = round(median, 1)
      ) |>
      # constuct tooltip
      dplyr::mutate(
        tooltip = paste0(
          "Area: ",
          area,
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
      dplyr::filter(viz == "county") |>
      dplyr::mutate(
        q1 = round(q1, 1),
        q3 = round(q3, 1),
        median = round(median, 1)
      ) |>
      # constuct tooltip
      dplyr::mutate(
        tooltip = paste0(
          "Area: ",
          area,
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
      dplyr::mutate(
        q1 = round(q1, 1),
        q3 = round(q3, 1),
        median = round(median, 1)
      ) |>
      # constuct tooltip
      dplyr::mutate(
        tooltip = paste0(
          "Area: ",
          area,
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
