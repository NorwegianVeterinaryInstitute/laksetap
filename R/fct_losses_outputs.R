#' losses_data_prep_plot
#'
#' @description Function to make data for the month losses plot.
#'
#' @return A filtered data frame.
#'
#' @noRd
losses_data_prep_plot <- function(
  dat,
  select_year = NULL,
  select_month = NULL,
  resolution = "m"
) {
  if (resolution == "m") {
    dat <- dat |>
      dplyr::filter(year_month == paste0(select_year, "-", select_month))
  } else {
    dat <- dat |>
      dplyr::filter(year %in% select_year)
  }

  dat
}


#' losses_plot
#'
#' @description Function to make the monthly losses plot.
#'
#' @return A ggplot2 object.
#'
#' @noRd
losses_plot <- function(dat) {
  # Colors
  vi_palette <- getOption("vi_palette")
  labels <- golem::get_golem_options(which = "labels")

  dat |>
    ggplot(aes(
      fill = type,
      x = region,
      y = n,
      text = paste0(
        labels$tooltips$region,
        region,
        labels$tooltips$count,
        n,
        labels$tooltips$type,
        type
      )
    )) +
    geom_bar(position = "stack", stat = "identity") +
    labs(
      x = labels$output_functions$losses_plot_label_x,
      y = labels$output_functions$losses_plot_label_y
    ) +
    scale_fill_manual(values = vi_palette) +
    scale_y_continuous(
      labels = scales::label_number(scale = 1e-6, suffix = "M")
    ) +
    theme_minimal() +
    theme(legend.title = element_blank())
}


#' losses_data_prep_table
#'
#' @description Function to make data for the month losses table.
#'
#' @return A dataframe.
#'
#' @param dat a data frame
#' @param resolution 'm' or 'y' when the data is on monthly on yearly level
#'
#' @noRd
losses_data_prep_table <- function(dat, resolution) {
  if (resolution == "m") {
    dat |>
      dplyr::select(
        "year",
        "month_name",
        "region",
        "losses",
        "dead",
        "discarded",
        "escaped",
        "other"
      )
  } else {
    dat |>
      dplyr::select(
        "year",
        "region",
        "losses",
        "dead",
        "discarded",
        "escaped",
        "other"
      )
  }
}


#' losses_table
#'
#' @description Function to make the monthly losses table.
#'
#' @param dat a data frame
#' @param resolution 'm' or 'y' when the data is on monthly on yearly level
#'
#' @return A datatable object.
#'
#' @noRd
losses_table <- function(dat, resolution) {
  labels <- golem::get_golem_options(which = "labels")
  if (resolution == "m") {
    colnames <- labels$output_functions$losses_table_months
  } else {
    colnames <- labels$output_functions$losses_table_years
  }
  DT::datatable(
    dat,
    rownames = FALSE,
    colnames = colnames,
    selection = (list(
      mode = "multiple",
      selected = "all",
      target = "column"
    )),
    options = list(
      sDom = '<"top">lrt<"bottom">ip',
      scrollX = FALSE,
      language = list(
        url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
      )
    )
  )
}
