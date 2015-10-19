context("interleave")

test_that("interleave", {
  ## Basic cases:
  expect_that(interleave("a", "b"), equals(c("a", "b")))
  expect_that(interleave(c("a", "b"), c("c", "d")),
              equals(c("a", "c", "b", "d")))

  expect_that(interleave("a", list("b")), equals(list("a", "b")))
  expect_that(interleave(c("a", "b"), list("c", "d")),
              equals(list("a", "c", "b", "d")))
  expect_that(interleave(list("a", "b"), list("c", "d")),
              equals(list("a", "c", "b", "d")))

  ## Things with raw vectors:
  obj <- lapply(1:2, serialize, NULL)
  expect_that(interleave(c("a", "b"), obj),
              equals(list("a", obj[[1]], "b", obj[[2]])))

  ## Corner cases:
  expect_that(interleave(c(), c()), equals(character(0)))
  expect_that(interleave(list(), list()), equals(list()))
  expect_that(interleave(NULL, NULL), equals(character(0)))

  ## Conversions:
  expect_that(interleave("a", 1L), equals(c("a", "1")))
  expect_that(interleave("a", 1.0), equals(c("a", "1")))
  expect_that(interleave("a", TRUE), equals(c("a", "1")))

  ## Error cases:
  expect_that(interleave("a", c()), throws_error("b must be length 1"))
  expect_that(interleave(c(), "b"), throws_error("b must be length 0"))
  expect_that(interleave("a", sin), throws_error("cannot coerce type"))
})
