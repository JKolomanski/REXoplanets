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
  shiny::tagList(
    reactable::reactableOutput(ns("planet_info_row_1")),
    reactable::reactableOutput(ns("planet_info_row_2")),
    reactable::reactableOutput(ns("planet_info_row_3"))
  )
}

#' @param id A unique identifier for the module.
#' @param planet_info
#' A reactive expression returning a data frame with information about the planet.
#' @describeIn module_planet_details server function for the planet details module.
#' @export
planet_details_server = function(id, planet_info) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized")

    .create_reactable_part(output, "planet_info_row_1", planet_info, 1:4)
    .create_reactable_part(output, "planet_info_row_2", planet_info, 5:8)
    .create_reactable_part(output, "planet_info_row_3", planet_info, (last_col() - 3):last_col())
  })
}
