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


select_months <- function(id, multiple = T) {
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

# Static things

#### Colors ####
my_palette <- c("#FF5447", "#59CD8B", "#FFC6C2", "#1C4FB9")

my_palette_long <- c(
  "#FF5447",
  "#59CD8B",
  "#95D9F3",
  "#1C4FB9",
  "#FFC6C2",
  "#BCEED1",
  "#D7F4FF",
  "#C7D9FF",
  "#F7FDFF",
  "#091A3E",
  "#CC0E00",
  "#288550",
  "#1FC0FF",
  "#6892E8",
  "#BD990A",
  "#969FB1",
  "#D3DFF8",
  "#C0ECD3",
  "#0076A3",
  "#F5D34A"
)

my_palette_named <- c(
  "Norge" = "#FF5447",
  "Agder" = "#59CD8B",
  "Rogaland" = "#95D9F3",
  "Vestland" = "#1C4FB9",
  "Møre og Romsdal" = "#FFC6C2",
  "Trøndelag" = "#BCEED1",
  "Nordland" = "#D7F4FF",
  "Troms" = "#C7D9FF",
  "Finnmark" = "#091A3E",
  "1 & 2" = "#CC0E00",
  "3" = "#288550",
  "4" = "#1FC0FF",
  "5" = "#6892E8",
  "6" = "#BD990A",
  "7" = "#969FB1",
  "8" = "#D3DFF8",
  "9" = "#C0ECD3",
  "10" = "#0076A3",
  "11" = "#F5D34A",
  "12 & 13" = "#59CD8B"
)
