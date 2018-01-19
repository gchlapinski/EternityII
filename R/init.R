#' Initiate or restore the puzzle game - EternityII.
#'
#' @param restore Logical (default \code{TRUE}). Start new game
#'   or restore previously saved one.
#' @param initPiece Logical (default \code{TRUE}). Add init piece to board.
#' @param tip1 Logical (default \code{TRUE}). Add tip 1 piece to board.
#' @param tip2 Logical (default \code{TRUE}). Add tip 2 piece to board.
#' @param tip3 Logical (default \code{TRUE}). Add tip 3 piece to board.
#' @return Invisible: Initiated puzzle game EternityII.
#' @seealso \code{\link{changePath}}.
#' @examples
#' init()
#' @export
init <- function(restore=TRUE, initPiece=TRUE, tip1=TRUE, tip2=TRUE, tip3=TRUE) {
  eterPath <- Sys.getenv("HOME")

  for (ob in c("pieces", "moves", "path", "possibleMoves", "usedEdges",
               "moveNumber")) {
    if (ob %in% ls(envir=.GlobalEnv)) {
      rm(list=c(ob), envir=.GlobalEnv)
    }
  }

  data("pieces256")
  assign("pieces", pieces256, envir=.GlobalEnv)

  if (restore && "etrnityii.RData" %in% list.files(paste0(eterPath, "/puzzle"))) {
    load(paste0(eterPath, "/puzzle/etrnityii.RData"))
    assign("usedEdges", usedEdges, envir=.GlobalEnv)

    cat(paste0("moves loaded...\n", "path loaded...\n", "possibleMoves loaded...\n",
      "usedEdges loaded...\n", "You can start from beginning by calling 'init'\n"))
  } else {
    if (restore) {
      warning("gCoo: There is no file 'etrnityii.RData' to restore...")
    }

    moves <- data.table::data.table(
      Id=1L:256L, Rotation=rep(0L, 256L), Board=rep(0L, 256L), Move=rep(0L, 256L))
    data.table::setDT(moves, key="Id")

    possibleMoves <- data.table::data.table(Move=integer(),
      Id=integer(), Rotation=integer())
    data.table::setDT(possibleMoves, key=c("Move", "Id"))

    usedEdges <- data.table::rbindlist(list(pieces[, .SD, .SDcols="U"],
      pieces[, .SD, .SDcols="R"],
      pieces[, .SD, .SDcols="D"],
      pieces[, .SD, .SDcols="L"]))[U > 0, .N, by=U]
    data.table::setnames(usedEdges, c("U", "N"), c("Edge", "N"))
    data.table::setDT(usedEdges, key="Edge")
    assign("usedEdges", usedEdges, envir=.GlobalEnv)

    moveNumber <- 1L
    path <- gcPath

    if (initPiece) {
      moves[139L, `:=`(Rotation=2L, Board=121L)]
      path <- setdiff(path, 121L)
      updateEdges(139L)
      cat("initPiece added\n")
    }

    if (tip1) {
      moves[181L, `:=`(Rotation=3L, Board=46L)]
      path <- setdiff(path, 46L)
      updateEdges(181L)
      cat("tip 1 added\n")
    }

    if (tip2) {
      moves[255L, `:=`(Rotation=3L, Board=211L)]
      path <- setdiff(path, 211L)
      updateEdges(255L)
      cat("tip 2 added\n")
    }

    if (tip3) {
      moves[249L, `:=`(Rotation=0L, Board=222L)]
      path <- setdiff(path, 222L)
      updateEdges(249L)
      cat("tip 3 added\n")
    }

    if (!("puzzle" %in% list.files(eterPath))) {
      dir.create(paste0(eterPath, "/puzzle"))
    }

    save(list=c("moves", "path", "possibleMoves", "usedEdges", "moveNumber"),
      file=paste0(eterPath, "/puzzle/etrnityii.RData"))

    cat("You may change the path of algorithm calling 'changePath'\n")
  }

  assign("moves", moves, envir=.GlobalEnv)
  assign("path", path, envir=.GlobalEnv)
  assign("possibleMoves", possibleMoves, envir=.GlobalEnv)
  assign("moveNumber", moveNumber, envir=.GlobalEnv)

  initRotation()

  invisible()
}

