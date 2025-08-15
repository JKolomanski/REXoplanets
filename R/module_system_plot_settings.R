#' System Plot Settings Module
#' @name module_system_plot_settings
#' @details
#' This module provides a series of controls to customize
#' the visible elements of a star system map
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_system_plot_settings UI function for the plot settings module.
#' @export
system_plot_settings_ui = function(id) {
  ns = shiny::NS(id)
  shiny::div(
    shiny::p("Plot settings"),
    shiny::checkboxInput(
      ns("show_hz"),
      "Show habitable zone"
    )
  )
}

#' @param id A unique identifier for the module.
#' @returns A reactive list object containing bool value wether to show the habitable zone.
#' @describeIn module_system_plot_settings function for the search module.
#' @export
system_plot_settings_server = function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized.")

    shiny::observe({
      logger::log_trace("{id} changed to: {input$show_hz}")
    }) |>
      shiny::bindEvent(input$show_hz)

    shiny::reactive(list(
      show_hz = input$show_hz
    ))
  })
}
