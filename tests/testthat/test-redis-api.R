context("redis-api")

test_that("invalid objects", {
  expect_that(redis_api$new(NULL),
              throws_error())
})
