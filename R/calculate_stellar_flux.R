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
#' @examples
#' calculate_stellar_flux(st_lum = 0, pl_orbsmax = 1)                  # Solar-type star, Earth-like orbit
#' calculate_stellar_flux(st_lum = 5, pl_orbsmax = 2, log_lum = FALSE) # Linear luminosity input (not log), 5x Sun at 2 AU
#' calculate_stellar_flux(st_lum = 0, pl_orbsmax = 1, unit = "wm2")    # Output in absolute units (W/m²), Earth-like conditions
#' 
#' @export
calculate_stellar_flux = function(st_lum, pl_orbsmax, log_lum = TRUE, unit = "relative") {
  # st_lum can be negative, so we don't check that
  if (!is.numeric(st_lum)) {
    stop("Invalid data type. `st_lum` must be `numeric`.")
  }

  if (!is.numeric(pl_orbsmax) || pl_orbsmax <= 0) {
    stop("Invalid data. `pl_orbsmax` must be `numeric` and larger than 0.")
  }

  if (!is.logical(log_lum)) {
    stop("Invalid data type. `log_lum` must be `logical`.")
  }

  if (!is.character(unit)) {
    stop("Invalid data type. `unit` must be `character`.")
  }

  if (!unit %in% c("relative", "wm2")) {
    stop("Invalid data value. `unit` must be `relative` or `wm2`.")
  }

  if (log_lum) {
    st_lum = 10 ^ st_lum
  }

  stellar_flux = st_lum / pl_orbsmax^2
  if (unit == "wm2") {
    stellar_flux = stellar_flux * 1361
  }

  stellar_flux
}
