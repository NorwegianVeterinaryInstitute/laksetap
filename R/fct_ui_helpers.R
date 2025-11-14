#' select_year
#'
#' @description Function to return a vector of years to be rendered in the UI.
#' Years are hardcoded for now.
#' Monthly data resolution has data from the current year,
#' yearly data resolution has data up to last full year.
#'
#' @param id id for the selectInput
#' @param multiple TRUE/FALSE for multiple selection
#' @param resolution "m" for monthly data, "y" for yearly data
#'
#' @returns a vector to be used in selectInput
#'
#' @noRd
select_year <- function(id, dat, multiple = F) {
  labels <- golem::get_golem_options(which = "labels")

  if (multiple) {
    text = labels$functions$select_multiple_years
  } else {
    text = labels$functions$select_year
  }

  years_available <- sort(unique(dat$year), decreasing = TRUE)
  names(years_available) <- as.character(years_available)

  selectInput(
    id,
    text,
    choices = years_available,
    selected = max(years_available),
    multiple = multiple
  )
}

#' select_months
#'
#' @description Function to return a vector of months to be rendered in the UI.
#'
#' @param id id for the selectInput
#' @param digit TRUE/FALSE for month as digits or text
#' @param multiple TRUE/FALSE for multiple selection
#'
#' @returns a vector to be used in selectInput
#'
#' @noRd
select_months <- function(id, digit = F, multiple = T) {
  labels <- golem::get_golem_options(which = "labels")
  months_abbv <- get_month_abbrev("nb_NO.UTF-8")
  months_digit <- formatC(1:12, width = 2, flag = "0")

  names(months_digit) <- months_abbv

  if (digit) {
    shiny::selectInput(
      id,
      labels$functions$select_month,
      months_digit,
      selected = months_digit[[1]],
      multiple = multiple
    )
  } else {
    selectInput(
      id,
      labels$functions$select_multiple_months,
      months_abbv,
      selected = months_abbv[[1]],
      multiple = multiple
    )
  }
}


#' get_month_abbrev
#' @description Function to get abbreviated month names in a specific locale
#'
#' @param locale for example nb_NO.UTF-8
#'
#' @returns a vector abbreviated month names
#'
#' @noRd
get_month_abbrev <- function(locale) {
  Sys.setlocale("LC_TIME", locale)
  months <- format(as.Date(paste0("2023-", 1:12, "-01")), "%b")
  return(months)
}
