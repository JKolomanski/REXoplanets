#' Calculate the Earth Similarity Index (ESI)
#'
#' @details
#' The function calculates the ESI for any parameter or number of parameters.
#' By default, it uses the weights of 0.57 for radius and 0.7 for stellar flux.
#'
#' ESI (Earth Similarity Index) is a characterization of how similar a planetary-mass object
#' or natural satellite is to Earth. It is designed to be a scale from zero to one,
#' with Earth having a value of 1.
#'
#' @references
#' Schulze-Makuch, D., Méndez, A., Fairén, A. G., von Paris, P., Turse, C., Boyer, G.,
#' Davila, A. F., Resendes de Sousa António, M., Irwin, L. N., and Catling, D. (2011)
#' A Two-Tiered Approach to Assess the Habitability of Exoplanets. Astrobiology 11(10): 1041-1052.
#'
#' @param ... Any number of numeric parameters representing the planet's characteristics.
#'            Parameter names should have corresponding weight names endin in `_w`
#'            (e.g., `mass`, `mass_w`).
#' @param radius_w Numeric. Weight for radius. Default is 0.57.
#' @param flux_w Numeric. Weight for stellar flux. Default is 0.7.
#'
#' @returns Numeric. Earth Similarity Index (ESI).
#'
#' @examples
#' # ESI for radius and flux, returns 1 (Earth is perfectly similar to itself)
#' calculate_esi(radius = 1, flux = 1)
#' # Mars approximation using radius = 0.532 and flux = 0.43, returns approximately 0.754
#' calculate_esi(radius = 0.532, flux = 0.43)
#' # Custom 3-parameter ESI (e.g. radius, flux, temperature)
#' calculate_esi(radius = 1.1, flux = 1.2, temp = 288,
#'               radius_w = 0.5, flux_w = 0.3, temp_w = 0.2)
#'
#' @importFrom checkmate assert_numeric
#'
#' @export
calculate_esi = function(..., radius_w = 0.57, flux_w = 0.7) {
  args = list(...)
  assert_numeric(unlist(args), lower = 0)
  assert_numeric(radius_w, lower = 0)
  assert_numeric(flux_w, lower = 0)

  # Assign default weights if missing
  if ("radius" %in% names(args)) {
    args$radius_w = radius_w
  }
  if ("flux" %in% names(args)) {
    args$flux_w = flux_w
  }

  values = args[!grepl("_w$", names(args))]
  weights = args[grepl("_w$", names(args))]

  val_names = names(values)
  weight_names = sub("_w$", "", names(weights))

  comp_names = intersect(val_names, weight_names)
  unmatched_vals = setdiff(val_names, weight_names)
  unmatched_weights = setdiff(weight_names, val_names)

  if (length(unmatched_vals) > 0) {
    warning("No matching weights for values: ", paste0(unmatched_vals, collapse = ", "))
  }

  if (length(unmatched_weights) > 0) {
    warning("Weights without matching values: ", paste0(unmatched_weights, collapse = ", "))
  }

  if (length(comp_names) == 0) {
    stop("No matching value-weight pairs found.")
  }

  values = unlist(values[comp_names])
  weights = unlist(weights[paste0(comp_names, "_w")])

  components = (1 - abs((values - 1) / (values + 1)))^weights

  if (length(components) == 1) {
    return(unname(components))
  }
  # Multiply all components element-wise and take square root
  esi_product = Reduce("*", components)
  sqrt(esi_product)
}
