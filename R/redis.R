##' Create a Redis API object
##'
##' This function is designed to be used from other packages, and not
##' designed to be used directly by users.  \code{host}, \code{port}
##' and \code{type} are never used except for being stored in the
##' returned object.
##' @title Create a Redis API object
##' @param x An object
##' @param host String indicating the hostnae
##' @param port String indicating the port
##' @param type String indicating the type
##' @importFrom R6 R6Class
##' @export
redis_api <- function(x, host, port, type) {
  redis_api_generator$new(x, host, port, type)
}

##' Create an interface to Redis, via RcppRedis.  The returned object
##' includes methods for all Redis commands.
##'
##' @title Interface to Redis
##' @param host Hostname.  Default is to look up the value of the
##' environment variable \code{REDIS_HOST} and then to default to the
##' value \code{127.0.0.1} (localhost).
##' @param port Port to connect on.  Default is to look up the value
##' of the environment variable \code{REDIS_PORT} and then to default
##' to the value "6379".
##' @export
##' @examples
##' # Only run if a Redis server is running
##' if (redis_available()) {
##'   r <- hiredis()
##'   r$PING()
##'   r$SET("foo", "bar")
##'   r$GET("foo")
##' }
hiredis <- function(host=Sys.getenv("REDIS_HOST", "127.0.0.1"),
                    port=Sys.getenv("REDIS_PORT", 6379)) {
  port <- as.integer(port)
  redis_api(redis_context(host, port)$execv,
            host, port, "RcppRedis")
}

##' @export
##' @rdname hiredis
##' @param ... Arguments passed from \code{redis_available} to
##' \code{hiredis}
redis_available <- function(...) {
  ## This will throw if Redis is not running because we'll get a
  ## "connection refused" error.
  !inherits(con <- try(redis_context(...), silent=TRUE), "try-error")
}

## This only exists to hide the ugly S4 initialisation and be a
## minimal test of Redis running.
redis_context <- function(host="127.0.0.1", port=6379) {
  new(RcppRedis::Redis, host, port)
}
