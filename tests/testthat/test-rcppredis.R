context("RcppRedis")
skip_if_no_RcppRedis()

test_that("creation", {
  con <- new(RcppRedis::Redis)
  obj <- redis_api(con$execv)
  expect_that(obj, is_a("redis_api"))
  expect_that(obj$type, equals("RcppRedis"))
  expect_that(obj$host, equals(NULL)) # Not set yet
  expect_that(obj$port, equals(NULL)) # Not set yet
  expect_that(obj$PING(), equals("PONG"))
})
