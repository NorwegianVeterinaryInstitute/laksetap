#' plot_cohorts_output
#'
#' @description A function to make the plot for cohort mortality
#'
#' @param dat A data frame with cohort mortality data
#'
#' @return A plotly object.
#'
#' @noRd
plot_cohorts_output <- function(dat, year) {
  labels <- golem::get_golem_options(which = "labels")
  dat |>
    ggplot() +
    geom_segment(
      aes(
        color = as.numeric(factor(region)),
        x = region,
        xend = region,
        y = q1,
        yend = q3,
        linewidth = 10
      )
    ) +
    scale_color_gradient(low = "#C7D9FF", high = "#1C4FB9") +
    geom_point(
      shape = 16,
      aes(
        x = region,
        y = median,
        group = year,
        text = paste0(
          labels$tooltips$region,
          region,
          labels$tooltips$q1,
          q1,
          labels$tooltips$median,
          median,
          labels$tooltips$q3,
          q3
        ),
        fill = "black",
        stroke = 0.2
      )
    ) +
    # geom_text(
    #   aes(x = region, y = median, group = year, label = region),
    #   nudge_y = 1
    # ) +
    labs(
      title = labels$output_functions$cohorts_plot_title,
      x = year,
      y = labels$output_functions$cohorts_plot_label_y
    ) +
    theme_minimal() +
    theme(legend.position = "none") +
    guides(fill = "none")
}

#' cohorts_mortality_table
#'
#' @description A function to make the data table.
#'
#' @return A DT object.
#'
#' @noRd

cohorts_mortality_table <- function(dat) {
  labels <- golem::get_golem_options(which = "labels")
  dat |>
    DT::datatable(
      rownames = FALSE,
      colnames = labels$output_functions$table_colnames_cohorts,
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
