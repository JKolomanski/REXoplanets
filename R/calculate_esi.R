#' Calculate the Earth Similarity Index (ESI)
#'
#' @details
#' The function takes in data frame and calculates the ESI for each entry.
#'
#' ESI (Earth Simillarity Index) is a characterization of how simmilar a planetary-mass object
#' or natural satelite is to earth. It was designed to be a scale from zero to one,
#' with Earth having a value of 1.
#'
#' This implementation bases it's calculation on planetary `stellar flux` and radius
#'
#' @references
#' Schulze-Makuch, D., Méndez, A., Fairén, A. G., von Paris, P., Turse, C., Boyer, G.,
#' Davila, A. F., Resendes de Sousa António, M., Irwin, L. N., and Catling, D. (2011)
#' A Two-Tiered Approach to Assess the Habitability of Exoplanets. Astrobiology 11(10): 1041-1052.
#'
#' @param data A data frame with data from `ps` or `pscomppars` table.
#'              It must contain columns: `objectid` `st_lum`, `pl_orbsmax`, `pl_rade` and pl_insol.
#' @returns A data frame containing:
#'              - `objectid` column with object ID.
#'              - `esi` column with the ESI
#'
#' @importFrom dplyr `%>%` coalesce select
#' @export
calculate_esi = function(data) {
  if (!"data.frame" %in% class(data)) {
    stop("Data must be a `data.frame`.")
  }

  if (nrow(data) == 0) {
    warning("Empty data.")
    return(NULL)
  }

  # Not all columns are required at once.
  # Allow `pl_orbmax` and `pl_rade` columns to be missing
  # if there are no NA's in `st_lum` and vice versa.
  required_cols = c("objectid", "pl_rade")

  # Check which optional columns exist
  has_insol = "pl_insol" %in% names(data)
  has_lum = "st_lum" %in% names(data)
  has_orb = "pl_orbsmax" %in% names(data)

  if (has_insol && all(!is.na(data$pl_insol))) {
    optional_cols = c()
  } else if (has_lum && has_orb && all(!is.na(data$st_lum)) && all(!is.na(data$pl_orbsmax))) {
    optional_cols = c()
  } else {
    optional_cols = c("pl_insol", "st_lum", "pl_orbsmax")
  }

  required_cols = c(required_cols, optional_cols)

  missing_cols = setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop("Invalid data provided. Missing columns: ", paste(missing_cols, collapse = ", "))
  }

  data %>%
    mutate(
      # Compute flux if pl_insol is NA
      stellar_flux = coalesce(pl_insol, 10^st_lum / pl_orbsmax^2),
      esi_radius = (1 - abs((pl_rade - 1) / (pl_rade + 1)))^0.57,
      esi_flux = (1 - abs((stellar_flux - 1) / (stellar_flux + 1)))^0.7,
      esi = sqrt(esi_radius * esi_flux)
    ) %>%
    select(objectid, esi)
}