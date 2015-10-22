##' Create a Redis API object
##'
##' This function is designed to be used from other packages, and not
##' designed to be used directly by users.  \code{host}, \code{port}
##' and \code{type} are never used except for being stored in the
##' returned object.
##' @title Create a Redis API object
##' @param x An object
##' @importFrom R6 R6Class
##' @export
redis_api <- function(x) {
  redis_api_generator$new(x)
}

##' Create an interface to Redis, via redux.  The returned object
##' includes methods for all Redis commands.
##'
##' @title Interface to Redis
##' @param ... Named configuration options passed to
##'   \code{\link{redis_config}}, used to create the environment
##'   (notable keys include \code{host}, \code{port}, and the
##'   environment variable \code{REDIS_URL})
##'
##' @export
##' @importFrom redux redis_connection
##' @examples
##' # Only run if a Redis server is running
##' if (redis_available()) {
##'   r <- hiredis()
##'   r$PING()
##'   r$SET("foo", "bar")
##'   r$GET("foo")
##' }
hiredis <- function(...) {
  redis_api(redux::redis_connection(redis_config(...)))
}

##' @export
##' @rdname hiredis
##' @param ... Arguments passed from \code{redis_available} to
##' \code{hiredis}
redis_available <- function(...) {
  ## This will throw if Redis is not running because we'll get a
  ## "connection refused" error.
  !inherits(try(redux::redis_connection(redis_config(...)), silent=TRUE),
            "try-error")
}
