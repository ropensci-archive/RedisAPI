##' Create an rdb object
##' @title Create an rdb object
##' @param driver A \code{redis_api} object or a function that will
##' create one when passed arguments \code{...}
##' @param ... Arguments to the driver
##' @export
##' @importFrom R6 R6Class
##' @examples
##' \dontrun{
##' r <- rdb(hirlite)
##' r$set("foo", runif(10))
##' r$get("foo")
##' r$keys()
##' r$del("foo")
##' r$keys()
##' }
rdb <- function(driver, ...) {
  UseMethod("rdb")
}

##' @export
rdb.redis_api <- function(driver, ...) {
  rdb_generator$new(driver)
}

##' @export
rdb.function <- function(driver, ...) {
  redis <- driver(...)
  if (!inherits(redis, c("redis_api"))) {
    stop("Expected a redis_api object")
  }
  rdb.redis_api(redis)
}

rdb_generator <- R6::R6Class(
  "rdb",
  public=list(
    hiredis=NULL,

    initialize=function(hiredis) {
      self$hiredis <- hiredis
    },

    set=function(key, value) {
      ok <- self$hiredis$SET(key, object_to_string(value))
      if (ok != "OK") {
        stop("Error setting key")
      }
      invisible(NULL)
    },

    get=function(key) {
      ret <- self$hiredis$GET(key)
      if (is.null(ret)) ret else string_to_object(ret)
    },

    keys=function(pattern=NULL) {
      if (is.null(pattern)) {
        pattern <- "*"
      }
      as.character(unlist(self$hiredis$KEYS(pattern)))
    },

    exists=function(key) {
      self$hiredis$EXISTS(key) == 1L
    },

    del=function(key) {
      invisible(self$hiredis$DEL(key) == 1L)
    }
  ))
