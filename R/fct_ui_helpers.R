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
select_year <- function(id, multiple = F, resolution = "m") {
  if (multiple) {
    text = "Velg flere år:"
  } else {
    text = "Velg år:"
  }

  if (resolution == "m") {
    selection <- c(
      "2025" = 2025,
      "2024" = 2024,
      "2023" = 2023,
      "2022" = 2022,
      "2021" = 2021,
      "2020" = 2020
    )

    selected <- c(2025)
  }

  if (resolution == "y") {
    selection <- c(
      "2024" = 2024,
      "2023" = 2023,
      "2022" = 2022,
      "2021" = 2021,
      "2020" = 2020
    )

    selected <- c(2024)
  }

  selectInput(
    id,
    text,
    selection,
    selected = selected,
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
  if (digit) {
    shiny::selectInput(
      id,
      "Velg måned:",
      c(
        "jan" = "01",
        "feb" = "02",
        "mar" = "03",
        "apr" = "04",
        "mai" = "05",
        "jun" = "06",
        "jul" = "07",
        "aug" = "08",
        "sep" = "09",
        "okt" = "10",
        "nov" = "11",
        "des" = "12"
      ),
      selected = c("01"),
      multiple = multiple
    )
  } else {
    selectInput(
      id,
      "Velg flere måneder:",
      c(
        "jan",
        "feb",
        "mar",
        "apr",
        "mai",
        "jun",
        "jul",
        "aug",
        "sep",
        "okt",
        "nov",
        "des"
      ),
      selected = c("jan"),
      multiple = multiple
    )
  }
}
