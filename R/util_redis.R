##' Convert contents of a Redis hash into something useful
##' @title Load Redis hash
##' @param con Redis connection (\code{redis_api} object)
##' @param name Name of the hash
##' @param keys Optional list of keys - if omitted we get all
##' @param f Function to apply to the \emph{entire} contents of the
##' hash (not each element)
##' @param missing What to replace missing keys with
##' @export
from_redis_hash <- function(con, name, keys=NULL, f=as.character,
                            missing=NA) {
  if (is.null(keys)) {
    x <- con$HGETALL(name)
    dim(x) <- c(2, length(x) / 2)
    setNames(f(x[2, ]),
             as.character(x[1, ]))
  } else {
    x <- con$HMGET(name, keys)
    x[vlapply(x, is.null)] <- missing
    setNames(f(x), as.character(keys))
  }
}
