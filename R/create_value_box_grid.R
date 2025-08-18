#' Internal helper for creating grid of `valueboxes`
#' for displaying information.
#'
#' @keywords internal
.create_value_box_grid = function(df) {
  vbs = lapply(names(df), function(col_name) {
    bslib::value_box(
      title = htmltools::tags$span(col_name, style = "font-size:12px;"),
      value = htmltools::tags$span(as.character(df[[1, col_name]]), style = "font-size:20px;"),
      showcase = NULL,
      theme = bslib::value_box_theme(
        bg = "#ffffff",
        fg = "#252729"
      )
    )
  })

  bslib::layout_column_wrap(
    !!!vbs,
    style = paste0(
      "max-width: 100%;",
      "display: grid;",
      "grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));",
      "gap: 8px;",
      "overflow: auto;"
    )
  )
}
