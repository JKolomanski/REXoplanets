#' Internal helper for creating grid of `valuboxes`
#' for displaying information.
#'
#' @keywords internal
create_value_box_grid = function(df) {
  vbs = purrr::imap(as.list(df), function(value, name) {
    print(value)
    print(name)
    print("AABBCC")
    bslib::value_box(
      title = htmltools::tags$span(as.character(name), style = "font-size:10pt;"),
      value = htmltools::tags$span(as.character(value), style = "font-size:16pt;"),
      showcase = NULL,
      theme = bslib::value_box_theme(
        bg = "#ffffff",
        fg = "#252729"
      )
    )
  })

  bslib::layout_column_wrap(
    !!!unname(vbs),
    style = htmltools::css(
      "max-width" = "100%",
      "display" = "grid",
      "grid-template-columns" = "repeat(auto-fit, minmax(160px, 1fr))",
      "gap" = "0.5rem;",
      "overflow" = "auto;"
    )
  )
}
