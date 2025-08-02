describe("get_star_spectral_type", {
  it("correctly classifies a star", {
    test_st_teff = 5778
    expected = "G"
    expect_equal(get_star_spectral_type(test_st_teff), expected)
  })

  it("throws and error if input is not numeric", {
    test_st_teff = ""
    expect_error(
      get_star_spectral_type(test_st_teff),
      "st_teff.*numeric"
    )
  })

  it("throws a warning when input exceedes the expected bounds", {
    test_st_teff = 1500
    expected = "M"

    expect_warning({
                    result = get_star_spectral_type(test_st_teff
                    )}, "`st_teff` exceedes expected bounds:*"
    )
    expect_equal(result, expected)
  })
})
