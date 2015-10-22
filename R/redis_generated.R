## Automatically generated: do not edit by hand
redis_api_generator <- R6::R6Class(
  "redis_api",
  public=list(
    config=NULL,
    reconnect=NULL,
    ## Driver functions
    .command=NULL,
    .pipeline=NULL,
    .subscribe=NULL,

    initialize=function(obj) {
      self$config     <- obj$config()
      self$reconnect  <- hiredis_function(obj$reconnect)
      self$.command   <- hiredis_function(obj$command, TRUE)
      self$.pipeline  <- hiredis_function(obj$pipeline)
      self$.subscribe <- hiredis_function(obj$subscribe)
    },

    pipeline=function(..., .commands=list(...)) {
      ret <- self$.pipeline(.commands)
      if (!is.null(names(.commands))) {
        names(ret) <- names(.commands)
      }
      ret
    },

    ## TODO: Pattern is not supported here yet.
    subscribe=function(channel, transform=NULL, terminate=NULL,
                       envir=parent.frame(), collect=TRUE, n=Inf) {
      collector <- make_collector(collect)
      callback <- make_callback(transform, terminate, collector$add, n)
      self$.subscribe(channel, callback, envir)
      collector$get()
    },
    ## generated methods:
    APPEND=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$.command(list("APPEND", key, value))
    },
    AUTH=function(password) {
      assert_scalar(password)
      self$.command(list("AUTH", password))
    },
    BGREWRITEAOF=function() {
      self$.command(list("BGREWRITEAOF"))
    },
    BGSAVE=function() {
      self$.command(list("BGSAVE"))
    },
    BITCOUNT=function(key, start=NULL, end=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(start)
      assert_scalar_or_null(end)
      self$.command(list("BITCOUNT", key, start, end))
    },
    BITOP=function(operation, destkey, key) {
      assert_scalar(operation)
      assert_scalar(destkey)
      self$.command(list("BITOP", operation, destkey, key))
    },
    BITPOS=function(key, bit, start=NULL, end=NULL) {
      assert_scalar(key)
      assert_scalar(bit)
      assert_scalar_or_null(start)
      assert_scalar_or_null(end)
      self$.command(list("BITPOS", key, bit, start, end))
    },
    BLPOP=function(key, timeout) {
      assert_scalar(timeout)
      self$.command(list("BLPOP", key, timeout))
    },
    BRPOP=function(key, timeout) {
      assert_scalar(timeout)
      self$.command(list("BRPOP", key, timeout))
    },
    BRPOPLPUSH=function(source, destination, timeout) {
      assert_scalar(source)
      assert_scalar(destination)
      assert_scalar(timeout)
      self$.command(list("BRPOPLPUSH", source, destination, timeout))
    },
    COMMAND=function() {
      self$.command(list("COMMAND"))
    },
    DBSIZE=function() {
      self$.command(list("DBSIZE"))
    },
    DECR=function(key) {
      assert_scalar(key)
      self$.command(list("DECR", key))
    },
    DECRBY=function(key, decrement) {
      assert_scalar(key)
      assert_scalar(decrement)
      self$.command(list("DECRBY", key, decrement))
    },
    DEL=function(key) {
      self$.command(list("DEL", key))
    },
    DISCARD=function() {
      self$.command(list("DISCARD"))
    },
    DUMP=function(key) {
      assert_scalar(key)
      self$.command(list("DUMP", key))
    },
    ECHO=function(message) {
      assert_scalar(message)
      self$.command(list("ECHO", message))
    },
    EVAL=function(script, numkeys, key, arg) {
      assert_scalar(script)
      assert_scalar(numkeys)
      self$.command(list("EVAL", script, numkeys, key, arg))
    },
    EVALSHA=function(sha1, numkeys, key, arg) {
      assert_scalar(sha1)
      assert_scalar(numkeys)
      self$.command(list("EVALSHA", sha1, numkeys, key, arg))
    },
    EXEC=function() {
      self$.command(list("EXEC"))
    },
    EXISTS=function(key) {
      self$.command(list("EXISTS", key))
    },
    EXPIRE=function(key, seconds) {
      assert_scalar(key)
      assert_scalar(seconds)
      self$.command(list("EXPIRE", key, seconds))
    },
    EXPIREAT=function(key, timestamp) {
      assert_scalar(key)
      assert_scalar(timestamp)
      self$.command(list("EXPIREAT", key, timestamp))
    },
    FLUSHALL=function() {
      self$.command(list("FLUSHALL"))
    },
    FLUSHDB=function() {
      self$.command(list("FLUSHDB"))
    },
    GEOADD=function(key, longitude, latitude, member) {
      assert_scalar(key)
      longitude <- interleave(longitude, latitude)
      longitude <- interleave(longitude, member)
      self$.command(list("GEOADD", key, longitude))
    },
    GEOHASH=function(key, member) {
      assert_scalar(key)
      self$.command(list("GEOHASH", key, member))
    },
    GEOPOS=function(key, member) {
      assert_scalar(key)
      self$.command(list("GEOPOS", key, member))
    },
    GEODIST=function(key, member1, member2, unit=NULL) {
      assert_scalar(key)
      assert_scalar(member1)
      assert_scalar(member2)
      assert_scalar_or_null(unit)
      self$.command(list("GEODIST", key, member1, member2, unit))
    },
    GEORADIUS=function(key, longitude, latitude, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(longitude)
      assert_scalar(latitude)
      assert_scalar(radius)
      assert_match_value(unit, c("m", "km", "ft", "mi"))
      assert_match_value_or_null(withcoord, c("WITHCOORD"))
      assert_match_value_or_null(withdist, c("WITHDIST"))
      assert_match_value_or_null(withhash, c("WITHHASH"))
      assert_scalar_or_null(COUNT)
      self$.command(list("GEORADIUS", key, longitude, latitude, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE)))
    },
    GEORADIUSBYMEMBER=function(key, member, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(member)
      assert_scalar(radius)
      assert_match_value(unit, c("m", "km", "ft", "mi"))
      assert_match_value_or_null(withcoord, c("WITHCOORD"))
      assert_match_value_or_null(withdist, c("WITHDIST"))
      assert_match_value_or_null(withhash, c("WITHHASH"))
      assert_scalar_or_null(COUNT)
      self$.command(list("GEORADIUSBYMEMBER", key, member, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE)))
    },
    GET=function(key) {
      assert_scalar(key)
      self$.command(list("GET", key))
    },
    GETBIT=function(key, offset) {
      assert_scalar(key)
      assert_scalar(offset)
      self$.command(list("GETBIT", key, offset))
    },
    GETRANGE=function(key, start, end) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(end)
      self$.command(list("GETRANGE", key, start, end))
    },
    GETSET=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$.command(list("GETSET", key, value))
    },
    HDEL=function(key, field) {
      assert_scalar(key)
      self$.command(list("HDEL", key, field))
    },
    HEXISTS=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$.command(list("HEXISTS", key, field))
    },
    HGET=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$.command(list("HGET", key, field))
    },
    HGETALL=function(key) {
      assert_scalar(key)
      self$.command(list("HGETALL", key))
    },
    HINCRBY=function(key, field, increment) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(increment)
      self$.command(list("HINCRBY", key, field, increment))
    },
    HINCRBYFLOAT=function(key, field, increment) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(increment)
      self$.command(list("HINCRBYFLOAT", key, field, increment))
    },
    HKEYS=function(key) {
      assert_scalar(key)
      self$.command(list("HKEYS", key))
    },
    HLEN=function(key) {
      assert_scalar(key)
      self$.command(list("HLEN", key))
    },
    HMGET=function(key, field) {
      assert_scalar(key)
      self$.command(list("HMGET", key, field))
    },
    HMSET=function(key, field, value) {
      assert_scalar(key)
      field <- interleave(field, value)
      self$.command(list("HMSET", key, field))
    },
    HSET=function(key, field, value) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(value)
      self$.command(list("HSET", key, field, value))
    },
    HSETNX=function(key, field, value) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(value)
      self$.command(list("HSETNX", key, field, value))
    },
    HSTRLEN=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$.command(list("HSTRLEN", key, field))
    },
    HVALS=function(key) {
      assert_scalar(key)
      self$.command(list("HVALS", key))
    },
    INCR=function(key) {
      assert_scalar(key)
      self$.command(list("INCR", key))
    },
    INCRBY=function(key, increment) {
      assert_scalar(key)
      assert_scalar(increment)
      self$.command(list("INCRBY", key, increment))
    },
    INCRBYFLOAT=function(key, increment) {
      assert_scalar(key)
      assert_scalar(increment)
      self$.command(list("INCRBYFLOAT", key, increment))
    },
    INFO=function(section=NULL) {
      assert_scalar_or_null(section)
      self$.command(list("INFO", section))
    },
    KEYS=function(pattern) {
      assert_scalar(pattern)
      self$.command(list("KEYS", pattern))
    },
    LASTSAVE=function() {
      self$.command(list("LASTSAVE"))
    },
    LINDEX=function(key, index) {
      assert_scalar(key)
      assert_scalar(index)
      self$.command(list("LINDEX", key, index))
    },
    LINSERT=function(key, where, pivot, value) {
      assert_scalar(key)
      assert_match_value(where, c("BEFORE", "AFTER"))
      assert_scalar(pivot)
      assert_scalar(value)
      self$.command(list("LINSERT", key, where, pivot, value))
    },
    LLEN=function(key) {
      assert_scalar(key)
      self$.command(list("LLEN", key))
    },
    LPOP=function(key) {
      assert_scalar(key)
      self$.command(list("LPOP", key))
    },
    LPUSH=function(key, value) {
      assert_scalar(key)
      self$.command(list("LPUSH", key, value))
    },
    LPUSHX=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$.command(list("LPUSHX", key, value))
    },
    LRANGE=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$.command(list("LRANGE", key, start, stop))
    },
    LREM=function(key, count, value) {
      assert_scalar(key)
      assert_scalar(count)
      assert_scalar(value)
      self$.command(list("LREM", key, count, value))
    },
    LSET=function(key, index, value) {
      assert_scalar(key)
      assert_scalar(index)
      assert_scalar(value)
      self$.command(list("LSET", key, index, value))
    },
    LTRIM=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$.command(list("LTRIM", key, start, stop))
    },
    MGET=function(key) {
      self$.command(list("MGET", key))
    },
    MIGRATE=function(host, port, key, destination_db, timeout, copy=NULL, replace=NULL) {
      assert_scalar(host)
      assert_scalar(port)
      assert_scalar(key)
      assert_scalar(destination_db)
      assert_scalar(timeout)
      assert_match_value_or_null(copy, c("COPY"))
      assert_match_value_or_null(replace, c("REPLACE"))
      self$.command(list("MIGRATE", host, port, key, destination_db, timeout, copy, replace))
    },
    MONITOR=function() {
      self$.command(list("MONITOR"))
    },
    MOVE=function(key, db) {
      assert_scalar(key)
      assert_scalar(db)
      self$.command(list("MOVE", key, db))
    },
    MSET=function(key, value) {
      key <- interleave(key, value)
      self$.command(list("MSET", key))
    },
    MSETNX=function(key, value) {
      key <- interleave(key, value)
      self$.command(list("MSETNX", key))
    },
    MULTI=function() {
      self$.command(list("MULTI"))
    },
    OBJECT=function(subcommand, arguments=NULL) {
      assert_scalar(subcommand)
      self$.command(list("OBJECT", subcommand, arguments))
    },
    PERSIST=function(key) {
      assert_scalar(key)
      self$.command(list("PERSIST", key))
    },
    PEXPIRE=function(key, milliseconds) {
      assert_scalar(key)
      assert_scalar(milliseconds)
      self$.command(list("PEXPIRE", key, milliseconds))
    },
    PEXPIREAT=function(key, milliseconds_timestamp) {
      assert_scalar(key)
      assert_scalar(milliseconds_timestamp)
      self$.command(list("PEXPIREAT", key, milliseconds_timestamp))
    },
    PFADD=function(key, element) {
      assert_scalar(key)
      self$.command(list("PFADD", key, element))
    },
    PFCOUNT=function(key) {
      self$.command(list("PFCOUNT", key))
    },
    PFMERGE=function(destkey, sourcekey) {
      assert_scalar(destkey)
      self$.command(list("PFMERGE", destkey, sourcekey))
    },
    PING=function() {
      self$.command(list("PING"))
    },
    PSETEX=function(key, milliseconds, value) {
      assert_scalar(key)
      assert_scalar(milliseconds)
      assert_scalar(value)
      self$.command(list("PSETEX", key, milliseconds, value))
    },
    PSUBSCRIBE=function(pattern) {
      self$.command(list("PSUBSCRIBE", pattern))
    },
    PUBSUB=function(subcommand, argument=NULL) {
      assert_scalar(subcommand)
      self$.command(list("PUBSUB", subcommand, argument))
    },
    PTTL=function(key) {
      assert_scalar(key)
      self$.command(list("PTTL", key))
    },
    PUBLISH=function(channel, message) {
      assert_scalar(channel)
      assert_scalar(message)
      self$.command(list("PUBLISH", channel, message))
    },
    PUNSUBSCRIBE=function(pattern=NULL) {
      self$.command(list("PUNSUBSCRIBE", pattern))
    },
    QUIT=function() {
      self$.command(list("QUIT"))
    },
    RANDOMKEY=function() {
      self$.command(list("RANDOMKEY"))
    },
    READONLY=function() {
      self$.command(list("READONLY"))
    },
    READWRITE=function() {
      self$.command(list("READWRITE"))
    },
    RENAME=function(key, newkey) {
      assert_scalar(key)
      assert_scalar(newkey)
      self$.command(list("RENAME", key, newkey))
    },
    RENAMENX=function(key, newkey) {
      assert_scalar(key)
      assert_scalar(newkey)
      self$.command(list("RENAMENX", key, newkey))
    },
    RESTORE=function(key, ttl, serialized_value, replace=NULL) {
      assert_scalar(key)
      assert_scalar(ttl)
      assert_scalar(serialized_value)
      assert_match_value_or_null(replace, c("REPLACE"))
      self$.command(list("RESTORE", key, ttl, serialized_value, replace))
    },
    ROLE=function() {
      self$.command(list("ROLE"))
    },
    RPOP=function(key) {
      assert_scalar(key)
      self$.command(list("RPOP", key))
    },
    RPOPLPUSH=function(source, destination) {
      assert_scalar(source)
      assert_scalar(destination)
      self$.command(list("RPOPLPUSH", source, destination))
    },
    RPUSH=function(key, value) {
      assert_scalar(key)
      self$.command(list("RPUSH", key, value))
    },
    RPUSHX=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$.command(list("RPUSHX", key, value))
    },
    SADD=function(key, member) {
      assert_scalar(key)
      self$.command(list("SADD", key, member))
    },
    SAVE=function() {
      self$.command(list("SAVE"))
    },
    SCARD=function(key) {
      assert_scalar(key)
      self$.command(list("SCARD", key))
    },
    SDIFF=function(key) {
      self$.command(list("SDIFF", key))
    },
    SDIFFSTORE=function(destination, key) {
      assert_scalar(destination)
      self$.command(list("SDIFFSTORE", destination, key))
    },
    SELECT=function(index) {
      assert_scalar(index)
      self$.command(list("SELECT", index))
    },
    SET=function(key, value, EX=NULL, PX=NULL, condition=NULL) {
      assert_scalar(key)
      assert_scalar(value)
      assert_scalar_or_null(EX)
      assert_scalar_or_null(PX)
      assert_match_value_or_null(condition, c("NX", "XX"))
      self$.command(list("SET", key, value, command("EX", EX, FALSE), command("PX", PX, FALSE), condition))
    },
    SETBIT=function(key, offset, value) {
      assert_scalar(key)
      assert_scalar(offset)
      assert_scalar(value)
      self$.command(list("SETBIT", key, offset, value))
    },
    SETEX=function(key, seconds, value) {
      assert_scalar(key)
      assert_scalar(seconds)
      assert_scalar(value)
      self$.command(list("SETEX", key, seconds, value))
    },
    SETNX=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$.command(list("SETNX", key, value))
    },
    SETRANGE=function(key, offset, value) {
      assert_scalar(key)
      assert_scalar(offset)
      assert_scalar(value)
      self$.command(list("SETRANGE", key, offset, value))
    },
    SHUTDOWN=function(NOSAVE=NULL, SAVE=NULL) {
      assert_match_value_or_null(NOSAVE, c("NOSAVE"))
      assert_match_value_or_null(SAVE, c("SAVE"))
      self$.command(list("SHUTDOWN", NOSAVE, SAVE))
    },
    SINTER=function(key) {
      self$.command(list("SINTER", key))
    },
    SINTERSTORE=function(destination, key) {
      assert_scalar(destination)
      self$.command(list("SINTERSTORE", destination, key))
    },
    SISMEMBER=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$.command(list("SISMEMBER", key, member))
    },
    SLAVEOF=function(host, port) {
      assert_scalar(host)
      assert_scalar(port)
      self$.command(list("SLAVEOF", host, port))
    },
    SLOWLOG=function(subcommand, argument=NULL) {
      assert_scalar(subcommand)
      assert_scalar_or_null(argument)
      self$.command(list("SLOWLOG", subcommand, argument))
    },
    SMEMBERS=function(key) {
      assert_scalar(key)
      self$.command(list("SMEMBERS", key))
    },
    SMOVE=function(source, destination, member) {
      assert_scalar(source)
      assert_scalar(destination)
      assert_scalar(member)
      self$.command(list("SMOVE", source, destination, member))
    },
    SORT=function(key, BY=NULL, LIMIT=NULL, GET=NULL, order=NULL, sorting=NULL, STORE=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(BY)
      assert_length_or_null(LIMIT, 2L)
      assert_match_value_or_null(order, c("ASC", "DESC"))
      assert_match_value_or_null(sorting, c("ALPHA"))
      assert_scalar_or_null(STORE)
      self$.command(list("SORT", key, command("BY", BY, FALSE), command("LIMIT", LIMIT, TRUE), command("GET", GET, FALSE), order, sorting, command("STORE", STORE, FALSE)))
    },
    SPOP=function(key, count=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(count)
      self$.command(list("SPOP", key, count))
    },
    SRANDMEMBER=function(key, count=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(count)
      self$.command(list("SRANDMEMBER", key, count))
    },
    SREM=function(key, member) {
      assert_scalar(key)
      self$.command(list("SREM", key, member))
    },
    STRLEN=function(key) {
      assert_scalar(key)
      self$.command(list("STRLEN", key))
    },
    SUBSCRIBE=function(channel) {
      self$.command(list("SUBSCRIBE", channel))
    },
    SUNION=function(key) {
      self$.command(list("SUNION", key))
    },
    SUNIONSTORE=function(destination, key) {
      assert_scalar(destination)
      self$.command(list("SUNIONSTORE", destination, key))
    },
    SYNC=function() {
      self$.command(list("SYNC"))
    },
    TIME=function() {
      self$.command(list("TIME"))
    },
    TTL=function(key) {
      assert_scalar(key)
      self$.command(list("TTL", key))
    },
    TYPE=function(key) {
      assert_scalar(key)
      self$.command(list("TYPE", key))
    },
    UNSUBSCRIBE=function(channel=NULL) {
      self$.command(list("UNSUBSCRIBE", channel))
    },
    UNWATCH=function() {
      self$.command(list("UNWATCH"))
    },
    WAIT=function(numslaves, timeout) {
      assert_scalar(numslaves)
      assert_scalar(timeout)
      self$.command(list("WAIT", numslaves, timeout))
    },
    WATCH=function(key) {
      self$.command(list("WATCH", key))
    },
    ZADD=function(key, condition=NULL, change=NULL, increment=NULL, score, member) {
      assert_scalar(key)
      assert_match_value_or_null(condition, c("NX", "XX"))
      assert_match_value_or_null(change, c("CH"))
      assert_match_value_or_null(increment, c("INCR"))
      score <- interleave(score, member)
      self$.command(list("ZADD", key, condition, change, increment, score))
    },
    ZCARD=function(key) {
      assert_scalar(key)
      self$.command(list("ZCARD", key))
    },
    ZCOUNT=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$.command(list("ZCOUNT", key, min, max))
    },
    ZINCRBY=function(key, increment, member) {
      assert_scalar(key)
      assert_scalar(increment)
      assert_scalar(member)
      self$.command(list("ZINCRBY", key, increment, member))
    },
    ZINTERSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
      assert_scalar(destination)
      assert_scalar(numkeys)
      assert_scalar_or_null(WEIGHTS)
      assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
      self$.command(list("ZINTERSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE)))
    },
    ZLEXCOUNT=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$.command(list("ZLEXCOUNT", key, min, max))
    },
    ZRANGE=function(key, start, stop, withscores=NULL) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      self$.command(list("ZRANGE", key, start, stop, withscores))
    },
    ZRANGEBYLEX=function(key, min, max, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZRANGEBYLEX", key, min, max, command("LIMIT", LIMIT, TRUE)))
    },
    ZREVRANGEBYLEX=function(key, max, min, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(max)
      assert_scalar(min)
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZREVRANGEBYLEX", key, max, min, command("LIMIT", LIMIT, TRUE)))
    },
    ZRANGEBYSCORE=function(key, min, max, withscores=NULL, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZRANGEBYSCORE", key, min, max, withscores, command("LIMIT", LIMIT, TRUE)))
    },
    ZRANK=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$.command(list("ZRANK", key, member))
    },
    ZREM=function(key, member) {
      assert_scalar(key)
      self$.command(list("ZREM", key, member))
    },
    ZREMRANGEBYLEX=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$.command(list("ZREMRANGEBYLEX", key, min, max))
    },
    ZREMRANGEBYRANK=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$.command(list("ZREMRANGEBYRANK", key, start, stop))
    },
    ZREMRANGEBYSCORE=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$.command(list("ZREMRANGEBYSCORE", key, min, max))
    },
    ZREVRANGE=function(key, start, stop, withscores=NULL) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      self$.command(list("ZREVRANGE", key, start, stop, withscores))
    },
    ZREVRANGEBYSCORE=function(key, max, min, withscores=NULL, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(max)
      assert_scalar(min)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZREVRANGEBYSCORE", key, max, min, withscores, command("LIMIT", LIMIT, TRUE)))
    },
    ZREVRANK=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$.command(list("ZREVRANK", key, member))
    },
    ZSCORE=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$.command(list("ZSCORE", key, member))
    },
    ZUNIONSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
      assert_scalar(destination)
      assert_scalar(numkeys)
      assert_scalar_or_null(WEIGHTS)
      assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
      self$.command(list("ZUNIONSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE)))
    },
    SCAN=function(cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$.command(list("SCAN", cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    SSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$.command(list("SSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    HSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$.command(list("HSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    ZSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$.command(list("ZSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    }
    ))
redis <- list2env(hash=TRUE, list(
  APPEND=function(key, value) {
    assert_scalar(key)
    assert_scalar(value)
    list("APPEND", key, value)
  },
  AUTH=function(password) {
    assert_scalar(password)
    list("AUTH", password)
  },
  BGREWRITEAOF=function() {
    list("BGREWRITEAOF")
  },
  BGSAVE=function() {
    list("BGSAVE")
  },
  BITCOUNT=function(key, start=NULL, end=NULL) {
    assert_scalar(key)
    assert_scalar_or_null(start)
    assert_scalar_or_null(end)
    list("BITCOUNT", key, start, end)
  },
  BITOP=function(operation, destkey, key) {
    assert_scalar(operation)
    assert_scalar(destkey)
    list("BITOP", operation, destkey, key)
  },
  BITPOS=function(key, bit, start=NULL, end=NULL) {
    assert_scalar(key)
    assert_scalar(bit)
    assert_scalar_or_null(start)
    assert_scalar_or_null(end)
    list("BITPOS", key, bit, start, end)
  },
  BLPOP=function(key, timeout) {
    assert_scalar(timeout)
    list("BLPOP", key, timeout)
  },
  BRPOP=function(key, timeout) {
    assert_scalar(timeout)
    list("BRPOP", key, timeout)
  },
  BRPOPLPUSH=function(source, destination, timeout) {
    assert_scalar(source)
    assert_scalar(destination)
    assert_scalar(timeout)
    list("BRPOPLPUSH", source, destination, timeout)
  },
  COMMAND=function() {
    list("COMMAND")
  },
  DBSIZE=function() {
    list("DBSIZE")
  },
  DECR=function(key) {
    assert_scalar(key)
    list("DECR", key)
  },
  DECRBY=function(key, decrement) {
    assert_scalar(key)
    assert_scalar(decrement)
    list("DECRBY", key, decrement)
  },
  DEL=function(key) {
    list("DEL", key)
  },
  DISCARD=function() {
    list("DISCARD")
  },
  DUMP=function(key) {
    assert_scalar(key)
    list("DUMP", key)
  },
  ECHO=function(message) {
    assert_scalar(message)
    list("ECHO", message)
  },
  EVAL=function(script, numkeys, key, arg) {
    assert_scalar(script)
    assert_scalar(numkeys)
    list("EVAL", script, numkeys, key, arg)
  },
  EVALSHA=function(sha1, numkeys, key, arg) {
    assert_scalar(sha1)
    assert_scalar(numkeys)
    list("EVALSHA", sha1, numkeys, key, arg)
  },
  EXEC=function() {
    list("EXEC")
  },
  EXISTS=function(key) {
    list("EXISTS", key)
  },
  EXPIRE=function(key, seconds) {
    assert_scalar(key)
    assert_scalar(seconds)
    list("EXPIRE", key, seconds)
  },
  EXPIREAT=function(key, timestamp) {
    assert_scalar(key)
    assert_scalar(timestamp)
    list("EXPIREAT", key, timestamp)
  },
  FLUSHALL=function() {
    list("FLUSHALL")
  },
  FLUSHDB=function() {
    list("FLUSHDB")
  },
  GEOADD=function(key, longitude, latitude, member) {
    assert_scalar(key)
    longitude <- interleave(longitude, latitude)
    longitude <- interleave(longitude, member)
    list("GEOADD", key, longitude)
  },
  GEOHASH=function(key, member) {
    assert_scalar(key)
    list("GEOHASH", key, member)
  },
  GEOPOS=function(key, member) {
    assert_scalar(key)
    list("GEOPOS", key, member)
  },
  GEODIST=function(key, member1, member2, unit=NULL) {
    assert_scalar(key)
    assert_scalar(member1)
    assert_scalar(member2)
    assert_scalar_or_null(unit)
    list("GEODIST", key, member1, member2, unit)
  },
  GEORADIUS=function(key, longitude, latitude, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
    assert_scalar(key)
    assert_scalar(longitude)
    assert_scalar(latitude)
    assert_scalar(radius)
    assert_match_value(unit, c("m", "km", "ft", "mi"))
    assert_match_value_or_null(withcoord, c("WITHCOORD"))
    assert_match_value_or_null(withdist, c("WITHDIST"))
    assert_match_value_or_null(withhash, c("WITHHASH"))
    assert_scalar_or_null(COUNT)
    list("GEORADIUS", key, longitude, latitude, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE))
  },
  GEORADIUSBYMEMBER=function(key, member, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
    assert_scalar(key)
    assert_scalar(member)
    assert_scalar(radius)
    assert_match_value(unit, c("m", "km", "ft", "mi"))
    assert_match_value_or_null(withcoord, c("WITHCOORD"))
    assert_match_value_or_null(withdist, c("WITHDIST"))
    assert_match_value_or_null(withhash, c("WITHHASH"))
    assert_scalar_or_null(COUNT)
    list("GEORADIUSBYMEMBER", key, member, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE))
  },
  GET=function(key) {
    assert_scalar(key)
    list("GET", key)
  },
  GETBIT=function(key, offset) {
    assert_scalar(key)
    assert_scalar(offset)
    list("GETBIT", key, offset)
  },
  GETRANGE=function(key, start, end) {
    assert_scalar(key)
    assert_scalar(start)
    assert_scalar(end)
    list("GETRANGE", key, start, end)
  },
  GETSET=function(key, value) {
    assert_scalar(key)
    assert_scalar(value)
    list("GETSET", key, value)
  },
  HDEL=function(key, field) {
    assert_scalar(key)
    list("HDEL", key, field)
  },
  HEXISTS=function(key, field) {
    assert_scalar(key)
    assert_scalar(field)
    list("HEXISTS", key, field)
  },
  HGET=function(key, field) {
    assert_scalar(key)
    assert_scalar(field)
    list("HGET", key, field)
  },
  HGETALL=function(key) {
    assert_scalar(key)
    list("HGETALL", key)
  },
  HINCRBY=function(key, field, increment) {
    assert_scalar(key)
    assert_scalar(field)
    assert_scalar(increment)
    list("HINCRBY", key, field, increment)
  },
  HINCRBYFLOAT=function(key, field, increment) {
    assert_scalar(key)
    assert_scalar(field)
    assert_scalar(increment)
    list("HINCRBYFLOAT", key, field, increment)
  },
  HKEYS=function(key) {
    assert_scalar(key)
    list("HKEYS", key)
  },
  HLEN=function(key) {
    assert_scalar(key)
    list("HLEN", key)
  },
  HMGET=function(key, field) {
    assert_scalar(key)
    list("HMGET", key, field)
  },
  HMSET=function(key, field, value) {
    assert_scalar(key)
    field <- interleave(field, value)
    list("HMSET", key, field)
  },
  HSET=function(key, field, value) {
    assert_scalar(key)
    assert_scalar(field)
    assert_scalar(value)
    list("HSET", key, field, value)
  },
  HSETNX=function(key, field, value) {
    assert_scalar(key)
    assert_scalar(field)
    assert_scalar(value)
    list("HSETNX", key, field, value)
  },
  HSTRLEN=function(key, field) {
    assert_scalar(key)
    assert_scalar(field)
    list("HSTRLEN", key, field)
  },
  HVALS=function(key) {
    assert_scalar(key)
    list("HVALS", key)
  },
  INCR=function(key) {
    assert_scalar(key)
    list("INCR", key)
  },
  INCRBY=function(key, increment) {
    assert_scalar(key)
    assert_scalar(increment)
    list("INCRBY", key, increment)
  },
  INCRBYFLOAT=function(key, increment) {
    assert_scalar(key)
    assert_scalar(increment)
    list("INCRBYFLOAT", key, increment)
  },
  INFO=function(section=NULL) {
    assert_scalar_or_null(section)
    list("INFO", section)
  },
  KEYS=function(pattern) {
    assert_scalar(pattern)
    list("KEYS", pattern)
  },
  LASTSAVE=function() {
    list("LASTSAVE")
  },
  LINDEX=function(key, index) {
    assert_scalar(key)
    assert_scalar(index)
    list("LINDEX", key, index)
  },
  LINSERT=function(key, where, pivot, value) {
    assert_scalar(key)
    assert_match_value(where, c("BEFORE", "AFTER"))
    assert_scalar(pivot)
    assert_scalar(value)
    list("LINSERT", key, where, pivot, value)
  },
  LLEN=function(key) {
    assert_scalar(key)
    list("LLEN", key)
  },
  LPOP=function(key) {
    assert_scalar(key)
    list("LPOP", key)
  },
  LPUSH=function(key, value) {
    assert_scalar(key)
    list("LPUSH", key, value)
  },
  LPUSHX=function(key, value) {
    assert_scalar(key)
    assert_scalar(value)
    list("LPUSHX", key, value)
  },
  LRANGE=function(key, start, stop) {
    assert_scalar(key)
    assert_scalar(start)
    assert_scalar(stop)
    list("LRANGE", key, start, stop)
  },
  LREM=function(key, count, value) {
    assert_scalar(key)
    assert_scalar(count)
    assert_scalar(value)
    list("LREM", key, count, value)
  },
  LSET=function(key, index, value) {
    assert_scalar(key)
    assert_scalar(index)
    assert_scalar(value)
    list("LSET", key, index, value)
  },
  LTRIM=function(key, start, stop) {
    assert_scalar(key)
    assert_scalar(start)
    assert_scalar(stop)
    list("LTRIM", key, start, stop)
  },
  MGET=function(key) {
    list("MGET", key)
  },
  MIGRATE=function(host, port, key, destination_db, timeout, copy=NULL, replace=NULL) {
    assert_scalar(host)
    assert_scalar(port)
    assert_scalar(key)
    assert_scalar(destination_db)
    assert_scalar(timeout)
    assert_match_value_or_null(copy, c("COPY"))
    assert_match_value_or_null(replace, c("REPLACE"))
    list("MIGRATE", host, port, key, destination_db, timeout, copy, replace)
  },
  MONITOR=function() {
    list("MONITOR")
  },
  MOVE=function(key, db) {
    assert_scalar(key)
    assert_scalar(db)
    list("MOVE", key, db)
  },
  MSET=function(key, value) {
    key <- interleave(key, value)
    list("MSET", key)
  },
  MSETNX=function(key, value) {
    key <- interleave(key, value)
    list("MSETNX", key)
  },
  MULTI=function() {
    list("MULTI")
  },
  OBJECT=function(subcommand, arguments=NULL) {
    assert_scalar(subcommand)
    list("OBJECT", subcommand, arguments)
  },
  PERSIST=function(key) {
    assert_scalar(key)
    list("PERSIST", key)
  },
  PEXPIRE=function(key, milliseconds) {
    assert_scalar(key)
    assert_scalar(milliseconds)
    list("PEXPIRE", key, milliseconds)
  },
  PEXPIREAT=function(key, milliseconds_timestamp) {
    assert_scalar(key)
    assert_scalar(milliseconds_timestamp)
    list("PEXPIREAT", key, milliseconds_timestamp)
  },
  PFADD=function(key, element) {
    assert_scalar(key)
    list("PFADD", key, element)
  },
  PFCOUNT=function(key) {
    list("PFCOUNT", key)
  },
  PFMERGE=function(destkey, sourcekey) {
    assert_scalar(destkey)
    list("PFMERGE", destkey, sourcekey)
  },
  PING=function() {
    list("PING")
  },
  PSETEX=function(key, milliseconds, value) {
    assert_scalar(key)
    assert_scalar(milliseconds)
    assert_scalar(value)
    list("PSETEX", key, milliseconds, value)
  },
  PSUBSCRIBE=function(pattern) {
    list("PSUBSCRIBE", pattern)
  },
  PUBSUB=function(subcommand, argument=NULL) {
    assert_scalar(subcommand)
    list("PUBSUB", subcommand, argument)
  },
  PTTL=function(key) {
    assert_scalar(key)
    list("PTTL", key)
  },
  PUBLISH=function(channel, message) {
    assert_scalar(channel)
    assert_scalar(message)
    list("PUBLISH", channel, message)
  },
  PUNSUBSCRIBE=function(pattern=NULL) {
    list("PUNSUBSCRIBE", pattern)
  },
  QUIT=function() {
    list("QUIT")
  },
  RANDOMKEY=function() {
    list("RANDOMKEY")
  },
  READONLY=function() {
    list("READONLY")
  },
  READWRITE=function() {
    list("READWRITE")
  },
  RENAME=function(key, newkey) {
    assert_scalar(key)
    assert_scalar(newkey)
    list("RENAME", key, newkey)
  },
  RENAMENX=function(key, newkey) {
    assert_scalar(key)
    assert_scalar(newkey)
    list("RENAMENX", key, newkey)
  },
  RESTORE=function(key, ttl, serialized_value, replace=NULL) {
    assert_scalar(key)
    assert_scalar(ttl)
    assert_scalar(serialized_value)
    assert_match_value_or_null(replace, c("REPLACE"))
    list("RESTORE", key, ttl, serialized_value, replace)
  },
  ROLE=function() {
    list("ROLE")
  },
  RPOP=function(key) {
    assert_scalar(key)
    list("RPOP", key)
  },
  RPOPLPUSH=function(source, destination) {
    assert_scalar(source)
    assert_scalar(destination)
    list("RPOPLPUSH", source, destination)
  },
  RPUSH=function(key, value) {
    assert_scalar(key)
    list("RPUSH", key, value)
  },
  RPUSHX=function(key, value) {
    assert_scalar(key)
    assert_scalar(value)
    list("RPUSHX", key, value)
  },
  SADD=function(key, member) {
    assert_scalar(key)
    list("SADD", key, member)
  },
  SAVE=function() {
    list("SAVE")
  },
  SCARD=function(key) {
    assert_scalar(key)
    list("SCARD", key)
  },
  SDIFF=function(key) {
    list("SDIFF", key)
  },
  SDIFFSTORE=function(destination, key) {
    assert_scalar(destination)
    list("SDIFFSTORE", destination, key)
  },
  SELECT=function(index) {
    assert_scalar(index)
    list("SELECT", index)
  },
  SET=function(key, value, EX=NULL, PX=NULL, condition=NULL) {
    assert_scalar(key)
    assert_scalar(value)
    assert_scalar_or_null(EX)
    assert_scalar_or_null(PX)
    assert_match_value_or_null(condition, c("NX", "XX"))
    list("SET", key, value, command("EX", EX, FALSE), command("PX", PX, FALSE), condition)
  },
  SETBIT=function(key, offset, value) {
    assert_scalar(key)
    assert_scalar(offset)
    assert_scalar(value)
    list("SETBIT", key, offset, value)
  },
  SETEX=function(key, seconds, value) {
    assert_scalar(key)
    assert_scalar(seconds)
    assert_scalar(value)
    list("SETEX", key, seconds, value)
  },
  SETNX=function(key, value) {
    assert_scalar(key)
    assert_scalar(value)
    list("SETNX", key, value)
  },
  SETRANGE=function(key, offset, value) {
    assert_scalar(key)
    assert_scalar(offset)
    assert_scalar(value)
    list("SETRANGE", key, offset, value)
  },
  SHUTDOWN=function(NOSAVE=NULL, SAVE=NULL) {
    assert_match_value_or_null(NOSAVE, c("NOSAVE"))
    assert_match_value_or_null(SAVE, c("SAVE"))
    list("SHUTDOWN", NOSAVE, SAVE)
  },
  SINTER=function(key) {
    list("SINTER", key)
  },
  SINTERSTORE=function(destination, key) {
    assert_scalar(destination)
    list("SINTERSTORE", destination, key)
  },
  SISMEMBER=function(key, member) {
    assert_scalar(key)
    assert_scalar(member)
    list("SISMEMBER", key, member)
  },
  SLAVEOF=function(host, port) {
    assert_scalar(host)
    assert_scalar(port)
    list("SLAVEOF", host, port)
  },
  SLOWLOG=function(subcommand, argument=NULL) {
    assert_scalar(subcommand)
    assert_scalar_or_null(argument)
    list("SLOWLOG", subcommand, argument)
  },
  SMEMBERS=function(key) {
    assert_scalar(key)
    list("SMEMBERS", key)
  },
  SMOVE=function(source, destination, member) {
    assert_scalar(source)
    assert_scalar(destination)
    assert_scalar(member)
    list("SMOVE", source, destination, member)
  },
  SORT=function(key, BY=NULL, LIMIT=NULL, GET=NULL, order=NULL, sorting=NULL, STORE=NULL) {
    assert_scalar(key)
    assert_scalar_or_null(BY)
    assert_length_or_null(LIMIT, 2L)
    assert_match_value_or_null(order, c("ASC", "DESC"))
    assert_match_value_or_null(sorting, c("ALPHA"))
    assert_scalar_or_null(STORE)
    list("SORT", key, command("BY", BY, FALSE), command("LIMIT", LIMIT, TRUE), command("GET", GET, FALSE), order, sorting, command("STORE", STORE, FALSE))
  },
  SPOP=function(key, count=NULL) {
    assert_scalar(key)
    assert_scalar_or_null(count)
    list("SPOP", key, count)
  },
  SRANDMEMBER=function(key, count=NULL) {
    assert_scalar(key)
    assert_scalar_or_null(count)
    list("SRANDMEMBER", key, count)
  },
  SREM=function(key, member) {
    assert_scalar(key)
    list("SREM", key, member)
  },
  STRLEN=function(key) {
    assert_scalar(key)
    list("STRLEN", key)
  },
  SUBSCRIBE=function(channel) {
    list("SUBSCRIBE", channel)
  },
  SUNION=function(key) {
    list("SUNION", key)
  },
  SUNIONSTORE=function(destination, key) {
    assert_scalar(destination)
    list("SUNIONSTORE", destination, key)
  },
  SYNC=function() {
    list("SYNC")
  },
  TIME=function() {
    list("TIME")
  },
  TTL=function(key) {
    assert_scalar(key)
    list("TTL", key)
  },
  TYPE=function(key) {
    assert_scalar(key)
    list("TYPE", key)
  },
  UNSUBSCRIBE=function(channel=NULL) {
    list("UNSUBSCRIBE", channel)
  },
  UNWATCH=function() {
    list("UNWATCH")
  },
  WAIT=function(numslaves, timeout) {
    assert_scalar(numslaves)
    assert_scalar(timeout)
    list("WAIT", numslaves, timeout)
  },
  WATCH=function(key) {
    list("WATCH", key)
  },
  ZADD=function(key, condition=NULL, change=NULL, increment=NULL, score, member) {
    assert_scalar(key)
    assert_match_value_or_null(condition, c("NX", "XX"))
    assert_match_value_or_null(change, c("CH"))
    assert_match_value_or_null(increment, c("INCR"))
    score <- interleave(score, member)
    list("ZADD", key, condition, change, increment, score)
  },
  ZCARD=function(key) {
    assert_scalar(key)
    list("ZCARD", key)
  },
  ZCOUNT=function(key, min, max) {
    assert_scalar(key)
    assert_scalar(min)
    assert_scalar(max)
    list("ZCOUNT", key, min, max)
  },
  ZINCRBY=function(key, increment, member) {
    assert_scalar(key)
    assert_scalar(increment)
    assert_scalar(member)
    list("ZINCRBY", key, increment, member)
  },
  ZINTERSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
    assert_scalar(destination)
    assert_scalar(numkeys)
    assert_scalar_or_null(WEIGHTS)
    assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
    list("ZINTERSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE))
  },
  ZLEXCOUNT=function(key, min, max) {
    assert_scalar(key)
    assert_scalar(min)
    assert_scalar(max)
    list("ZLEXCOUNT", key, min, max)
  },
  ZRANGE=function(key, start, stop, withscores=NULL) {
    assert_scalar(key)
    assert_scalar(start)
    assert_scalar(stop)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    list("ZRANGE", key, start, stop, withscores)
  },
  ZRANGEBYLEX=function(key, min, max, LIMIT=NULL) {
    assert_scalar(key)
    assert_scalar(min)
    assert_scalar(max)
    assert_length_or_null(LIMIT, 2L)
    list("ZRANGEBYLEX", key, min, max, command("LIMIT", LIMIT, TRUE))
  },
  ZREVRANGEBYLEX=function(key, max, min, LIMIT=NULL) {
    assert_scalar(key)
    assert_scalar(max)
    assert_scalar(min)
    assert_length_or_null(LIMIT, 2L)
    list("ZREVRANGEBYLEX", key, max, min, command("LIMIT", LIMIT, TRUE))
  },
  ZRANGEBYSCORE=function(key, min, max, withscores=NULL, LIMIT=NULL) {
    assert_scalar(key)
    assert_scalar(min)
    assert_scalar(max)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    assert_length_or_null(LIMIT, 2L)
    list("ZRANGEBYSCORE", key, min, max, withscores, command("LIMIT", LIMIT, TRUE))
  },
  ZRANK=function(key, member) {
    assert_scalar(key)
    assert_scalar(member)
    list("ZRANK", key, member)
  },
  ZREM=function(key, member) {
    assert_scalar(key)
    list("ZREM", key, member)
  },
  ZREMRANGEBYLEX=function(key, min, max) {
    assert_scalar(key)
    assert_scalar(min)
    assert_scalar(max)
    list("ZREMRANGEBYLEX", key, min, max)
  },
  ZREMRANGEBYRANK=function(key, start, stop) {
    assert_scalar(key)
    assert_scalar(start)
    assert_scalar(stop)
    list("ZREMRANGEBYRANK", key, start, stop)
  },
  ZREMRANGEBYSCORE=function(key, min, max) {
    assert_scalar(key)
    assert_scalar(min)
    assert_scalar(max)
    list("ZREMRANGEBYSCORE", key, min, max)
  },
  ZREVRANGE=function(key, start, stop, withscores=NULL) {
    assert_scalar(key)
    assert_scalar(start)
    assert_scalar(stop)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    list("ZREVRANGE", key, start, stop, withscores)
  },
  ZREVRANGEBYSCORE=function(key, max, min, withscores=NULL, LIMIT=NULL) {
    assert_scalar(key)
    assert_scalar(max)
    assert_scalar(min)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    assert_length_or_null(LIMIT, 2L)
    list("ZREVRANGEBYSCORE", key, max, min, withscores, command("LIMIT", LIMIT, TRUE))
  },
  ZREVRANK=function(key, member) {
    assert_scalar(key)
    assert_scalar(member)
    list("ZREVRANK", key, member)
  },
  ZSCORE=function(key, member) {
    assert_scalar(key)
    assert_scalar(member)
    list("ZSCORE", key, member)
  },
  ZUNIONSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
    assert_scalar(destination)
    assert_scalar(numkeys)
    assert_scalar_or_null(WEIGHTS)
    assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
    list("ZUNIONSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE))
  },
  SCAN=function(cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar(cursor)
    assert_scalar_or_null(MATCH)
    assert_scalar_or_null(COUNT)
    list("SCAN", cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  },
  SSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar(key)
    assert_scalar(cursor)
    assert_scalar_or_null(MATCH)
    assert_scalar_or_null(COUNT)
    list("SSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  },
  HSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar(key)
    assert_scalar(cursor)
    assert_scalar_or_null(MATCH)
    assert_scalar_or_null(COUNT)
    list("HSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  },
  ZSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar(key)
    assert_scalar(cursor)
    assert_scalar_or_null(MATCH)
    assert_scalar_or_null(COUNT)
    list("ZSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  }
))
