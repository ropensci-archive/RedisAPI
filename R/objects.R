##' Support for writing and reading R objects (currently data.frames)
##' to a redis instance.
##' @title Read/write R objects to Redis
##' @param object An R object (must be a data.frame at present)
##' @param key The key to store it in
##' @param db The database to store it in
##' @param ... Additional arguments to methods
##' @export
##' @rdname redis_object
##' @name redis_object
redis_object_set <- function(key, object, db, ...) {
  if (inherits(object, "data.frame")) {
    redis_object_set.data.frame(key, object, db, ...)
  } else {
    stop("Can't store object of class %s as a Redis object",
         paste(sprintf('"^s"', class(object)), collapse=", "))
  }
}

##' @export
##' @rdname redis_object
redis_object_get <- function(key, db, ...) {
  type <- redis_object_type(key, db)
  f <- switch(type,
              data.frame=redis_object_get.data.frame,
              stop("Unknown type: ", type))
  f(key, db, ...)

}

##' @export
##' @rdname redis_object
redis_object_del <- function(key, db, ...) {
  type <- redis_object_type(key, db)
  exists <- !is.null(type)
  if (exists) {
    f <- switch(type,
                data.frame=redis_object_del.data.frame,
                function(...) {})
    f(key, db, ...)

  }
  invisible(exists)
}

##' @export
##' @rdname redis_object
redis_object_exists <- function(key, db, ...) {
  !is.null(redis_object_type(key, db))
}

##' @export
##' @rdname redis_object
redis_object_type <- function(key, db, ...) {
  db$GET(sprintf("%s:type", key))
}
