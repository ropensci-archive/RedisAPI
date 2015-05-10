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

test_that("Round trip (via Redis)", {
  db <- RedisAPI::hiredis()

  redis_object_set("key1", mtcars, db)
  expect_that(redis_object_get("key1", db), equals(mtcars))
  expect_that(redis_object_exists("key1", db), is_true())
  expect_that(redis_object_type("key1", db), equals("data.frame"))

  expect_that(redis_object_del("key1", db), is_true())
  expect_that(redis_object_del("key1", db), is_false())
  expect_that(redis_object_exists("key1", db), is_false())
  expect_that(redis_object_type("key1", db), is_null())

  x2 <- mixed_fake_data(100)
  redis_object_set("key2", x2, db)
  expect_that(redis_object_get("key2", db), equals(x2))

  expect_that(redis_object_del("key2", db), is_true())
  expect_that(redis_object_del("key2", db), is_false())
})
