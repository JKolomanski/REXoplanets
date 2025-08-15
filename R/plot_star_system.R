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
  spectral_type = NULL,
  habitable_zone = c(0, 0),
  show_legend = FALSE
) {
  assert_data_frame(planet_data)
  assert_numeric(habitable_zone, len = 2)
  assert_names(colnames(planet_data), must.include = c("pl_orbsmax", "pl_rade", "pl_dens"))
  if (!is.null(spectral_type)) {
    assert_character(spectral_type, len = 1, any.missing = FALSE)
    assert_choice(spectral_type, choices = c("O", "B", "A", "F", "G", "K", "M"))
  }

  star_name = paste0(
    "Central star",
    if (!is.null(spectral_type)) paste0(", type ", spectral_type) else ""
  )

  plot_data = data.frame(
    orbit_offset = c(0, runif(nrow(planet_data), min = 0, max = 2 * pi), 0, 0),
    pl_orbsmax = c(0, .rescale_orbsmax(c(
      planet_data$pl_orbsmax,
      min(habitable_zone),
      max(habitable_zone)
    ))),
    pl_rade = c(17, planet_data$pl_rade, 0, 0),
    type = c(star_name, .map_planet_type(planet_data$pl_dens), "HZ inner edge", "HZ outer edge")
  )

  inner_hz = plot_data$pl_orbsmax[nrow(plot_data) - 1]
  outer_hz = plot_data$pl_orbsmax[nrow(plot_data)]
  plot_data = plot_data[1:(nrow(plot_data) - 2), ]

  color_map = c(
    setNames(.map_star_color(spectral_type), star_name),
    "Gas-dominated planet" = "lightblue",
    "Water/ice-rich planet"               = "deepskyblue",
    "Terrestial planet"            = "darkorange3",
    "Iron-rich planet"     = "ivory3",
    "Super-dense planet"      = "gray20"
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
    scale_color_manual(values = color_map) +
    scale_size_continuous(range = c(3.5, 17)) +
    coord_polar(theta = "x") +
    guides(
      size = "none",
      color = guide_legend(title = "", override.aes = list(size = 6, shape = 15))
    ) +
    theme_void() +
    theme(
      panel.background = element_rect(fill = "black", color = NA),
      legend.text = element_text(size = 16),
      legend.justification = "left",
      legend.box.just      = "left",
      legend.position = if (show_legend) "bottom" else "none",
      legend.key.height = unit(19, "pt")
    )
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
