#' Turn piece by 90 degree.
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(9)
#' turnPiece90(9)
#' showPiece(9)
#' @export
turnPiece90 <- function(id) {
  pieces[id, `:=`(tmp=U, U=L, L=D, D=R, Rotation=(Rotation + 1) %% 4)]
  pieces[id, R:=tmp]
  pieces[, tmp:=NULL]

  invisible()
}

#' Turn piece by 180 degree.
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(9)
#' turnPiece180(9)
#' showPiece(9)
#' @export
turnPiece180 <- function(id) {
  pieces[id, `:=`(tmp1=U, U=D, tmp2=L, L=R, Rotation=(Rotation + 2) %% 4)]
  pieces[id, `:=`(D=tmp1, R=tmp2)]
  pieces[, `:=`(tmp1=NULL, tmp2=NULL)]

  invisible()
}

#' Turn piece by 270 degree.
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(9)
#' turnPiece270(9)
#' showPiece(9)
#' @export
turnPiece270 <- function(id) {
  pieces[id, `:=`(tmp=U, U=R, R=D, D=L, Rotation=(Rotation + 3) %% 4)]
  pieces[id, L:=tmp]
  pieces[, tmp:=NULL]

  invisible()
}

#' Turn corner piece to match proper corner of the border.
#'
#' @param id An integer, a number of a piece.
#' @param field A corner field number: \code{1}, \code{sqrt(N)},
#'   \code{N - sqrt(N) + 1}, \code{N}.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(1)
#' turnCorner(1, 1)
#' showPiece(1)
#' @export
turnCorner <- function(id, field) {
  maxNumber <- pieces[, max(Id)]
  sqrtMax <- sqrt(maxNumber)
  thirdCorner <- maxNumber - sqrtMax + 1

  if (field == 1L) {
    while (pieces[Id == id & U == 0L, .N] == 0L
        || pieces[Id == id & L == 0L, .N] == 0L) {
      turnPiece90(id)
    }
  }

  if (field == sqrtMax) {
    while (pieces[Id == id & D == 0L, .N] == 0L
        || pieces[Id == id & L == 0L, .N] == 0L) {
      turnPiece90(id)
    }
  }

  if (field == thirdCorner) {
    while (pieces[Id == id & U == 0L, .N] == 0L
        || pieces[Id == id & R == 0L, .N] == 0L) {
      turnPiece90(id)
    }
  }

  if (field == maxNumber) {
    while (pieces[Id == id & D == 0L, .N] == 0L
        || pieces[Id == id & R == 0L, .N] == 0L) {
      turnPiece90(id)
    }
  }

  invisible()
}

#' Turn border piece to match proper edge of the border.
#'
#' @param id An integer, a number of a piece.
#' @param field A border field number.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(5)
#' turnBorder(5, 17)
#' showPiece(5)
#' turnBorder(5, 32)
#' showPiece(5)
#' @export
turnBorder <- function(id, field) {
  maxNumber <- pieces[, max(Id)]
  sqrtMax <- sqrt(maxNumber)
  thirdCorner <- maxNumber - sqrtMax + 1

  if (field > 1L && field < sqrtMax) {
    turnBorderLeft(id)
  }

  if (field > thirdCorner && field < maxNumber) {
    turnBorderRight(id)
  }

  if (field > sqrtMax && field < thirdCorner && field %% sqrtMax == 1L) {
    turnBorderUp(id)
  }

  if (field > sqrtMax && field < thirdCorner && field %% sqrtMax == 0L) {
    turnBorderDown(id)
  }

  invisible()
}

#' Turn border piece up (U=0).
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(5)
#' turnBorderUp(5)
#' showPiece(5)
#' @export
turnBorderUp <- function(id) {
  if (pieces[Id == id & U == 0, .N] == 0L) {
    if (pieces[Id == id & D == 0, .N] == 1L) {
      turnPiece180(id)
    } else {
      if (pieces[Id == id & R == 0, .N] == 1L) {
        turnPiece270(id)
      } else {
        turnPiece90(id)
      }
    }

  }

  invisible()
}

#' Turn border piece right (R=0).
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(5)
#' turnBorderRight(5)
#' showPiece(5)
#' @export
turnBorderRight <- function(id) {
  if (pieces[Id == id & R == 0L, .N] == 0L) {
    if (pieces[Id == id & L == 0L, .N] == 1L) {
      turnPiece180(id)
    } else {
      if (pieces[Id == id & D == 0L, .N] == 1L) {
        turnPiece270(id)
      } else {
        turnPiece90(id)
      }
    }

  }

  invisible()
}

#' Turn border piece down (D=0).
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(5)
#' turnBorderDown(5)
#' showPiece(5)
#' @export
turnBorderDown <- function(id) {
  if (pieces[Id == id & D == 0L, .N] == 0L) {
    if (pieces[Id == id & U == 0L, .N] == 1L) {
      turnPiece180(id)
    } else {
      if (pieces[Id == id & L == 0L, .N] == 1L) {
        turnPiece270(id)
      } else {
        turnPiece90(id)
      }
    }

  }

  invisible()
}

#' Turn border piece left (L=0).
#'
#' @param id An integer, a number of a piece.
#' @return Invisible: Turned piece.
#' @seealso \code{\link{showPiece}}, \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(5)
#' turnBorderLeft(5)
#' showPiece(5)
#' @export
turnBorderLeft <- function(id) {
  if (pieces[Id == id & L == 0L, .N] == 0L) {
    if (pieces[Id == id & R == 0L, .N] == 1L) {
      turnPiece180(id)
    } else {
      if (pieces[Id == id & U == 0L, .N] == 1L) {
        turnPiece270(id)
      } else {
        turnPiece90(id)
      }
    }

  }

  invisible()
}
