describe("calculate_stellar_flux", {
  it("calculates stellar flux correctly and fills NA in pl_insol", {
    test_df = data.frame(
      objectid = c(1, 2, 3),
      st_lum = c(-0.1, 0.3, 1),
      pl_orbsmax = c(1, 2, 1.5),
      pl_insol = c(NA, 0.3, NA)
    )

    expected_sf = c(
      10^(-0.1) / 1^2,
      0.3, # Already present, should be unchanged
      10^(1) / 1.5^2
    )

    result = calculate_stellar_flux(test_df, log = TRUE, unit = "relative")

    expect_equal(result$pl_insol, expected_sf, tolerance = 1e-6)
  })

  it("calculates stellar flux correctly with linear luminosity (log = FALSE)", {
    test_df = data.frame(
      objectid = c(1, 2, 3),
      st_lum = c(0.8, 0.3, 2),
      pl_orbsmax = c(1, 2, 1.5),
      pl_insol = c(NA, 0.3, NA)
    )

    expected_sf = c(
      0.8 / 1^2,
      0.3,
      2 / 1.5^2
    )

    result = calculate_stellar_flux(test_df, log = FALSE, unit = "relative")

    expect_equal(result$pl_insol, expected_sf, tolerance = 1e-6)
  })

  it("calculates stellar flux correctly in W/m² (unit = 'wm2')", {
    test_df = data.frame(
      objectid = c(1, 2, 3),
      st_lum = c(-0.1, 0.3, 1),
      pl_orbsmax = c(1, 2, 1.5),
      pl_insol = c(NA, 400, NA)
    )

    solar_const = 1361
    expected_sf = c(
      (10^(-0.1) / 1^2) * solar_const,
      400,
      (10^(1) / 1.5^2) * solar_const
    )

    result = calculate_stellar_flux(test_df, log = TRUE, unit = "wm2")

    expect_equal(result$pl_insol, expected_sf, tolerance = 1e-6)
  })


  it("throws an error if input is not a data frame", {
    expect_error(
      calculate_stellar_flux(""),
      "Data must be a `data.frame`."
    )
  })

  it("returns NULL if input has zero rows", {
    test_df = data.frame()

    expect_warning(
      calculate_stellar_flux(test_df),
      "Empty data."
    )
  })

  it("throws an error if input does not contain required columns", {
    test_df = data.frame(objectid = c(1, 2, 3))

    expect_error(
      calculate_stellar_flux(test_df),
      "Invalid data provided. Missing columns: st_lum, pl_orbsmax"
    )
  })
})
