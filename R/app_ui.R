#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    div(
      class = "d-flex flex-column p-4 gap-3", 
      style = "background-color: #d7f4ff",
      shiny::tags$div(class = "logo-wrapper",
                      shiny::tags$a(href = "#main-content", class = "skip-link", "Hopp til hovedinnhold"),
                      shiny::tags$a(
                        href = "https://www.vetinst.no/",
                        style = "height:64px;", 
                        div(class = "container",
                            tags$img(
                              src = app_sys("app/www/vetinst-logo-no.svg"),
                              alt = "Veterinærinstituttets logo",
                              style = "height:64px;",
                            ))
                      ),
      ),
      div(class = "container",style = "background-color:#d7f4ff;", #padding-left:15px;",
          shiny::tags$div(role="region", `aria-label`= "App Title",
                          shiny::tags$h1(
                            "Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen",
                            role = "heading",
                            `aria-label` = "1",
                          ),
                          shiny::includeMarkdown(app_sys("app/www/header_text.md"))
          )))
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(rel = "shortcut icon", resources_path = app_sys("app/www"), ico =  "favicon.png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "laksetap"
    ),
    head_block(),
    meta_block(),
    tag_manager()
    
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
