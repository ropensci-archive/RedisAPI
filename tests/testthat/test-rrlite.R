context("rrlite")
skip_if_no_rrlite()

test_that("creation", {
  con <- rrlite::rlite_context()
  obj <- redis_api(con$run)
  expect_that(obj, is_a("redis_api"))
  expect_that(obj$type, equals("rrlite"))
  expect_that(obj$host, equals(":memory:"))
  expect_that(obj$port, equals(NULL))
  expect_that(obj$PING(), equals("PONG"))
})
