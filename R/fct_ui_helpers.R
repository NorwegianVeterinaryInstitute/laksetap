#' select_year
#'
#' Function to return a vector of years to be rendered in the UI.
#' Years are hardcoded for now.
#' Monthly data resolution has data from the current year,
#' yearly data resolution has data up to last full year.
#'
#' @param id id for the selectInput
#' @param multiple TRUE/FALSE for multiple selection
#' @param resolution "m" for monthly data, "y" for yearly data
#'
#' @returns a vector to be used in selectInput
select_year <- function(id, dat, multiple = F) {
  if (multiple) {
    text = "Velg flere år:"
  } else {
    text = "Velg år:"
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
#' Function to return a vector of months to be rendered in the UI.
#'
#' @param id id for the selectInput
#' @param digit TRUE/FALSE for month as digits or text
#' @param multiple TRUE/FALSE for multiple selection
#'
#' @returns a vector to be used in selectInput

select_months <- function(id, digit = F, multiple = T) {
  
  months_abbv <- get_month_abbrev("nb_NO.UTF-8")
  months_digit <- c("01", "02", "03", "04", "05", "06",
                    "07", "08", "09", "10", "11", "12")
  
  names(months_digit) <- months_abbv
  
  if (digit) {
    shiny::selectInput(
      id,
      "Velg måned:",
     months_digit,
      selected = months_digit[[1]],
      multiple = multiple
    )
  } else {
    selectInput(
      id,
      "Velg flere måneder:",
      months_abbv,
      selected = months_abbv[[1]],
      multiple = multiple
    )
  }
}

# Function to get abbreviated month names in a specific locale
get_month_abbrev <- function(locale) {
  Sys.setlocale("LC_TIME", locale)
  months <- format(as.Date(paste0("2023-", 1:12, "-01")), "%b")
  return(months)
}
