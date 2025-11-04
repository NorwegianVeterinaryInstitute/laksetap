#' losses_data_pivot_longer
#' The losses data is in wide format which is OK for the table
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

#' loses_data_prep_plot
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
#' @description Function to make the monthly loses plot.
#'
#' @return A ggplot2 object.
#'
#' @noRd
losses_plot <- function(dat) {
  dat |>
    ggplot(aes(fill=type, x=region, y=n)) + 
    geom_bar(position="stack", stat="identity") +
    labs(x = "Område", y = "Antal (Milioner)") +
    scale_fill_manual(values = my_palette) +
    theme_minimal()
}


#' loses_data_prep_table
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
    )} else {
      dat |>
        dplyr::select(
          "year",
          "region",
          "losses",
          "dead",
          "discarded",
          "escaped",
          "other")
    }
}


#' losses_table
#'
#' @description Function to make the monthly loses table.
#' 
#' @param dat a data frame
#' @param resolution 'm' or 'y' when the data is on monthly on yearly level
#'
#' @return A datatable object.
#'
#' @noRd
losses_table <- function(dat, resolution) {
  if (resolution == "m") {
    colnames = c(
      "År",
      "Måned",
      "Område",
      "Total",
      "Døde",
      "Utkast",
      "Rømt",
      "Annet"
    )
  } else {
    colnames = c(
      "År",
      "Område",
      "Total",
      "Døde",
      "Utkast",
      "Rømt",
      "Annet"
    )
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
