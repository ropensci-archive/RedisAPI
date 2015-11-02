##' Create a Redis API object.  This function is designed to be used
##' from other packages, and not designed to be used directly by
##' users.
##' @title Create a Redis API object
##' @param x An object
##' @importFrom R6 R6Class
##' @export
##'
redis_api <- function(x) {
  redis_api_generator$new(x)
}
