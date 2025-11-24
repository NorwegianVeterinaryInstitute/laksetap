#' cumulative_mortality_plot
#'
#' @description A function to make the monthly mortality plot.
#'
#' @param dat a data frame
#'
#' @return A ggplot2 object.
#'
#' @noRd
cumulative_mortality_plot <- function(dat) {
  # Colors #
  vi_palette_named <- getOption("vi_palette_named")
  labels <- golem::get_golem_options(which = "labels")

  dat |>
    ggplot2::ggplot() +
    aes(
      x = date,
      y = mean,
      group = region,
      text = paste0(
        "Mean: ",
        mean,
        "<br>LCI: ",
        lci,
        "<br>UCI: ",
        uci
      )
    ) +
    labs(
      x = labels$output_functions$mortality_plot_label_x,
      y = labels$output_functions$mortality_plot_label_y
    ) +
    geom_line(aes(
      color = factor(region)
    )) +
    geom_ribbon(
      aes(
        ymin = .data$lci,
        ymax = .data$uci,
        fill = factor(region)
      ),
      linetype = 0,
      alpha = 0.1,
      show.legend = FALSE
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45)) +
    scale_color_manual(values = vi_palette_named) +
    scale_fill_manual(values = vi_palette_named) +
    scale_x_date(
      date_breaks = "1 month",
      date_labels = "%b %Y"
    ) +
    guides(
      col = guide_legend(
        title = labels$output_functions$mortality_plot_label_title
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
cumulative_mortality_table <- function(dat) {
  labels <- golem::get_golem_options(which = "labels")
  DT::datatable(
    dat,
    rownames = FALSE,
    colnames = labels$output_functions$cumulative_table_colnames,
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
