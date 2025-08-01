#' Trim planetary systems table
#'
#' @details
#' The function takes in a planetary systems data frame,
#' and trims it to include only 20 most important columns.
#'
#' @param data A data frame with planetary systems data.
#' @returns A data frame containing:
#' \itemize{
#'   \item `objectid` - Object ID
#'   \item `pl_name` – Planet name
#'   \item `hostname` – Host star name
#'   \item `sy_dist` – Distance to the system (parsecs)
#'   \item `pl_rade` – Planetary radius (Earth radii)
#'   \item `pl_bmasse` – Planetary mass (Earth masses)
#'   \item `pl_orbper` – Orbital period (days)
#'   \item `pl_orbsmax` – Semi-major axis (AU)
#'   \item `pl_orbeccen` – Orbital eccentricity
#'   \item `pl_insol` – Incident stellar flux (Earth units)
#'   \item `st_teff` – Stellar effective temperature (K)
#'   \item `st_rad` – Stellar radius (Solar radii)
#'   \item `st_mass` – Stellar mass (Solar masses)
#'   \item `st_lum` – Stellar luminosity (log10 L/Lsun)
#'   \item `pl_eqt` – Planetary equilibrium temperature (K)
#'   \item `pl_dens` – Planetary density
#'   \item `discoverymethod` – Discovery method
#'   \item `disc_year` – Year of discovery
#'   \item `sy_snum` – Number of stars in system
#'   \item `sy_pnum` – Number of planets in system
#' }
#'
#' @importFrom dplyr select all_of
#'
#' @examples
#' trim_ps_table(closest_50_exoplanets)
#'
#' @export
trim_ps_table = function(data) {
  required_cols = c(
    "objectid", "pl_name", "hostname", "sy_dist", "pl_rade",
    "pl_bmasse", "pl_orbper", "pl_orbsmax", "pl_orbeccen", "pl_insol",
    "st_teff", "st_rad", "st_mass", "st_lum", "pl_eqt", "pl_dens",
    "disc_year", "sy_snum", "sy_pnum", "discoverymethod"
  )

  missing = setdiff(required_cols, colnames(data))
  if (length(missing) > 0) {
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }

  select(data, all_of(required_cols))
}
