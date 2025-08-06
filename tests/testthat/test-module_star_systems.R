describe("module_star_systems", {
  it("starts up without errors and displays UI template", {
    app = shinytest2::AppDriver$new(
      shiny::shinyApp(
        ui = star_systems_ui("test_module"),
        server = function(input, output, session) {
          star_systems_server("test_module")
        }
      ),
    )

    html = app$get_html("body")
    expect_true(grepl('<div class="card-header">Star System</div>', html))
    expect_true(grepl('<div class="card-header">Planet details</div>', html))
    expect_true(grepl('<div class="card-header">System info</div>', html))
    expect_true(grepl('<div class="card-header">Legend</div>', html))
  })
})