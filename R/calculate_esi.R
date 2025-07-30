#' Calculate the Earth Similarity Index (ESI)
#'
#' @details
#' The function calculates the ESI based on stellar flux and planetary radius.
#'
#' ESI (Earth Similarity Index) is a characterization of how similar a planetary-mass object
#' or natural satellite is to earth. It was designed to be a scale from zero to one,
#' with Earth having a value of 1.
#'
#' @references
#' Schulze-Makuch, D., Méndez, A., Fairén, A. G., von Paris, P., Turse, C., Boyer, G.,
#' Davila, A. F., Resendes de Sousa António, M., Irwin, L. N., and Catling, D. (2011)
#' A Two-Tiered Approach to Assess the Habitability of Exoplanets. Astrobiology 11(10): 1041-1052.
#'
#' @param pl_rade Numeric. Planetary radius in Earth radii.
#' @param pl_insol Numeric. Stellar flux in Earth units. Optional.
#'
#' @returns Numeric. Earth Similarity Index (ESI).
#' @export
calculate_esi = function(pl_rade, pl_insol) {
  if (!is.numeric(pl_rade) || pl_rade <= 0) {
    stop("Invalid data type. `pl_rade` must be `numeric` and larger than 0.")
  }

  if (!is.numeric(pl_insol) || pl_insol <= 0) {
    stop("Invalid data type. `pl_insol` must be `numeric` and larger than 0.")
  }

  esi_radius = (1 - abs((pl_rade - 1) / (pl_rade + 1)))^0.57
  esi_flux = (1 - abs((pl_insol - 1) / (pl_insol + 1)))^0.7
  sqrt(esi_radius * esi_flux)
}
