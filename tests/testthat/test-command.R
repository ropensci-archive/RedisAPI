context("cmd_command")

test_that("cmd_command", {
  expect_that(cmd_command("foo", NULL, FALSE),
              is_null())
  expect_that(cmd_command("foo", 1, FALSE),
              equals(list("foo", 1)))
  expect_that(cmd_command("foo", 1:2, FALSE),
              equals(c("foo", 1, "foo", 2)))
  ## Type conversions:
  expect_that(cmd_command("foo", c(TRUE, FALSE), FALSE),
              equals(c("foo", 1, "foo", 0)))

  expect_that(cmd_command("foo", NULL, TRUE),
              is_null())
  expect_that(cmd_command("foo", 1, TRUE),
              equals(list("foo", 1)))
  expect_that(cmd_command("foo", 1:2, TRUE),
              equals(list("foo", 1:2)))
})
