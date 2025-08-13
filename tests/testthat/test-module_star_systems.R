#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

describe("module_star_systems", {
  it("starts up without errors and displays UI template", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = star_systems_ui("test_module"),
        server = function(input, output, session) {
          star_systems_server("test_module", shiny::reactive(closest_50_exoplanets))
        }
      ),
    )

    html = app$get_html("body")
    expect_true(grepl('<div class="card-header">System map</div>', html))
    expect_true(grepl('<div class="card-header">Planet details</div>', html))
    expect_true(grepl('<div class="card-header">System info</div>', html))
    expect_true(grepl('<div class="card-header">Legend</div>', html))
  })
})
