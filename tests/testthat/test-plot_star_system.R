describe("plot_star_system", {
  it("returns a ggplot2 object", {
    test_data = data.frame(
      pl_orbsmax = c(1, 1.52, 6.00),
      pl_dens    = c(6.43, 3.93, 1.33),
      pl_rade    = c(1.000, 2.114, 10.000)
    )

    expect_s3_class(plot_star_system(test_data), "ggplot")
  })
})
