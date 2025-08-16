.onLoad = function(libname, pkgname) {
  logger::log_layout(logger::layout_glue_colors)
  logger::log_formatter(logger::formatter_glue)
  logger::log_threshold(Sys.getenv("REXOPLANETS_LOG_LEVEL", "INFO"))

  utils::globalVariables(c(
    "kepoi_name",
    "Star",
    "pl_insol",
    "st_lum",
    "pl_orbsmax",
    "pl_rade",
    "stellar_flux",
    "esi_radius",
    "esi_flux",
    "objectid",
    "esi",
    "df",
    "name_map",
    "exoplanets_col_labels",
    "orbit_offset",
    "hostname",
    "closest_50_exoplanets",
    ".",
    "across",
    "st_mass",
    "st_rad",
    "st_teff",
    "sy_pnum",
    "sy_snum",
    "sy_dist",
    ""
  ))
}
