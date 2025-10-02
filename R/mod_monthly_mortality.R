#' monthly_mortality UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import ggplot2
mod_monthly_mortality_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(
      class = "container",
      bslib::navset_tab(
        bslib::nav_panel(
          "Diagram",
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_mortality_month_plot")),
          plotly::plotlyOutput(ns("plot_mortality_month")),
          shiny::hr(),
          shiny::includeMarkdown(app_sys(
            "app/www/mortality_monthly_plot_footer.md"
          )),
        ),
        bslib::nav_panel(
          "Tabell",
          shiny::br(),
          shiny::uiOutput(ns("tab_filter_mortality_month_table")),
          shiny::div(
            DT::DTOutput(ns("table_mortality_month"))
          ),
          shiny::hr(),
          shiny::div(
            shiny::includeMarkdown(app_sys(
              "app/www/mortality_monthly_table_footer.md"
            ))
          )
        )
      )
    )
  )
}

#' monthly_mortality Server Functions
#'
#' @noRd
mod_monthly_mortality_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #### DATA ####
    mortality_rates_monthly_data <- getOption("mortality_rates_monthly_data")
    df_mort_month <-
      eventReactive(
        c(session$userData$species(), session$userData$geo_group()),
        {
          mortality_rates_monthly_data |>
            dplyr::filter(
              species == session$userData$species() &
                viz %in% c(session$userData$geo_group(), "all")
            )
        }
      )

    #### UI for tab mortality monthly ####
    plot_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "zone") {
        render_input_for_plot(ns = ns, dat = df_mort_month(), viz = "zone")
      } else if (session$userData$geo_group() == "fylke") {
        render_input_for_plot(ns = ns, dat = df_mort_month(), viz = "fylke")
      } else {
        render_input_for_plot(ns = ns, dat = df_mort_month(), viz = "all")
      }
    }) |>
      bindEvent(session$userData$geo_group())

    output$tab_filter_mortality_month_plot <- shiny::renderUI({
      plot_inputs_ui()
    }) |>
      bindEvent(plot_inputs_ui())

    table_inputs_ui <- shiny::reactive({
      if (session$userData$geo_group() == "zone") {
        output$tab_filter_mortality_month_table <-
          render_input_for_table(ns = ns, dat = df_mort_month(), viz = "zone")
      } else if (session$userData$geo_group() == "fylke") {
        output$tab_filter_mortality_month_table <-
          render_input_for_table(ns = ns, dat = df_mort_month(), viz = "fylke")
      } else {
        output$tab_filter_mortality_month_table <-
          render_input_for_table(ns = ns, dat = df_mort_month(), viz = "all")
      }
    })

    output$tab_filter_mortality_month_table <- shiny::renderUI({
      table_inputs_ui()
    }) |>
      bindEvent(table_inputs_ui())

    #### OUTPUTS ####

    #### Plot mortality monthly ####
    output$plot_mortality_month <- plotly::renderPlotly({
      req(df_mort_month())
      req(input$select_years_mortality_month)
      req(input$select_area_mortality_month_plot)
      p <- df_mort_month() |>
        dplyr::filter(year %in% input$select_years_mortality_month) |>
        dplyr::filter(area %in% c(input$select_area_mortality_month_plot)) |>
        # ribbon for norway - enabled:
        # dplyr::mutate(q1 = if_else(area == "Norge", NA, q1)) |>
        # dplyr::mutate(q3 = if_else(area == "Norge", NA, q3)) |>
        ggplot2::ggplot() +
        aes(
          x = date,
          y = median,
          group = area,
          text = paste0(
            "Median: ",
            round(median, 2),
            "<br>Q1: ",
            round(q1, 2),
            "<br>Q3: ",
            round(q3, 2)
          )
        ) +
        labs(x = "Måned", y = "Dødelighet (%)") +
        geom_line(aes(
          color = factor(area)
        )) +
        geom_ribbon(
          aes(
            ymin = .data$q1,
            ymax = .data$q3,
            fill = factor(area)
          ),
          linetype = 0,
          alpha = 0.1,
          show.legend = FALSE
        ) +
        theme_minimal() +
        scale_color_manual(values = my_palette_named) +
        scale_fill_manual(values = my_palette_named) +
        guides(
          col = guide_legend(title = "Område"),
          fill = "none"
        )

      plotly::ggplotly(p, tooltip = "text") |>
        plotly::layout(
          legend = list(
            orientation = "h", # horizontal
            x = 0.5,
            y = 1.1,
            xanchor = "center"
          )
        ) |>
        plotly::config(
          displaylogo = FALSE,
          modeBarButtons = list(list("toImage"))
        )
    })

    #### Table mortality monthly ####
    output$table_mortality_month <- DT::renderDT({
      req(session$userData$geo_group())
      req(input$select_years_mortality_month_table)
      req(input$select_months_mortality_month_table)
      dat <- df_mort_month() |>
        dplyr::filter(!is.na(median)) |>
        dplyr::filter(
          year %in% input$select_years_mortality_month_table,
          month_name %in% input$select_months_mortality_month_table
        ) |>
        dplyr::select(year, month_name, area, q1, median, q3) |>
        dplyr::mutate(
          q1 = round(q1, 2),
          median = round(median, 2),
          q3 = round(q3, 2)
        )

      if (session$userData$geo_group() != "all") {
        req(input$select_area_mortality_month)
        dat <- dat |> dplyr::filter(area %in% input$select_area_mortality_month)
      }

      DT::datatable(
        dat,
        rownames = F,
        colnames = c(
          "År",
          "Måned",
          "Område",
          "1 Kvartil %",
          "Median %",
          "3 Kvartil %"
        ),
        selection = (list(
          mode = "multiple",
          selected = "all",
          target = "column"
        )),
        options = list(
          sDom = '<"top">lrt<"bottom">ip',
          autoWidth = FALSE,
          scrollX = FALSE,
          language = list(
            url = "//cdn.datatables.net/plug-ins/2.0.1/i18n/no-NB.json"
          )
        )
      )
    })
  })
}

## To be copied in the UI
# mod_monthly_mortality_ui1("monthly_mortality_1")

## To be copied in the server
# mod_monthly_mortality_server("monthly_mortality_1")
