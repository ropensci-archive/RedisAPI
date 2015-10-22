## Utilities for dealing with Redis:
interleave <- function(a, b) {
  assert_length(b, length(a))
  convert <- function(x) {
    if (is.logical(x)) {
      as.character(as.integer(x))
    } else if (is.list(x)) {
      x
    } else {
      as.character(x)
    }
  }
  join <- function(a, b) {
    c(rbind(a, b))
  }
  a <- convert(a)
  b <- convert(b)
  if (is.character(a) && is.character(b)) {
    join(a, b)
  } else {
    join(as.list(a), as.list(b))
  }
}

command <- function(cmd, value, combine) {
  n <- length(value)
  if (n == 0L) {
    NULL
  } else if (n == 1L || combine) {
    list(cmd, value)
  } else {
    interleave(rep_len(cmd, length(value)), value)
  }
}

hiredis_function <- function(f, required=FALSE, name=deparse(substitute(f))) {
  if (is.null(f)) {
    ## Probably deparse the name a little better to strip off a leading obj$?
    force(name)
    if (required) {
      stop(sprintf("Interface function %s required", name))
    }
    f <- function(...) {
      stop(sprintf("%s is not supported with this interface", name))
    }
  }
  f
}
