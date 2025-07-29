#' Classify Planet Type
#'
#' @description
#' This function returns a compact four-character code
#' representing the classification of an exoplanet
#' based on its mass, equilibrium temperature, orbital eccentricity, and density.
#'
#' The classification code is composed of four parts:
#'
#' 1. **Mass class:**
#'    - `M`: Mercury-like planets (< 0.22 Earth masses)
#'    - `E`: Earth-like planets (0.22–2.2 Earth masses)
#'    - `S`: Super-Earths (2.2–22 Earth masses)
#'    - `N`: Neptune-like planets (22–127 Earth masses)
#'    - `J`: Jupiter-like giants (127–4450 Earth masses)
#'    - `D`: Degenerate-matter/brown dwarf-like objects (≥ 4450 Earth masses)
#'
#' 2. **Temperature class:**
#'    - `F`: Frozen (T < 250 K)
#'    - `W`: Temperate/water zone (250–450 K)
#'    - `G`: Gaseous (450–1000 K)
#'    - `R`: Roasters (≥ 1000 K)
#'
#' 3. **Eccentricity:**
#'    - First decimal digit of orbital eccentricity.
#'      For example, 0.26 → `"3"` → appended as `"3"`.
#'
#' 4. **Density-based surface/composition class:**
#'    - `g`: Gas-dominated (< 0.25 g/cm³)
#'    - `w`: Water/ice-rich (0.25–2 g/cm³)
#'    - `t`: Terrestrial/rocky (2–6 g/cm³)
#'    - `i`: Iron-rich (6–13 g/cm³)
#'    - `s`: Super-dense (≥ 13 g/cm³)
#'
#' @param pl_bmasse Numeric. Planetary mass in Earth masses. Must be > 0.
#' @param pl_eqt Numeric. Planetary equilibrium temperature in Kelvin. Must be > 0.
#' @param pl_orbeccen Numeric. Orbital eccentricity. Must be > 0.
#' @param pl_dens Numeric. Planetary density in g/cm³. Must be > 0.
#'
#' @return A character string containing a 4-character planet classification code.
#'
#' @examples
#' classify_planet_type(1.0, 288, 0.0167, 5.5)   # Earth-like: "EW0t"
#' classify_planet_type(318, 1300, 0.05, 1.3)    # Hot Jupiter: "JR1w"
#' classify_planet_type(0.1, 180, 0.2, 0.1)      # Cold, light, low-density: "MF2g"
#'
#' @export
classify_planet_type = function(pl_bmasse, pl_eqt, pl_orbeccen, pl_dens) {
  if (!is.numeric(pl_bmasse) || pl_bmasse <= 0) {
    stop("Invalid data type. `pl_bmasse` must be `numeric` and larger than 0.")
  }

  if (!is.numeric(pl_eqt) || pl_eqt <= 0) {
    stop("Invalid data type. `pl_eqt` must be `numeric` and larger than 0.")
  }

  if (!is.numeric(pl_orbeccen) || pl_orbeccen <= 0) {
    stop("Invalid data type. `pl_orbeccen` must be `numeric` and larger than 0.")
  }

  if (!is.numeric(pl_dens) || pl_dens <= 0) {
    stop("Invalid data type. `pl_dens` must be `numeric` and larger than 0.")
  }

  class_code = ""

  if (pl_bmasse < 0.22) {
    class_code = paste0(class_code, "M")
  } else if (pl_bmasse < 2.2) {
    class_code = paste0(class_code, "E")
  } else if (pl_bmasse < 22) {
    class_code = paste0(class_code, "S")
  } else if (pl_bmasse < 127) {
    class_code = paste0(class_code, "N")
  } else if (pl_bmasse < 4450) {
    class_code = paste0(class_code, "J")
  } else {
    class_code = paste0(class_code, "D")
  }

  if (pl_eqt < 250) {
    class_code = paste0(class_code, "F")
  } else if (pl_eqt < 450) {
    class_code = paste0(class_code, "W")
  } else if (pl_eqt < 1000) {
    class_code = paste0(class_code, "G")
  } else {
    class_code = paste0(class_code, "R")
  }

  eccen_first_decimal = round(pl_orbeccen, 1) * 10
  class_code = paste0(class_code, as.character(eccen_first_decimal))

  if (pl_dens < 0.25) {
    class_code = paste0(class_code, "g")
  } else if (pl_dens < 2) {
    class_code = paste0(class_code, "w")
  } else if (pl_dens < 6) {
    class_code = paste0(class_code, "t")
  } else if (pl_dens < 13) {
    class_code = paste0(class_code, "i")
  } else {
    class_code = paste0(class_code, "s")
  }

  class_code
}
