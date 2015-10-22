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

assert_scalar_or_raw <- function(x, name=deparse(substitute(x))) {
  if (length(x) != 1L && !is.raw(x)) {
    stop(sprintf("%s must be a scalar", name), call.=FALSE)
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

Sys_getenv <- function(x, unset=NULL) {
  assert_scalar_character(x)
  ret <- Sys.getenv(x, NA_character_)
  if (is.na(ret)) unset else ret
}

drop_null <- function(x) {
  x[!vlapply(x, is.null)]
}

modify_list <- function(x, val, name=deparse(substitute(x))) {
  warn_unknown(name, val, names(x))
  modifyList(x, val)
}

warn_unknown <- function(name, defn, known) {
  stop_unknown(name, defn, known, FALSE)
}

## Warn if keys are found in an object that are not in a known set.
stop_unknown <- function(name, defn, known, error=TRUE) {
  unknown <- setdiff(names(defn), known)
  if (length(unknown) > 0) {
    msg <- sprintf("Unknown fields in %s: %s",
                   name, paste(unknown, collapse=", "))
    if (error) {
      stop(msg, call.=FALSE)
    } else {
      warning(msg, immediate.=TRUE, call.=FALSE)
    }
  }
}
