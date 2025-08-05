#' closest_50_exoplanets
#'
#' A sample dataset of 50 exoplanets closest to earth,
#' taken from table `Planetary Systems Composite Parameters`,
#' including their names, discovery methods,
#' and other relevant information.
#'
#' @format A data frame with 683 columns and 50 rows.
#' @source \url{https://exoplanetarchive.ipac.caltech.edu/}
"closest_50_exoplanets"

#' col_labes
#' A collection of Exoplanets archive columns names and their respective labels / comments.
#' Currently only supports `ps` and `pscomppars` tables
#'
#' @format A nested list.
#' @examples
#' col_labels[["ps"]][["pl_name"]]
#'
#' @source \url{https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html#columns}
"col_labels"
