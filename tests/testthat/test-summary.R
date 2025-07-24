describe("summarize_star_occurances", {
  it("summarizes planet occurances correctly per star", {
    # Arrange
    test_df = data.frame(
      kepoi_name = c("a", "a", "a", "b", "b", "c")
    )

    expected_df = data.frame(
      Star = c("a", "b", "c"),
      Count = c(3, 2, 1)
    )

    # Act
    result = summarize_star_occurances(test_df)

    # Assert
    expect_equal(nrow(result), 3)
    expect_equal(result$Count, c(3, 2, 1))
  })

  it("returns empty data frame if input data has zero rows", {
    test_df = data.frame()

    expect_warning(
      summarize_star_occurances(test_df),
      "Empty exoplanets data"
    )

    result = suppressWarnings(summarize_star_occurances(test_df))

    expect_equal(nrow(result), 0)
    expect_equal(names(result), c("Star", "Count"))
  })

  it("throws an error if input is not a data frame", {
    expect_error(
      summarize_star_occurances(""),
      "Exoplanets data must be a `data.frame`"
    )
  })

  it("throws an error if input does not contain required columns", {
    expect_error(
      summarize_star_occurances(data.frame(Star = c(1, 2, 3))),
      "Exoplanets data must contain `kepoi_name` column."
    )
  })
})
