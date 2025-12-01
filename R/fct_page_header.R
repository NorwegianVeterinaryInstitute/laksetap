#' page_header
#'
#' @description The header section of the page
#'
#'
#' @noRd
page_header <- function() {
  labels <- golem::get_golem_options(which = "labels")
  config <- golem::get_golem_options(which = "config")

  div(
    class = "d-flex flex-column p-4 gap-3",
    style = "background-color: #d7f4ff",
    shiny::tags$div(
      class = "logo-wrapper",
      shiny::tags$a(
        href = "#main-content",
        class = "skip-link",
        labels$header$skip_link
      ),
      shiny::tags$a(
        href = "https://www.vetinst.no/",
        style = "height:64px;",
        div(
          class = "container",
          tags$img(
            src = config$header$image,
            alt = labels$meta$image_alt,
            style = "height:64px;",
          )
        )
      ),
    ),
    div(
      class = "container",
      style = "background-color:#d7f4ff;",
      shiny::tags$div(
        role = "region",
        `aria-label` = "App Title",
        shiny::tags$h1(
          labels$header$h1,
          role = "heading",
          `aria-label` = "1",
        ),
        shiny::includeMarkdown(app_sys("app/www/header_text.md"))
      )
    )
  )
}
