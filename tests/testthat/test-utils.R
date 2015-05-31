context("utils")

test_that("command", {
  expect_that(command("foo", NULL, FALSE),
              is_null())
  expect_that(command("foo", 1, FALSE),
              equals(c("foo", 1)))
  expect_that(command("foo", 1:2, FALSE),
              equals(c("foo", 1, "foo", 2)))

  expect_that(command("foo", NULL, TRUE),
              is_null())
  expect_that(command("foo", 1, TRUE),
              equals(c("foo", 1)))
  expect_that(command("foo", 1:2, TRUE),
              equals(c("foo", 1, 2)))
})
