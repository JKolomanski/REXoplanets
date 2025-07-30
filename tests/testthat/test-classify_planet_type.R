describe("classify_planet_type", {
  it("outputs correct planet code", {
    test_bmasse = 1
    test_eqt = 392
    test_orbeccen = 0.0112
    test_dens = 5.51

    expected_code = "EW0t"

    expect_equal(classify_planet_type(test_bmasse,
                                      test_eqt,
                                      test_orbeccen,
                                      test_dens), expected_code)
  })

  it("throws an error if one of the arguments is negative", {
    test_bmasse = -1
    test_eqt = 392
    test_orbeccen = 0.0112
    test_dens = 5.51

    expect_error(
      classify_planet_type(test_bmasse, test_eqt, test_orbeccen, test_dens),
      "Invalid data type. `pl_bmasse` must be `numeric` and larger than 0."
    )
  })

  it("throws an error if one of the arguments is the wrong type", {
    test_bmasse = ""
    test_eqt = 392
    test_orbeccen = 0.0112
    test_dens = 5.51

    expect_error(
      classify_planet_type(test_bmasse, test_eqt, test_orbeccen, test_dens),
      "Invalid data type. `pl_bmasse` must be `numeric` and larger than 0."
    )
  })

  it("displays a warning if pl_orbeccen is >= 1", {
    test_bmasse = 1
    test_eqt = 392
    test_orbeccen = 2
    test_dens = 5.51

    expect_warning(
      classify_planet_type(1, 1, 1, 5),
      "Eccentricity value >= 1"
    )
  })
})
