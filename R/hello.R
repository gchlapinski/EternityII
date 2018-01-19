#' EternityII: A brute force type algorithm trying solve this puzzle.
#'
#' Different implementation of a brute force type algorithms solving
#' EternityII puzzle:
#' \url{https://en.wikipedia.org/wiki/Eternity_II_puzzle}
#'
#' @docType package
#' @name EternityII
NULL

#' 256 puzzle pieces.
#'
#' A dataset containing info about pieces' Ids, edges and types.
#' The value of an edge is decoded: 0 for border and 1-22 for
#' different symbols.
#'
#' @format A data.table with 256 rows and 6 variables:
#' \describe{
#'   \item{Id}{Piece's number,}
#'   \item{U}{Up edge,}
#'   \item{R}{Right edge,}
#'   \item{D}{Down edge,}
#'   \item{L}{Left edge,}
#'   \item{Type}{Piece's type: 1 - middle, 2 - border, 3 - corner,}
#'   \item{Rotation}{0 - not rotated, 1 - turned by 90 degree,
#'     2 - turned by 180 degree, 3 - turned by 270 degree.}
#' }
"pieces256"

#' 36 puzzle pieces (clue 1).
#'
#' A dataset containing info about pieces' Ids, edges and types.
#' The value of an edge is decoded: 0 for border and 1-7 for
#' different symbols.
#'
#' @format A data.table with 256 rows and 6 variables:
#' \describe{
#'   \item{Id}{Piece's number,}
#'   \item{U}{Up edge,}
#'   \item{R}{Right edge,}
#'   \item{D}{Down edge,}
#'   \item{L}{Left edge,}
#'   \item{Type}{Piece's type: 1 - middle, 2 - border, 3 - corner,}
#'   \item{Rotation}{0 - not rotated, 1 - turned by 90 degree,
#'     2 - turned by 180 degree, 3 - turned by 270 degree.}
#' }
"pieces36"

#' 72 puzzle pieces (clue 2).
#'
#' A dataset containing info about pieces' Ids, edges and types.
#' The value of an edge is decoded: 0 for border and 1-8 for
#' different symbols.
#'
#' @format A data.table with 256 rows and 6 variables:
#' \describe{
#'   \item{Id}{Piece's number,}
#'   \item{U}{Up edge,}
#'   \item{R}{Right edge,}
#'   \item{D}{Down edge,}
#'   \item{L}{Left edge,}
#'   \item{Type}{Piece's type: 1 - middle, 2 - border, 3 - corner,}
#'   \item{Rotation}{0 - not rotated, 1 - turned by 90 degree,
#'     2 - turned by 180 degree, 3 - turned by 270 degree.}
#' }
"pieces72"

#' 25 puzzle pieces (test version).
#'
#' A dataset containing info about pieces' Ids, edges and types.
#' The value of an edge is decoded: 0 for border and 1-4 for
#' different symbols.
#'
#' @format A data.table with 256 rows and 6 variables:
#' \describe{
#'   \item{Id}{Piece's number,}
#'   \item{U}{Up edge,}
#'   \item{R}{Right edge,}
#'   \item{D}{Down edge,}
#'   \item{L}{Left edge,}
#'   \item{Type}{Piece's type: 1 - middle, 2 - border, 3 - corner,}
#'   \item{Rotation}{0 - not rotated, 1 - turned by 90 degree,
#'     2 - turned by 180 degree, 3 - turned by 270 degree.}
#' }
"pieces25"

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste0("\n\n",
    "EternityII waits for a solution...\n",
    'Check vignette("EternityII")...'))
}
