describe("scatterplot_esi", {
  it("throws an error when input is not a data frame", {
    test_data = ""
    expect_error(
      scatterplot_esi(test_data),
      "Assertion on 'data' failed: Must be of type 'data\\.frame'*"
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
