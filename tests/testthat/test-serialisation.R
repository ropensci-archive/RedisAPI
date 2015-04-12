context("serialisation")

test_that("serialisation is transitive", {
  f <- function(x, identical=TRUE) {
    y <- string_to_object(object_to_string(x))
    is_equivalent_to <- if (identical) is_identical_to else equals
    expect_that(x, is_equivalent_to(y))
  }
  f(NULL)
  f(1)
  f(f, identical=FALSE)
  f(1:10)
})
