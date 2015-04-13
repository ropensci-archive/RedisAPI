context("RcppRedis")

test_that("creation", {
  skip_if_no_RcppRedis()
  con <- new(RcppRedis::Redis)
  obj <- redis_api(con$execv)
  expect_that(obj, is_a("redis_api"))
  expect_that(obj$type, equals("RcppRedis"))
  expect_that(obj$host, equals(NULL)) # Not set yet
  expect_that(obj$port, equals(NULL)) # Not set yet
  expect_that(obj$PING(), equals("PONG"))
})

test_that("connection", {
    skip_if_no_RcppRedis()
  con <- redis_context()
  expect_that(con$context$exec("PING"), equals("PONG"))
})

test_that("use", {
  skip_if_no_RcppRedis()
  r <- hiredis()
  expect_that(r$PING(), equals("PONG"))
  key <- "rlite-test:foo"
  expect_that(r$SET(key, "bar"), equals("OK"))
  expect_that(r$GET(key), equals("bar"))
  r$DEL(key)
})

test_that("redis", {
  r <- rdb(hiredis)
  x <- mtcars
  expect_that(r$set("foo", x), is_null())
  expect_that(r$get("foo"), equals(x))
  expect_that("foo" %in% r$keys(), is_true())
  expect_that(r$exists("foo"), is_true())
  r$del("foo")
  expect_that("foo" %in% r$keys(), is_false())
  expect_that(r$exists("foo"), is_false())
})
