describe("scatterplot_esi", {
  it("throws an error when input data is not a data frame", {
    test_data = ""
    expect_error(
      scatterplot_esi(test_data),
      "Assertion on 'data' failed: Must be of type 'data\\.frame'*"
    )
  })

  it("throws an error when data_limits is not a numeric vector of length 2", {
    test_data = data.frame(
      "pl_insol" = c(1, 2, 3),
      "pl_rade" = c(1, 2, 3),
      "esi" = c(1, 2, 3)
    )
    test_data_limits = c(1)

    expect_error(
      scatterplot_esi(test_data, test_data_limits),
      "Assertion on 'data_limits' failed: *"
    )
  })

  it("throws an error when input is missing columns", {
    test_data = data.frame(
      "pl_insol" = c(1, 2, 3),
      "pl_rade" = c(1, 2, 3)
    )
    expect_error(
      scatterplot_esi(test_data),
      "*\\{'pl_insol','pl_rade','esi'\\}, but is missing elements \\{'esi'\\}\\."
    )
  })
})
