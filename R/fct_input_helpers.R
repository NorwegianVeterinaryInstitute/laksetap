# Helper functions for rendering inputs for all the modules
# TODO: avoid hardcoding "Norge" as an option

#' render_input_for_mortality_month_plot
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param viz "zone", "fylke" or "all"
#'
#' @returns a taglist to be rendered in the UI
#' for the plot
render_input_for_mortality_month_plot <- function(ns, dat, viz) {
  area <- c(as.character(unique(dat$area[dat$viz == viz])), "Norge")

  if (viz == "all") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_mortality_month"),
            multiple = TRUE
          )
        )
      )
    )
  } else {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 4,
          select_year(
            ns("select_years_mortality_month"),
            multiple = TRUE
          )
        ),
        shiny::column(
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

#' render_input_for_mortality_month_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param viz "zone", "fylke" or "all"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_mortality_month_table <- function(ns, dat, viz) {
  area <- c(as.character(unique(dat$area[dat$viz == viz])), "Norge")

  if (viz == "all") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_mortality_month_table"),
            multiple = TRUE
          )
        ),
        shiny::column(
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
        shiny::column(
          width = 4,
          select_year(
            ns("select_years_mortality_month_table"),
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 4,
          select_months(
            id = ns("select_months_mortality_month_table"),
          )
        ),
        shiny::column(
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

#' render_input_for_mortality_year
#' function renders input for both plot and table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param viz "zone", "fylke" or "all"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_mortality_year <- function(ns, dat, viz) {
  area <- c(as.character(unique(dat$area[dat$viz == viz])), "Norge")

  if (viz == "all") {
    tagList(
      fluidRow(
        column(
          width = 6,
          select_year(
            ns("select_years_mortality_year"),
            multiple = TRUE,
            resolution = "y"
          )
        )
      )
    )
  } else {
    tagList(
      fluidRow(
        column(
          width = 6,
          select_year(
            ns("select_years_mortality_year"),
            multiple = TRUE,
            resolution = "y"
          )
        ),
        column(
          width = 6,
          selectizeInput(
            ns("select_area_mortality_year"),
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

#' render_input_for_cohorts_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param viz "zone", "fylke" or "all"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_cohorts_table <- function(ns, dat, viz) {
  area <- as.character(unique(dat$area[dat$viz == viz]))

  if (viz == "all") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_cohort_table"),
            multiple = TRUE,
            resolution = "y"
          )
        )
      )
    )
  } else {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 4,
          select_year(
            ns("select_years_cohort_table"),
            multiple = TRUE,
            resolution = "y"
          )
        ),
        shiny::column(
          width = 4,
          shiny::selectInput(
            ns("select_area_cohort_table"),
            "Velg flere områder:",
            area,
            selected = area,
            multiple = TRUE
          )
        )
      )
    )
  }
}

#' render_input_for_losses_montly_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param viz "zone", "fylke" or "all"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_losses_montly_table <- function(ns, dat, viz) {
  area <- as.character(unique(dat$area[dat$viz == viz]))

  if (viz == "all") {
    tagList(
      fluidRow(
        column(
          width = 6,
          select_year(
            id = "select_years_losses_montly_table",
            multiple = T
          )
        ),
        column(
          width = 6,
          select_months(
            id = "select_years_losses_montly_table",
            digit = FALSE,
            multiple = TRUE
          )
        )
      )
    )
  } else {
    tagList(
      fluidRow(
        column(
          width = 4,
          select_year(
            id = "select_years_losses_montly_table",
            multiple = T
          )
        ),
        column(
          width = 4,
          select_months(
            id = "select_years_losses_montly_table",
            digit = FALSE,
            multiple = TRUE
          )
        ),
        column(
          width = 4,
          selectizeInput(
            "select_areal_losses_montly_table",
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

#' render_input_for_losses_montly_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param viz "zone", "fylke" or "all"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_losses_yearly_table <- function(ns, dat, viz) {
  area <- as.character(unique(dat$area[dat$viz == viz]))

  if (viz == "all") {
    tagList(
      fluidRow(
        column(
          width = 6,
          select_year(
            id = "select_years_losses_montly_table",
            multiple = T
          )
        )
      )
    )
  } else {
    tagList(
      fluidRow(
        column(
          width = 6,
          select_year(
            id = "select_years_losses_montly_table",
            multiple = T
          )
        ),
        column(
          width = 6,
          selectizeInput(
            "select_areal_losses_montly_table",
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
