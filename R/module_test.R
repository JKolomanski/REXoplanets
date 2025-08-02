#' Test module
#' @name module_test
#' @details
#' This is just a test module for reference for further development.
NULL

#' @param id A unique identifier for the module.
#' @returns A Shiny `UI` object.
#' @importFrom shiny NS div
#' @describeIn module_test `UI` function for the module.
#' @export
test_ui = function(id) {
  ns = NS(id)

  div(
    "Test module body"
  )
}

#' @param id A unique identifier for the module.
#' @returns A Shiny server module.
#' @importFrom shiny moduleServer
#' @describeIn module_test Server function for the module.
#' @export
test_server = function(id) {
  moduleServer(id, function(input, output, session) {
    message("Test module server initialized.")
  })
}
