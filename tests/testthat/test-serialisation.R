context("serialisation")

test_that("string serialisation is transitive", {
  f <- function(x, identical=TRUE) {
    y <- string_to_object(object_to_string(x))
    is_equivalent_to <- if (identical) is_identical_to else equals
    expect_that(x, is_equivalent_to(y))
  }
  f(NULL)
  f(1)
  f(pi)
  f(f, identical=FALSE)
  f(1:10)

  ## Not all floating point numbers are representable in strings
  ## *exactly*; this is actually a little surprising, though the
  ## difference is extremely small.
  set.seed(1)
  x <- runif(100)
  expect_that(string_to_object(object_to_string(x)),
              not(is_identical_to(x)))
  f(x, FALSE)
})

test_that("binrary serialisation is transitive", {
  f <- function(x, identical=TRUE) {
    y <- bin_to_object(object_to_bin(x))
    is_equivalent_to <- if (identical) is_identical_to else equals
    expect_that(x, is_equivalent_to(y))
  }
  f(NULL)
  f(1)
  f(f, identical=FALSE)
  f(1:10)

  ## In contrast with string serialization above, binary serialization
  ## is exact (as well as being about 10x faster which is nice).
  set.seed(1)
  x <- runif(100)
  f(x)
})
