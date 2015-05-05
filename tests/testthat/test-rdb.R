context("rdb")

test_that("rlite", {
  skip_if_no_rrlite()
  r <- rdb(rrlite::hirlite)
  on.exit(file.remove("test.rld"))
  x <- mtcars
  expect_that(r$set("foo", x), is_null())
  expect_that(r$get("foo"), equals(x))
  expect_that(r$keys(), equals("foo"))
  expect_that(r$exists("foo"), is_true())
  r$del("foo")
  expect_that(r$keys(), equals(character(0)))
  expect_that(r$exists("foo"), is_false())
})

test_that("redis", {
  skip_if_no_rrlite()
  r <- rdb(rrlite::hirlite)
  on.exit(file.remove("test.rld"))
  x <- mtcars
  expect_that(r$set("foo", x), is_null())
  expect_that(r$get("foo"), equals(x))
  expect_that("foo" %in% r$keys(), is_true())
  expect_that(r$exists("foo"), is_true())
  r$del("foo")
  expect_that("foo" %in% r$keys(), is_false())
  expect_that(r$exists("foo"), is_false())
})
