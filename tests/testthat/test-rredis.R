context("rredis")

test_that("creation", {
  skip_if_no_rredis()
  rredis::redisConnect()
  obj <- redis_api(rredis::redisCmd)
  expect_that(obj, is_a("redis_api"))
  expect_that(obj$type, equals("rredis"))
  expect_that(obj$host, equals("localhost"))
  expect_that(obj$port, equals(6379))
  expect_that(obj$PING(), equals("PONG"))
})
