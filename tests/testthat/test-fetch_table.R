describe("fetch_table", {
  it("performs simple fetch and returns a data frame", {
    mock_data = function(req) {
      response(
        status_code = 200,
        body = charToRaw("
          pl_name,pl_rade,pl_insol,esi\nPlanetA,1.0,1.0,0.9\nPlanetB,1.2,0.8,0.85
        ")
      )
    }
    with_mocked_responses(
      mock_data,
      {
        result = fetch_table("ps")
        expect_true(is.data.frame(result))
        expect_equal(nrow(result), 2)
        expect_equal(ncol(result), 4)
        expect_equal(colnames(result), c("pl_name", "pl_rade", "pl_insol", "esi"))
        expect_equal(result$pl_name, c("PlanetA", "PlanetB"))
      }
    )
  })

  # TODO: Extend these tests and cover more code responses.
  it("throws an error for non-200 response", {
    mock_data = function(req) {
      response(status_code = 404, body = charToRaw("Not Found"))
    }
    with_mocked_responses(
      mock_data,
      {
        expect_error(fetch_table("ps"), "*.404 Not Found")
      }
    )
  })
})
