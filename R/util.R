vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}
viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}
vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
}
interleave <- function(a, b) {
  c(rbind(a, b, deparse.level=0))
}

assert_scalar <- function(x, name=deparse(substitute(x))) {
  if (length(x) != 1) {
    stop(sprintf("%s must be a scalar", name), call.=FALSE)
  }
}

assert_scalar_or_null <- function(x, name=deparse(substitute(x))) {
  if (!(is.null(x) || length(x) == 1L)) {
    stop(sprintf("%s must be a scalar or NULL", name), call.=FALSE)
  }
}
