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
#' @param pl_insol Optional numeric. Precomputed flux value. If provided, it is returned as-is.
#' @param log_lum Logical. If TRUE, assumes `st_lum` is in log10(L / Lsun). Defaults to TRUE.
#' @param unit Character. Either `"relative"` (default) or `"wm2"` to convert to W/m².
#'
#' @returns Numeric. Stellar flux (relative or in W/m²).
#'
#' @export
calculate_stellar_flux = function(st_lum, pl_orbsmax,
                                  pl_insol = NA,
                                  log_lum = TRUE,
                                  unit = "relative") {
  # Return existing value if present.
  # We do it to not override a pl_insol value
  # if already present when applying this function to a whole dataset.
  if (!is.na(pl_insol)) {
    return(pl_insol)
  }

  if (is.na(st_lum) || is.na(pl_orbsmax)) {
    missing = c()
    if (is.na(st_lum)) missing = c(missing, "st_lum")
    if (is.na(pl_orbsmax)) missing = c(missing, "pl_orbsmax")

    warning("Missing arguments: ", paste(missing, collapse = ", "))
    return(NA)
  }

  if (log_lum) {
    st_lum = 10 ^ st_lum
  }

  if (unit == "wm2") {
    (st_lum / pl_orbsmax^2) * 1361
  } else {
    st_lum / pl_orbsmax^2
  }
}
