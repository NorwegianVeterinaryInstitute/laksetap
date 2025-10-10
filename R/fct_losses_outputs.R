#' loses_data_prep
#'
#' @description Function to make data for the month losses plot.
#'
#' @return A dataframe.
#'
#' @noRd
losses_data_prep <- function(
  dat,
  select_year = NULL,
  select_month = NULL,
  resolution = "m"
) {
  dat <- dat |>
    dplyr::filter(
      !area == "Norway" &
        !area == "All"
    ) |>
    tidyr::gather(type, n, c(doed, ut, romt, ufor)) |>
    droplevels() |>
    dplyr::mutate(
      perc = dplyr::case_when(
        type == "doed" ~ p.doed,
        type == "ut" ~ p.ut,
        type == "romt" ~ p.romt,
        type == "ufor" ~ p.ufor
      )
    ) |>
    dplyr::mutate(
      type = factor(
        type,
        levels = c("doed", "ut", "romt", "ufor"),
        labels = c("Døde", "Utkast", "Rømt", "Annet")
      )
    )

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
#' @return A plotly object.
#'
#' @noRd
losses_plot <- function(dat) {
  dat |>
    plotly::plot_ly(
      x = ~area,
      y = ~n,
      color = ~type,
      colors = my_palette,
      type = "bar",
      legendgroup = ~type,
      textposition = "none",
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Antall: ",
        n,
        "<br>"
      )
    ) |>
    plotly::layout(
      legend = list(
        orientation = "h", # horizontal
        x = 0.5,
        y = 1.1,
        xanchor = "center"
      ),
      barmode = "stack",
      title = NULL,
      annotations = list(
        yref = "paper",
        xref = "paper",
        y = 1.05,
        x = 1.1,
        text = "Velg tap:",
        showarrow = F,
        font = list(size = 14, face = "bold")
      ),
      yaxis = list(title = "Antall (millioner)"),
      xaxis = list(title = "Område"),
      showlegend = TRUE
    ) |>
    plotly::config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
}

#' montly_loses_table
#'
#' @description Function to make the monthly loses table.
#'
#' @return A datatable object.
#'
#' @noRd
montly_loses_table <- function(dat) {}

#' yearly_loses_plot
#'
#' @description Function to make the monthly loses plot.
#'
#' @return A plotly object.
#'
#' @noRd
yearly_loses_plot <- function(dat) {}

#' yearly_loses_table
#'
#' @description Function to make the monthly loses table.
#'
#' @return A datatable object.
#'
#' @noRd
yearly_loses_plot <- function(dat) {}
