#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  labels <- golem::get_golem_options(which = "labels")

  shiny::tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    shiny::tags$head(
      meta_block(),
      tag_manager(),
      shiny::tags$html(lang = "nb-NO")
    ),

    page_header(),

    shiny::tags$div(
      id = "main-content",
      role = "region",
      `aria-label` = "main",
      bslib::page_navbar(
        title = "",
        footer = tags$footer(
          shiny::tags$div(
            role = "region",
            `aria-label` = "footer",
            shiny::includeHTML(app_sys("app/www/footer.html"))
          ),
        ),
        id = "navbar",
        theme = bslib::bs_theme(primary = "#d7f4ff", version = 5),
        header = shiny::tagList(
          shiny::div(
            class = "container",
            style = "padding: 1.5rem;",
            shiny::uiOutput("tab_title"),
            shiny::tags$br(),
            mod_top_bar_ui("top_bar_1"),
          )
        ),

        #### Tab 1: top level tab monthly mortality ####
        bslib::nav_panel(
          labels$app_server$navbar_monthly_mortality,
          value = "monthly_mortality",
          mod_monthly_mortality_ui("monthly_mortality_1")
        ),
        #### Tab 2 top level tab cumulative yearly mortality ####
        bslib::nav_panel(
          labels$app_server$navbar_cumulative_mortality,
          value = "cumulative_mortality",
          mod_cumulative_mortality_ui("cumulative_mortality_1")
        ),
        #### Tab 3: Top level tab cohorts ####
        bslib::nav_panel(
          labels$app_server$navbar_prod_mortality,
          value = "prod_mortality",
          mod_cohort_mortality_ui("cohort_mortality_1")
        ),
        #### Tab 4: Top level tab for all losses ####
        bslib::nav_panel(
          labels$app_server$navbar_losses,
          value = "losses",
          mod_losses_ui("losses_1")
        ),
        #### Tab 5: Top level tab for about the app ####
        bslib::nav_panel(
          labels$app_server$navbar_about,
          value = "about",
          mod_about_ui("about_1")
        )
      )
    )
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
  labels <- golem::get_golem_options(which = "labels")

  add_resource_path(
    "www",
    app_sys("app/www")
  )

  shiny::tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = labels$app_ui$app_title
    )

    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
