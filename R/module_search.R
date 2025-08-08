#' Search Module
#' @name module_search
#' @details
#' This module provides a reusable search component with a select input and optional randomize
#' button. It can be used to create searchable dropdowns with support for multiple selection and
#' random choice selection. The module handles updating choices dynamically and provides a reactive
#' value for the selected item(s).
NULL

#' @param id A unique identifier for the module.
#' @param label The label text for the select input.
#' @param multiple Whether to allow multiple selections (default: FALSE).
#' @param random Whether to show a randomize button (default: FALSE).
#' @returns A Shiny UI object.
#' @describeIn module_search UI function for the search module.
#' @export
search_ui = function(id, label = "Search...", multiple = FALSE, random = FALSE) {
  ns = shiny::NS(id)
  shiny::div(
    shiny::selectInput(
      ns("select"),
      label,
      multiple = multiple,
      choices = NULL,
    ),
    if (random) shiny::actionButton(ns("random"), "Randomize", width = "100%") else ""
  )
}

#' @param id A unique identifier for the module.
#' @param choices A reactive expression that returns a vector of choices for the select input.
#' @returns A reactive expression containing the selected value(s).
#' @describeIn module_search Server function for the search module.
#' @export
search_server = function(id, choices) {
  shiny::moduleServer(id, function(input, output, session) {
    logger::log_trace("{id} initialized.")

    shiny::observe({
      logger::log_trace("{id} updating choices.")
      shiny::updateSelectInput(
        inputId = "select",
        choices = c("", choices())
      )
    })

    shiny::observe({
      logger::log_trace("{id} randomizing choice.")
      shiny::updateSelectInput(
        inputId = "select",
        selected = sample(choices(), 1)
      )
    }) |>
      shiny::bindEvent(input$random)

    shiny::reactive(input$select)
  })
}