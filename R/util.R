vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}
viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}
vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
}
vnapply <- function(X, FUN, ...) {
  vapply(X, FUN, numeric(1), ...)
}
interleave <- function(a, b) {
  c(rbind(a, b, deparse.level=0))
}

command <- function(cmd, value, combine) {
  n <- length(value)
  if (n == 0L) {
    NULL
  } else if (n == 1L || combine) {
    c(cmd, value)
  } else {
    interleave(rep_len(cmd, length(value)), value)
  }
}

assert_match_value <- function(x, choices, name=deparse(substitute(x))) {
  assert_scalar_character(x)
  if (!(x %in% choices)) {
    stop(sprintf("%s must be one of %s", name,
                 paste(dQuote(choices), collapse = ", ")))
  }
}

assert_match_value_or_null <- function(x, choices,
                                       name=deparse(substitute(x))) {
  if (!is.null(x)) {
    assert_scalar_character(x)
    if (!(x %in% choices)) {
      stop(sprintf("%s must be one of %s", name,
                   paste(dQuote(choices), collapse = ", ")))
    }
  }
}

assert_scalar <- function(x, name=deparse(substitute(x))) {
  if (length(x) != 1L) {
    stop(sprintf("%s must be a scalar", name), call.=FALSE)
  }
}

assert_length <- function(x, n, name=deparse(substitute(x))) {
  if (length(x) != n) {
    stop(sprintf("%s must be length %d", name, n), call.=FALSE)
  }
}

assert_character <- function(x, name=deparse(substitute(x))) {
  if (!is.character(x)) {
    stop(sprintf("%s must be character", name), call.=FALSE)
  }
}

assert_scalar_character <- function(x, name=deparse(substitute(x))) {
  assert_scalar(x, name)
  assert_character(x, name)
}

assert_scalar_or_null <- function(x, name=deparse(substitute(x))) {
  if (!is.null(x)) {
    assert_scalar(x, name)
  }
}

assert_length_or_null <- function(x, n, name=deparse(substitute(x))) {
  if (!is.null(x)) {
    assert_length(x, n, name)
  }
}

assert_named <- function(x,
                         empty_can_be_unnamed=TRUE,
                         unique_names=TRUE,
                         name=deparse(substitute(x))) {
  nx <- names(x)
  if (is.null(nx) || any(nx == "")) {
    if (length(x) > 0 || !empty_can_be_unnamed) {
      stop(sprintf("%s must be named", name), call.=FALSE)
    }
  } else if (unique_names && any(duplicated(nx))) {
    stop(sprintf("%s must have unique names", name), call.=FALSE)
  }
}
