describe("calculate_star_habitable_zone", {
  it("Calculates star's habitable zone with logarithmic units", {
    test_st_lum = 0

    expected_st_lum = c(0.95, 1.37)

    expect_equal(calculate_star_habitable_zone(test_st_lum), expected_st_lum, tolerance = 1e-2)
  })

  it("Calculates star's habitable zone with linear units", {
    test_st_lum = 1

    expected_st_lum = c(0.95, 1.37)

    expect_equal(calculate_star_habitable_zone(test_st_lum, log_lum = FALSE),
                 expected_st_lum, tolerance = 1e-2)
  })
})
