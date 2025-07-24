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
  data %>%
    mutate(
      Star = sapply(kepoi_name, \(x) unlist(strsplit(x, "\\."))[[1]])
    ) %>%
    group_by(Star) %>%
    summarise(
      Count = n()
    )
}
