describe("calculate_esi", {
  it("calculates ESI correctly for valid inputs", {
    # Earth-like planet
    expect_equal(
      calculate_esi(1, 1),
      1.0,
      tolerance = 1e-6
    )

    expect_equal(
      calculate_esi(0.6, 0.5),
      0.7993933,
      tolerance = 1e-6
    )

    expect_equal(
      calculate_esi(14, 10^(-0.1) / 3.5^2),
      0.2695072,
      tolerance = 1e-6
    )
  })

  it("throws error when pl_rade or pl_insol is NA", {
    expect_error(
      calculate_esi(NA, 1),
      "Missing arguments: pl_rade"
    )
    expect_error(
      calculate_esi(1, NA),
      "Missing arguments: pl_insol"
    )
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
