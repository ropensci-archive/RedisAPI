skip_if_no_RcppRedis <- function() {
  testthat::skip_if_not_installed("RcppRedis")
}

skip_if_no_rredis <- function() {
  testthat::skip_if_not_installed("rredis")
}

skip_if_no_rrlite <- function() {
  testthat::skip_if_not_installed("rrlite")
}
