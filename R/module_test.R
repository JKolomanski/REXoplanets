#' This is a test moduel for boilerplate purposes.
#' @param id A unique identifier for the module.
#' @return A Shiny UI element.
#' @importFrom shiny NS div
#' @rdname test_module
test_ui = function(id) {
  ns = NS(id)

  div(
    "Test module body"
  )
}

#' This is a test server function for the test module.
#' @param id A unique identifier for the module.
#' @return A Shiny server function.
#' @importFrom shiny moduleServer
#' @rdname test_module
test_server = function(id) {
  moduleServer(id, function(input, output, session) {
    message("Test module server initialized.")
  })
}
