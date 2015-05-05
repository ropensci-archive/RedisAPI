##' @export
redis_api.rlite_context <- function(x, ...) {
  redis_api(x$run, ...)
}

##' @export
redis_api.redis_context <- function(x, ...) {
  redis_api(x$context$execv, host=x$host, port=x$port, ...)
}

##' @export
redis_api.Rcpp_Redis <- function(x, ...) {
  redis_api(x$execv, ...)
}

##' Interface to RcppRedis
##' @title Interface to RcppRedis
##' @param host Hostname (default is the localhost)
##' @param port Port to connect on (default is Redis' default of 6379)
##' @export
##' @examples
##' # Only run if RcppRedis is installed and if a Redis server is running
##' if (redis_available()) {
##' r <- hiredis()
##' r$PING()
##' r$SET("foo", "bar")
##' r$GET("foo")
##' }
redis_context <- function(host="127.0.0.1", port=6379) {
  ## This only exists to (a) hide the ugly S4 initialisation and (b)
  ## keep the host/port information.
  ##
  ## Once moved into RcppRedis that won't be needed.
  requireNamespace("RcppRedis")
  ret <- list(host=host, port=port,
              context=new(RcppRedis::Redis, host, port))
  class(ret) <- "redis_context"
  ret
}

##' @export
##' @rdname redis_context
hiredis <- function(host="127.0.0.1", port=6379) {
  redis_api(redis_context(host, port))
}

##' @export
##' @rdname redis_context
##' @param ... Arguments passed from \code{redis_available} to
##' \code{redis_context}
redis_available <- function(...) {
  ## This will throw if Redis is not running or if the RcppRedis
  ## package is not installed
  !inherits(con <- try(redis_context(...), silent=TRUE), "try-error")
}
