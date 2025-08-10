#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

options(shiny.testmode = TRUE)

describe("module_search", {
  it("starts up without errors and displays correct UI", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = search_ui("test_module", random = TRUE),
        server = function(input, output, session) {
          choices = shiny::reactive(c("Choice 1", "Choice 2", "Choice 3"))
          search_server("test_module", choices)
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Check if select HTML is present #
    select_html = app$get_html("#test_module-select")
    expect_true(select_html != "")

    # Check if random button HTML is present #
    button_html = app$get_html("#test_module-random")
    expect_true(button_html != "")

    # Check if option is available for selection #
    app$set_inputs(`test_module-select` = "Choice 1", wait_ = FALSE)
    option_value = app$get_value(input = "test_module-select")
    expect_equal(option_value, "Choice 1")
  })

  it("returns appropriate value when selected", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = search_ui("test_module"),
        server = function(input, output, session) {
          choices = shiny::reactive(c("Choice 1", "Choice 2", "Choice 3"))
          selected_val = search_server("test_module", choices)
          shiny::exportTestValues(selected_val = {selected_val()}) # nolint
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Select a choice and make sure returned value is the same #
    app$set_inputs(`test_module-select` = "Choice 2")
    vals = app$get_values(export = TRUE)
    expect_equal(vals$export$selected_val, "Choice 2")
  })

  it("returns random value when button is pressed", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = search_ui("test_module", random = TRUE),
        server = function(input, output, session) {
          choices = shiny::reactive(c("Choice 1", "Choice 2", "Choice 3"))
          selected_val = search_server("test_module", choices)
          shiny::exportTestValues(selected_val = {selected_val()}) # nolint
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Select a choice and make sure returned value is the same #
    app$click(selector = "#test_module-random")
    app$wait_for_idle(500)
    vals = app$get_values(export = TRUE)
    expect_false(vals$export$selected_val == "")

  })
})