#' Initiate or restore the clue 1 puzzle game.
#'
#' @param restore Logical (default \code{TRUE}). Start new game
#'   or restore previously saved one.
#' @param initPiece Logical (default \code{TRUE}). Add init piece to board.
#' @param tip1 Logical (default \code{FALSE}). Add tip 1 piece to board.
#' @param tip2 Logical (default \code{FALSE}). Add tip 2 piece to board.
#' @param tip3 Logical (default \code{FALSE}). Add tip 3 piece to board.
#' @return Invisible: Initiated puzzle test game.
#' @seealso \code{\link{changePath}}.
#' @examples
#' init36()
#' @export
init36 <- function(restore=TRUE, initPiece=TRUE, tip1=FALSE, tip2=FALSE, tip3=FALSE) {
  eterPath <- Sys.getenv("HOME")

  for (ob in c("pieces", "moves", "path", "possibleMoves", "usedEdges",
               "moveNumber")) {
    if (ob %in% ls(envir=.GlobalEnv)) {
      rm(list=c(ob), envir=.GlobalEnv)
    }
  }

  data("pieces36")
  assign("pieces", pieces36, envir=.GlobalEnv)

  if (restore && "eternity36.RData" %in% list.files(paste0(eterPath, "/puzzle"))) {
    load(paste0(eterPath, "/puzzle/eternity36.RData"))
    assign("usedEdges", usedEdges, envir=.GlobalEnv)

    cat(paste0("moves loaded...\n", "path loaded...\n", "possibleMoves loaded...\n",
               "usedEdges loaded...\n", "You can start from beginning by calling 'init36'\n"))
  } else {
    if (restore) {
      warning("gCoo: There is no file 'eternity36.RData' to restore...")
    }

    moves <- data.table::data.table(
      Id=1L:36L, Rotation=rep(0L, 36L), Board=rep(0L, 36L), Move=rep(0L, 36L))
    data.table::setDT(moves, key="Id")

    possibleMoves <- data.table::data.table(Move=integer(),
                                            Id=integer(), Rotation=integer())
    data.table::setDT(possibleMoves, key=c("Move", "Id"))

    usedEdges <- data.table::rbindlist(list(pieces[, .SD, .SDcols="U"],
                                            pieces[, .SD, .SDcols="R"],
                                            pieces[, .SD, .SDcols="D"],
                                            pieces[, .SD, .SDcols="L"]))[U > 0, .N, by=U]
    data.table::setnames(usedEdges, c("U", "N"), c("Edge", "N"))
    data.table::setDT(usedEdges, key="Edge")
    assign("usedEdges", usedEdges, envir=.GlobalEnv)

    moveNumber <- 1L
    path <- gc36Path

    if (initPiece) {
      moves[36L, `:=`(Board=1L, Rotation=3L)]
      path <- setdiff(path, 1L)
      updateEdges(1L)
      cat("initPiece added\n")
    }

    if (tip1) {
      cat("tip 1 not available")
    }

    if (tip2) {
      cat("tip 2 not available")
    }

    if (tip3) {
      cat("tip 3 not available")
    }

    if (!("puzzle" %in% list.files(eterPath))) {
      dir.create(paste0(eterPath, "/puzzle"))
    }

    save(list=c("moves", "path", "possibleMoves", "usedEdges", "moveNumber"),
         file=paste0(eterPath, "/puzzle/eternity36.RData"))

    cat("You may change the path of algorithm calling 'changePath'\n")
  }

  assign("moves", moves, envir=.GlobalEnv)
  assign("path", path, envir=.GlobalEnv)
  assign("possibleMoves", possibleMoves, envir=.GlobalEnv)
  assign("moveNumber", moveNumber, envir=.GlobalEnv)

  initRotation()

  invisible()
}

