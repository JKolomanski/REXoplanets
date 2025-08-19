#' Fetch Exoplanets table
#'
#' @details
#' Fetches data from an exoplanets TAP (Table Access Protocol) service
#' and returns it as a data frame or a named list.
#' You can optionally specify `WHERE` ADQL clause to filter rows based on conditions.
#'
#' @param table A string specifying the table to query. Must be one of:
#'   \itemize{
#'   \item `ps` - Planetary Systems table
#'   \item `pscomppars` – Planetary Systems Composite Parameters table
#'   \item `stellarhosts` – Stellar Hosts table
#'   \item `keplernames` – Kepler Confirmed Names
#' }
#' @param query_string
#'  Optional ADQL `WHERE` clause as a string, e.g., `pl_bmasse > 1 AND st_teff < 6000`.
#' @param pretty_colnames
#'  Optional `bool` value. If `TRUE` replaces database column names with their
#'  labels / descriptions. Defaults to `FALSE`.
#'  Currently only tables `ps` and `pscomppars` are supported.
#' @param format
#'  Optional `char` value specifying output format. Can be either `"csv"` for data frame,
#'  or `"json"` for a named list.
#'
#' @returns A data frame or named list containing fetched data.
#'
#' @importFrom httr2 request req_perform resp_body_string req_options
#' @importFrom readr read_csv
#' @importFrom dplyr `%>%` rename any_of
#' @importFrom checkmate assert_choice assert_string
#' @importFrom utils URLencode
#' @importFrom jsonlite fromJSON
#' @importFrom logger log_info log_success log_error log_debug log_trace
#'
#' @examples
#' \dontrun{
#'  # All entries from Stellar Hosts table
#'  fetch_table("stellarhosts")
#'  # Entries from Planetary Systems table where planetary mass > 3 times the earth mass
#'  fetch_table("ps", query_string = "pl_bmasse > 3")
#'  # Planets orbiting Teegarden's Star with radius > 1 Earth radius
#'  fetch_table("pscomppars", query_string = "hostname = 'Teegarden''s Star' and pl_rade > 1")
#' }
#'
#' @export
fetch_table = function(table, query_string = NULL, pretty_colnames = FALSE, format = "csv") {
  assert_choice(table, c("ps", "pscomppars", "stellarhosts", "keplernames"))
  assert_choice(format, c("csv", "json"))

  query = paste0("select * from ", table)
  if (!is.null(query_string)) {
    assert_string(query_string)
    query = paste0(query, " where ", query_string)
  }

  url = paste0(
    TAP_URL,
    utils::URLencode(query, reserved = TRUE),
    "&format=",
    format
  )

  log_info("Fetching table `{table}`...")
  log_debug("Query URL: `{url}`")

  req = request(url) %>%
    req_options(followlocation = TRUE)
  res = tryCatch(
    req_perform(req),
    error = function(e) {
      status_code = sub(".*?(\\d{3}).*", "\\1", e$message)

      message = switch(
        status_code,
        "400" = "The request was invalid, please check filter syntax",
        "500" = paste0(
          "The API encountered an unknown error. Try again later.",
          "If the issue persists, please report a bug"
        ),
        "503" = "The API is currently unavailable. Try again later.",
        "504" = "The API connection timed out. Try again later.",
        "API request encountered an unexpected error."
      )

      stop(paste0(message, " Original error: ", e$message), call. = FALSE)
    }
  )

  log_trace("Response status: {res$status_code}")

  res_data = res %>%
    resp_body_string()

  read_fn = list(
    # Due to messy data read_csv fails to assign column types.
    # To avoid polluting the console, warnings are suppressed.
    csv = \(data) suppressWarnings(read_csv(data, show_col_types = FALSE)),
    json = \(data) jsonlite::fromJSON(data)
  )

  res_data = read_fn[[format]](res_data)

  log_success("Table {table} fetched successfully.")

  if (pretty_colnames) {
    if (!(table %in% c("ps", "pscomppars"))) {
      warning(paste0(
        "Table `", table, "` doesn't currently support pretty names.",
        "Database column names provided instead."
      ))
    } else {
      res_data = rename(res_data, any_of(exoplanets_col_labels[[table]]))
    }
  }

  res_data
}
