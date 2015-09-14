context("scan")

test_that("scan", {
  con <- hiredis()
  prefix <- rand_str("scan:")
  keys <- character(0)
  for (i in seq_len(10)) {
    key <- paste0(prefix, ":", rand_str())
    con$SET(key, runif(1))
    keys <- c(keys, key)
  }

  expect_that(all(vnapply(keys, con$EXISTS) == 1), is_true())

  res <- scan_find(con, paste0(prefix, "*"))
  expect_that(sort(res), equals(sort(keys)))

  n <- scan_del(con, paste0(prefix, "*"))
  expect_that(n, equals(10))

  expect_that(any(vnapply(keys, con$EXISTS) == 1), is_false())
  res <- scan_find(con, paste0(prefix, "*"))

  expect_that(res, equals(character(0)))
})
