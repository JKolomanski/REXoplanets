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

    output$system_info_row_1 = reactable::renderReactable({
      shiny::req(system_info())

      system_info_row_1 = system_info() %>%
        dplyr::slice(1) %>%
        select(1:4)

      reactable::reactable(system_info_row_1, compact = TRUE)
    })

    output$system_info_row_2 = reactable::renderReactable({
      shiny::req(system_info())

      system_info_row_2 = system_info() %>%
        dplyr::slice(1) %>%
        select((ncol(.) - 3):ncol(.))

      reactable::reactable(system_info_row_2, compact = TRUE)
    })

  })
}
