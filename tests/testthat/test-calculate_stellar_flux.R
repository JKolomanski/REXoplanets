describe("calculate_stellar_flux", {
  it("calculates stellar flux with logarithmic luminosity (default)", {
    result = calculate_stellar_flux(st_lum = 1, pl_orbsmax = 1)
    expected = 10^1 / 1^2
    expect_equal(result, expected)
  })

  it("calculates stellar flux with linear luminosity (log_lum = FALSE)", {
    result = calculate_stellar_flux(st_lum = 1, pl_orbsmax = 2, log_lum = FALSE)
    expected = 1 / 2^2
    expect_equal(result, expected)
  })

  it("calculates stellar flux with unit = 'wm2'", {
    result = calculate_stellar_flux(st_lum = 0, pl_orbsmax = 1, unit = "wm2")
    expected = (10^0 / 1^2) * 1361
    expect_equal(result, expected)
  })
})
