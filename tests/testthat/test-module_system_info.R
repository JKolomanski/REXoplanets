#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

options(shiny.testmode = TRUE)

describe("module_system_info", {
  it("renders table without errors", {
    test_data = data.frame(
      "Host Name" = c("ABC"),
      "Distance [pc]" = c(1.5),
      "Number of Stars" = c(1),
      "Number of Planets" = c(1),
      "Stellar spectral class" = c("K"),
      "Stellar Radius [Solar Radius]" = c(0.5),
      "Stellar Mass [Solar mass]" = c(0.509),
      "Stellar Luminosity [log(Solar)]" = c(-1.553)
    )

    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = system_info_ui("test_info"),
        server = function(input, output, session) {
          system_info_server("test_info", shiny::reactive(test_data))
        }
      )
    )

    # Wait longer for the reactive updates to complete #
    app$wait_for_idle(500)

    # Check if plot HTML is present for both rows
    plot_html = app$get_html("#test_info-system_info_row_1")
    expect_true(plot_html != "")

    plot_html = app$get_html("#test_info-system_info_row_2")
    expect_true(plot_html != "")
  })
})
