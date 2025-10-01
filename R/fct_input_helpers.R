render_input_for_fylke_plot <- function(ns) {
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
                    c(
                        #"Agder",
                        "Rogaland",
                        "Vestland",
                        "Møre og Romsdal",
                        "Trøndelag",
                        "Nordland",
                        "Troms",
                        "Finnmark",
                        "Norge"
                    ),
                    selected = c("Norge"),
                    multiple = TRUE
                )
            )
        )
    )
}

render_input_for_zone_plot <- function(ns) {
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
                    "Velg flere områder",
                    c(
                        "1 & 2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10",
                        "11",
                        "12 & 13",
                        "Norge"
                    ),
                    selected = c("Norge"),
                    multiple = TRUE
                )
            )
        )
    )
}

render_input_for_all_plot <- function(ns) {
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
}

render_input_for_fylke_table <- function(ns) {
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
                    c(
                        "1 & 2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10",
                        "11",
                        "12 & 13"
                    ),
                    selected = c(
                        "1 & 2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10",
                        "11",
                        "12 & 13"
                    ),
                    multiple = TRUE
                )
            )
        )
    )
}

render_input_for_zone_table <- function(ns) {
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
                    "Velg flere områder:",
                    c(
                        #"Agder",
                        "Rogaland",
                        "Vestland",
                        "Møre og Romsdal",
                        "Trøndelag",
                        "Nordland",
                        "Troms",
                        "Finnmark"
                    ),
                    selected = c(
                        #"Agder",
                        "Rogaland",
                        "Vestland",
                        "Møre og Romsdal",
                        "Trøndelag",
                        "Nordland",
                        "Troms",
                        "Finnmark"
                    ),
                    multiple = TRUE
                )
            )
        )
    )
}

render_input_for_all_table <- function(ns) {
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
}
