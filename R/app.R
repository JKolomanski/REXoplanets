#'
#' @import shiny shinyjs bslib
app = function(...) {
  check_app_dependencies()

  ui = bslib::page_sidebar(
    title = "REXoplanets application",
    sidebar = bslib::sidebar(
      "Sidebar goes here"
    ),
    "Main app body",
    shinyjs::useShinyjs()
  )

  server = function(input, output, session) {
    message("REXoplanets application initialized.")
  }

  shiny::shinyApp(
    ui = ui,
    server = server
  ) |>
    shiny::runApp(...)
}

#' Checks if packages required for shiny application are installed on user machine. If not,
#' asks if the user wants to install them. If yes, installs the packages using `pak`.
#' @importFrom purrr keep
#' @noRd
#' @keywords internal
check_app_dependencies = function() {
  APP_PACKAGES = c(
    "shiny",
    "shinyjs",
    "bslib"
  )

  missing_packages = purrr::keep(APP_PACKAGES, \(dep) !requireNamespace(dep, quietly = TRUE))

  if (length(missing_packages) > 0) {
    msg = paste0(
      "The following packages are required for shiny application, but are missing:\n",
      paste0("    - ", missing_packages, collapse = "\n"), "\n",
      "Do you want to install them now? (yes/no): "
    )

    proceed = readline(msg)
    if (!assert_valid_answer(proceed)) {
      proceed = readline("Please answer with 'yes' or 'no': ")
    }
    if (!assert_valid_answer(proceed)) {
      stop("Unknown answer, aborting installation.")
    }

    if (assert_no(proceed)) {
      stop(
        "Shiny application cannot run without following packages:\n",
        paste0("    - ", missing_packages, collapse = "\n"), "\n",
        "Aborting application startup."
      )
    }

    if (!requireNamespace("pak", silently = TRUE)) {
      install.packages("pak")
    }

    pak::pak(missing_packages)
  }
}

#' @keywords internal
assert_valid_answer = function(answer) {
  valid_answers = c("yes", "no", "y", "n")
  tolower(answer) %in% valid_answers
}

#' @keywords internal
assert_no = function(answer) {
  no_answers = c("no", "n")
  tolower(answer) %in% no_answers
}
