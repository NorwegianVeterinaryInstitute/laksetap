# Helper functions for rendering inputs for all the modules
#' render_input_for_mortality_month_plot
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the plot
#'
#' @noRd
render_input_for_mortality_month_plot <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(dat, geo_group, with_country = TRUE)

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_mortality_month"),
            dat,
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
            dat,
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 4,
          shiny::selectInput(
            ns("select_region_mortality_month_plot"),

            label = labels$input_functions$select_multiple_places,
            choices = region,
            selected = c(as.character(unique(dat$region[
              dat$geo_group == 'country'
            ]))),
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
#'
#' @noRd
render_input_for_mortality_month_table <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(
    dat,
    geo_group,
    with_country = FALSE
  )

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 4,
          select_year(
            ns("select_years_mortality_month_table"),
            dat,
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
            dat,
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
            #"Velg flere områder",
            label = labels$input_functions$select_multiple_places,
            choices = region,
            selected = region,
            multiple = TRUE
          )
        )
      )
    )
  }
}

#' render_input_for_cumulative_mortality_plot
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the plot
#'
#' @noRd
render_input_for_cumulative_mortality_plot <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(dat, geo_group, with_country = TRUE)

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_year_cumulative_mortality"),
            dat,
            multiple = FALSE
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
            ns("select_year_cumulative_mortality"),
            dat,
            multiple = FALSE
          )
        ),
        shiny::column(
          width = 4,
          shiny::selectInput(
            ns("select_region_cumulative_mortality_plot"),
            label = labels$input_functions$select_multiple_places,
            region,
            selected = c(as.character(unique(dat$region[
              dat$geo_group == 'country'
            ]))),
            multiple = TRUE
          )
        )
      )
    )
  }
}

#' render_input_for_cumulative_mortality_table
#'
#' @param ns namespace function
#' @param dat dataframe
#' @param geo_group "area", "county" or "country"
#'
#' @returns a taglist to be rendered in the UI
#' for the table
#'
#' @noRd
render_input_for_cumulative_mortality_table <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(
    dat,
    geo_group,
    with_country = FALSE
  )

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_cumulative_mortality_table"),
            dat,
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 6,
          select_months(
            id = ns("select_months_cumulative_mortality_table")
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
            ns("select_years_cumulative_mortality_table"),
            dat,
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 4,
          select_months(
            id = ns("select_months_cumulative_mortality_table")
          )
        ),
        shiny::column(
          width = 4,
          shiny::selectizeInput(
            ns("select_region_cumulative_mortality"),
            label = labels$input_functions$select_multiple_places,
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
#'
#' @noRd
render_input_for_cohorts_table <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(
    dat,
    geo_group,
    with_country = FALSE
  )

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_cohort_table"),
            dat,
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
            ns("select_years_cohort_table"),
            dat,
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 4,
          shiny::selectInput(
            ns("select_region_cohort_table"),

            label = labels$input_functions$select_multiple_places,
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
#' @importFrom stats na.omit
#'
#' @returns a taglist to be rendered in the UI
#' for the table
#'
#' @noRd
render_input_for_losses_monthly_table <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(
    dat,
    geo_group,
    with_country = FALSE
  )

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_losses_monthly_table"),
            dat,
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
            dat,
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

            label = labels$input_functions$select_multiple_places,
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
#'
#' @noRd
render_input_for_losses_yearly_table <- function(ns, dat, geo_group) {
  labels <- golem::get_golem_options(which = "labels")

  region <- factor_order_on_region_dropdown(
    dat,
    geo_group,
    with_country = FALSE
  )

  if (geo_group == "country") {
    shiny::tagList(
      shiny::fluidRow(
        shiny::column(
          width = 6,
          select_year(
            ns("select_years_losses_year_table"),
            dat,
            multiple = TRUE
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
            dat,
            multiple = TRUE
          )
        ),
        shiny::column(
          width = 6,
          shiny::selectizeInput(
            ns("select_region_losses_year_table"),

            label = labels$input_functions$select_multiple_places,
            region,
            selected = region,
            multiple = TRUE
          )
        )
      )
    )
  }
}


#' factor_order_on_region_dropdown
#'
#' @param with_country TRUE or FALSE
#' @param dat the data frame
#' @param geo_group the filter used
#'
#' @returns a sorted vector
#'
#' @noRd
factor_order_on_region_dropdown <- function(
  dat,
  geo_group,
  with_country = TRUE
) {
  if (with_country) {
    region <- factor(
      c(
        unique(dat$region[dat$geo_group == geo_group]),
        unique(dat$region[dat$geo_group == "country"])
      ),
      levels = levels(dat$region)
    )

    region <- as.character(sort(region))
  } else {
    region <- factor(
      unique(dat$region[dat$geo_group == geo_group]),
      levels = levels(dat$region)
    )

    region <- as.character(sort(region))
  }

  region
}
