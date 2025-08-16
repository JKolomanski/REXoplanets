#' Module Displaying Star System Info
#' @name module_system_info
#' @details
#' This module provides a dynamically refreshing table component
#' for displaying basic information about a star system.
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_system_info UI function for the system info module.
#' @export
system_info_ui = function(id) {
  ns = shiny::NS(id)
  shiny::tagList(
    reactable::reactableOutput(ns("system_info_row_1")),
    reactable::reactableOutput(ns("system_info_row_2"))
  )
}

#' @param id A unique identifier for the module.
#' @param system_info
#' A reactive expression returning a data frame with information about the system.
#' @describeIn module_system_info server function for the system info module.
#' @export
system_info_server = function(id, system_info) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized")

    .create_reactable_part(output, "system_info_row_1", system_info, 1:4)
    .create_reactable_part(output, "system_info_row_2", system_info, (last_col() - 3):last_col())

  })
}
