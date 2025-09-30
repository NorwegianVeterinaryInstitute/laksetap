#' page_header
#'
#' @description The header section of the page
#'
#'
#' @noRd
page_header <- function() {
  div(
    class = "d-flex flex-column p-4 gap-3",
    style = "background-color: #d7f4ff",
    shiny::tags$div(
      class = "logo-wrapper",
      shiny::tags$a(
        href = "#main-content",
        class = "skip-link",
        "Hopp til hovedinnhold"
      ),
      shiny::tags$a(
        href = "https://www.vetinst.no/",
        style = "height:64px;",
        div(
          class = "container",
          tags$img(
            src = "www/vetinst-logo-no.svg",
            alt = "Veterinærinstituttets logo",
            style = "height:64px;",
          )
        )
      ),
    ),
    div(
      class = "container",
      style = "background-color:#d7f4ff;", #padding-left:15px;",
      shiny::tags$div(
        role = "region",
        `aria-label` = "App Title",
        shiny::tags$h1(
          "Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen",
          role = "heading",
          `aria-label` = "1",
        ),
        shiny::includeMarkdown(app_sys("app/www/header_text.md"))
      )
    )
  )
}