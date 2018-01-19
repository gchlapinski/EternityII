#' Makes move forward if possible. Undo previous move if there is no
#'   possibility to move forward.
#'
#' @param strategy One of the strategies of chosing \code{id} of the piece
#'   for the next move: Rnd, Min, Max.
#' @return \code{id} of piece added to solution (step forward) or removed
#'   from the solution (step backward).
#' @seealso \code{\link{bruteForce}}.
#' @examples
#' makeMove()
#' @export
makeMove <- function(strategy="Rnd") {
  if (possibleMoves[Move == moveNumber, .N] > 0L) {
    if (possibleMoves[Move == moveNumber, .N] > 1L) {
      switch(strategy,
        Rnd={ id <- sample(possibleMoves[Move == moveNumber, ]$Id, 1L) },
        Min={ id <- min(possibleMoves[Move == moveNumber, ]$Id) },
        Max={ id <- max(possibleMoves[Move == moveNumber, ]$Id) }
      )
    } else {
      id <- possibleMoves[Move == moveNumber, ]$Id
    }

    rotation <- possibleMoves[Move == moveNumber & Id == id, ]$Rotation[1]
    moves[id, `:=`(Rotation=rotation, Board=path[moveNumber], Move=moveNumber)]
    switch((rotation - pieces[id, ]$Rotation) %% 4,
      turnPiece90(id),
      turnPiece180(id),
      turnPiece270(id)
    )

    possibleMoves <<- possibleMoves[!(Move == moveNumber &
      Id == id & Rotation == rotation), ]
    moveNumber <<- moveNumber + 1

    id
  } else {
    moveNumber <<- moveNumber - 1
    id <- moves[Move == moveNumber, ]$Id
    moves[Move == moveNumber, `:=`(Rotation=0L, Board=0L, Move=0L)]

    id
  }
}

#' Brute force type algotithm to solve the puzzle game.
#'
#' @return Invisible: Solved teh puzzle game - updated all structures.
#' @seealso \code{\link{makeMove}}.
#' @examples
#' \dontrun{
#' # very long calculation
#' bruteForce()
#' }
#' @export
bruteForce <- function(...) {
  moveTmp <- 0

  while(moveNumber <= length(path)) {
    if (moveTmp < moveNumber) {
      pattern <- findMoves(path[moveNumber])
    }
    moveTmp <- moveNumber
    id <- makeMove()

    if (moveTmp > moveNumber) {
      pattern <- createPattern(path[moveNumber])
      updateEdges(id, pattern, add=FALSE)
    } else {
      updateEdges(id, pattern, add=TRUE)
    }
  }

  if (pieces[, .N] == 25) {
    save(list=c("moves"), file=paste0(Sys.getenv("HOME"), "/puzzle/Solution25.RData"))
    cat(paste0("Finally...\n",
      "Solution saved in file 'Solution.RData'"))
  }

  if (pieces[, .N] == 36) {
    save(list=c("moves"), file=paste0(Sys.getenv("HOME"), "/puzzle/Solution36.RData"))
    cat(paste0("Finally...\n",
               "Solution saved in file 'Solution.RData'"))
  }

  if (pieces[, .N] == 256) {
    save(list=c("moves"), file=paste0(Sys.getenv("HOME"), "/puzzle/Solution256.RData"))
    cat(paste0("Finally...\n",
      "Solution saved in file 'Solution.RData'"))
  }

  invisible()
}

#' Updates available edges counters.
#'
#' @param id An integer, a number of a piece.
#' @param pattern A vector \code{c(U, R, D, L)} - pattern of a piece.
#' @param add Logical (default \code{TRUE}), update edges after adding
#'   or removing piece from the board.
#' @return Invisible: Updated \code{usedEdges}
#' @examples
#' \dontrun{
#' updateEdges(9)
#' }
#' @export
updateEdges <- function(id, pattern=rep(-1L, 4), add=TRUE) {
  for (i in 1:4) {
    if (pattern[i] == -1L) {
      usedEdges[pieces[id, ][[i + 1]], N:=N + 2L*(-1L)^add]
    }
  }

  invisible()
}
