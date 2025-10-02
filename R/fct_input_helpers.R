#' render_input_for_plot
#'
#' @param ns
#' @param dat
#' @param viz
#'
#' @returns a taglist to be rendered in the UI
#' for the plot
render_input_for_plot <- function(ns, dat, viz) {
    area <- c(as.character(unique(dat$area[dat$viz == viz])), "Norge")

    if (viz == "all") {
        shiny::tagList(
            shiny::fluidRow(
                column(
                    width = 6,
                    select_year(
                        ns("select_years_mortality_month"),
                        multiple = T
                    )
                )
            )
        )
    } else {
        shiny::tagList(
            shiny::fluidRow(
                column(
                    width = 4,
                    select_year(
                        ns("select_years_mortality_month"),
                        multiple = T
                    )
                ),
                column(
                    width = 4,
                    shiny::selectInput(
                        ns("select_area_mortality_month_plot"),
                        "Velg flere områder:",
                        area,
                        selected = c("Norge"),
                        multiple = TRUE
                    )
                )
            )
        )
    }
}

#' render_input_for_table
#'
#' @param ns
#' @param dat
#' @param viz
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_table <- function(ns, dat, viz) {
    area <- c(as.character(unique(dat$area[dat$viz == viz])), "Norge")

    if (viz == "all") {
        shiny::tagList(
            shiny::fluidRow(
                column(
                    width = 6,
                    select_year(
                        ns("select_years_mortality_month_table"),
                        multiple = T
                    )
                ),
                column(
                    width = 4,
                    select_months(
                        id = ns("select_months_mortality_month_table")
                    )
                )
            )
        )
    } else {
        shiny::tagList(
            shiny::fluidRow(
                column(
                    width = 4,
                    select_year(
                        ns("select_years_mortality_month_table"),
                        multiple = T
                    )
                ),
                column(
                    width = 4,
                    select_months(
                        id = ns("select_months_mortality_month_table"),
                    )
                ),
                column(
                    width = 4,
                    shiny::selectizeInput(
                        ns("select_area_mortality_month"),
                        "Velg flere områder",
                        area,
                        selected = area,
                        multiple = TRUE
                    )
                )
            )
        )
    }
}
