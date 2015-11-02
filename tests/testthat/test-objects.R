context("Objects")

test_that("Round trip a data.frame disassembly (cells)", {
  x <- mtcars
  obj <- df_disassemble(x)
  cmp <- df_reassemble(obj$names, obj$rownames, obj$rows, obj$factors,
                       obj$classes)
  expect_that(cmp, is_identical_to(x))

  x2 <- mixed_fake_data(10)
  cl <- vcapply(x2, class)
  obj2 <- df_disassemble(x2)
  cmp2 <- df_reassemble(obj2$names, obj2$rownames, obj2$rows, obj2$factors,
                        obj2$classes)
  expect_that(cmp2, equals(x2, tolerance=1e-14))
})
