#' Generate a Scatterplot of the Earth Similarity Index (ESI)
#'
#' Creates a log-log scatterplot of planetary radius versus stellar flux,
#' colored by the Earth Similarity Index (ESI).
#'
#' Dashed lines at (1,1) indicate Earth's reference values for stellar flux and radius.
#'
#' @param data A data frame containing exoplanet data. Must include the columns:
#'   - `pl_insol`: incident stellar flux (in Earth flux units),
#'   - `pl_rade`: planetary radius (in Earth radii),
#'   - `esi`: Earth Similarity Index (numeric).
#' @param plot_limits A numeric vector of length 2 specifying the lower and upper bounds.
#'  Default is \code{c(0.1, 10)}.
#'
#' @return A ggplot2 object representing the scatterplot.
#'
#' @importFrom ggplot2 ggplot aes geom_point scale_color_viridis_c scale_x_log10
#'   scale_y_log10 labs theme_bw theme element_blank geom_vline
#'   geom_hline scale_color_gradient
#' @importFrom checkmate assert_names assert_data_frame assert_numeric
#'
#' @examples
#' closest_50_exoplanets %>%
#'   dplyr::mutate(esi = calculate_esi(pl_rade, pl_insol)) %>%
#'   scatterplot_esi()
#' @export
scatterplot_esi = function(data, plot_limits = c(0.1, 10)) {
  assert_data_frame(data)
  assert_names(colnames(data), must.include = c("pl_insol", "pl_rade", "esi"))
  assert_numeric(plot_limits, len = 2, lower = 0, any.missing = FALSE)


  ggplot(data, aes(x = pl_insol, y = pl_rade, color = esi)) +
    geom_vline(xintercept = 1, linetype = "dashed") +
    geom_hline(yintercept = 1, linetype = "dashed") +
    geom_point(size = 3) +
    scale_color_gradient(
                         low = "darkgoldenrod1",
                         high = "darkorchid4",
                         name = "ESI",
                         breaks = seq(0.1, 1.0, by = 0.1)) +
    scale_x_log10(limits = plot_limits) +
    scale_y_log10(limits = plot_limits) +
    labs(
      title = "Earth Similarity Index Scatterplot",
      x = expression("Stellar Flux (" * F[p] * ")"), #nolint
      y = expression("Planet Radius (" * R[p] * ")")
    ) +
    theme_bw(base_size = 14)
}
