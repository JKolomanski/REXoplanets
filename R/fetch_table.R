#' Fetch Exoplanets table
#'
#' @details
#' Fetches data from an exoplanets TAP (Table Access Protocol) service
#' and returns it as a data frame.
#' You can optionally specify a `WHERE` clause to filter rows based on conditions.
#'
#' @param table A string specifying the table to query. Must be one of:
#'   \itemize{
#'   \item `ps` - Planetary Systems table
#'   \item `pscomppars` – Planetary Systems Composite Parameters table
#'   \item `stellarhosts` – Stellar Hosts table
#'   \item `keplernames` – Kepler Confirmed Names
#' }
#' @param filters Optional ADQL WHERE clause as a string, e.g., "pl_bmasse > 1 AND st_teff < 6000".
#'
#' @returns A data frame containing fetched data.
#'
#' @importFrom httr2 request req_perform resp_body_string req_options
#' @importFrom readr read_csv
#' @importFrom dplyr `%>%`
#' @importFrom checkmate assert_choice assert_string
#'
#' @examples
#' \dontrun{
#'  # All entries from Stellar Hosts table
#'  fetch_table("stellarhosts")
#'  # Entries from Planetary Systems table where planetary mass > 3 times the earth mass
#'  fetch_table("ps", filters = "pl_bmasse > 3")
#'  # Planets orbiting Teegarden's Star with radius > 1 Earth radius
#'  fetch_table("pscomppars", filters = "hostname = 'Teegarden''s Star' and pl_rade > 1")
#' }
#'
#' @export
fetch_table = function(table, filters = NULL) {
  assert_choice(table, c("ps", "pscomppars", "stellarhosts", "keplernames"))
  if (!is.null(filters)) {
    assert_string(filters)
  }

  query = paste0("select * from ", table)
  if (!is.null(filters)) {
    query = paste0(query, " where ", filters)
  }

  url = paste0(
    TAP_URL,
    utils::URLencode(query, reserved = TRUE),
    "&format=csv"
  )

  req = request(url) %>% req_options(followlocation = TRUE) # issue: can't get httr2 to redirect
  res = req_perform(req)
  csv_data = resp_body_string(res)

  read_csv(csv_data, show_col_types = FALSE) # should definee col_types explicitly?
}
