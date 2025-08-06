#' Calculate star's Goldilocks zone
#'
#' @description
#' Calculates star's Goldilocks zone inner and outer radius,
#' based on star's luminosity.
#'
#' @param st_lum A numeric Stellar luminosity value (log10(L/Lsun) or linear).
#' @param log_lum A logical value. If `TRUE` assumes `st_lum` is logarithmic. Defaults to `TRUE`.
#'
#' @returns
#' A numeric vector of 2 elements
#' where first is Goldilocks zone inner radius and second is the outer radius.
#'
#' @examples
#' calculate_star_goldilocks_zone(0) # goldilocks zone for sun, with logarithmic units
#' calculate_star_goldilocks_zone(1, log_lum = FALSE) # goldilocks zone for sun, with linear units
#'
#' @export
calculate_star_goldilocks_zone = function(st_lum, log_lum = TRUE) {
  assert_numeric(st_lum)
  assert_logical(log_lum)

  if (log_lum) {
    st_lum = 10 ^ st_lum
  }

  hz_inner = sqrt(st_lum / 1.1)
  hz_outer = sqrt(st_lum / 0.53)

  c(hz_inner, hz_outer)
}
