context("RcppRedis")

test_that("connection", {
  skip_if_no_redis()
  con <- redis_context()
  expect_that(con$exec("PING"), equals("PONG"))
})

test_that("defaults", {
  skip_if_no_redis()
  Sys.setenv("REDIS_HOST"="localhost")
  con <- hiredis()
  expect_that(con$host, equals("localhost"))
  Sys.setenv("REDIS_PORT"="1234")
  expect_that(con <- hiredis(), throws_error("Connection refused"))
  Sys.unsetenv(c("REDIS_PORT", "REDIS_HOST"))
  con <- hiredis()
  expect_that(con$host, equals("127.0.0.1"))
  expect_that(con$port, equals(6379))
})

test_that("use", {
  skip_if_no_redis()
  r <- hiredis()
  expect_that(r$PING(), equals("PONG"))
  key <- "redisapi-test:foo"
  expect_that(r$SET(key, "bar"), equals("OK"))
  expect_that(r$GET(key), equals("bar"))
  r$DEL(key)
})

test_that("rdb", {
  skip_if_no_redis()
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
