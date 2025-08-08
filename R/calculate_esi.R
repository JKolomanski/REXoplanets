#' Calculate the Earth Similarity Index (ESI)
#'
#' @details
#' The function calculates the ESI based for any parameter or number of parameters.
#' By default, it uses the weights of 0.57 for radius and 0.7 for stellar flux.
#'
#' ESI (Earth Similarity Index) is a characterization of how similar a planetary-mass object
#' or natural satellite is to earth. It was designed to be a scale from zero to one,
#' with Earth having a value of 1.
#'
#' @references
#' Schulze-Makuch, D., Méndez, A., Fairén, A. G., von Paris, P., Turse, C., Boyer, G.,
#' Davila, A. F., Resendes de Sousa António, M., Irwin, L. N., and Catling, D. (2011)
#' A Two-Tiered Approach to Assess the Habitability of Exoplanets. Astrobiology 11(10): 1041-1052.
#'
#' @param ... any number of numeric parameters representing the planet's characteristics.
#' @param weights Numeric vector of weights for each parameter. Default is c(0.57, 0.7),
#'                assuming The first parameter is the radius, and the second is the stellar flux.
#'
#' @returns Numeric. Earth Similarity Index (ESI).
#'
#' @examples
#' calculate_esi(1, 1)
#' # Returns: 1 (Earth is perfectly similar to itself)
#' # Mars approximation using radius ≈ 0.532 and flux ≈ 0.43
#' calculate_esi(0.532, 0.43)
#' # Returns: ~0.812 (Mars is moderately similar to Earth)
#' # Custom 3-parameter ESI (e.g. radius, flux, temperature)
#' calculate_esi(1.1, 1.2, 288, weights = c(0.5, 0.3, 0.2))
#' # Assumes third value is e.g. temperature in Kelvin
#'
#' @importFrom checkmate assert_numeric test_double
calculate_esi = function(..., weights = c(0.57, 0.7)) {
  args = c(...)

  if (!test_double(weights, lower = 0, len = length(args))) {
    stop("Weights must be numeric >= 0 and match the number of arguments provided.")
  }
  assert_numeric(args, lower = 0)

  components = mapply(function(x, w) {
    (1 - abs((x - 1) / (x + 1)))^w
  }, args, weights, SIMPLIFY = FALSE)

  # If calculating only one component, return it directly
  if (length(components) == 1) {
    return(components[[1]])
  }

  # Multiply all components element-wise and take square root
  esi_product = Reduce("*", components)
  sqrt(esi_product)
}
