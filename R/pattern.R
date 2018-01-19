#' Checks if piece matches the pattern.
#'
#' @param id An integer, a number of a piece.
#' @param pattern A vector \code{c(U, R, D, L)} - pattern of a piece.
#' @return Logical.
#' @seealso \code{\link{createPattern}}.
#' @examples
#' matchPattern(9, createPattern(17))
#' @export
matchPattern <- function(id, pattern) {
  if ((pattern[1] == -1L ||
       pieces[Id == id & U == pattern[1], .N] == 1L)
    && (pattern[2] == -1L ||
        pieces[Id == id & R == pattern[2], .N] == 1L)
    && (pattern[3] == -1L ||
        pieces[Id == id & D == pattern[3], .N] == 1L)
    && (pattern[4] == -1L ||
        pieces[Id == id & L == pattern[4], .N] == 1L)) {
    TRUE
  } else {
    FALSE
  }
}

#' Create pattern of possible move.
#'
#' @param field An integer, a number of a field on the board.
#' @return A vector \code{c(U, R, D, L)} - pattern of a piece.
#' @examples
#' path[moveNumber]
#' createPattern(1)
#' createPattern(7)
#' @export
createPattern <- function(field) {
  maxNumber <- pieces[, max(Id)]
  sqrtMax <- sqrt(maxNumber)
  thirdCorner <- maxNumber - sqrtMax + 1

  fieldType <- checkFieldType(field)

  if (fieldType == 1L) {
    c(
      U=ifelse(
        length(U <- pieces[moves[Board == field - 1L, ]$Id, ]$D) > 0L, U, -1L),
      R=ifelse(
        length(R <- pieces[moves[Board == field + sqrtMax, ]$Id, ]$L) > 0L, R, -1L),
      D=ifelse(
        length(D <- pieces[moves[Board == field + 1L, ]$Id, ]$U) > 0L, D, -1L),
      L=ifelse(
        length(L <- pieces[moves[Board == field - sqrtMax, ]$Id, ]$R) > 0L, L, -1L))
  } else {
    if (fieldType == 2L) {
      switch(checkBorderKind(field),
             c(
               U=0L,
               R=ifelse(
                 length(R <- pieces[moves[Board == field + sqrtMax, ]$Id, ]$L) > 0L,
                 R, -1L),
               D=ifelse(
                 length(D <- pieces[moves[Board == field + 1L, ]$Id, ]$U) > 0L,
                 D, -1L),
               L=ifelse(
                 length(L <- pieces[moves[Board == field - sqrtMax, ]$Id, ]$R) > 0L,
                 L, -1L)),
             c(
               U=ifelse(
                 length(U <- pieces[moves[Board == field - 1L, ]$Id, ]$D) > 0L,
                 U, -1L),
               R=0L,
               D=ifelse(
                 length(D <- pieces[moves[Board == field + 1L, ]$Id, ]$U) > 0L,
                 D, -1L),
               L=ifelse(
                 length(L <- pieces[moves[Board == field - sqrtMax, ]$Id, ]$R) > 0L,
                 L, -1L)),
             c(
               U=ifelse(
                 length(U <- pieces[moves[Board == field - 1L, ]$Id, ]$D) > 0L,
                 U, -1L),
               R=ifelse(
                 length(R <- pieces[moves[Board == field + sqrtMax, ]$Id, ]$L) > 0L,
                 R, -1L),
               D=0L,
               L=ifelse(
                 length(L <- pieces[moves[Board == field - sqrtMax, ]$Id, ]$R) > 0L,
                 L, -1L)),
             c(
               U=ifelse(
                 length(U <- pieces[moves[Board == field - 1L, ]$Id, ]$D) > 0L,
                 U, -1L),
               R=ifelse(
                 length(R <- pieces[moves[Board == field + sqrtMax, ]$Id, ]$L) > 0L,
                 R, -1L),
               D=ifelse(
                 length(D <- pieces[moves[Board == field + 1L, ]$Id, ]$U) > 0L,
                 D, -1L),
               L=0L)
      )
    } else {
      switch(which(field == c(1L, thirdCorner, sqrtMax, maxNumber)),
             c(
               U=0L,
               R=ifelse(
                 length(R <- pieces[moves[Board == field + sqrtMax, ]$Id, ]$L) > 0L,
                 R, -1L),
               D=ifelse(
                 length(D <- pieces[moves[Board == field + 1L, ]$Id, ]$U) > 0L,
                 D, -1L),
               L=0L),
             c(
               U=0L,
               R=0L,
               D=ifelse(
                 length(D <- pieces[moves[Board == field + 1L, ]$Id, ]$U) > 0L,
                 D, -1L),
               L=ifelse(
                 length(L <- pieces[moves[Board == field - sqrtMax, ]$Id, ]$R) > 0L,
                 L, -1L)),
             c(
               U=ifelse(
                 length(U <- pieces[moves[Board == field - 1L, ]$Id, ]$D) > 0L,
                 U, -1L),
               R=ifelse(
                 length(R <- pieces[moves[Board == field + sqrtMax, ]$Id, ]$L) > 0L,
                 R, -1L),
               D=0L,
               L=0L),
             c(
               U=ifelse(
                 length(U <- pieces[moves[Board == field - 1L, ]$Id, ]$D) > 0L,
                 U, -1L),
               R=0L,
               D=0L,
               L=ifelse(
                 length(L <- pieces[moves[Board == field - sqrtMax, ]$Id, ]$R) > 0L,
                 L, -1L))
      )
    }
  }
}


#' Check type of the board field.
#'
#' @return An integer: 1 - middle, 2 - border, 3 - corner.
#' @examples
#' checkFieldType(1)
#' checkFieldType(2)
#' @export
checkFieldType <- function(field) {
  maxNumber <- pieces[, max(Id)]
  sqrtMax <- sqrt(maxNumber)
  thirdCorner <- maxNumber - sqrtMax + 1

  if (field > sqrtMax && field < thirdCorner && field %% sqrtMax > 1L) {
    1L
  } else {
    if (field %in% c(1L, sqrtMax, thirdCorner, maxNumber)) {
      3L
    } else {
      2L
    }
  }
}

#' Check type of the board field.
#'
#' @return An integer: 1 - up, 2 - right, 3 - down, 4 - left.
#' @examples
#' checkBorderKind(2)
#' @export
checkBorderKind <- function(field) {
  maxNumber <- pieces[, max(Id)]
  sqrtMax <- sqrt(maxNumber)
  thirdCorner <- maxNumber - sqrtMax + 1

  if (field < sqrtMax) {
    4L
  } else {
    if (field > thirdCorner) {
      2L
    } else {
      if (field %% sqrtMax == 0L) {
        3L
      } else {
        1L
      }
    }
  }
}
