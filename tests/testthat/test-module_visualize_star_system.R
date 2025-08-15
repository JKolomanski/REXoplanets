#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

options(shiny.testmode = TRUE)

describe("module_visualize_star_system", {
  it("renders plot without errors", {
    test_data = data.frame(
      st_teff = c(5800, 4500, 3000),
      st_lum = c(1.0, 0.5, 0.05)
    )

    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = visualize_star_system_ui("test_star"),
        server = function(input, output, session) {
          visualize_star_system_server("test_star", shiny::reactive(test_data))
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Check if plot HTML is present
    plot_html = app$get_html("#test_star-system_plot")
    expect_true(plot_html != "")
  })
})
