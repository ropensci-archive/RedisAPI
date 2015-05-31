## Automatically generated: do not edit by hand
redis_api_generator <- R6::R6Class(
  "redis_api",
  public=list(
    host=NULL,
    port=NULL,
    run=NULL,
    type=NULL,
    initialize=function(run, host=NULL, port=NULL, type=NULL) {
      info <- redis_api_info(run, host, port, type)
      self$run  <- run
      self$host <- info$host
      self$port <- info$port
      self$type <- info$type
    },
    APPEND=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$run(c("APPEND", key, value))
    },
    AUTH=function(password) {
      assert_scalar(password)
      self$run(c("AUTH", password))
    },
    BGREWRITEAOF=function() {
      self$run(c("BGREWRITEAOF"))
    },
    BGSAVE=function() {
      self$run(c("BGSAVE"))
    },
    BITCOUNT=function(key, start=NULL, end=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(start)
      assert_scalar_or_null(end)
      self$run(c("BITCOUNT", key, start, end))
    },
    BITOP=function(operation, destkey, key) {
      assert_scalar(operation)
      assert_scalar(destkey)
      self$run(c("BITOP", operation, destkey, key))
    },
    BITPOS=function(key, bit, start=NULL, end=NULL) {
      assert_scalar(key)
      assert_scalar(bit)
      assert_scalar_or_null(start)
      assert_scalar_or_null(end)
      self$run(c("BITPOS", key, bit, start, end))
    },
    BLPOP=function(key, timeout) {
      assert_scalar(timeout)
      self$run(c("BLPOP", key, timeout))
    },
    BRPOP=function(key, timeout) {
      assert_scalar(timeout)
      self$run(c("BRPOP", key, timeout))
    },
    BRPOPLPUSH=function(source, destination, timeout) {
      assert_scalar(source)
      assert_scalar(destination)
      assert_scalar(timeout)
      self$run(c("BRPOPLPUSH", source, destination, timeout))
    },
    COMMAND=function() {
      self$run(c("COMMAND"))
    },
    DBSIZE=function() {
      self$run(c("DBSIZE"))
    },
    DECR=function(key) {
      assert_scalar(key)
      self$run(c("DECR", key))
    },
    DECRBY=function(key, decrement) {
      assert_scalar(key)
      assert_scalar(decrement)
      self$run(c("DECRBY", key, decrement))
    },
    DEL=function(key) {
      self$run(c("DEL", key))
    },
    DISCARD=function() {
      self$run(c("DISCARD"))
    },
    DUMP=function(key) {
      assert_scalar(key)
      self$run(c("DUMP", key))
    },
    ECHO=function(message) {
      assert_scalar(message)
      self$run(c("ECHO", message))
    },
    EVAL=function(script, numkeys, key, arg) {
      assert_scalar(script)
      assert_scalar(numkeys)
      self$run(c("EVAL", script, numkeys, key, arg))
    },
    EVALSHA=function(sha1, numkeys, key, arg) {
      assert_scalar(sha1)
      assert_scalar(numkeys)
      self$run(c("EVALSHA", sha1, numkeys, key, arg))
    },
    EXEC=function() {
      self$run(c("EXEC"))
    },
    EXISTS=function(key) {
      assert_scalar(key)
      self$run(c("EXISTS", key))
    },
    EXPIRE=function(key, seconds) {
      assert_scalar(key)
      assert_scalar(seconds)
      self$run(c("EXPIRE", key, seconds))
    },
    EXPIREAT=function(key, timestamp) {
      assert_scalar(key)
      assert_scalar(timestamp)
      self$run(c("EXPIREAT", key, timestamp))
    },
    FLUSHALL=function() {
      self$run(c("FLUSHALL"))
    },
    FLUSHDB=function() {
      self$run(c("FLUSHDB"))
    },
    GET=function(key) {
      assert_scalar(key)
      self$run(c("GET", key))
    },
    GETBIT=function(key, offset) {
      assert_scalar(key)
      assert_scalar(offset)
      self$run(c("GETBIT", key, offset))
    },
    GETRANGE=function(key, start, end) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(end)
      self$run(c("GETRANGE", key, start, end))
    },
    GETSET=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$run(c("GETSET", key, value))
    },
    HDEL=function(key, field) {
      assert_scalar(key)
      self$run(c("HDEL", key, field))
    },
    HEXISTS=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$run(c("HEXISTS", key, field))
    },
    HGET=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$run(c("HGET", key, field))
    },
    HGETALL=function(key) {
      assert_scalar(key)
      self$run(c("HGETALL", key))
    },
    HINCRBY=function(key, field, increment) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(increment)
      self$run(c("HINCRBY", key, field, increment))
    },
    HINCRBYFLOAT=function(key, field, increment) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(increment)
      self$run(c("HINCRBYFLOAT", key, field, increment))
    },
    HKEYS=function(key) {
      assert_scalar(key)
      self$run(c("HKEYS", key))
    },
    HLEN=function(key) {
      assert_scalar(key)
      self$run(c("HLEN", key))
    },
    HMGET=function(key, field) {
      assert_scalar(key)
      self$run(c("HMGET", key, field))
    },
    HMSET=function(key, field, value) {
      assert_scalar(key)
      field <- interleave(field, value)
      self$run(c("HMSET", key, field))
    },
    HSET=function(key, field, value) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(value)
      self$run(c("HSET", key, field, value))
    },
    HSETNX=function(key, field, value) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(value)
      self$run(c("HSETNX", key, field, value))
    },
    HSTRLEN=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$run(c("HSTRLEN", key, field))
    },
    HVALS=function(key) {
      assert_scalar(key)
      self$run(c("HVALS", key))
    },
    INCR=function(key) {
      assert_scalar(key)
      self$run(c("INCR", key))
    },
    INCRBY=function(key, increment) {
      assert_scalar(key)
      assert_scalar(increment)
      self$run(c("INCRBY", key, increment))
    },
    INCRBYFLOAT=function(key, increment) {
      assert_scalar(key)
      assert_scalar(increment)
      self$run(c("INCRBYFLOAT", key, increment))
    },
    INFO=function(section=NULL) {
      assert_scalar_or_null(section)
      self$run(c("INFO", section))
    },
    KEYS=function(pattern) {
      assert_scalar(pattern)
      self$run(c("KEYS", pattern))
    },
    LASTSAVE=function() {
      self$run(c("LASTSAVE"))
    },
    LINDEX=function(key, index) {
      assert_scalar(key)
      assert_scalar(index)
      self$run(c("LINDEX", key, index))
    },
    LINSERT=function(key, where, pivot, value) {
      assert_scalar(key)
      assert_match_value(where, c("BEFORE", "AFTER"))
      assert_scalar(pivot)
      assert_scalar(value)
      self$run(c("LINSERT", key, where, pivot, value))
    },
    LLEN=function(key) {
      assert_scalar(key)
      self$run(c("LLEN", key))
    },
    LPOP=function(key) {
      assert_scalar(key)
      self$run(c("LPOP", key))
    },
    LPUSH=function(key, value) {
      assert_scalar(key)
      self$run(c("LPUSH", key, value))
    },
    LPUSHX=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$run(c("LPUSHX", key, value))
    },
    LRANGE=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$run(c("LRANGE", key, start, stop))
    },
    LREM=function(key, count, value) {
      assert_scalar(key)
      assert_scalar(count)
      assert_scalar(value)
      self$run(c("LREM", key, count, value))
    },
    LSET=function(key, index, value) {
      assert_scalar(key)
      assert_scalar(index)
      assert_scalar(value)
      self$run(c("LSET", key, index, value))
    },
    LTRIM=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$run(c("LTRIM", key, start, stop))
    },
    MGET=function(key) {
      self$run(c("MGET", key))
    },
    MIGRATE=function(host, port, key, destination_db, timeout, copy=NULL, replace=NULL) {
      assert_scalar(host)
      assert_scalar(port)
      assert_scalar(key)
      assert_scalar(destination_db)
      assert_scalar(timeout)
      assert_match_value_or_null(copy, c("COPY"))
      assert_match_value_or_null(replace, c("REPLACE"))
      self$run(c("MIGRATE", host, port, key, destination_db, timeout, copy, replace))
    },
    MONITOR=function() {
      self$run(c("MONITOR"))
    },
    MOVE=function(key, db) {
      assert_scalar(key)
      assert_scalar(db)
      self$run(c("MOVE", key, db))
    },
    MSET=function(key, value) {
      key <- interleave(key, value)
      self$run(c("MSET", key))
    },
    MSETNX=function(key, value) {
      key <- interleave(key, value)
      self$run(c("MSETNX", key))
    },
    MULTI=function() {
      self$run(c("MULTI"))
    },
    OBJECT=function(subcommand, arguments=NULL) {
      assert_scalar(subcommand)
      self$run(c("OBJECT", subcommand, arguments))
    },
    PERSIST=function(key) {
      assert_scalar(key)
      self$run(c("PERSIST", key))
    },
    PEXPIRE=function(key, milliseconds) {
      assert_scalar(key)
      assert_scalar(milliseconds)
      self$run(c("PEXPIRE", key, milliseconds))
    },
    PEXPIREAT=function(key, milliseconds_timestamp) {
      assert_scalar(key)
      assert_scalar(milliseconds_timestamp)
      self$run(c("PEXPIREAT", key, milliseconds_timestamp))
    },
    PFADD=function(key, element) {
      assert_scalar(key)
      self$run(c("PFADD", key, element))
    },
    PFCOUNT=function(key) {
      self$run(c("PFCOUNT", key))
    },
    PFMERGE=function(destkey, sourcekey) {
      assert_scalar(destkey)
      self$run(c("PFMERGE", destkey, sourcekey))
    },
    PING=function() {
      self$run(c("PING"))
    },
    PSETEX=function(key, milliseconds, value) {
      assert_scalar(key)
      assert_scalar(milliseconds)
      assert_scalar(value)
      self$run(c("PSETEX", key, milliseconds, value))
    },
    PSUBSCRIBE=function(pattern) {
      self$run(c("PSUBSCRIBE", pattern))
    },
    PUBSUB=function(subcommand, argument=NULL) {
      assert_scalar(subcommand)
      self$run(c("PUBSUB", subcommand, argument))
    },
    PTTL=function(key) {
      assert_scalar(key)
      self$run(c("PTTL", key))
    },
    PUBLISH=function(channel, message) {
      assert_scalar(channel)
      assert_scalar(message)
      self$run(c("PUBLISH", channel, message))
    },
    PUNSUBSCRIBE=function(pattern=NULL) {
      self$run(c("PUNSUBSCRIBE", pattern))
    },
    QUIT=function() {
      self$run(c("QUIT"))
    },
    RANDOMKEY=function() {
      self$run(c("RANDOMKEY"))
    },
    RENAME=function(key, newkey) {
      assert_scalar(key)
      assert_scalar(newkey)
      self$run(c("RENAME", key, newkey))
    },
    RENAMENX=function(key, newkey) {
      assert_scalar(key)
      assert_scalar(newkey)
      self$run(c("RENAMENX", key, newkey))
    },
    RESTORE=function(key, ttl, serialized_value, replace=NULL) {
      assert_scalar(key)
      assert_scalar(ttl)
      assert_scalar(serialized_value)
      assert_match_value_or_null(replace, c("REPLACE"))
      self$run(c("RESTORE", key, ttl, serialized_value, replace))
    },
    ROLE=function() {
      self$run(c("ROLE"))
    },
    RPOP=function(key) {
      assert_scalar(key)
      self$run(c("RPOP", key))
    },
    RPOPLPUSH=function(source, destination) {
      assert_scalar(source)
      assert_scalar(destination)
      self$run(c("RPOPLPUSH", source, destination))
    },
    RPUSH=function(key, value) {
      assert_scalar(key)
      self$run(c("RPUSH", key, value))
    },
    RPUSHX=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$run(c("RPUSHX", key, value))
    },
    SADD=function(key, member) {
      assert_scalar(key)
      self$run(c("SADD", key, member))
    },
    SAVE=function() {
      self$run(c("SAVE"))
    },
    SCARD=function(key) {
      assert_scalar(key)
      self$run(c("SCARD", key))
    },
    SDIFF=function(key) {
      self$run(c("SDIFF", key))
    },
    SDIFFSTORE=function(destination, key) {
      assert_scalar(destination)
      self$run(c("SDIFFSTORE", destination, key))
    },
    SELECT=function(index) {
      assert_scalar(index)
      self$run(c("SELECT", index))
    },
    SET=function(key, value, EX=NULL, PX=NULL, condition=NULL) {
      assert_scalar(key)
      assert_scalar(value)
      assert_scalar_or_null(EX)
      assert_scalar_or_null(PX)
      assert_match_value_or_null(condition, c("NX", "XX"))
      self$run(c("SET", key, value, command("EX", EX, FALSE), command("PX", PX, FALSE), condition))
    },
    SETBIT=function(key, offset, value) {
      assert_scalar(key)
      assert_scalar(offset)
      assert_scalar(value)
      self$run(c("SETBIT", key, offset, value))
    },
    SETEX=function(key, seconds, value) {
      assert_scalar(key)
      assert_scalar(seconds)
      assert_scalar(value)
      self$run(c("SETEX", key, seconds, value))
    },
    SETNX=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$run(c("SETNX", key, value))
    },
    SETRANGE=function(key, offset, value) {
      assert_scalar(key)
      assert_scalar(offset)
      assert_scalar(value)
      self$run(c("SETRANGE", key, offset, value))
    },
    SHUTDOWN=function(NOSAVE=NULL, SAVE=NULL) {
      assert_match_value_or_null(NOSAVE, c("NOSAVE"))
      assert_match_value_or_null(SAVE, c("SAVE"))
      self$run(c("SHUTDOWN", NOSAVE, SAVE))
    },
    SINTER=function(key) {
      self$run(c("SINTER", key))
    },
    SINTERSTORE=function(destination, key) {
      assert_scalar(destination)
      self$run(c("SINTERSTORE", destination, key))
    },
    SISMEMBER=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$run(c("SISMEMBER", key, member))
    },
    SLAVEOF=function(host, port) {
      assert_scalar(host)
      assert_scalar(port)
      self$run(c("SLAVEOF", host, port))
    },
    SLOWLOG=function(subcommand, argument=NULL) {
      assert_scalar(subcommand)
      assert_scalar_or_null(argument)
      self$run(c("SLOWLOG", subcommand, argument))
    },
    SMEMBERS=function(key) {
      assert_scalar(key)
      self$run(c("SMEMBERS", key))
    },
    SMOVE=function(source, destination, member) {
      assert_scalar(source)
      assert_scalar(destination)
      assert_scalar(member)
      self$run(c("SMOVE", source, destination, member))
    },
    SORT=function(key, BY=NULL, LIMIT=NULL, GET=NULL, order=NULL, sorting=NULL, STORE=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(BY)
      assert_length_or_null(LIMIT, 2L)
      assert_match_value_or_null(order, c("ASC", "DESC"))
      assert_match_value_or_null(sorting, c("ALPHA"))
      assert_scalar_or_null(STORE)
      self$run(c("SORT", key, command("BY", BY, FALSE), command("LIMIT", LIMIT, TRUE), command("GET", GET, FALSE), order, sorting, command("STORE", STORE, FALSE)))
    },
    SPOP=function(key, count=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(count)
      self$run(c("SPOP", key, count))
    },
    SRANDMEMBER=function(key, count=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(count)
      self$run(c("SRANDMEMBER", key, count))
    },
    SREM=function(key, member) {
      assert_scalar(key)
      self$run(c("SREM", key, member))
    },
    STRLEN=function(key) {
      assert_scalar(key)
      self$run(c("STRLEN", key))
    },
    SUBSCRIBE=function(channel) {
      self$run(c("SUBSCRIBE", channel))
    },
    SUNION=function(key) {
      self$run(c("SUNION", key))
    },
    SUNIONSTORE=function(destination, key) {
      assert_scalar(destination)
      self$run(c("SUNIONSTORE", destination, key))
    },
    SYNC=function() {
      self$run(c("SYNC"))
    },
    TIME=function() {
      self$run(c("TIME"))
    },
    TTL=function(key) {
      assert_scalar(key)
      self$run(c("TTL", key))
    },
    TYPE=function(key) {
      assert_scalar(key)
      self$run(c("TYPE", key))
    },
    UNSUBSCRIBE=function(channel=NULL) {
      self$run(c("UNSUBSCRIBE", channel))
    },
    UNWATCH=function() {
      self$run(c("UNWATCH"))
    },
    WATCH=function(key) {
      self$run(c("WATCH", key))
    },
    ZADD=function(key, score, member) {
      assert_scalar(key)
      score <- interleave(score, member)
      self$run(c("ZADD", key, score))
    },
    ZCARD=function(key) {
      assert_scalar(key)
      self$run(c("ZCARD", key))
    },
    ZCOUNT=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$run(c("ZCOUNT", key, min, max))
    },
    ZINCRBY=function(key, increment, member) {
      assert_scalar(key)
      assert_scalar(increment)
      assert_scalar(member)
      self$run(c("ZINCRBY", key, increment, member))
    },
    ZINTERSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
      assert_scalar(destination)
      assert_scalar(numkeys)
      assert_scalar_or_null(WEIGHTS)
      assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
      self$run(c("ZINTERSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE)))
    },
    ZLEXCOUNT=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$run(c("ZLEXCOUNT", key, min, max))
    },
    ZRANGE=function(key, start, stop, withscores=NULL) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      self$run(c("ZRANGE", key, start, stop, withscores))
    },
    ZRANGEBYLEX=function(key, min, max, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      assert_length_or_null(LIMIT, 2L)
      self$run(c("ZRANGEBYLEX", key, min, max, command("LIMIT", LIMIT, TRUE)))
    },
    ZREVRANGEBYLEX=function(key, max, min, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(max)
      assert_scalar(min)
      assert_length_or_null(LIMIT, 2L)
      self$run(c("ZREVRANGEBYLEX", key, max, min, command("LIMIT", LIMIT, TRUE)))
    },
    ZRANGEBYSCORE=function(key, min, max, withscores=NULL, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      assert_length_or_null(LIMIT, 2L)
      self$run(c("ZRANGEBYSCORE", key, min, max, withscores, command("LIMIT", LIMIT, TRUE)))
    },
    ZRANK=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$run(c("ZRANK", key, member))
    },
    ZREM=function(key, member) {
      assert_scalar(key)
      self$run(c("ZREM", key, member))
    },
    ZREMRANGEBYLEX=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$run(c("ZREMRANGEBYLEX", key, min, max))
    },
    ZREMRANGEBYRANK=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$run(c("ZREMRANGEBYRANK", key, start, stop))
    },
    ZREMRANGEBYSCORE=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$run(c("ZREMRANGEBYSCORE", key, min, max))
    },
    ZREVRANGE=function(key, start, stop, withscores=NULL) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      self$run(c("ZREVRANGE", key, start, stop, withscores))
    },
    ZREVRANGEBYSCORE=function(key, max, min, withscores=NULL, LIMIT=NULL) {
      assert_scalar(key)
      assert_scalar(max)
      assert_scalar(min)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      assert_length_or_null(LIMIT, 2L)
      self$run(c("ZREVRANGEBYSCORE", key, max, min, withscores, command("LIMIT", LIMIT, TRUE)))
    },
    ZREVRANK=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$run(c("ZREVRANK", key, member))
    },
    ZSCORE=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$run(c("ZSCORE", key, member))
    },
    ZUNIONSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
      assert_scalar(destination)
      assert_scalar(numkeys)
      assert_scalar_or_null(WEIGHTS)
      assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
      self$run(c("ZUNIONSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE)))
    },
    SCAN=function(cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$run(c("SCAN", cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    SSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$run(c("SSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    HSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$run(c("HSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    ZSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar(key)
      assert_scalar(cursor)
      assert_scalar_or_null(MATCH)
      assert_scalar_or_null(COUNT)
      self$run(c("ZSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    }
    ))
