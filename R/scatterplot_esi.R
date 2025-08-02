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
#' @param data_limits A numeric vector of length 2 specifying the lower and upper bounds.
#'  Default is \code{c(0.1, 10)}.
#'
#' @return A ggplot2 object representing the scatterplot.
#'
#' @importFrom ggplot2 ggplot aes geom_point scale_color_viridis_c scale_x_log10
#'   scale_y_log10 ggtitle theme_bw theme element_blank geom_vline
#'   geom_hline scale_color_gradient
#' @importFrom checkmate assert_names assert_data_frame assert_numeric
#'
#' @examples
#' \dontrun{
#'   data = read.csv("some_esi_dataset.csv")
#'   scatterplot_esi(data)
#' }
#' @export

scatterplot_esi = function(data, data_limits = c(0.1, 10)) {
  assert_data_frame(data)
  assert_names(colnames(data), must.include = c("pl_insol", "pl_rade", "esi"))
  assert_numeric(data_limits, len = 2, lower = 0, any.missing = FALSE)


  ggplot(data, aes(x = pl_insol, y = pl_rade, color = esi)) +
    geom_point(size = 3) +
    scale_color_gradient(
                         low = "darkgoldenrod1",
                         high = "darkorchid4",
                         name = "ESI",
                         breaks = seq(0.1, 1.0, by = 0.1)) +
    scale_x_log10(
      limits = data_limits,
      name = expression("Stellar Flux (" * F[p] * ")") # nolint
    ) +
    scale_y_log10(
      limits = data_limits,
      name = expression("Planet Radius (" * R[p] * ")")
    ) +
    ggtitle("Earth Similarity Index Scatterplot") +
    theme_bw(base_size = 14) +
    geom_vline(xintercept = 1, linetype = "dashed") +
    geom_hline(yintercept = 1, linetype = "dashed")
}
