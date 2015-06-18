context("interface")

## Multiple args OK:
test_that("MSET / MGET / DEL", {
  skip_if_no_redis()
  r <- hiredis()
  r$MSET(letters, LETTERS)
  expect_that(r$MGET(letters), equals(as.list(LETTERS)))
  expect_that(r$DEL(letters), equals(length(letters)))
  expect_that(vnapply(letters, r$EXISTS, USE.NAMES=FALSE),
              equals(rep(0.0, length(letters))))
})

## SORT is the most complicated, so lets nail that
test_that("SORT", {
  skip_if_no_redis()
  key <- rand_str()
  i <- sample(20)
  r <- hiredis()
  r$RPUSH(key, i)
  on.exit(r$DEL(key))
  res <- r$SORT(key)
  cmp <- as.list(as.character(sort(i)))
  expect_that(res, equals(cmp))

  ## NOTE: this is a different behaviour to the examples because order
  ## *must* be given as a kw argument here, whereas there it's done
  ## positionally.  Not sure how to implement that, or if it's
  ## worthwhile.
  expect_that(r$SORT(key, order="DESC"), equals(rev(cmp)))
  expect_that(r$SORT(key, order="ASC"), equals(cmp))
  expect_that(r$SORT(key, order="A"),
              throws_error("order must be one of"))

  expect_that(r$SORT(key, LIMIT=c(0, 10)),
              equals(cmp[1:10]))
  expect_that(r$SORT(key, LIMIT=c(5, 10)),
              equals(cmp[6:15]))

  cmp_alpha <- as.list(sort(as.character(i)))
  expect_that(r$SORT(key, sorting="ALPHA"), equals(cmp_alpha))
  expect_that(r$SORT(key, sorting="ALPHA", order="DESC"),
              equals(rev(cmp_alpha)))

  key2 <- rand_str()
  on.exit(r$DEL(key2))
  expect_that(r$SORT(key, STORE=key2), equals(length(i)))
  expect_that(r$TYPE(key2), equals("list"))
  expect_that(r$LRANGE(key2, 0, -1), equals(cmp))
})

## SCAN does some cool things; let's try that, too.
test_that("SCAN", {
  skip_if_no_redis()
  r <- hiredis()

  prefix <- paste0(rand_str(), ":")
  str <- replicate(50, rand_str(prefix))
  r$MSET(str, str)
  on.exit(r$DEL(str))

  ## The stupid way:
  pat <- paste0(prefix, "*")
  all <- as.character(r$KEYS(pat))
  expect_that(sort(all), equals(sort(str)))

  ## The better way:
  seen <- setNames(integer(length(str)), str)
  cursor <- 0L
  for (i in 1:50) {
    res <- r$SCAN(cursor, pat)
    cursor <- res[[1]]
    i <- as.character(res[[2]])
    seen[i] <- seen[i] + 1L
    if (cursor == "0") {
      break
    }
  }
  expect_that(cursor, equals("0"))
  expect_that(all(seen > 0), is_true())

  ## Try to do it in one big jump:
  res <- r$SCAN(0L, pat, 1000)
  if (res[[1]] == "0") {
    expect_that(length(res[[2]]), equals(length(str)))
    expect_that(sort(unlist(res[[2]])), equals(sort(str)))
  }
})
