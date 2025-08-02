describe("app", {
  it("starts up the application correctly", {
    app = shinytest2::AppDriver$new(app(run = FALSE))

    html = app$get_html("body")
    expect_true(grepl("REXoplanets application", html))
  })
})