#' Calculate the Earth Similarity Index (ESI)
#'
#' @details
#' The function calculates the ESI based on stellar flux and planetary radius.
#'
#' ESI (Earth Simillarity Index) is a characterization of how simmilar a planetary-mass object
#' or natural satelite is to earth. It was designed to be a scale from zero to one,
#' with Earth having a value of 1.
#'
#'
#' @references
#' Schulze-Makuch, D., Méndez, A., Fairén, A. G., von Paris, P., Turse, C., Boyer, G.,
#' Davila, A. F., Resendes de Sousa António, M., Irwin, L. N., and Catling, D. (2011)
#' A Two-Tiered Approach to Assess the Habitability of Exoplanets. Astrobiology 11(10): 1041-1052.
#'
#' @param pl_rade Numeric. Planetary radius in Earth radii.
#' @param pl_insol Optional numeric. Stellar flux in Earth units.
#'
#' @returns Numeric. Earth Similarity Index (ESI).
#'
#' @importFrom dplyr `%>%` coalesce select
#' @export
calculate_esi = function(pl_rade, pl_insol) {
  if (is.na(pl_rade) || is.na(pl_insol)) {
    missing = c()
    if (is.na(pl_rade)) missing = c(missing, "pl_rade")
    if (is.na(pl_insol)) missing = c(missing, "pl_insol")

    stop("Missing arguments: ", paste(missing, collapse = ", "))
  }

  if (!is.numeric(pl_rade)) {
    stop("Invalid data type. `pl_rade` must be `numeric`.")
  }

  if (!is.numeric(pl_insol)) {
    stop("Invalid data type. `pl_insol` must be `numeric`.")
  }

  # Disallow setting pl_rade and pl_insol to -1 to prevent division by 0.
  if (pl_rade == -1 || pl_insol == -1) {
    stop("Invalid input: `pl_rade` or `pl_insol` cannot be -1.")
  }

  esi_radius = (1 - abs((pl_rade - 1) / (pl_rade + 1)))^0.57
  esi_flux = (1 - abs((pl_insol - 1) / (pl_insol + 1)))^0.7
  sqrt(esi_radius * esi_flux)
}
