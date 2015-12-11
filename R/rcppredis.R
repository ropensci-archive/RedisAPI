##' Support for using RcppRedis with RedisAPI.
##'
##' @section Differences to redux/rrlite:
##'
##'  Note that via this interface RcppRedis will not support binary
##' serialisation (though it does through its own interface) so you
##' need to use \code{object_to_string}/\code{string_to_object} rather
##' than \code{object_to_bin}/\code{bin_to_object}.
##'
##' Treatment of TRUE/FALSE is different as redux will store them as
##' 1/0 but RcppRedis will store as "TRUE"/"FALSE".  Both will be
##' conveted back to TRUE/FALSE after \code{as.logical} though.
##'
##' RcppRedis returns strings for Redis statuses (which \emph{are}
##' just strings) but redux/rrlite add a \code{redis_status}
##' attribute.
##'
##' @title RcppRedis interface
##' @param config A named list of configuration options, as generated
##'   by \code{\link{redis_config}}.  Only \code{host} and \code{port}
##'   are used at present.
##' @export
rcppredis_connection <- function(config=redis_config()) {
  loadNamespace("methods")
  loadNamespace("RcppRedis")
  connect <- function(config) {
    methods::new(RcppRedis::Redis, config$host, config$port)$execv
  }
  stop_if_raw <- function(x) {
    if (any(vapply(x, is.raw, logical(1)))) {
      stop("Binary objects not supported through RedisAPI + RcppRedis")
    }
  }
  run_command <- function(r, cmd) {
    stop_if_raw(cmd)
    if (any(vapply(cmd, is.list, logical(1)))) {
      cmd <- unlist(cmd, FALSE)
      stop_if_raw(cmd)
    }
    r(as.character(unlist(cmd)))
  }
  r <- connect(config)
  ret <-
    list(
      config=function() {
        config
      },
      reconnect=function() {
        r <<- connect(config)
      },
      command=function(cmd) {
        run_command(r, cmd)
      },
      ## Stubs for unsupported functions.
      pipeline=function(...) {
        stop("Pipelining not supported with RcppRedis")
      },
      subscribe=function(...) {
        stop("Subscription not supported with RcppRedis")
      })
  attr(ret, "type") <- "RcppRedis"
  ret
}