#' Initiate or restore the test puzzle game.
#'
#' @param restore Logical (default \code{TRUE}). Start new game
#'   or restore previously saved one.
#' @param initPiece Logical (default \code{TRUE}). Add init piece to board.
#' @param tip1 Logical (default \code{FALSE}). Add tip 1 piece to board.
#' @param tip2 Logical (default \code{FALSE}). Add tip 2 piece to board.
#' @param tip3 Logical (default \code{FALSE}). Add tip 3 piece to board.
#' @return Invisible: Initiated puzzle test game.
#' @seealso \code{\link{changePath}}.
#' @examples
#' init25()
#' @export
init25 <- function(restore=TRUE, initPiece=TRUE, tip1=TRUE, tip2=TRUE, tip3=TRUE) {
  eterPath <- Sys.getenv("HOME")

  for (ob in c("pieces", "moves", "path", "possibleMoves", "usedEdges",
               "moveNumber")) {
    if (ob %in% ls(envir=.GlobalEnv)) {
      rm(list=c(ob), envir=.GlobalEnv)
    }
  }

  data("pieces25")
  assign("pieces", pieces25, envir=.GlobalEnv)

  if (restore && "test.RData" %in% list.files(paste0(eterPath, "/puzzle"))) {
    load(paste0(eterPath, "/puzzle/test.RData"))
    assign("usedEdges", usedEdges, envir=.GlobalEnv)

    cat(paste0("moves loaded...\n", "path loaded...\n", "possibleMoves loaded...\n",
               "usedEdges loaded...\n", "You can start from beginning by calling 'init25'\n"))
  } else {
    if (restore) {
      warning("gCoo: There is no file 'test.RData' to restore...")
    }

    moves <- data.table::data.table(
      Id=1L:25L, Rotation=rep(0L, 25L), Board=rep(0L, 25L), Move=rep(0L, 25L))
    data.table::setDT(moves, key="Id")

    possibleMoves <- data.table::data.table(Move=integer(),
      Id=integer(), Rotation=integer())
    data.table::setDT(possibleMoves, key=c("Move", "Id"))

    usedEdges <- data.table::rbindlist(list(pieces[, .SD, .SDcols="U"],
                                            pieces[, .SD, .SDcols="R"],
                                            pieces[, .SD, .SDcols="D"],
                                            pieces[, .SD, .SDcols="L"]))[U > 0, .N, by=U]
    data.table::setnames(usedEdges, c("U", "N"), c("Edge", "N"))
    data.table::setDT(usedEdges, key="Edge")
    assign("usedEdges", usedEdges, envir=.GlobalEnv)

    moveNumber <- 1L
    path <- gc25Path

    if (initPiece) {
      moves[9L, `:=`(Board=7L)]
      path <- setdiff(path, 7L)
      updateEdges(9L)
      cat("initPiece added\n")
    }

    if (tip1) {
      moves[19L, `:=`(Board=9L)]
      path <- setdiff(path, 9L)
      updateEdges(19L)
      cat("tip 1 added\n")
    }

    if (tip2) {
      moves[7L, `:=`(Board=17L)]
      path <- setdiff(path, 17L)
      updateEdges(7L)
      cat("tip 2 added\n")
    }

    if (tip3) {
      moves[17L, `:=`(Board=19L)]
      path <- setdiff(path, 19L)
      updateEdges(17L)
      cat("tip 3 added\n")
    }

    if (!("puzzle" %in% list.files(eterPath))) {
      dir.create(paste0(eterPath, "/puzzle"))
    }

    save(list=c("moves", "path", "possibleMoves", "usedEdges", "moveNumber"),
         file=paste0(eterPath, "/puzzle/test.RData"))

    cat("You may change the path of algorithm calling 'changePath'\n")
  }

  assign("moves", moves, envir=.GlobalEnv)
  assign("path", path, envir=.GlobalEnv)
  assign("possibleMoves", possibleMoves, envir=.GlobalEnv)
  assign("moveNumber", moveNumber, envir=.GlobalEnv)

  initRotation()

  invisible()
}

#' Changes path of solving puzzle.
#' @param newPath An integer, number of the prepared paths
#'   (random path: \code{0}) or vector of fields numbers ordered
#'   in a way which field to start and where to go next...
#' @return Invisible: Changed \code{path}.
#' @export
changePath <- function(newPath) {
  eterPath <- Sys.getenv("HOME")

  if (moveNumber > 1) {
    stop(paste0("gCoo: 'path' can be changed only at start.\n",
      "Initiate the game and then change 'path'."))
  }

  if (length(newPath) > length(unique(newPath))) {
    stop(paste0("gCoo: 'newPath` must have unique values"))
  }

  if (length(newPath)== 1) {
    if (newPath == 1L) {
      if (pieces[, .N] == 25) {
        path <- intersect(gc25Path, path)
      }

      if (pieces[, .N] == 36) {
        path <- intersect(gc36Path, path)
      }

      if (pieces[, .N] == 256) {
        path <- intersect(gcPath, path)
      }
    } else {
      path <- intersect(sample(1L:pieces[, .N], pieces[, .N]), path)
    }
  } else {
    if (length(c(moves[Board != 0, ]$Board, newPath)) != pieces[, .N] ||
        length(setdiff(1:pieces[, .N],
          c(moves[Board != 0, ]$Board, newPath))) > 0) {
      stop("gCoo: incorrect 'newPath'")
    }

    path <- newPath
  }

  assign("path", path, envir=.GlobalEnv)

  if (pieces[, .N] == 25) {
    save(list=c("moves", "path", "possibleMoves", "usedEdges", "moveNumber"),
      file=paste0(eterPath, "/puzzle/test.RData"))
  }

  if (pieces[, .N] == 36) {
    save(list=c("moves", "path", "possibleMoves", "usedEdges", "moveNumber"),
         file=paste0(eterPath, "/puzzle/eternity36.RData"))
  }

  if (pieces[, .N] == 255) {
    save(list=c("moves", "path", "possibleMoves", "usedEdges", "moveNumber"),
         file=paste0(eterPath, "/puzzle/eternityii.RData"))
  }

  invisible()
}

#' Initial rotation of restored \code{pieces}.
#'
#' @return Invisible: Rotated pieces.
initRotation <- function() {
  for (i in 1L:pieces[, .N]) {
    if (moves[i, ]$Rotation == 1L) {
      turnPiece90(i)
    }
    if (moves[i, ]$Rotation == 2L) {
      turnPiece180(i)
    }
    if (moves[i, ]$Rotation == 3L) {
      turnPiece270(i)
    }
  }

  invisible()
}
