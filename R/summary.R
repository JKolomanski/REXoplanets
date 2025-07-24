#' Summarize star occurances
#'
#' @details
#' The function takes in KOI data frame and summarizes the number of planets that appear in a
#' given dataset for each star.
#'
#' @param data A data frame with KOI data. Must contain `kepoi_name` column.
#' @returns A data farme containing:
#'           - `Star` column with star ID.
#'           - `Count` column with number of planets.
#'
#' @importFrom dplyr `%>%` mutate group_by n summarise
#' @export
summarize_star_occurances = function(data) {
  if (!"data.frame" %in% class(data)) {
    stop("Exoplanets data must be a `data.frame`")
  }

  if (nrow(data) == 0) {
    warning("Empty exoplanets data")
    return(data.frame("Star" = character(), "Count" = numeric()))
  }

  if (!"kepoi_name" %in% colnames(data)) {
    stop("Exoplanets data must contain `kepoi_name` column.")
  }

  data %>%
    dplyr::mutate(
      Star = sapply(kepoi_name, \(x) unlist(strsplit(x, "\\."))[[1]])
    ) %>%
    dplyr::group_by(Star) %>%
    dplyr::summarise(
      Count = dplyr::n()
    )
}
