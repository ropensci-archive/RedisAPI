## ---
## title: "Using Redis with RedisAPI"
## author: "Rich FitzJohn"
## date: "`r Sys.Date()`"
## output: rmarkdown::html_vignette
## vignette: >
##   %\VignetteIndexEntry{Using Redis with RedisAPI}
##   %\VignetteEngine{knitr::rmarkdown}
##   \usepackage[utf8]{inputenc}
## ---

library(RedisAPI)

##+ echo=FALSE,results="hide"
library(methods)
knitr::opts_chunk$set(error=FALSE)
RedisAPI::hiredis()$DEL(c("mykey", "mylist", "mylist2", "rlist"))
set.seed(1)

## The main feature of `RedisAPI` is to provide a full interface to
## the Redis API.  It provdes access to `r length(grep("^[A-Z]",
## names(RedisAPI:::redis_api_generator$public_methods)))` Redis
## commands s a set of user-friendly R functions that do basic error
## checking.  This is the level that new applications would be build
## from, and `rdb` is built on top of a *driver*, which allows use
## with [`RcppRedis`](https://github.com/eddelbuettel/rcppredis)
## and [`rrlite`](https://github.com/ropensci/rrlite).

## It is possible to build user-friendly applications on top of this,
## for example, the built in `rdb` R key-value store,
## [`storr`](https://github.com/richfitz/storr) which provides a
## content-addressable object store, and
## [`rrqueue`](https://github.com/traitecoevo/rrqueue) which
## implements a scalable queuing system.

## # Redis API

## Because this package is simply a wrapper around the RedisAPI, the
## main source of documentation is the Redis help itself,
## `http://redis.io` (Unfortunately, the CRAN submission system
## incorrectly complains and thinks that website is a dead link so I
## can't include it without risking a scolding).  The Redis
## documentation is very readable, thorough and contains great
## examples.

## `RedisAPI` tries to bridge to this help.  Redis' commands are
## "grouped" by data types or operation type; use
## \code{redis_commands_groups()} to see these groups:
redis_commands_groups()

## To see command listed within a group, use the `redis_commands`
## function:
redis_commands("string")

## Then use the function `redis_help` to get help for a particular
## command:
redis_help("SET")

## The function definition here is the definition of the method you
## will use within the retuned object (see below).  A default argument
## of `NULL` indicates that a command is optional (`EX`, `PX` and
## `condition` here are all optional).  The sentence is straight from
## the Redis documentation, and the link will take you to the full
## documentation on the Redis site.

## This gives you all the power of Redis, but you will have to
## manually serialise/deserialise all complicated R objects (i.e.,
## everything other than logicals, numbers or strings).  Similarly,
## you are responsible for type coersion/deserialisation when
## retrieving data at the other end.

## The main entry point for creating a `redis_api` object is the
## `hiredis` function:
r <- RedisAPI::hiredis()

## By default, it will connect to a database running on the local
## machine (`localhost`, or ip `127.0.0.1`) and port 6379.  The two
## arguments that `hiredis` accepts are `host` and `port` if you need
## to change these to point at a different location.  Alternatively,
## you can set the `REDIS_HOST` and `REDIS_PORT` environment variables
## to appropriate values and then use `hiredis()` with no arguments.

## The `redis_api` object is an [`R6`](https://github.com/wch/R6)
## class with _many_ methods, each corresponding to a different Redis
## command.
##+ eval=FALSE
r
##+ echo=FALSE
res <- capture.output(print(r))
res <- c(res[1:6], "    ...", res[(length(res) - 3):(length(res) - 1)])
writeLines(res)

## For example, `SET` and `GET`:
r$SET("mykey", "mydata") # set the key "mykey" to the value "mydata"
r$GET("mykey")

## The value must be a string or will be coerced into one.  So if you
## want to save an arbitrary R object, you need to convert it to a
## string.  The `object_to_string` function and its inverse
## `string_to_object` can help here:

s <- object_to_string(1:10)
s # ew. but this does encode everything about this object
string_to_object(s) # here's the original back

## So:
r$SET("mylist", object_to_string(1:10))
r$GET("mylist")
string_to_object(r$GET("mylist"))

## This is how the `rdb` object is implemented (see below).

## However, Redis offers far better ways of holding lists, if that is the aim:

r$RPUSH("mylist2", 1:10)

