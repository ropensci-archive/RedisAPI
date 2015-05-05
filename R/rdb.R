##' Create an rdb object
##' @title Create an rdb object
##' @param driver A \code{redis_api} object or a function that will
##' create one when passed arguments \code{...}
##' @param ... Arguments to the driver
##' @param prefix Prefix to add to keys
##' @export
##' @importFrom R6 R6Class
##' @examples
##' \dontrun{
##' r <- rdb(hiredis)
##' r$set("foo", runif(10))
##' r$get("foo")
##' r$keys()
##' r$del("foo")
##' r$keys()
##' }
rdb <- function(driver, ..., prefix="rdb:") {
  if (is.function(driver)) {
    driver <- driver(...)
    if (!inherits(driver, c("redis_api"))) {
      stop("Expected a redis_api object")
    }
  }
  rdb_generator$new(driver, prefix)
}

rdb_generator <- R6::R6Class(
  "rdb",
  public=list(
    hiredis=NULL,
    prefix=NULL,

    initialize=function(hiredis, prefix) {
      self$hiredis <- hiredis
      self$prefix  <- prefix
    },

    set=function(key, value) {
      ok <- self$hiredis$SET(self$key(key), object_to_string(value))
      if (ok != "OK") {
        stop("Error setting key")
      }
      invisible(NULL)
    },

    get=function(key) {
      ret <- self$hiredis$GET(self$key(key))
      if (is.null(ret)) ret else string_to_object(ret)
    },

    keys=function(pattern=NULL) {
      if (is.null(pattern)) {
        pattern <- "*"
      }
      sub(paste0("^", self$prefix), "",
          as.character(unlist(self$hiredis$KEYS(self$key(pattern)))))
    },

    exists=function(key) {
      self$hiredis$EXISTS(self$key(key)) == 1L
    },

    del=function(key) {
      invisible(self$hiredis$DEL(self$key(key)) == 1L)
    },

    key=function(key) {
      paste0(self$prefix, key)
    }
  ))
