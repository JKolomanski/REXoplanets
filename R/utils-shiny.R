#' Internal helper for creating grid of `valuboxes`
#' for displaying information.
#'
#' @keywords internal
create_value_box_grid = function(df) {
  vbs = lapply(names(df), function(col_name) {
    bslib::value_box(
      title = shiny::span(col_name, style = "font-size:10pt;"),
      value = shiny::span(as.character(df[[1, col_name]]), style = "font-size:16pt;"),
      showcase = NULL,
      theme = bslib::value_box_theme(
        bg = "#ffffff",
        fg = "#252729"
      )
    )
  })

  bslib::layout_column_wrap(
    !!!vbs,
    style = htmltools::css(
      "max-width" = "100%",
      "display" = "grid",
      "grid-template-columns" = "repeat(auto-fit, minmax(160px, 1fr))",
      "gap" = "0.5rem;",
      "overflow" = "auto;"
    )
  )
}
