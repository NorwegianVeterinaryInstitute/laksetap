#' @export
load_data <- function() {
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
  mortality_cohorts_data_other <- prep_cohorts_data(
    mortality_cohorts_data,
    geo_group = 'other'
  )

  options(losses = losses)
  options(losses_monthly_data = losses_monthly_data)
  options(mortality_cohorts_data = mortality_cohorts_data)
  options(mortality_cohorts_data_zone = mortality_cohorts_data_zone)
  options(mortality_cohorts_data_other = mortality_cohorts_data_other)
  options(mortality_rates_monthly_data = mortality_rates_monthly_data)
}

prep_cohorts_data <- function(dat, geo_group) {
  if (geo_group == "zone") {
    prep_dat <- dat |>
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
      ) |>
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
      )
  } else {
    prep_dat <- dat |>
      dplyr::filter(
        area != "13",
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
  }
}
