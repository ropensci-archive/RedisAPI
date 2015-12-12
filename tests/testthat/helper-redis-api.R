skip_if_no_rcppredis <- function() {
  skip_if_not_installed("RcppRedis")
  if (!inherits(try(rcppredis_connection(), silent=TRUE), "try-error")) {
    return()
  }
  skip("Redis is not available")
}
