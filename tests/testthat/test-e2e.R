#' App driver from `shinytest2` has issues with stability when running from
#' inside R CMD check - we are skipping the tests in that scenario.
#' The tests will still run correctly when `devtools::test()` is called.
if (!identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), ""))
  skip("Skipping app tests on R CMD check.")

describe("app", {
  it("starts up the application correctly", {
    app = shinytest2::AppDriver$new(app(run = FALSE))

    html = app$get_html("body")
    expect_true(grepl("REXoplanets application", html))
  })
})
