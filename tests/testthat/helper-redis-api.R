skip_if_no_RcppRedis <- function() {
  testthat::skip_if_not_installed("RcppRedis")
}

skip_if_no_rredis <- function() {
  testthat::skip_if_not_installed("rredis")
}

skip_if_no_redis <- function() {
  if (redis_available()) {
    return()
  }
  skip("Redis or RcppRedis are not available")
}

big_fake_data <- function(nr) {
  data.frame(x1=rnorm(nr),
             x2=sample(rownames(mtcars), nr, replace=TRUE),
             x3=sample(100L, nr, replace=TRUE),
             x4=sample(c(TRUE, FALSE), nr, replace=TRUE),
             x5=rnorm(nr),
             x6=rnorm(nr),
             x7=rnorm(nr),
             x8=rnorm(nr),
             x9=rnorm(nr),
             x10=rnorm(nr))
}

mixed_fake_data <- function(nr) {
  str <- sample(rownames(mtcars), nr, replace=TRUE)
  data.frame(x_logical=(runif(nr) < .3),
             x_numeric=rnorm(nr),
             x_integer=as.integer(rpois(nr, 2)),
             x_character=str,
             x_factor=factor(str),
             stringsAsFactors=FALSE)
}

rand_str <- function(prefix="") {
  len <- rpois(1, 5) + 1L
  paste0(prefix,
         paste(sample(c(LETTERS, letters, 0:9), len), collapse=""))
}
