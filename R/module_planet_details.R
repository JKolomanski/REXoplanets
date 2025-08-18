#' Module Displaying Planet Details
#' @name module_planet_details
#' @details
#' This module provides a dynamically refreshing table component
#' for displaying basic information about a planet.
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_planet_details UI function for the planet details module.
#' @export
planet_details_ui = function(id) {
  ns = shiny::NS(id)
  shiny::uiOutput(ns("planet_info"))
}

#' @param id A unique identifier for the module.
#' @param planet_info
#' A reactive expression returning a data frame with information about the planet.
#' @describeIn module_planet_details server function for the planet details module.
#' @export
planet_details_server = function(id, planet_info) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized")

    output$planet_info = shiny::renderUI({
      shiny::req(planet_info())
      # Check for present data to avoid "subscript out of bounds"
      # Error when changing star systems
      shiny::req(nrow(planet_info()) > 0)

      create_value_box_grid(planet_info())
    })
  })
}
