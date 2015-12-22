# RedisAPI

[![Build Status](https://travis-ci.org/ropensci/RedisAPI.png?branch=master)](https://travis-ci.org/ropensci/RedisAPI)



Automatically generated R6 interface to the full [Redis](http://redis.io) API.  The generated functions are faithful to the Redis [documentation](http://redis.io/commands) while attempting to match R's argument and vectorisation semantics.

As of version `0.3.0` RedisAPI supports binary serialisation of almost anything; keys, values, etc.  Just don't expect Redis to do anything sensible with the values - you won't be able to compute on directly.

This package is designed primarily to work with driver packages that are not yet on CRAN: [redux](https://github.com/richfitz/redux) and [`rrlite`](https://github.com/ropensci/rrlite), but support for RcppRedis is included.


```r
con <- RedisAPI::rcppredis_hiredis()
```

That connection has many (188) methods. Automatically generated methods are in all-caps, following the Redis documentation.  Unlike Redis commands are *case sensitive*.


```r
con
```

```
## <redis_api>
##   Redis commands:
##     APPEND: function
##     AUTH: function
##     BGREWRITEAOF: function
##     BGSAVE: function
##     ...
##     ZSCORE: function
##     ZUNIONSTORE: function
##   Other public methods:
##     clone: function
##     command: function
##     config: function
##     initialize: function
##     pipeline: function
##     reconnect: function
##     subscribe: function
##     type: function
```

The lower-case methods listed after the upper-case Redis commands are not REdis commands, but can be used to do things other an issue commands (see below).

The Redis methods are designed to be straightforward to use following the Redis documentation.  For example, the Redis [`HMSET`](http://redis.io/commands/hmset) command is defined as

```
HMSET key field value [field value ...]
```

which sets one or more `field` / `value` pairs within a hash stored at a `key`.  In `RedisAPI`, the generated interface has arguments


```r
args(con$HMSET)
```

```
## function (key, field, value)
## NULL
```

where `key` is a scalar and `field` / `value` are vectors of the same non-zero length (these requirements are enforced at runtime).

Because `RedisAPI` objects are `R6` objects, access methods using `$`:


```r
con$HMSET("myhash", c("a", "b", "c"), c(1, 2, 3))
```

```
## [1] "OK"
```

```r
con$HGET("myhash", "b")
```

```
## [1] "2"
```

Note that no clever type conversion will be done; R types are converted to strings and are not converted back when returned.  In general this is not possible without serialisation.

Redis contains several "sub-command-style" commands with spaces in them (e.g., `CLIENT KILL`, `SCRIPT LOAD`); these are implemented by replacing spaces with underscores to give `CLIENT_KILL` and `SCRIPT_LOAD`.

# Serialisation

To ease saving and retrieving arbitrary R data into Redis, `RedisAPI` has two convenience functions for serialising to and deserialising from a string: `object_to_string` and `string_to_object`.


```r
RedisAPI::object_to_string(2)
```

```
## [1] "A\n2\n197121\n131840\n14\n1\n2\n"
```

```r
RedisAPI::string_to_object("A\n2\n196866\n131840\n14\n1\n2\n")
```

```
## [1] 2
```

This makes it easy (though reasonably verbose) to use arbitrary R values anywhere in Redis:


```r
con$SET(RedisAPI::object_to_string(1:10), object_to_string(iris))
```

```
## [1] "OK"
```

```r
head(RedisAPI::string_to_object(con$GET(object_to_string(1:10))))
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

String serialisation can very slightly mess with floating point numbers, but should be reasonable for many uses.

It is not supported with RcppRedis above, but the [redux](https://github.com/richfitz/redux) package allows use of binary serialisation for everything.  Use it with `redux::hiredis()`.  The convenience functions there are `object_to_bin` and `bin_to_object`.

# Other features

## Versioned interfaces

RedisAPI can restrict the generated commands to a subset of Redis commands based on a version, or on the current Redis version.  To restrict to a particular Redis version, use:


```r
con1 <- RedisAPI::rcppredis_hiredis(version="1.0.0")
```

The generated interface here has only 63 Redis methods, relative to 188 in the current version of Redis (3.2.0).

Alternatively, `RedisAPI` can query the database on startup.  My installed Redis is version:


```r
redis_version(con)
```

```
## [1] '3.0.3'
```

Passing `version=TRUE` will query Redis for the version and filter the commands appropriately.


```r
con2 <- RedisAPI::rcppredis_hiredis(version=TRUE)
```

(187 commands)

Note that commands that are not given will be omitted from the generated object.  This means attempting to run them will give the moderately cryptic error:


```r
con1$TIME()
```

```
## Error in eval(expr, envir, enclos): attempt to apply non-function
```


```r
con$HSTRLEN("key", "fields")
```

```
## [1] "ERR unknown command 'HSTRLEN'"
```

(with the redux interface or a recent RcppRedis this will return an error).

Depending on the use-case it may be better to let Redis throw the error rather than use filtering.

## Redis helpers

### SCAN helpers

The `SCAN` function should be preferred to `KEYS` to identify all keys that match some pattern.


```r
con$MSET(paste0("redisapi:", sample(20, 10)), runif(10))
```

```
## [1] "OK"
```

```r
con$KEYS("redisapi:*") # potentially dangerous
```

```
## [[1]]
## [1] "redisapi:20"
##
## [[2]]
## [1] "redisapi:8"
##
## [[3]]
## [1] "redisapi:4"
##
## [[4]]
## [1] "redisapi:11"
##
## [[5]]
## [1] "redisapi:18"
##
## [[6]]
## [1] "redisapi:9"
##
## [[7]]
## [1] "redisapi:13"
##
## [[8]]
## [1] "redisapi:16"
##
## [[9]]
## [1] "redisapi:5"
##
## [[10]]
## [1] "redisapi:7"
```

```r
scan_find(con, "redisapi:*") # will not block
```

```
##  [1] "redisapi:20" "redisapi:13" "redisapi:18" "redisapi:4"  "redisapi:8"
##  [6] "redisapi:5"  "redisapi:11" "redisapi:16" "redisapi:9"  "redisapi:7"
```

Generalising this, RedisAPI provides a `scan_apply` function that will
apply a function to each found element.  The provided function must
take a _vector_ of key names as its first argument, and must work by
side effects.


```r
values <- numeric()
collect <- function(keys) {
  if (length(keys) > 0L) {
    values <<- c(values, as.numeric(con$MGET(keys)))
  }
}
scan_apply(con, collect, "redisapi:*")
values
```

```
##  [1] 0.62911404 0.57285336 0.20168193 0.37212390 0.89838968 0.26550866
##  [7] 0.94467527 0.66079779 0.06178627 0.90820779
```

There is a `scan_del` function implemented this way that deletes keys matching a pattern:


```r
scan_del(con, "redisapi:*")
```

```
## [1] 10
```

Read the redis [scan documentation](http://redis.io/commands/scan) as the soft guarantees will affect how functions using SCAN should be written.  In particular, a key may be returned twice if the `SCAN` is used at same time that the database is being changed.  Zero elements may be returned during a batch of scanning, and this edge case needs to be handled gracefully.

### Redis scripts

Redis allows running lua scripts like:


```r
lua <- '
  local keyname = KEYS[1]
  local value = ARGV[1]
  redis.call("SET", keyname, value)
  redis.call("INCR", keyname)
  return redis.call("GET", keyname)'
```

Which can be run as:


```r
con$EVAL(lua, 1L, "mykey", 10)
```

```
## [1] "11"
```

Far better is to save the script to the database and call it by SHA:


```r
sha <- con$SCRIPT_LOAD(lua)
con$EVALSHA(sha, 1L, "mykey", 10)
```

```
## [1] "11"
```

Doing this is a hassle though, and RedisAPI provides a small helper to wrap this pattern while allowing calling scripts by name:


```r
scripts <- RedisAPI::redis_scripts(con, set_and_incr=lua)
scripts("set_and_incr", "mykey", 10)
```

```
## [1] "11"
```

### Misc

* The function `from_redis_hash` converts a Redis hash into an R list
  (or character/numeric vector) in a consistent way.
* `redis_time` returns `TIME()` as an R POSIXct object,
  `format_redis_time` formats `TIME` in a nicer way.
* `redis_info` returns `INFO()` as an R list, `redis_version` returns
  the version of Redis (as an R `numeric_version` object) and
  `parse_info` parses the `INFO()` string.
* `redis_multi` allows using Redis' `MULTI`/`EXEC` block with R's
  error handling, evaluating a series of expressions but running the
  Redis commands only if none fail.  `pipeline` may be a better option
  now.

## Pipelining

For drivers that support it, "pipeling" is available; multiple commands are queued and sent to the Redis server at the same time.  This can greatly reduce the time to execute bulk commands because you pay only one round trip cost (see `redux` for more details and an example).

## Subscription

Subscription support, using Redis' `PUBLISH`/`SUBSCRIBE` interface is implemented using callback functions.  This requires support in the underlying driver (supported only by `redux`).

# rlite support

If [`rrlite`](https://github.com/ropensci/rrlite) is installed, you can create hirlite connections with `rrlite::hirlite()` which has the same set of generated interfaces.  Not all commands are supported (for example, `SCAN` and `BLPOP`) but `hirlite` will throw an error if unsupported commands are used.  `rrlite` does not currently compile on Windows.

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/RedisAPI/issues).
* License: BSD (2 clause)
* Get citation information for `RedisAPI` in R by doing `citation(package = 'RedisAPI')`

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
