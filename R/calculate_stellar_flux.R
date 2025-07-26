#' Calculate stellar flux value
#'
#' @details
#' This function calculates the stellar flux for each entry in the input data frame.
#' It assumes luminosity is either logarithmic (log10 of L/Lsun) or linear, and optionally
#' converts flux to absolute units (W/m²) if requested.
#'
#' Stellar flux is the amount of energy from a star that reaches a given area per unit time.
#'
#' @param data A data frame containing `objectid`, `st_lum`, and `pl_orbsmax`.
#' @param log_lum Logical. If TRUE, assumes `st_lum` is in log10(L / L☉). Defaults to TRUE.
#' @param unit Character. Either `"relative"` (default) or `"wm2"` to convert to W/m².
#'
#' @returns A data frame with columns `objectid` and `pl_insol`.
#'
#' @importFrom dplyr `%>%`, coalesce
#' @export
calculate_stellar_flux = function(data, log = TRUE, unit = "relative") {
  if (!"data.frame" %in% class(data)) {
    stop("Data must be a `data.frame`.")
  }

  if (nrow(data) == 0) {
    warning("Empty data.")
    return(NULL)
  }

  required_cols = c("objectid", "st_lum", "pl_orbsmax")
  missing_cols = setdiff(required_cols, colnames(data))
  if (length(missing_cols) > 0) {
    stop("Invalid data provided. Missing columns: ", paste(missing_cols, collapse = ", "))
  }

  if (log) {
    sf = 10^data$st_lum / data$pl_orbsmax^2
  } else {
    sf = data$st_lum / data$pl_orbsmax^2
  }

  if (unit == "wm2") {
    solar_const = 1361
    sf = sf * solar_const
  }

  data = data %>%
    mutate(
      pl_insol = coalesce(pl_insol, sf)
    )

  data %>% select(objectid, pl_insol)
}
