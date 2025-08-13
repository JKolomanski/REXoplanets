#' Module Visualizing Star Systems
#' @name module_visualize_star_system
#' @details
#' This module provides a dynamically refreshing plot component
#' for visualizing star systems based on data provided
NULL

visualize_star_system_ui = function(id) {
  ns = shiny::NS(id)
  shiny::plotOutput(ns("system_plot"))
}

visualize_star_system_server = function(id, plot_data) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} rendering star system plot")

    output$system_plot = shiny::renderPlot({
      req(plot_data())
      plot_star_system(plot_data())
    })
  })
}