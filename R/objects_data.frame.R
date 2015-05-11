keys.data.frame <- function(key) {
  rows_cells <- function(i) sprintf("%s:rows:%d", key, i)
  list(type=sprintf("%s:type", key),
       nrows=sprintf("%s:nrows", key),
       rows=sprintf("%s:rows", key),
       rownames=sprintf("%s:rownames", key),
       names=sprintf("%s:names", key),
       factors_levels=sprintf("%s:factors:levels", key),
       factors_ordered=sprintf("%s:factors:ordered", key),
       rows_cells=rows_cells, # cells only
       classes=sprintf("%s:classes", key),
       attributes=sprintf("%s:attributes", key))
}

redis_object_set.data.frame <- function(key, object, db, ...) {
  keys <- keys.data.frame(key)
  dat <- df_disassemble(object)
  nr <- nrow(object)

  ## TODO: On delete, fetch nrow and delete all keys the first.

  ## Delete a bunch of things that are accessed not all at once:
  ## TODO: we really want to be deleting all keys:rows:%d from cells
  ## too, but that's really hard to get right without hitting KEYS.
  ## For now just pass on it.
  db$DEL(as.character(keys[setdiff(names(keys), "rows_cells")]))

  ## TODO: all of this can be considerably sped up using pipelineing
  ## (not available in RcppRedis I think) or using scripting
  ##   - http://redis.io/topics/pipelining
  ##   - http://redis.io/commands/eval
  ## the trick will be to reduce the number of roundtrips (i.e., the
  ## for loop) by pushing the data up in bulk and then directing it
  ## into the right place with a lua script.

  db$SET(keys$type, "data.frame")

  ## TODO: consider saving each row as a *list* to cut back on
  ## overhead of data (by 1/2 or more) but does require careful
  ## cleaning out of data first.

  db$SET(keys$nrows, nr)

  if (!is.null(dat$rownames)) {
    db$RPUSH(keys$rownames, dat$rownames)
  }
  db$RPUSH(keys$names, dat$names)
  if (length(dat$factors$ordered) > 0L) {
    db$HMSET(keys$factors_ordered,
             names(dat$factors$ordered),
             as.character(dat$factors$ordered))
    db$HMSET(keys$factors_levels,
             names(dat$factors$levels),
             vcapply(dat$factors$levels, object_to_string, USE.NAMES=FALSE))
  }
  db$HMSET(keys$classes, dat$names, dat$classes)

  at <- attributes(object)
  at$names <- at$row.names <- NULL # already stored
  ## Could do this with another hash, but
  db$SET(keys$attributes, object_to_string(at))

  idx <- seq_len(nr)
  keys_rows_cells <- keys$rows_cells(idx)
  for (i in idx) {
    db$HMSET(keys_rows_cells[[i]], dat$names, dat$rows[i,])
  }

  invisible(NULL)
}

redis_object_get.data.frame <- function(key, db, ...) {
  keys <- keys.data.frame(key)

  names <- unlist(db$LRANGE(keys$names, 0, -1))
  rownames <- unlist(db$LRANGE(keys$rownames, 0, -1))
  factors_ordered <- from_redis_hash(db, keys$factors_ordered, f=as.logical)
  factors_levels  <- lapply(from_redis_hash(db, keys$factors_levels),
                            string_to_object)
  factors <- list(ordered=factors_ordered,
                  levels=factors_levels)
  at <- string_to_object(db$GET(keys$attributes))
  nr <- as.integer(db$GET(keys$nrows))

  classes <- db$HMGET(keys$classes, names)

  idx <- seq_len(nr)
  keys_rows_cells <- keys$rows_cells(idx)
  rows <- matrix(NA_character_, nr, length(names))
  for (i in idx) {
    rows[i, ] <- as.character(db$HMGET(keys_rows_cells[[i]], names))
  }
  ret <- df_reassemble(names, rownames, rows, factors, classes)

  for (i in names(at)) {
    attr(ret, i) <- at[[i]]
  }
  ret
}

