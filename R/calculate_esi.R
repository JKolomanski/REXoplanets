#' Calculate the Earth Similarity Index (ESI)
#'
#' @details
#' The function calculates the ESI based on stellar flux and planetary radius.
#'
#' ESI (Earth Simillarity Index) is a characterization of how simmilar a planetary-mass object
#' or natural satelite is to earth. It was designed to be a scale from zero to one,
#' with Earth having a value of 1.
#'
#' @references
#' Schulze-Makuch, D., Méndez, A., Fairén, A. G., von Paris, P., Turse, C., Boyer, G.,
#' Davila, A. F., Resendes de Sousa António, M., Irwin, L. N., and Catling, D. (2011)
#' A Two-Tiered Approach to Assess the Habitability of Exoplanets. Astrobiology 11(10): 1041-1052.
#'
#' @param pl_rade Numeric. Planetary radius in Earth radii.
#' @param pl_insol Numeric. Stellar flux in Earth units.
#'
#' @returns Numeric. Earth Similarity Index (ESI).
#'
#' @examples
#' calculate_esi(1, 1)        # Earth:   1
#' calculate_esi(0.53, 0.43)  # Mars:    0.753
#' calculate_esi(11.2, 0.037) # Jupiter: 0.24
#'
#' @importFrom checkmate assert_numeric
#' @export
calculate_esi = function(pl_rade, pl_insol) {
  assert_numeric(pl_rade, lower = 0)
  assert_numeric(pl_insol, lower = 0)

  esi_radius = (1 - abs((pl_rade - 1) / (pl_rade + 1)))^0.57
  esi_flux = (1 - abs((pl_insol - 1) / (pl_insol + 1)))^0.7
  sqrt(esi_radius * esi_flux)
}
