describe("trim_ps_table", {
  it("returns data frame with exactly 20 columns", {
trimmed_data = trim_ps_table(closest_50_exoplanets)
expect_equal(ncol(trimmed_data), 20)
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
