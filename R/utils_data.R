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

    mortality_cohorts_data_zone <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'zone'
    )
    mortality_cohorts_data_fylke <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'fylke'
    )

    mortality_cohorts_data_all <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'all'
    )
  } else {
    losses <- readRDS(
      system.file(
        "extdata",
        "losses_and_mortality_yearly_data.rds",
        package = "laksetap"
      )
    )
    losses_monthly_data <- readRDS(
      system.file(
        "extdata",
        "losses_monthly_data.rds",
        package = "laksetap"
      )
    )
    mortality_rates_monthly_data <- readRDS(
      system.file(
        "extdata",
        "mortality_rates_monthly_data.rds",
        package = "laksetap"
      )
    )
    mortality_cohorts_data <- readRDS(
      app_sys("data/losses.rds")
    )

    mortality_cohorts_data_zone <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'zone'
    )
    mortality_cohorts_data_fylke <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'fylke'
    )

    mortality_cohorts_data_all <- prep_cohorts_data(
      mortality_cohorts_data,
      geo_group = 'all'
    )
  }

  options(losses = losses)
  options(losses_monthly_data = losses_monthly_data)
  options(mortality_cohorts_data = mortality_cohorts_data)
  options(mortality_cohorts_data_zone = mortality_cohorts_data_zone)
  options(mortality_cohorts_data_fylke = mortality_cohorts_data_fylke)
  options(mortality_cohorts_data_all = mortality_cohorts_data_all)
  options(mortality_rates_monthly_data = mortality_rates_monthly_data)
}

prep_cohorts_data <- function(dat, geo_group) {
  if (geo_group == "zone") {
    prep_dat <- dat |>
      dplyr::filter(viz == "zone") |>
      dplyr::mutate(
        area = factor(
          area,
          levels = c(
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "All"
          )
        )
      ) |>
      dplyr::filter(
        area != "13",
        area != "1",
        area != "All"
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
  } else if (geo_group == "fylke") {
    prep_dat <- dat |>
      dplyr::filter(viz == "fylke") |>
      dplyr::filter(
        area != "All"
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
  } else {
    prep_dat <- dat |>
      dplyr::filter(viz == "all") |>
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
