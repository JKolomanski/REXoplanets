#' Module Displaying Star System Info with Value Boxes (Two Rows)
#' @name module_system_info
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny UI object.
#' @describeIn module_system_info UI function for the system info module using value boxes.
#' @export
system_info_ui = function(id) {
  ns = shiny::NS(id)
  shiny::uiOutput(ns("system_info"))
}

#' @param id A unique identifier for the module.
#' @param system_info
#' A reactive expression returning a data frame with information about the system.
#' @describeIn module_system_info Server function for the system info module using value boxes.
#' @export
system_info_server = function(id, system_info) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized")

    output$system_info = shiny::renderUI({
      shiny::req(system_info())

      create_value_box_grid(system_info())
    })
  })
}
