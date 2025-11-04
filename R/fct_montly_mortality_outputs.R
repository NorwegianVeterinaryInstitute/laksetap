#' monthly_mortality_plot
#'
#' @description A function to make the monthly mortality plot.
#'
#' @return A ggplot2 object.
#'
#' @noRd
monthly_mortality_plot <- function(dat) {
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
        labs(x = "Måned", y = "Dødelighet (%)") +
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
        scale_color_manual(values = my_palette_named) +
        scale_fill_manual(values = my_palette_named) +
        guides(
            col = guide_legend(title = "Område"),
            fill = "none"
        )
}

#' style_plotly
#'
#' @description A function to style a plotly object.
#'
#' @return A plotly object.
#'
#' @noRd
style_plotly <- function(p) {
    p |>
        plotly::ggplotly(tooltip = "text") |>
        plotly::layout(
            legend = list(
                orientation = "h", # horizontal
                x = 0.5,
                y = 1.1,
                xanchor = "center"
            )
        ) |>
        plotly::config(
            displaylogo = FALSE,
            modeBarButtons = list(list("toImage"))
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
    DT::datatable(
        dat,
        rownames = F,
        colnames = c(
            "År",
            "Måned",
            "Område",
            "1 Kvartil %",
            "Median %",
            "3 Kvartil %"
        ),
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
