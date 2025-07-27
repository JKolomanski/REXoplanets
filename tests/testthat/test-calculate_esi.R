describe("calculate_esi", {
  it("calculates ESI correctly for valid inputs", {
    expected1 = 1.0
    expected2 = 0.7993933
    expected3 = 0.2695072

    res1 = calculate_esi(1, 1)
    res2 = calculate_esi(0.6, 0.5)
    res3 = calculate_esi(14, 10^(-0.1) / 3.5^2)

    expect_equal(res1, expected1, tolerance = 1e-6)
    expect_equal(res2, expected2, tolerance = 1e-6)
    expect_equal(res3, expected3, tolerance = 1e-6)
  })

  it("throws error on non-numeric input", {
    expect_error(
      calculate_esi("a", 1),
      "pl_rade.*numeric"
    )
    expect_error(
      calculate_esi(1, "b"),
      "pl_insol.*numeric"
    )
  })

  it("throws error if input is -1", {
    expect_error(
      calculate_esi(-1, 1),
      "cannot be -1"
    )
    expect_error(
      calculate_esi(1, -1),
      "cannot be -1"
    )
  })
})