## (the returned value `10` indicates that the list "mylist2" is 10
## elements long).  There are lots of commands for operating on lists:

RedisAPI::redis_commands("list")

## For example, you can do things like;

## * get an element by its index (note tht this uses C-style base0
## indexing for consistency with the `Redis` documentation rather than
## R's semantics)
RedisAPI::redis_help("LINDEX")
r$LINDEX("mylist2", 1)

## * set an element by its index
RedisAPI::redis_help("LSET")
r$LSET("mylist2", 1, "carrot")

## * get all of a list:
RedisAPI::redis_help("LRANGE")
r$LRANGE("mylist2", 0, -1)

## * or part of it:
r$LRANGE("mylist2", 0, 2)

## * pop elements off the front or back
RedisAPI::redis_help("LLEN")
RedisAPI::redis_help("LPOP")
RedisAPI::redis_help("RPOP")
r$LLEN("mylist2")
r$LPOP("mylist2")
r$RPOP("mylist2")
r$LLEN("mylist2")

## Of course, each element of the list can be an R object if you run
## it through `object_to_string`:
r$LPUSH("mylist2", object_to_string(1:10))

## but you'll be responsible for converting that back (and detecting
## / knowing that this needs doing)
dat <- r$LRANGE("mylist2", 0, 2)
dat
dat[[1]] <- string_to_object(dat[[1]])
dat

## # High level (`rdb`)

## Create a new database in memory (this is not written to disk, and
## I've not actually worked out how to save to disk once the database
## is created...)
db <- rdb(hiredis)

## Newly created databases are empty - they have no keys
db$keys()

## R objects can be stored against keys, for example:
db$set("mykey", 1:10)
db$keys()

## Retrieve the value of a key with `$get`:
db$get("mykey")

## Trying to get a nonexistant key does not throw an error but returns
## `NULL`
db$get("no_such_key")

## That's it.  Arbitrary R objects can be stored in keys, and they
## will be returned intact with few exceptions (the exceptions are
## things like `rdb` itself which includes an "external pointer"
## object which can't be serialised - see `?serialize` for more
## information):
db$set("mtcars", mtcars)
identical(db$get("mtcars"), mtcars)
db$set("a_function", sin)
db$get("a_function")(pi / 2) # 1

## This seems really silly, but is potentially very useful.  There are
## file-based key/value systems on CRAN, and this would be another but
## backed by a potentailly very efficient store (and without the
## overhead of disk access).

## # Potential applications

## Because `RedisAPI` exposes all of Redis, you can roll your own data
## structures.

## First, a generator object that sets up a new list at `key` within
## the database `r`.
rlist <- function(..., key="rlist", r=RedisAPI::hiredis()) {
  dat <- vapply(c(...), object_to_string, character(1))
  r$RPUSH(key, dat)
  ret <- list(r=r, key=key)
  class(ret) <- "rlist"
  ret
}

## Then some S3 methods that work with this object.  I've only
## implemented `length` and `[[`, but `[` would be useful here too as
## would `print`.
length.rlist <- function(x) {
  x$r$LLEN(x$key)
}

`[[.rlist` <- function(x, i, ...) {
  string_to_object(x$r$LINDEX(x$key, i - 1L))
}

`[[<-.rlist` <- function(x, i, value, ...) {
  x$r$LSET(x$key, i - 1L, object_to_string(value))
  x
}

## Then we have this weird object we can add things to.
obj <- rlist(1:10)
length(obj) # 10
obj[[3]]
obj[[3]] <- "an element"
obj[[3]]

## The object has reference semantics so that assignment does *not* make a copy:
obj2 <- obj
obj2[[2]] <- obj2[[2]] * 2
obj[[2]] == obj2[[2]]

## For a better version of this, see
## [storr](https://github.com/richfitz/storr) which does similar things to implement "[indexable serialisation](http://htmlpreview.github.io/?https://raw.githubusercontent.com/richfitz/storr/master/inst/doc/storr.html#lists-and-indexable-serialisation)"

## What would be nice is a set of tools for working with any R/`Redis`
## package that can convert R objects into `Redis` data structures so
## that they can be accessed in pieces even if they are far too big to
## fit into memory.  Of course, these objects could be read/written by
## programs *other* than R if they also support `Redis`.  We have made
## some approaches towards that with the
## [docdbi](https://github.com/ropensci/docdbi) package, but this is a
## work in progress.
