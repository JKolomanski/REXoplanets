describe("calculate_stellar_flux", {
  it("returns precomputed pl_insol if provided", {
    result = calculate_stellar_flux(st_lum = 1, pl_orbsmax = 1, pl_insol = 5)
    expect_equal(result, 5)
  })

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

  it("returns NA and warns when st_lum is missing", {
    expect_warning({
      result = calculate_stellar_flux(st_lum = NA, pl_orbsmax = 1)
      expect_true(is.na(result))
    }, "Missing arguments: st_lum")
  })

  it("returns NA and warns when pl_orbsmax is missing", {
    expect_warning({
      result = calculate_stellar_flux(st_lum = 1, pl_orbsmax = NA)
      expect_true(is.na(result))
    }, "Missing arguments: pl_orbsmax")
  })

  it("returns NA and warns when both st_lum and pl_orbsmax are missing", {
    expect_warning({
      result = calculate_stellar_flux(st_lum = NA, pl_orbsmax = NA)
      expect_true(is.na(result))
    }, "Missing arguments: st_lum, pl_orbsmax")
  })
})
