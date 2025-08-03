#' Plot a Stylized Star System
#'
#' Creates a stylized polar plot of a planetary system,
#' displaying planets in circular orbits
#' around a central star. Planet size is scaled by radius,
#' orbit position is randomized for aesthetics,
#' planet color is mapped by density.
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
#'   Accepted values: `O`, `B`, `A`, `F`, `G`, `K`, `M`.
#'
#' @returns A `ggplot2` object representing the planetary system visualization.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_hline scale_color_identity
#'   scale_size_continuous coord_polar theme_void theme element_rect
#' @importFrom checkmate assert_names assert_data_frame assert_numeric
#'
#' @examples
#' # Plot system GJ 682 (with hostid = "2.582960")
#' closest_50_exoplanets %>%
#'   filter(hostid == 2.101289) %>%
#'   {
#'     plot_star_system(., spectral_type = get_star_spectral_type(.$st_teff[1]))
#'   }
#'
#' @export
plot_star_system = function(planet_data, spectral_type = NULL) {
  assert_data_frame(planet_data)
  assert_names(colnames(planet_data), must.include = c("pl_orbsmax", "pl_rade", "pl_dens"))
  if (!is.null(spectral_type)) {
    assert_character(spectral_type, len = 1, any.missing = FALSE)
    assert_choice(spectral_type, choices = c("O", "B", "A", "F", "G", "K", "M"))
  }

  plot_data = data.frame(
    offset = c(0, runif(nrow(planet_data), min = 0, max = 2 * pi)),
    pl_orbsmax = c(0, .rescale_orbsmax(planet_data$pl_orbsmax)),
    pl_rade = c(15, planet_data$pl_rade),
    col = c(.map_star_color(spectral_type), .map_color(planet_data$pl_dens))
  )

  ggplot(plot_data, aes(x = offset, y = pl_orbsmax, size = pl_rade, color = col)) +
    geom_hline(yintercept = plot_data$pl_orbsmax, color = "grey15") +
    geom_point() +
    scale_color_identity() +
    scale_size_continuous(range = c(2, 17)) +
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
    spectral_type == "M" ~ "red2",
    spectral_type == "K" ~ "indianred2",
    spectral_type == "G" ~ "yellow1",
    spectral_type == "F" ~ "lightyellow",
    spectral_type == "A" ~ "lavenderblush",
    spectral_type == "B" ~ "lightsteelblue1",
    spectral_type == "O" ~ "slateblue1"
  )
}

.rescale_orbsmax = function(pl_orbsmax) {
  log_vals = log10(pl_orbsmax)
  min_val = min(log_vals)
  max_val = max(log_vals)
  ((log_vals - min_val) / (max_val - min_val)) * (7 - 1) + 1
}