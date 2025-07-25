#' Calculate the Earth SImilarity Index (ESI)
#'
#' @details
#' The function takes in data frame and calculates the esi for each entry.
#'
#' @param data A data frame with data from `ps` or `pscomppars` table.
#'              It must contain columns: `st_lum`, `pl_orbsmax` and `pl_rade`.
#' @returns A data frame containing:
#'              - `objectid` column with object ID.
#'              - `esi` column with the ESI
#'
#' @importFrom dplyr `%>%` coalesce select
#' @export
calculate_esi = function(data) {
  if (!"data.frame" %in% class(data)) {
    stop("Exoplanets data must be a `data.frame`")
  }

  if (nrow(data) == 0) {
    warning("Empty exoplanets data")
    return(data.frame("objectid" = character(), "esi" = numeric()))
  }

  if (!"st_lum" %in% colnames(data)) {
    stop("Exoplanets data must contain `st_lum` column.")
  }

  data = data %>%
    mutate(
      # Compute flux if pl_insol is NA
      stellar_flux = coalesce(pl_insol, 10^st_lum / pl_orbsmax^2),
      esi_radius = (1 - abs((pl_rade - 1) / (pl_rade + 1)))^0.57,
      esi_flux = (1 - abs((stellar_flux - 1) / (stellar_flux + 1)))^0.7,
      esi = sqrt(esi_radius * esi_flux)
    )

  data %>% select(objectid, esi)
}