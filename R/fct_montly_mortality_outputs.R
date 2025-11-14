#' monthly_mortality_plot
#'
#' @description A function to make the monthly mortality plot.
#'
#' @return A ggplot2 object.
#'
#' @noRd
monthly_mortality_plot <- function(dat) {
  # Colors #
  vi_palette_named <- getOption("vi_palette_named")
  labels <- golem::get_golem_options(which = "labels")

  dat |>
    ggplot2::ggplot() +
    aes(
      x = date,
      y = median,
      group = region,
      text = paste0(
        "Median: ",
        round(median, 2),
        "<br>Q1: ",
        round(q1, 2),
        "<br>Q3: ",
        round(q3, 2)
      )
    ) +
    labs(
      x = labels$output_functions$monthly_mortality_plot_label_x,
      y = labels$output_functions$monthly_mortality_plot_label_y
    ) +
    geom_line(aes(
      color = factor(region)
    )) +
    geom_ribbon(
      aes(
        ymin = .data$q1,
        ymax = .data$q3,
        fill = factor(region)
      ),
      linetype = 0,
      alpha = 0.1,
      show.legend = FALSE
    ) +
    theme_minimal() +
    scale_color_manual(values = vi_palette_named) +
    scale_fill_manual(values = vi_palette_named) +
    guides(
      col = guide_legend(
        title = labels$output_functions$monthly_mortality_plot_label_title
      ),
      fill = "none"
    )
}

#' monhtly_mortality_table
#'
#' @description A function to make the data table.
#'
#' @return A DT object.
#'
#' @noRd
monthly_mortality_table <- function(dat) {
  labels <- golem::get_golem_options(which = "labels")
  DT::datatable(
    dat,
    rownames = F,
    colnames = labels$output_functions$table_colnames,
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
