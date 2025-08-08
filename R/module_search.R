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