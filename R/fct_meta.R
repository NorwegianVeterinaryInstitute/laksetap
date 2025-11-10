#' meta_block 
#'
#' @description Meta block for the app
#'
#' @noRd
meta_block <- function() {
  metathis::meta() |>
    metathis::meta_social(
      title = "Laksetap: Statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen",
      description = "Utforsk interaktiv statistikk over tap og dødelighet av laks og regnbueørret i sjøfasen i Norge",
      url = "https://apps.vetinst.no/laksetap",
      image = "https://www.vetinst.no/_/image/5c4e853a-130b-4e7f-92a3-8ca38bec0b56:2dcf9428a329fc0044b412c55b8c9e471f742d65/block-1200-630/Logo-vetinst-open-graph-no-svg-1200x630.png.jpg",
      image_alt = "Veterinærinstituttets logo"
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