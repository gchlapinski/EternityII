#' Finds possible moves (also checks rotations).
#'
#' @param field An integer, a number of a field on the board.
#' @return A vector \code{c(U, R, D, L)} - pattern of a piece.
#'   Updated structure \code{possibleMoves}.
#' @seealso \code{\link{createPattern}}.
#' @examples
#' findMoves(120)
#' @export
findMoves <- function(field) {
  fieldType <- checkFieldType(field)
  pattern <- createPattern(field)

  switch (fieldType,
    { for (id in intersect(moves[Board == 0, ]$Id, pieces[Type == fieldType, ]$Id)) {
        for (i in 1:4) {
          turnPiece90(id)
          if (matchPattern(id, pattern) && checkEdges(id, pattern)) {
            possibleMoves <- data.table::rbindlist(list(possibleMoves,
              data.table::data.table(Move=moveNumber,
                Id=id, Rotation=pieces[id, ]$Rotation)))
          }
        }
      }
    },
    { for (id in intersect(moves[Board == 0, ]$Id, pieces[Type == fieldType, ]$Id)) {
        turnBorder(id, field)
        if (matchPattern(id, pattern) && checkEdges(id, pattern)) {
          possibleMoves <- data.table::rbindlist(list(possibleMoves,
            data.table::data.table(Move=moveNumber,
              Id=id, Rotation=pieces[id, ]$Rotation)))
        }
      }
    },
    { for (id in intersect(moves[Board == 0, ]$Id, pieces[Type == fieldType, ]$Id)) {
        turnCorner(id, field)
        if (matchPattern(id, pattern) && checkEdges(id, pattern)) {
          possibleMoves <- data.table::rbindlist(list(possibleMoves,
            data.table::data.table(Move=moveNumber,
              Id=id, Rotation=pieces[id, ]$Rotation)))
        }
      }
    }
  )

  possibleMoves <<- possibleMoves

  pattern
}

#' Checks if edges of new pieces are available.
#'
#' @param id An integer, a number of a piece.
#' @param pattern A vector \code{c(U, R, D, L)} - pattern of a piece.
#' @return Logical.
#' @examples
#' checkEdges(9, createPattern(12))
#' @export
checkEdges <- function(id, pattern) {
  edgesAvailable <- TRUE

  for (i in 1:4) { # i = 1
    if (pattern[i] == -1L) {
      if (usedEdges[pieces[id, ][[i + 1]], ]$N == 0L) {
        edgesAvailable <- FALSE
        break
      }
    }
  }

  edgesAvailable
}
