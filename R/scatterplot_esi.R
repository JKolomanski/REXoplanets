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
#'
#' @return A ggplot2 object representing the scatterplot.
#'
#' @importFrom ggplot2 ggplot aes geom_point scale_color_viridis_c scale_x_log10
#'   scale_y_log10 ggtitle theme_minimal theme element_blank geom_vline
#'   geom_hline scale_color_gradient
#'
#' @examples
#' \dontrun{
#'   data = read.csv("some_esi_dataset.csv")
#'   scatterplot_esi(data)
#' }
#' @export

scatterplot_esi = function(data) {
  required_cols = c(
    "pl_insol", "pl_rade", "esi"
  )

  missing = setdiff(required_cols, colnames(data))
  if (length(missing) > 0) {
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }

  ggplot(data, aes(x = pl_insol, y = pl_rade, color = esi)) +
    geom_point(size = 3) +
    scale_color_gradient(low = "red", high = "green", name = "ESI") +
    scale_x_log10(
      limits = c(0.1, 15),
      name = expression("Stellar Flux (" * F[p] * ")") # nolint
    ) +
    scale_y_log10(
      limits = c(0.1, 15),
      name = expression("Planet Radius (" * R[p] * ")")
    ) +
    ggtitle("Earth Simillarity Index Scatterplot") +
    theme_minimal(base_size = 14) +
    theme(panel.grid.minor = element_blank()) +
    geom_vline(xintercept = 1, linetype = "dashed") +
    geom_hline(yintercept = 1, linetype = "dashed")
}
