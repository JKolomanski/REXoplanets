describe("fetch_table", {
  it("performs simple fetch and returns a data frame", {
    mock_data = function(req) {
      httr2::response(
        status_code = 200,
        body = charToRaw("
          pl_name,pl_rade,pl_insol,esi\nPlanetA,1.0,1.0,0.9\nPlanetB,1.2,0.8,0.85
        ")
      )
    }
    httr2::with_mocked_responses(
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

  it("performs simple fetch with output format set to 'json'", {
    mock_data = function(req) {
      httr2::response(
        status_code = 200,
        body = charToRaw('[
          {
            "pl_name": "PlanetA",
            "pl_rade": 1.0,
            "pl_insol": 1.0,
            "esi": 0.9
          },
          {
            "pl_name": "PlanetB",
            "pl_rade": 1.2,
            "pl_insol": 0.8,
            "esi": 0.85
          }
        ]')
      )
    }
    httr2::with_mocked_responses(
      mock_data,
      {
        result = fetch_table("ps", format = "json")
        expect_true(is.list(result))
        expect_equal(length(result[[1]]), 2)
        expect_equal(length(result), 4)
        expect_equal(colnames(result), c("pl_name", "pl_rade", "pl_insol", "esi"))
        expect_equal(result$pl_name, c("PlanetA", "PlanetB"))
      }
    )
  })

  it("throws an error for 400 response", {
    mock_data = function(req) {
      httr2::response(status_code = 400, body = charToRaw("Bad Request"))
    }
    httr2::with_mocked_responses(
      mock_data,
      {
        expect_error(fetch_table("ps"), "*.Bad Request")
      }
    )
  })

  it("throws an error for 404 response", {
    mock_data = function(req) {
      httr2::response(status_code = 404, body = charToRaw("Not Found"))
    }
    httr2::with_mocked_responses(
      mock_data,
      {
        expect_error(fetch_table("ps"), "*.Not Found")
      }
    )
  })

  it("throws an error for 500 response", {
    mock_data = function(req) {
      httr2::response(status_code = 500, body = charToRaw("Internal Server Error"))
    }
    httr2::with_mocked_responses(
      mock_data,
      {
        expect_error(fetch_table("ps"), "*.Internal Server Error")
      }
    )
  })

  it("throws an error for 503 response", {
    mock_data = function(req) {
      httr2::response(status_code = 503, body = charToRaw("Service Unavailable"))
    }
    httr2::with_mocked_responses(
      mock_data,
      {
        expect_error(fetch_table("ps"), "*.Service Unavailable")
      }
    )
  })

  it("throws an error for 504 response", {
    mock_data = function(req) {
      httr2::response(status_code = 504, body = charToRaw("Gateway Timeout"))
    }
    httr2::with_mocked_responses(
      mock_data,
      {
        expect_error(fetch_table("ps"), "*.Gateway Timeout")
      }
    )
  })
})
