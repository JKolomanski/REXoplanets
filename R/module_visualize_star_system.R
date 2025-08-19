#' Module Visualizing Star Systems
#' @name module_visualize_star_system
#' @details
#' This module provides a dynamically refreshing plot component
#' for visualizing star systems based on data provided
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_visualize_star_system UI function for the system mapping module.
#' @export
visualize_star_system_ui = function(id) {
  ns = shiny::NS(id)
  shiny::plotOutput(ns("system_plot"))
}

#' @param id A unique identifier for the module.
#' @param plot_data A reactive expression returning a data frame with information about the system.
#' @param show_hz A reactive boolean expression determining whether to show habitable zone.
#' @param show_legend A reactive boolean expression determining whether to show plot legend.
#' @describeIn module_visualize_star_system server function for the system mapping module.
#' @export
visualize_star_system_server = function(id, plot_data, show_hz, show_legend) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} rendering star system plot")

    output$system_plot = shiny::renderPlot({
      shiny::req(plot_data())

      hz = c(0, 0)
      if (show_hz()) {
        hz = calculate_star_habitable_zone(plot_data()[["st_lum"]][1])
      }

      plot_star_system(
        plot_data(),
        spectral_type = classify_star_spectral_type(plot_data()[["st_teff"]][1]),
        habitable_zone = hz,
        show_legend = show_legend()
      )
    })
  })
}
