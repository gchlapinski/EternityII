#' Show piece (png).
#'
#' @param id A number of a piece.
#' @return Invisible. Plot.
#' @seealso \code{\link{showPiece}}.
#' @examples
#' showPiecePNG(9)
#' @export
showPiecePNG <- function(id) {
  op <- par(no.readonly=TRUE)
  on.exit(par(op))

  par(mar=c(2, 2, 2, 2))

  imaG <- png::readPNG(system.file("pngsym",
    paste0("Symbol", pieces[id, ]$U, ".png"), package="EternityII"))
  imaP <- png::readPNG(system.file("pngsym",
    paste0("Symbol", pieces[id, ]$R, ".png"), package="EternityII"))
  imaD <- png::readPNG(system.file("pngsym",
    paste0("Symbol", pieces[id, ]$D, ".png"), package="EternityII"))
  imaL <- png::readPNG(system.file("pngsym",
    paste0("Symbol", pieces[id, ]$L, ".png"), package="EternityII"))

  plot(1:2, type='n', main=pieces[id, ]$Id,
       xaxt="n", yaxt="n", xlab="", ylab="", bty="n")
  rasterImage(imaL, 1.01, 1.33, 1.33, 1.66)
  rasterImage(imaD, 1.64, 1.01, 1.97, 1.33, ang=90)
  rasterImage(imaP, 1.99, 1.66, 2.32, 1.99, ang=180)
  rasterImage(imaG, 1.35, 2.01, 1.68, 2.33, ang=270)

  invisible()
}

#' Show piece (3x3).
#'
#' @param id A number of a piece.
#' @return \code{mat} matrix 3 by 3
#' @seealso \code{\link{showPiecePNG}}.
#' @examples
#' showPiece(9)
#' @export
showPiece <- function(id) {
  mat <- matrix(rep(c(""), 9L), 3L, 3L)
  mat[1, 2] <- pieces[id, ]$U
  mat[2, 1] <- pieces[id, ]$L
  mat[2, 2] <- id
  mat[2, 3] <- pieces[id, ]$R
  mat[3, 2] <- pieces[id, ]$D

  data.table::data.table(mat)
}

#' Show path.
#'
#' @param pth vector of fields numbers of the board (or subset if initial
#'   or/and tips pieces are used.
#' @return \code{board} matrix \code{N} by \code{N} with numbered fields according to path.
#' @seealso \code{\link{showBoard}}.
#' @examples
#' showPath(path)
#' @export
showPath <- function(pth=path) {
  len <- length(path)
  i <- 2

  while (i^2 < len) {
    i <- i + 1
  }

  board <- matrix(rep(0L, i^2), i, i)

  for (i in 1:length(pth)) {
    board[path[i]] <- i
  }

  data.table(board)
}

#' Show board.
#'
#' @return \code{board} matrix \code{N} by \code{N} with Ids of pieces on fields.
#' @seealso \code{\link{showPath}}.
#' @examples
#' showBoard()
#' @export
showBoard <- function() {
  maxNumber <- pieces[, max(Id)]
  sqrtMax <- sqrt(maxNumber)

  board <- matrix(rep("", maxNumber), sqrtMax, sqrtMax)
  board[moves[Board != 0L, ]$Board] <- moves[Board != 0L, ]$Id

  data.table::data.table(board)
}

#' #' Show board EternityII.
#' #'
#' #' @param board A matrix 16 by 16.
#' #' @return Invisible. Plot.
#' #' @examples
#' #' showBoardPlot(pieces[69, ])
#' showBoard <- function(board, boardTitle="Eternity II") {
#'   x <- which(!is.na(board[9, ]))
#'   y <- rep(9, length(x))
#'
#'   default_par <- par(no.readonly = TRUE)
#'   #  par(bg="darkgray")
#'   #  on.exit(par(default_par))
#'
#'   plot(x, y, pch='.', xlab="", ylab="", main=boardTitle, col=115, cex=1,
#'        xlim=c(0.5, 16.5), ylim=c(16.5, 0.5), asp=0.95, lwd=1, xaxt="n", yaxt="n")
#'
#'   abline(h=seq(from=0.5, to=16.5, by=1), lty=3)
#'   abline(v=seq(from=0.5, to=16.5, by=1), lty=3)
#'
#'   text(rep(0.2, 16), 1:16, label=c("A", "B", "C", "D", "E", "F", "G", "H",
#'                                    "I", "J", "K", "L", "M", "N", "O", "P"), cex=0.8)
#'   text(rep(16.9, 16), 1:16, label=c("A", "B", "C", "D", "E", "F", "G", "H",
#'                                     "I", "J", "K", "L", "M", "N", "O", "P"), cex=0.8)
#'   text(1:16, rep(0.1, 16), label=c("1", "2", "3", "4", "5", "6", "7", "8",
#'                                    "9", "10", "11", "12", "13", "14", "15", "16"), cex=0.8)
#'   text(1:16, rep(16.8, 16), label=c("1", "2", "3", "4", "5", "6", "7", "8",
#'                                     "9", "10", "11", "12", "13", "14", "15", "16"), cex=0.8)
#'
#'   for (i in 1:16) {   #i=0 , j=0
#'     for(j in 1:16) {
#'       text(j, i, label=board[i, j], cex=0.7, col="springgreen")
#'       if (j < 16) {
#'         if (!(is.na(board[i, j]) && is.na(board[i, j + 1]))) {
#'           if (is.na(board[i, j]) || is.na(board[i, j + 1])) {
#'             lines(c(j + 0.5, j + 0.5), c(i - 0.5, i + 0.5), lty=1, lwd=2,
#'                   col="darkseagreen")
#'           } else {
#'             if (klocki[board[i, j], ]$P == klocki[board[i, j + 1], ]$L) {
#'               lines(c(j + 0.5, j + 0.5), c(i - 0.5, i + 0.5),
#'                     lty=1, lwd=3, col="darkorchid")
#'             } else {
#'               lines(c(j + 0.5, j + 0.5), c(i - 0.5, i + 0.5),
#'                     lty=1, lwd=3, col="gold4")
#'             }
#'           }
#'         }
#'       }
#'       if (i < 16) {
#'         if (!(is.na(board[i, j]) && is.na(board[i + 1, j]))) {
#'           if (is.na(board[i, j]) || is.na(board[i + 1, j])) {
#'             lines(c(j - 0.5, j + 0.5), c(i + 0.5, i + 0.5), lty=1, lwd=2,
#'                   col="darkseagreen")
#'           } else {
#'             if (klocki[board[i, j], ]$D == klocki[board[i + 1, j], ]$G) {
#'               lines(c(j - 0.5, j + 0.5), c(i + 0.5, i + 0.5),
#'                     lty=1, lwd=3, col="darkorchid")
#'             } else {
#'               lines(c(j - 0.5, j + 0.5), c(i + 0.5, i + 0.5),
#'                     lty=1, lwd=3, col="gold4")
#'             }
#'           }
#'         }
#'       }
#'     }
#'   }
#'
#'   invisible()
#' }
