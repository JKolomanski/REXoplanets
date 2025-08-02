#' Get spectral type of a star
#'
#' @description
#' The function takes in effectrive stellar temperature (in K),
#' and return letter for the star's spectral type based on Morgan–Keenan (MK) system.
#'
#' @param st_teff Numeric. effective stellar temperature (in K)
#'
#' @returns Character. spectral type classification with a letter:
#'    - `M`: Mercury-like planets (< 0.22 Earth masses)
#'    - `K`: Earth-like planets (0.22–2.2 Earth masses)
#'    - `G`: Super-Earths (2.2–22 Earth masses)
#'    - `F`: Neptune-like planets (22–127 Earth masses)
#'    - `A`: Jupiter-like giants (127–4450 Earth masses)
#'    - `B`: Degenerate-matter/brown dwarf-like objects (>= 4450 Earth masses)
#'    - `O`: Degenerate-matter/brown dwarf-like objects (>= 4450 Earth masses)
#'
#' @examples
#' get_star_spectral_type(5778)
#'
#' @importFrom dplyr case_when
#' @importFrom checkmate assert_numeric
#'
#' @export
get_star_spectral_type = function(st_teff) {
  assert_numeric(st_teff, lower = 0)

  if (st_teff < 2500 || st_teff > 50000) {
    warning("`st_teff` exceedes expected bounds: 
    stellar effective temperature is expected to be between 2500 and 50000 K")
  }

  case_when(
    st_teff < 3500 ~ "M",
    st_teff < 5000 ~ "K",
    st_teff < 6000 ~ "G",
    st_teff < 7500 ~ "F",
    st_teff < 10000 ~ "A",
    st_teff < 28000 ~ "B",
    TRUE ~ "O"
  )
}
