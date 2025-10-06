#' plot_yearly_mortality_outputs
#'
#' @description A function to make the plot
#'
#' @param dat A data frame with yearly mortality data
#'
#' @return A plotly object
#'
#' @noRd
plot_yearly_mortality_outputs <- function(dat) {
  dat |>
    plotly::plot_ly(
      x = ~area,
      y = ~`2024`,
      name = "2024",
      type = "scatter",
      mode = "markers",
      marker = list(color = "#1C4FB9"),
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Prosent: ",
        `2024`,
        "<br>",
        "Aar: 2024"
      )
    ) |>
    plotly::add_trace(
      x = ~area,
      y = ~`2023`,
      name = "2023",
      type = "scatter",
      mode = "markers",
      marker = list(color = "#95D9F3"),
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Prosent: ",
        `2023`,
        "<br>",
        "Aar: 2023"
      )
    ) |>
    plotly::add_trace(
      x = ~area,
      y = ~`2022`,
      name = "2022",
      type = "scatter",
      mode = "markers",
      marker = list(color = "#59CD8B"),
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Prosent: ",
        `2022`,
        "<br>",
        "Aar: 2022"
      )
    ) |>
    plotly::add_trace(
      x = ~area,
      y = ~`2021`,
      name = "2021",
      type = "scatter",
      mode = "markers",
      marker = list(color = "#BCEED1"),
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Prosent: ",
        `2021`,
        "<br>",
        "Aar: 2021"
      )
    ) |>
    plotly::add_trace(
      x = ~area,
      y = ~`2020`,
      name = "2020",
      type = "scatter",
      mode = "markers",
      marker = list(color = "#FF5447"),
      hoverinfo = "text",
      text = ~ paste(
        "Område: ",
        area,
        "<br>",
        "Prosent: ",
        `2020`,
        "<br>",
        "Aar: 2020"
      )
    ) |>
    plotly::layout(
      title = "",
      annotations = list(
        yref = "paper",
        xref = "paper",
        y = 1.09,
        x = .2,
        text = "Velg år:",
        showarrow = F,
        font = list(size = 14, face = "bold")
      ),
      legend = list(orientation = "h", x = .25, y = 1.1),
      xaxis = list(title = "Område"),
      yaxis = list(title = "Dødelighet (%)", categoryarray = ~area),
      margin = list(l = 100)
    ) |>
    plotly::config(displaylogo = FALSE, modeBarButtons = list(list("toImage")))
}


table_yearly_mortality_outputs <- function(dat) {
  dat |>
    DT::datatable(
      rownames = F,
      colnames = c("År", "Område", "Dødelighet %"),
      # also here
      selection = (list(
        mode = "multiple",
        selected = "all",
        target = "column"
      )),
      options = list(
        sDom = '<"top">lrt<"bottom">ip',
        autoWidth = FALSE,
        scrollX = FALSE,
        language = list(
          url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
        )
      )
    )
}
