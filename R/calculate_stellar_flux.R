#' Calculate stellar flux value
#'
#' @details
#' This function calculates the stellar flux based on provided values.
#' It assumes luminosity is either logarithmic (log10 of L/Lsun) or linear, and optionally
#' converts flux to absolute units (W/m²) if requested.
#'
#' Stellar flux is the amount of energy from a star that reaches a given area per unit time.
#'
#' @param st_lum Numeric. Stellar luminosity (log10(L/Lsun) or linear).
#' @param pl_orbsmax Numeric. Orbital distance in AU.
#' @param log_lum Logical. If TRUE, assumes `st_lum` is in log10(L / Lsun). Defaults to TRUE.
#' @param unit Character. Either `"relative"` (default) or `"wm2"` to convert to W/m².
#'
#' @returns Numeric. Stellar flux (relative or in W/m²).
#'
#' @importFrom checkmate assert_numeric assert_logical assert_choice
#' @export
calculate_stellar_flux = function(st_lum, pl_orbsmax, log_lum = TRUE, unit = "relative") {
  # st_lum can be negative, so we don't check that
  assert_numeric(st_lum)
  assert_numeric(pl_orbsmax, lower = 0)
  assert_logical(log_lum)
  assert_choice(unit, c("relative", "wm2"))

  if (log_lum) {
    st_lum = 10 ^ st_lum
  }

  stellar_flux = st_lum / pl_orbsmax^2
  if (unit == "wm2") {
    stellar_flux = stellar_flux * 1361
  }

  stellar_flux
}
