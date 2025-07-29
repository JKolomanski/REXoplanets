describe("calculate_stellar_flux", {
  it("calculates stellar flux with logarithmic luminosity (default)", {
    result = calculate_stellar_flux(st_lum = 1, pl_orbsmax = 1)
    expected = 10
    expect_equal(result, expected)
  })

  it("calculates stellar flux with linear luminosity (log_lum = FALSE)", {
    result = calculate_stellar_flux(st_lum = 1, pl_orbsmax = 2, log_lum = FALSE)
    expected = 0.25
    expect_equal(result, expected)
  })

  it("calculates stellar flux with unit = 'wm2'", {
    result = calculate_stellar_flux(st_lum = 0, pl_orbsmax = 1, unit = "wm2")
    expected = 1361
    expect_equal(result, expected)
  })

  it("throws an error if input is the wrong type", {
    expect_error(
      calculate_stellar_flux(st_lum = "", pl_orbsmax = 1, unit = "wm2"),
      "st_lum.*numeric"
    )
  })

  it("throws an error if pl_orbsmax is less than 0", {
    expect_error(
      calculate_stellar_flux(st_lum = 1, pl_orbsmax = -1, unit = "wm2"),
      "is not >= 0."
    )
  })

  it("throws an error if unit is not in ('relative' or 'wm2')", {
    expect_error(
      calculate_stellar_flux(st_lum = 1, pl_orbsmax = 1, unit = "abc"),
      "unit.*Must be.*\\{'relative','wm2'\\}"
    )
  })
})
