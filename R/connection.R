##' @export
print.redis_connection <- function(x, ...) {
  cat(sprintf("<redis_connection[%s]>:\n", attr(x, "type", exact=TRUE)))
  for (i in names(x)) {
    cat(sprintf("  - %s", capture_args(x[[i]], i)))
  }
  invisible(x)
}

capture_args <- function(f, name) {
  args <- capture.output(args(f))
  sub("function ", name,
      paste0(paste(args[-length(args)], collapse="\n"), "\n"))
}
