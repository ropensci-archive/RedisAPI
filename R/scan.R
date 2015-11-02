##' Support for iterating with \code{SCAN}.  Note that this will
##' generalise soon to support collecting output, \code{SSCAN} and
##' other variants, etc.
##'
##' The functions \code{scan_del} and \code{scan_find} are example
##' functions that delete and find all keys corresponding to a given
##' pattern.
##'
##' @title Iterate over keys using SCAN
##' @param con A \code{redis_api} object
##' @param callback Function that takes a character vector of keys and
##' does something useful to it.  \code{con$DEL} is one option here to
##' delete keys that match a pattern.
##' @param pattern Optional pattern to use.
##' @param count Optional step size (default is Redis' default which
##' is 10)
##' @export
scan_apply <- function(con, callback, pattern=NULL, count=NULL) {
  ## TODO: need escape hatch here for rlite which does not support
  ## SCAN yet.  According to the issue on rlite, the best thing to do
  ## is KEYS
  cursor <- 0L
  repeat {
    res <- con$SCAN(cursor, pattern, count)
    cursor <- res[[1]]
    callback(as.character(res[[2]]))
    if (cursor == "0") {
      break
    }
  }
}

##' @export
##' @rdname scan_apply
scan_del <- function(con, pattern, count=NULL) {
  n <- 0L
  del <- function(keys) {
    if (length(keys) > 0L) {
      n <<- n + con$DEL(keys)
    }
  }
  scan_apply(con, del, pattern, count)
  n
}

##' @export
##' @rdname scan_apply
scan_find <- function(con, pattern, count=NULL) {
  res <- character(0)
  find <- function(keys) {
    if (length(keys) > 0L) {
      res <<- c(res, keys)
    }
  }
  scan_apply(con, find, pattern, count)
  res
}
