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
#' @param show_legend Optional bool value, whether to show plot legend.
#'
#' @returns A ggplot2 object representing the planetary system visualization.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_hline scale_color_identity scale_color_manual
#'   scale_size_continuous coord_polar theme_void theme element_rect annotate guides guide_legend
#'   element_text unit
#' @importFrom checkmate assert_names assert_data_frame assert_character assert_choice
#' @importFrom stats runif setNames
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
plot_star_system = function(
  planet_data,
  spectral_type = " ",
  habitable_zone = c(0, 0),
  show_legend = FALSE
) {
  assert_data_frame(planet_data)
  assert_numeric(habitable_zone, len = 2)
  assert_names(colnames(planet_data), must.include = c("pl_orbsmax", "pl_rade", "pl_dens"))
  assert_character(spectral_type, len = 1, any.missing = FALSE)
  assert_choice(spectral_type, choices = c(" ", "O", "B", "A", "F", "G", "K", "M"))

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
      min(habitable_zone),
      max(habitable_zone)
    ))),
    pl_rade = c(17, planet_data$pl_rade, 0, 0),
    type = c(spectral_type, .map_planet_type(planet_data$pl_dens), "HZ inner edge", "HZ outer edge")
  )

  inner_hz = plot_data$pl_orbsmax[nrow(plot_data) - 1]
  outer_hz = plot_data$pl_orbsmax[nrow(plot_data)]
  plot_data = plot_data[1:(nrow(plot_data) - 2), ]

  color_map = c(
    "M" = "red2",
    "K" = "indianred2",
    "G" = "yellow1",
    "F" = "lightyellow",
    "A" = "lavenderblush",
    "B" = "lightsteelblue1",
    "O" = "slateblue1",
    "Gas-dominated planet" = "lightblue",
    "Water/ice-rich planet" = "deepskyblue",
    "Terrestial planet" = "darkorange3",
    "Iron-rich planet" = "ivory3",
    "Super-dense planet" = "gray20"
  )

  ggplot(plot_data, aes(x = orbit_offset, y = pl_orbsmax, size = pl_rade, color = type)) +
    annotate(
      "rect",
      xmin = -Inf, xmax = Inf,
      ymin = inner_hz, ymax = outer_hz,
      alpha = 0.15, fill = "green"
    ) +
    geom_hline(yintercept = plot_data$pl_orbsmax, color = "grey15") +
    geom_point() +
    scale_color_manual(
      values = color_map,
      labels = setNames(
        paste0("Central star, spectral type ", spectral_type),
        spectral_type
      )
    ) +
    scale_size_continuous(range = c(3.5, 17)) +
    coord_polar(theta = "x") +
    guides(
      size = "none",
      color = guide_legend(title = "", override.aes = list(size = 6, shape = 16))
    ) +
    theme_void() +
    theme(
      panel.background = element_rect(fill = "black", color = NA),
      legend.text = element_text(size = 16),
      legend.justification = "left",
      legend.box.just = "left",
      legend.box = "vertical",
      legend.direction = "vertical",
      legend.position = if (show_legend) "bottom" else "none",
      legend.key.height = unit(23, "pt"),
      legend.key = element_rect(fill = "white", color = NA)

    )
}

.map_planet_type = function(pl_dens) {
  dplyr::case_when(
    pl_dens < 0.25 ~ "Gas-dominated planet",
    pl_dens < 2    ~ "Water/ice-rich planet",
    pl_dens < 6    ~ "Terrestial planet",
    pl_dens < 13   ~ "Iron-rich planet",
    TRUE           ~ "Super-dense planet"
  )
}

.rescale_orbsmax = function(x, new_min = 2, new_max = 12) {
  if (length(x) == 1 || all(x == x[1])) {
    return(rep((new_min + new_max) / 2, length(x))) # constant vector fallback
  }
  rng = range(x, na.rm = TRUE)
  scaled = (x - rng[1]) / (rng[2] - rng[1])
  new_min + scaled * (new_max - new_min)
}
