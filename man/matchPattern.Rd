% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pattern.R
\name{matchPattern}
\alias{matchPattern}
\title{Checks if piece matches the pattern.}
\usage{
matchPattern(id, pattern)
}
\arguments{
\item{id}{An integer, a number of a piece.}

\item{pattern}{A vector \code{c(U, R, D, L)} - pattern of a piece.}
}
\value{
Logical.
}
\description{
Checks if piece matches the pattern.
}
\examples{
matchPattern(9, createPattern(17))
}
\seealso{
\code{\link{createPattern}}.
}
