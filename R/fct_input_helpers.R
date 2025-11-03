# Helper functions for rendering inputs for all the modules
# TODO: avoid hardcoding "Norge" as an option

#' render_input_for_mortality_month_plot
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the plot
render_input_for_mortality_month_plot <- function(ns, dat, geo_group) {
  region <- c(as.character(unique(dat$region[dat$geo_group == geo_group])), "Norge")

  if (geo_group == "country") {
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
            ns("select_region_mortality_month_plot"),
            "Velg flere områder:",
            region,
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
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_mortality_month_table <- function(ns, dat, geo_group) {
  region <- c(as.character(unique(dat$region[dat$geo_group == geo_group])), "Norge")

  if (geo_group == "country") {
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
            ns("select_region_mortality_month"),
            "Velg flere områder",
            region,
            selected = region,
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
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_mortality_year <- function(ns, dat, geo_group) {
  region <- c(as.character(unique(dat$region[dat$geo_group == geo_group])), "Norge")

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          shiny::select_year(
            ns("select_years_mortality_year"),
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
          width = 6,
          shiny::select_year(
            ns("select_years_mortality_year"),
            multiple = TRUE,
            resolution = "y"
          )
        ),
        shiny::column(
          width = 6,
          shiny::selectizeInput(
            ns("select_region_mortality_year"),
            "Velg flere områder",
            region,
            selected = region,
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
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_cohorts_table <- function(ns, dat, geo_group) {
  region <- as.character(unique(dat$region[dat$geo_group == geo_group]))

  if (geo_group == "country") {
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
            ns("select_region_cohort_table"),
            "Velg flere områder:",
            region,
            selected = region,
            multiple = TRUE
          )
        )
      )
    )
  }
}

#' render_input_for_losses_monthly_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_losses_monthly_table <- function(ns, dat, geo_group) {
  region <- as.character(na.omit(unique(dat$region[dat$geo_group == geo_group])))

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_losses_monthly_table"),
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 6,
          select_months(
            ns("select_months_losses_monthly_table"),
            digit = FALSE,
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
            ns("select_years_losses_monthly_table"),
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 4,
          select_months(
            ns("select_months_losses_monthly_table"),
            digit = FALSE,
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 4,
          shiny::selectizeInput(
            ns("select_region_losses_monthly_table"),
            "Velg flere områder",
            region,
            selected = region,
            multiple = TRUE
          )
        )
      )
    )
  }
}

#' render_input_for_losses_yearly_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
render_input_for_losses_yearly_table <- function(ns, dat, geo_group) {
  region <- as.character(unique(dat$region[dat$geo_group == geo_group]))

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_losses_year_table"),
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
          width = 6,
          select_year(
            ns("select_years_losses_year_table"),
            multiple = TRUE,
            resolution = "y"
          )
        ),
        shiny::column(
          width = 6,
          shiny::selectizeInput(
            ns("select_region_losses_year_table"),
            "Velg flere områder",
            region,
            selected = region,
            multiple = TRUE
          )
        )
      )
    )
  }
}
