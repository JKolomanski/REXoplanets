describe("trim_ps_table", {
  it("returns data frame with exactly 19 columns", {
    expect_equal(ncol(trim_ps_table(closest_50_exoplanets)), 19)
  })

  it("throws an error if required columns are missing", {
    test_df = data.frame(
      objectid = c(1, 2, 3)
    )

    expect_error(
      trim_ps_table(test_df),
      "Missing required columns: .*"
    )
  })
})
