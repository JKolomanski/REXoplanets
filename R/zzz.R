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
<<<<<<< HEAD
    "orbit_offset"
=======
    "df",
    "name_map",
    "col_labels"
>>>>>>> e6e7a27 (refactor: merged ps_colnames and pscomppars_colnames into one nested list)
  ))
}
