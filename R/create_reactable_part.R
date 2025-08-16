#' Internal helper for breaking up larger
#' `reactable` tables into a single row table
#'
#' @keywords internal
.create_reactable_part = function(output, id, data, col_selector) {
  output[[id]] = reactable::renderReactable({
    shiny::req(data())
    data = dplyr::select(data(), {{ col_selector }})
    reactable::reactable(data)
  })
}
