.onLoad = function(libname, pkgname) {
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
    "orbit_offset"
  ))
}
