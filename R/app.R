#' Function responsible for initializing and running the REXoplanets shiny application.
#' @param ... Additional arguments passed to `shiny::runApp()`.
#' @param run If true, runs the application. If false, returns an app object.
#' @return App object.
#' @export
app = function(..., run = TRUE) {
  check_app_dependencies()

  ui = bslib::page_navbar(
    title = "REXoplanets",
    bslib::nav_panel(
      shiny::span(bsicons::bs_icon("house"), "Home"),
      shiny::h1("Welcome to REXoplanets"),
      shiny::p("This is the home page of the REXoplanets application.")
    ),
    bslib::nav_panel(
      shiny::span(bsicons::bs_icon("stars"), "Star Systems"),
      star_systems_ui("test_module")
    )
  )

  server = function(input, output, session) {
    message("REXoplanets application initialized.")

    star_systems_server("test_module")
  }

  app_obj = shiny::shinyApp(
    ui = ui,
    server = server
  )

  if (run) {
    shiny::runApp(app_obj, ...)
  } else {
    app_obj
  }
}

#' Checks if packages required for shiny application are installed on user machine. If not,
#' asks if the user wants to install them. If yes, installs the packages using `pak`.
#' @importFrom purrr keep
#' @importFrom utils install.packages
#' @noRd
#' @keywords internal
check_app_dependencies = function() {
  APP_PACKAGES = c(
    "bsicons",
    "bslib",
    "htmltools",
    "shiny",
    "shinyjs"
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
      requireNamespace("pak", quietly = TRUE)
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
