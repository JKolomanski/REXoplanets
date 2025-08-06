#' Star Systems Module
#' @name module_star_systems
#' @details
#' This module provides functionality for exploring star systems and their planets.
#' Provides a handy UI for selecting a star system. The star is visualized alongside its planets and
#' their orbits. The display provides basic information about the system itself, as well as
#' particular planets. A legend is available for the plot.
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_star_systems UI function for the module.
#' @export
star_systems_ui = function(id) {
  ns = shiny::NS(id)

  bslib::layout_sidebar(
    sidebar = shiny::tagList(
      shiny::h2("Options"),
      shiny::p("This is a placeholder for the star systems module options.")
    ),
    shiny::div(
      style = htmltools::css(
        "height" = "100%",
        "display" = "grid",
        "grid-template-columns" = "1fr 1fr",
        "grid-template-rows" = "3fr 1fr",
        "row-gap" = "0",
        "column-gap" = "1rem"
      ),
      bslib::card(
        bslib::card_header("Star System"),
        bslib::card_body(
          shiny::p("This is a placeholder for the star systems module content.")
        )
      ),
      bslib::card(
        bslib::card_header("Planet details"),
        bslib::card_body(
          shiny::p("This is a placeholder for the planet details.")
        )
      ),
      bslib::card(
        bslib::card_header("System info"),
        bslib::card_body(
          shiny::p("This is a placeholder for the results of the star systems module.")
        )
      ),
      bslib::card(
        bslib::card_header("Legend"),
        bslib::card_body(
          shiny::p("This area will display the legend for the plot")
        )
      )
    )
  )
}

#' @param id A unique identifier for the module.
#' @returns A Shiny server module.
#' @describeIn module_star_systems Server function for the module.
#' @export
star_systems_server = function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("Star systems module server initialized.")
  })
}
