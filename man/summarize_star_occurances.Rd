% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.R
\name{summarize_star_occurances}
\alias{summarize_star_occurances}
\title{Summarize star occurances}
\usage{
summarize_star_occurances(data)
}
\arguments{
\item{data}{A data frame with KOI data. Must contain \code{kepoi_name} column.}
}
\value{
A data farme containing:
- \code{Star} column with star ID.
- \code{Count} column with number of planets.
}
\description{
Summarize star occurances
}
\details{
The function takes in KOI data frame and summarizes the number of planets that appear in a
given dataset for each star.
}
