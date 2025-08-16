#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

options(shiny.testmode = TRUE)

describe("module_planet_details", {
  it("renders tables without errors", {
    test_data = as.data.frame(
      setNames(
        rep(list("some_value"), 12),
        paste0("testval", 1:12)
      )
    )

    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = planet_details_ui("test_planet"),
        server = function(input, output, session) {
          planet_details_server("test_planet", shiny::reactive(test_data))
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Check if plot HTML is present for all three rows
    plot_html = app$get_html("#test_planet-planet_info_row_1")
    expect_true(plot_html != "")

    plot_html = app$get_html("#test_planet-planet_info_row_2")
    expect_true(plot_html != "")

    plot_html = app$get_html("#test_planet-planet_info_row_3")
    expect_true(plot_html != "")
  })
})
