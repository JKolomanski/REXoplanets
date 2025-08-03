#' Plot a Stylized Star System
#'
#' Creates a stylized polar plot of a planetary system,
#' displaying planets in circular orbits
#' around a central star. Planet size is scaled by radius,
#' orbit position is randomized for aesthetics,
#' and planet color is mapped by density.
#' The star's color is optionally based on spectral type.
#'
#' The central star is positioned at the origin
#' with planets arranged in orbits of increasing radius.
#' Orbit lines are shown in grey for clarity.
#'
#' @param planet_data A data frame containing planetary system data. Must include:
#'   - `pl_orbsmax`: semi-major axis (orbital distance),
#'   - `pl_rade`: planetary radius (in Earth radii),
#'   - `pl_dens`: planetary density (g/cm³).
#' @param spectral_type Optional character string indicating the star's spectral type.
#'   Accepted values: `"O"`, `"B"`, `"A"`, `"F"`, `"G"`, `"K"`, `"M"`.
#'
#' @returns A `ggplot2` object representing the planetary system visualization.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_hline scale_color_identity
#'   scale_size_continuous coord_polar theme_void theme element_rect
#'
#' @examples
#' # Plot system GJ 682 (with hostid = "2.582960")
#' gj_682 = closest_50_exoplanets %>%
#'  filter(hostid == 2.101289)
#' plot_star_system(gj_682 , spectral_type = get_star_spectral_type(gj_682$st_teff[1]))
#'
#' @export
plot_star_system = function(planet_data, spectral_type = NULL) {
  data = data.frame(
    offset = c(0, runif(nrow(planet_data), min = 0, max = 2 * pi)),
    pl_orbsmax = c(0, planet_data$pl_orbsmax),
    pl_rade = c(15, planet_data$pl_rade),
    col = c(.map_star_color(spectral_type), .map_color(planet_data$pl_dens))
  )

  ggplot(data, aes(x = offset, y = pl_orbsmax, size = pl_rade, color = col)) +
    scale_color_identity() +
    # geom_hline here to render below points
    geom_hline(yintercept = data$pl_orbsmax, color = "grey15") +
    geom_point() +
    scale_size_continuous(range = c(2, 15)) +
    coord_polar(theta = "x") +
    theme_void() +
    theme(legend.position = "none", panel.background = element_rect(fill = "black", color = NA))
}

.map_color = function(pl_dens) {
  case_when(
    pl_dens < 0.25 ~ "lightblue",
    pl_dens < 2 ~ "deepskyblue",
    pl_dens < 6 ~ "darkorange3",
    pl_dens < 13 ~ "ivory3",
    TRUE ~ "gray20"
  )
}

.map_star_color = function(spectral_type) {
  if (is.null(spectral_type)) {
    return("white")
  }

  case_when(
    spectral_type == "M" ~ "#ffb56c",
    spectral_type == "K" ~ "#ffdab5",
    spectral_type == "G" ~ "#ffede3",
    spectral_type == "F" ~ "#f9f5ff",
    spectral_type == "A" ~ "#d5e0ff",
    spectral_type == "B" ~ "#a2c0ff",
    spectral_type == "O" ~ "#92b5ff"
  )
}
