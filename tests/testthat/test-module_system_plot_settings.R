#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

options(shiny.testmode = TRUE)

describe("module_system_plot_settings", {
  it("starts up without errors and displays correct UI", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = system_plot_settings_ui("test_module"),
        server = function(input, output, session) {
          system_plot_settings_server("test_module")
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Check if check box HTML is present #
    select_html = app$get_html("#test_module-show_hz")
    expect_true(select_html != "")
  })

  it("returns appropriate value when checkbox is toggled", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = system_plot_settings_ui("test_module"),
        server = function(input, output, session) {
          show_hz = system_plot_settings_server("test_module")
          shiny::exportTestValues(show_hz = {show_hz()}) # nolint
        }
      )
    )

    # Wait for reactive updates
    app$wait_for_idle(500)

    # Initially unchecked, expect FALSE
    vals = app$get_values(export = TRUE)
    expect_false(vals$export$show_hz)

    # Toggle the checkbox to TRUE
    app$set_inputs(`test_module-show_hz` = TRUE)
    app$wait_for_idle(500)

    # Check that the reactive returned TRUE
    vals = app$get_values(export = TRUE)
    expect_true(vals$export$show_hz)

    # Toggle back to FALSE
    app$set_inputs(`test_module-show_hz` = FALSE)
    app$wait_for_idle(500)

    # Check that the reactive returned FALSE
    vals = app$get_values(export = TRUE)
    expect_false(vals$export$show_hz)
  })
})
