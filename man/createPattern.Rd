% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pattern.R
\name{createPattern}
\alias{createPattern}
\title{Create pattern of possible move.}
\usage{
createPattern(field)
}
\arguments{
\item{field}{An integer, a number of a field on the board.}
}
\value{
A vector \code{c(U, R, D, L)} - pattern of a piece.
}
\description{
Create pattern of possible move.
}
\examples{
path[moveNumber]
createPattern(1)
createPattern(7)
}
