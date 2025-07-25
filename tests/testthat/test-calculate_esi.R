describe("calculate_esi", {
  it("calculates esi value correctly per planet", {
    # Arrange
    test_df = data.frame(
      objectid = c(1, 2, 3),
      st_lum = c(-2, -0.1, 1),
      pl_orbsmax = c(0.5, 3.5, 1),
      pl_insol = c(0.5, NA, 1),
      pl_rade = c(0.6, 14, 1)
    )

    expected_df = data.frame(
      objectid = c(1, 2, 3),
      esi = c(0.799393328, 0.269507240, 1.0000000)
    )

    # Act
    result = calculate_esi(test_df)

    # Assert
    expect_equal(nrow(result), nrow(expected_df))
    expect_equal(result$esi, expected_df$esi)
  })

  it("throws an error if input is not a data frame", {
    expect_error(
      calculate_esi(""),
      "calculate_esi data must be a `data.frame`"
    )
  })

  it("returns empty data frame if input has zero rows", {
    test_df = data.frame()

    expect_warning(
      calculate_esi(test_df),
      "Empty calculate_esi data"
    )
  })

  it("throws an error if input does not contain required columns", {
    test_df = data.frame(objectid = c(1, 2, 3))

    expect_error(
      calculate_esi(test_df),
      "Invalid data provided. Missing columns: st_lum, pl_orbsmax, pl_rade, pl_insol"
    )
  })
})