redis_object_del.data.frame <- function(key, db) {
  keys <- keys.data.frame(key)
  n <- db$GET(keys$nrows)
  if (is.null(n)) {
    n <- 100
  } else {
    n <- min(1000, n)
  }
  db$DEL(as.character(keys[setdiff(names(keys), "rows_cells")]))
  pattern <- sub("0$", "*", keys$rows_cells(0))
  if (db$type == "RcppRedis") { # SCAN supported:
    RedisAPI::scan_del(db, pattern, n)
  } else {
    ## Potentially very slow:
    db$DEL(db$KEYS(pattern))
  }
}

## TODO: Use storr to deal with object columns; store them as
## indexable vectors I think.  That's going to deal most nicely with
## the getting them in and out with a nice caching layer that should
## do well from performance, plus we get some ability to access them
## from within Redis.
df_disassemble <- function(x) {
  names <- names(x)

  ## Not the most efficient but it'll do:
  if (is.integer(attr(x, "row.names"))) {
    rownames <- NULL
  } else {
    rownames <- rownames(x, FALSE)
  }

  ## defactor, or we store levels with *every* serialised cell which
  ## is terrible.
  i <- vlapply(x, is.factor)
  factors <- list(levels=lapply(x[i], levels),
                  ordered=vlapply(x[i], is.ordered))
  x[i] <- lapply(x[i], as.integer)

  ## prepare for split:
  x <- unname(x)
  rownames(x) <- NULL

  classes <- df_classes(x)

  rows <- df_to_cells(x, classes)

  list(names=names, rownames=rownames, rows=rows, factors=factors,
       classes=classes)
}
## TODO: Not transitive for all factor types; we'd need to deal with
## *all* elements of factor.  So that's not ideal.  But should work
## reasonably well for now.
##   * ordered comes from is.ordered
## Safer might be to warn & drop the factor?
df_reassemble <- function(names, rownames, rows, factors, classes) {
  f <- function(x) {
    structure(x, names=names, class="data.frame", row.names=1L)
  }

  colnames(rows) <- names
  is_logical <- classes == "logical"
  is_integer <- classes == "integer"
  is_numeric <- classes == "numeric"
  is_other   <- classes == "other"

  df <- as.data.frame(rows, stringsAsFactors=FALSE)
  df[is_logical] <- lapply(df[is_logical],
                           function(x) as.logical(as.integer(x)))
  df[is_integer] <- lapply(df[is_integer], as.integer)
  df[is_numeric] <- lapply(df[is_numeric], as.numeric)
  if (any(is_other)) {
    stop("not yet implemented")
    # x[is_other]   <- lapply(x[is_other], string_to_object)
  }

  if (!is.null(rownames)) {
    attr(df, "row.names") <- rownames
  }

  ## re-factor:
  levels <- factors$levels
  ordered <- factors$ordered
  ## NOTE: Access by *name* not order so we don't assume ordered and
  ## levels are co-sorted.
  for (i in names(levels)) {
    lvls <- levels[[i]]
    df[[i]] <- factor(lvls[df[[i]]], lvls, ordered=ordered[[i]])
  }
  df
}

df_to_cells <- function(x, classes) {
  ## Logicals we'll convert to integer:
  is_logical <- classes == "logical"
  is_number  <- classes == "integer" | classes == "numeric"
  is_other   <- classes == "other"

  x[is_logical] <- lapply(x[is_logical],
                          function(x) as.character(as.integer(x)))
  x[is_number]  <- lapply(x[is_number], as.character)
  ## this is not right; need to serialise at the cell level...
  if (any(is_other)) {
    stop("not yet implemented")
    # x[is_other]   <- lapply(x[is_other], object_to_string)
  }

  as.matrix(x)
}

df_classes <- function(x) {
  cl <- function(x) {
    ret <- class(x)
    if (length(ret) == 1L) ret else "other"
  }
  classes <- vcapply(x, cl)
  classes <- factor(classes,
                    c("logical", "integer", "numeric", "character",
                      "other"))
  classes[is.na(classes)] <- "other"
  as.character(classes)
}
