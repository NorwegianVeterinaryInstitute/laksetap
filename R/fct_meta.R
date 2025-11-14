#' meta_block
#'
#' @description Meta block for the app
#'
#' @noRd
meta_block <- function() {
  labels <- golem::get_golem_options(which = "labels")
  config <- golem::get_golem_options(which = "config")

  metathis::meta() |>
    metathis::meta_social(
      title = labels$meta$title,
      description = labels$meta$description,
      url = config$meta$url,
      image = config$meta$image,
      image_alt = labels$meta$image_alt
    )
}

#' tag_manager
#'
#' @description Tag manager for usage tracking
#'
#' @noRd
tag_manager <- function() {
  shiny::tags$head(shiny::HTML(
    '<!-- Seeds Consulting Tag Manager -->
      <script>
        var _mtm = (window._mtm = window._mtm || []);
        _mtm.push({ "mtm.startTime": new Date().getTime(), event: "mtm.Start" }); 
        (function () {
          var d = document,
            g = d.createElement("script"),
            s = d.getElementsByTagName("script")[0];
          g.async = true;
          g.src = "https://stats.vetinst.no/js/container_R9v9ZduS.js";
          s.parentNode.insertBefore(g, s);
        })();
      </script>
      <!-- End Seeds Consulting Tag Manager -->'
  ))
}
