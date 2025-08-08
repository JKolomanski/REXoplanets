describe("calculate_esi", {
  it("calculates ESI correctly for valid inputs", {
    expected1 = 1.0
    expected2 = 0.7993933
    expected3 = 0.2695072

    res1 = calculate_esi(1, 1)
    res2 = calculate_esi(0.6, 0.5)
    res3 = calculate_esi(14, 0.065)

    expect_equal(res1, expected1, tolerance = 1e-3)
    expect_equal(res2, expected2, tolerance = 1e-3)
    expect_equal(res3, expected3, tolerance = 1e-3)
  })

  it("calculates ESI correctly for single input", {
    expected = 0.8112416
    result = calculate_esi(0.53, weights = c(0.57))
    expect_equal(result, expected, tolerance = 1e-6)
  })

  it("throws error on non-numeric input", {
    expect_error(
      calculate_esi("a", 1),
      "Must be of type 'numeric'"
    )
    expect_error(
      calculate_esi(1, "b"),
      "Must be of type 'numeric'"
    )
  })

  it("throws error if input is negative", {
    expect_error(
      calculate_esi(-1, 1),
      ">= 0"
    )
    expect_error(
      calculate_esi(1, -1),
      ">= 0"
    )
  })

  it("throws error if weights length does not match arguments", {
    expect_error(
      calculate_esi(1, 2, weights = c(0.5)),
      "match the number of arguments"
    )
  })
})
