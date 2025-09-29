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
    shiny::tags$head(
      meta_block(),
      tag_manager(), 
      shiny::tags$html(lang = "nb-NO")
    ),
    
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
                              src = "www/vetinst-logo-no.svg",
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
          ))),
    shiny::tags$div(id = "main-content", role="region", `aria-label`= "main",
                    bslib::page_navbar(
                      title = "",
                      footer = tags$footer(
                        shiny::tags$div(role="region", `aria-label`= "footer",
                                        shiny::includeHTML(app_sys("app/www/footer.html"))),
                      ),
                      id = "navbar",
                      theme = bslib::bs_theme(primary = "#d7f4ff"),
                      header = shiny::tagList(
                        shiny::div(class = "container",
                                   style = "padding: 1.5rem;",
                                   shiny::uiOutput("tab_title"),
                                   shiny::tags$br(),
                                   shiny::uiOutput("top_bar"),
                        )),
                      
                      #### Tab 1: top level tab monthly mortality ####
                      bslib::nav_panel(
                        "Månedlig dødelighet %",
                        value = "monthly_mortality",  mod_monthly_mortality_ui("monthly_mortality_1"))
  )))
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

  shiny::tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Laksetap - Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen"
    )

    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}