#' Plot a Stylized Star System
#'
#' Creates a stylized polar plot of a planetary system,
#' displaying planets in circular orbits
#' around a central star. Planet size is scaled by radius,
#' orbit position is randomized for aesthetics,
#' planet color is mapped by density.
#' The star's color is optionally based on spectral type.
#' Optionally, star's habitable zone visualization can be overlayed.
#'
#' The central star is positioned at the origin
#' with planets arranged in orbits of increasing radius.
#' Orbit lines are shown in gray for clarity.
#'
#' @param planet_data A data frame containing planetary system data. Must include:
#'   - `pl_orbsmax`: semi-major axis (orbital distance),
#'   - `pl_rade`: planetary radius (in Earth radii),
#'   - `pl_dens`: planetary density (g/cm³).
#' @param spectral_type Optional character string indicating the star's spectral type.
#'   Accepted values: `O`, `B`, `A`, `F`, `G`, `K`, `M`.
#' @param habitable_zone Optional numeric vector containing 2 values:
#'   Inner and outer habitable zone edges in AU.
#'
#' @returns A `ggplot2` object representing the planetary system visualization.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_hline scale_color_identity
#'   scale_size_continuous coord_polar theme_void theme element_rect annotate
#' @importFrom checkmate assert_names assert_data_frame assert_character assert_choice
#' @importFrom stats runif
#'
#' @examples
#' # Plot system GJ 682 (with hostid == "2.101289")
#' data = closest_50_exoplanets |>
#'   subset(hostid == 2.101289)
#' spectral_type = classify_star_spectral_type(data$st_teff[1])
#' plot_star_system(data,
#'                  spectral_type,
#'                  habitable_zone = calculate_star_habitable_zone(data$st_lum[1]))
#'
#' @export
plot_star_system = function(planet_data, spectral_type = NULL, habitable_zone = c(0, 0)) {
  assert_data_frame(planet_data)
  assert_numeric(habitable_zone, len = 2)
  assert_names(colnames(planet_data), must.include = c("pl_orbsmax", "pl_rade", "pl_dens"))
  if (!is.null(spectral_type)) {
    assert_character(spectral_type, len = 1, any.missing = FALSE)
    assert_choice(spectral_type, choices = c("O", "B", "A", "F", "G", "K", "M"))
  }

  # Create data frame for plotting the star system:
  # First row is always the host star and following rows are the planets.
  #    - randomize position on the orbit, with the star being in the center (0)
  #    - rescale orbit for the visualization, keep the star at center (0). Add habitable zone edges.
  #    - ensure star is the largest object with size 17
  #    - map color based on spectral type or density
  plot_data = data.frame(
    orbit_offset = c(0, runif(nrow(planet_data), min = 0, max = 2 * pi), 0, 0),
    pl_orbsmax = c(0, .rescale_orbsmax(c(
      planet_data$pl_orbsmax,
      min(habitable_zone), max(habitable_zone)
    ))),
    pl_rade = c(17, planet_data$pl_rade, 0, 0), # Ensure star is the largest object
    col = c(.map_star_color(spectral_type), .map_planet_color(planet_data$pl_dens), "", "")
  )

  inner_hz = plot_data$pl_orbsmax[length(plot_data$pl_orbsmax) - 1]
  outer_hz = plot_data$pl_orbsmax[length(plot_data$pl_orbsmax)]

  plot_data = plot_data[1:(nrow(plot_data) - 2), ]


  ggplot(plot_data, aes(x = orbit_offset, y = pl_orbsmax, size = pl_rade, color = col)) +
    annotate(
      "rect",
      xmin = -Inf, xmax = Inf,  # full width
      ymin = inner_hz, ymax = outer_hz,
      alpha = 0.15, fill = "green"
    ) +
    geom_hline(yintercept = plot_data$pl_orbsmax, color = "grey15") +
    geom_point() +
    scale_color_identity() +
    scale_size_continuous(range = c(2, 17)) + # Limit object size to prevent it from overlapping
    coord_polar(theta = "x") +
    theme_void() +
    theme(legend.position = "none", panel.background = element_rect(fill = "black", color = NA))
}

.map_planet_color = function(pl_dens) {
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

.rescale_orbsmax = function(x, new_min = 2.5, new_max = 12) {
  if (length(x) == 1 || all(x == x[1])) {
    return(rep((new_min + new_max) / 2, length(x))) # constant vector fallback
  }
  rng = range(x, na.rm = TRUE)
  scaled = (x - rng[1]) / (rng[2] - rng[1])
  new_min + scaled * (new_max - new_min)
}
