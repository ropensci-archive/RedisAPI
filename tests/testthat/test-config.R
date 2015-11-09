context("config")

## Url splitting (why isn't this in base R? It doesn't seem worth
## adding a whole dependency for)
test_that("url parse", {
  f <- function(host, port=NULL, password=NULL, db=NULL, scheme=NULL) {
    list(scheme=scheme, password=password, host=host, port=port, db=db)
  }
  expect_that(parse_redis_url("localhost"),
              equals(f("localhost")))
  expect_that(parse_redis_url("redis://localhost"),
              equals(f("localhost", scheme="redis")))
  expect_that(parse_redis_url("redis://localhost:999"),
              equals(f("localhost", scheme="redis", port=999L)))
  expect_that(parse_redis_url("redis://:foo@localhost:999"),
              equals(f("localhost", scheme="redis", port=999L,
                       password="foo")))
  expect_that(parse_redis_url("redis://:foo@localhost:999/2"),
              equals(f("localhost", scheme="redis", port=999L,
                       password="foo", db=2L)))

  expect_that(parse_redis_url("redis://127.0.0.1:999"),
              equals(f("127.0.0.1", scheme="redis", port=999L)))

  ## Failures (not enough tests)
  expect_that(parse_redis_url(""), throws_error("Failed to parse URL"))
})

test_that("defaults", {
  ## Defaults, same as redis-rb, seem pretty reasonable to me:
  obj <- redis_config()
  expect_that(obj$host,     equals("127.0.0.1"))
  expect_that(obj$port,     equals(6379L))
  expect_that(obj$db,       is_null())
  expect_that(obj$password, is_null())
  expect_that(obj$path,     is_null())
  expect_that(obj$scheme,   equals("redis"))
  expect_that(obj$url,      equals("redis://127.0.0.1:6379"))
})

test_that("url", {
  obj <- redis_config(url="redis://:secr3t@foo.com:999/2")
  expect_that(obj$host,     equals("foo.com"))
  expect_that(obj$port,     equals(999L))
  expect_that(obj$db,       equals(2L))
  expect_that(obj$password, equals("secr3t"))
  expect_that(obj$url, equals("redis://:secr3t@foo.com:999/2"))
})

test_that("unescape password", {
  obj <- redis_config(url="redis://:secr3t%3A@foo.com:999/2")
  expect_that(obj$password, equals("secr3t:"))
})

test_that("don't unescape password when explicitly passed", {
  obj <- redis_config(url="redis://:secr3t%3A@foo.com:999/2",
                      password="secr3t%3A")
  expect_that(obj$password, equals("secr3t%3A"))
})

test_that("path overrides URL", {
  obj <- redis_config(url="redis://:secr3t@foo.com:999/2",
                      path="/tmp/redis.sock")
  expect_that(obj$path, equals("/tmp/redis.sock"))
  expect_that(obj$host, is_null())
  expect_that(obj$port, is_null())
  ## These still get picked up though.
  expect_that(obj$password, equals("secr3t"))
  expect_that(obj$db,   equals(2L))
})

test_that("NULL options do not override", {
  obj <- redis_config(url="redis://:secr3t@foo.com:999/2",
                      port=NULL)
  expect_that(obj$port, equals(999L))
})

test_that("environment variable", {
  Sys.setenv(REDIS_URL="redis://:secr3t@foo.com:999/2")
  on.exit(Sys.unsetenv("REDIS_URL"))
  obj <- redis_config()
  expect_that(obj$host,     equals("foo.com"))
  expect_that(obj$port,     equals(999L))
  expect_that(obj$db,       equals(2L))
  expect_that(obj$password, equals("secr3t"))
})

test_that("redis_config", {
  cfg <- redis_config()
  expect_that(cfg, is_a("redis_config"))
  expect_that(redis_config(cfg), equals(cfg))
  expect_that(redis_config(config=cfg), equals(cfg))
  expect_that(redis_config(host="foo", config=cfg), equals(cfg))
})

test_that("list argument", {
  cfg <- list(host="foo", port=8888)
  config <- redis_config(cfg)
  expect_that(config$host, equals("foo"))
  expect_that(config$port, equals(8888))

  expect_that(redis_config(cfg, db=1), throws_error("Invalid configuration"))
  expect_that(redis_config(db=1, cfg), throws_error("must be named"))
  expect_that(redis_config(db=1, other=cfg), throws_error("must be scalar"))

  expect_that(cfg2 <- redis_config(db=1, config=cfg),
              gives_warning("Ignoring dots"))
  expect_that(cfg2$db, is_null())
})

test_that("unknowns", {
  expect_that(cfg <- redis_config(foo=1),
              gives_warning("Unknown fields in defaults"))
  expect_that(cfg$foo, is_null())
})

test_that("non-named args", {
  expect_that(redis_config("foo"), throws_error("must be named"))
})
