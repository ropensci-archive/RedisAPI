##' Create a Redis API object
##' @title Create a Redis API object
##' @param x An object
##' @param ... Arguments passed through to methods
##' @importFrom R6 R6Class
##' @export
redis_api <- function(x, ...) {
  UseMethod("redis_api")
}
##' @export
redis_api.default <- function(x, ...) {
  redis_api_generator$new(x, ...)
}

redis_api_info <- function(run, host=NULL, port=NULL, type=NULL) {
  if (!is.function(run)) {
    stop("run must be a function")
  }
  ## First, try and determine the type:
  envir <- environment(run)
  if (is.null(type)) {
    type <- get(".packageName", envir)
  }
  if (type == "rrlite") {
    if (is.null(host)) {
      host <- envir$self$path
    }
  } else if (type == "RcppRedis") {
    ## TODO: not yet fetchable
  } else if (type == "rredis") {
    if (is.null(host)) {
      host <- envir$.redisEnv$current$host
    }
    if (is.null(port)) {
      port <- envir$.redisEnv$current$port
    }
  }
  list(host=host, port=port, type=type)
}

##' Parse information returned by \code{INFO}
##' @title Parse Redis INFO
##' @param x character string
##' @export
parse_info <- function(x) {
  xx <- strsplit(x, "\r\n", fixed=TRUE)[[1]]
  xx <- strsplit(xx, ":")
  xx <- xx[viapply(xx, length) == 2L]
  keys <- setNames(vcapply(xx, "[[", 2),
                   vcapply(xx, "[[", 1))
  keys <- strsplit(keys, ",", fixed=TRUE)
  keys$redis_version <- numeric_version(keys$redis_version)
  keys
}
