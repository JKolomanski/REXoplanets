describe("calculate_esi", {
  it("calculates ESI correctly for valid inputs", {
    expected1 = 1.0
    expected2 = 0.7993933
    expected3 = 0.2695072

    res1 = calculate_esi(radius = 1, flux = 1)
    res2 = calculate_esi(radius = 0.6, flux = 0.5)
    res3 = calculate_esi(radius = 14, flux = 0.065)

    expect_equal(res1, expected1, tolerance = 1e-3)
    expect_equal(res2, expected2, tolerance = 1e-3)
    expect_equal(res3, expected3, tolerance = 1e-3)
  })

  it("calculates ESI correctly for single input", {
    expected = 0.8112416
    result = calculate_esi(radius = 0.53, radius_w = 0.57)
    expect_equal(result, expected, tolerance = 1e-3)
  })

  it("throws error on non-numeric input", {
    expect_error(
      calculate_esi(radius = "a", flux = 1),
      "Must be of type 'numeric'"
    )
    expect_error(
      calculate_esi(radius = 1, flux = "b"),
      "Must be of type 'numeric'"
    )
  })

  it("throws error if input is negative", {
    expect_error(
      calculate_esi(radius = -1, flux = 1),
      ">= 0"
    )
    expect_error(
      calculate_esi(radius = 1, flux = -1),
      ">= 0"
    )
  })

  it("shows warning when a value is missing a weight", {
    expect_warning(
      calculate_esi(mass = 1, flux = 1, flux_w = 0.7),
      "No matching weights for values"
    )
  })

  it("shows warning when a weight is missing a value", {
    expect_warning(
      calculate_esi(radius = 1, radius_w = 0.57, mass_w = 0.7),
      "Weights without matching values"
    )
  })
})
