#' Fetch Exoplanets table
#'
#' @details
#' Fetches data from an exoplanets TAP (Table Access Protocol) service
#' and returns it as a data frame.
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
#'  Optional ADQL WHERE clause as a string, e.g., "pl_bmasse > 1 AND st_teff < 6000".
#'
#' @returns A data frame containing fetched data.
#'
#' @importFrom httr2 request req_perform resp_body_string req_options
#' @importFrom readr read_csv
#' @importFrom dplyr `%>%`
#' @importFrom checkmate assert_choice assert_string
#' @importFrom utils URLencode
#'
#' @examples
#' \dontrun{
#'  # All entries from Stellar Hosts table
#'  fetch_table("stellarhosts")
#'  # Entries from Planetary Systems table where planetary mass > 3 times the earth mass
#'  fetch_table("ps", query_string
#'  = "pl_bmasse > 3")
#'  # Planets orbiting Teegarden's Star with radius > 1 Earth radius
#'  fetch_table("pscomppars", query_string
#'  = "hostname = 'Teegarden''s Star' and pl_rade > 1")
#' }
#'
#' @export
fetch_table = function(table, query_string = NULL) {
  assert_choice(table, c("ps", "pscomppars", "stellarhosts", "keplernames"))

  query = paste0("select * from ", table)
  if (!is.null(query_string)) {
    assert_string(query_string)
    query = paste0(query, " where ", query_string)
  }

  url = paste0(
    TAP_URL,
    utils::URLencode(query, reserved = TRUE),
    "&format=csv"
  )

  req = request(url) %>%
    req_options(followlocation = TRUE) # issue: can't get httr2 to redirect
  res = tryCatch(
    req_perform(req),
    error = function(e) {
      stop("Request failed. Check your filter syntax. Original error: ", e$message, call. = FALSE)
    }
  )

  res %>%
    resp_body_string() %>%
    read_csv(show_col_types = FALSE)
}
