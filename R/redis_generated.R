## Automatically generated: do not edit by hand
redis_api_generator <- R6::R6Class(
  "redis_api",
  public=list(
    config=NULL,
    type=NULL,
    reconnect=NULL,
    ## Driver functions
    .command=NULL,
    .pipeline=NULL,
    .subscribe=NULL,

    initialize=function(obj) {
      self$config     <- hiredis_function(obj$config)
      self$reconnect  <- hiredis_function(obj$reconnect)
      self$.command   <- hiredis_function(obj$command, TRUE)
      self$.pipeline  <- hiredis_function(obj$pipeline)
      self$.subscribe <- hiredis_function(obj$subscribe)
      self$type       <- function() attr(obj, "type", exact=TRUE)
    },

    pipeline=function(..., .commands=list(...)) {
      ret <- self$.pipeline(.commands)
      if (!is.null(names(.commands))) {
        names(ret) <- names(.commands)
      }
      ret
    },

    subscribe=function(channel, transform=NULL, terminate=NULL,
                       collect=TRUE, n=Inf, pattern=FALSE,
                       envir=parent.frame()) {
      assert_scalar_logical(pattern)
      collector <- make_collector(collect)
      callback <- make_callback(transform, terminate, collector$add, n)
      self$.subscribe(channel, pattern, callback, envir)
      collector$get()
    },
    ## generated methods:
    APPEND=function(key, value) {
      assert_scalar2(key)
      assert_scalar2(value)
      self$.command(list("APPEND", key, value))
    },
    AUTH=function(password) {
      assert_scalar2(password)
      self$.command(list("AUTH", password))
    },
    BGREWRITEAOF=function() {
      self$.command(list("BGREWRITEAOF"))
    },
    BGSAVE=function() {
      self$.command(list("BGSAVE"))
    },
    BITCOUNT=function(key, start=NULL, end=NULL) {
      assert_scalar2(key)
      assert_scalar_or_null2(start)
      assert_scalar_or_null2(end)
      self$.command(list("BITCOUNT", key, start, end))
    },
    BITOP=function(operation, destkey, key) {
      assert_scalar2(operation)
      assert_scalar2(destkey)
      self$.command(list("BITOP", operation, destkey, key))
    },
    BITPOS=function(key, bit, start=NULL, end=NULL) {
      assert_scalar2(key)
      assert_scalar2(bit)
      assert_scalar_or_null2(start)
      assert_scalar_or_null2(end)
      self$.command(list("BITPOS", key, bit, start, end))
    },
    BLPOP=function(key, timeout) {
      assert_scalar2(timeout)
      self$.command(list("BLPOP", key, timeout))
    },
    BRPOP=function(key, timeout) {
      assert_scalar2(timeout)
      self$.command(list("BRPOP", key, timeout))
    },
    BRPOPLPUSH=function(source, destination, timeout) {
      assert_scalar2(source)
      assert_scalar2(destination)
      assert_scalar2(timeout)
      self$.command(list("BRPOPLPUSH", source, destination, timeout))
    },
    CLIENT_KILL=function(ip_port=NULL, ID=NULL, TYPE=NULL, ADDR=NULL, SKIPME=NULL) {
      assert_scalar_or_null2(ip_port)
      assert_scalar_or_null2(ID)
      assert_match_value_or_null(TYPE, c("normal", "slave", "pubsub"))
      assert_scalar_or_null2(ADDR)
      assert_scalar_or_null2(SKIPME)
      self$.command(list("CLIENT", "KILL", ip_port, command("ID", ID, FALSE), command("TYPE", TYPE, FALSE), command("ADDR", ADDR, FALSE), command("SKIPME", SKIPME, FALSE)))
    },
    CLIENT_LIST=function() {
      self$.command(list("CLIENT", "LIST"))
    },
    CLIENT_GETNAME=function() {
      self$.command(list("CLIENT", "GETNAME"))
    },
    CLIENT_PAUSE=function(timeout) {
      assert_scalar2(timeout)
      self$.command(list("CLIENT", "PAUSE", timeout))
    },
    CLIENT_SETNAME=function(connection_name) {
      assert_scalar2(connection_name)
      self$.command(list("CLIENT", "SETNAME", connection_name))
    },
    CLUSTER_ADDSLOTS=function(slot) {
      self$.command(list("CLUSTER", "ADDSLOTS", slot))
    },
    CLUSTER_COUNT_FAILURE_REPORTS=function(node_id) {
      assert_scalar2(node_id)
      self$.command(list("CLUSTER", "COUNT-FAILURE-REPORTS", node_id))
    },
    CLUSTER_COUNTKEYSINSLOT=function(slot) {
      assert_scalar2(slot)
      self$.command(list("CLUSTER", "COUNTKEYSINSLOT", slot))
    },
    CLUSTER_DELSLOTS=function(slot) {
      self$.command(list("CLUSTER", "DELSLOTS", slot))
    },
    CLUSTER_FAILOVER=function(options=NULL) {
      assert_match_value_or_null(options, c("FORCE", "TAKEOVER"))
      self$.command(list("CLUSTER", "FAILOVER", options))
    },
    CLUSTER_FORGET=function(node_id) {
      assert_scalar2(node_id)
      self$.command(list("CLUSTER", "FORGET", node_id))
    },
    CLUSTER_GETKEYSINSLOT=function(slot, count) {
      assert_scalar2(slot)
      assert_scalar2(count)
      self$.command(list("CLUSTER", "GETKEYSINSLOT", slot, count))
    },
    CLUSTER_INFO=function() {
      self$.command(list("CLUSTER", "INFO"))
    },
    CLUSTER_KEYSLOT=function(key) {
      assert_scalar2(key)
      self$.command(list("CLUSTER", "KEYSLOT", key))
    },
    CLUSTER_MEET=function(ip, port) {
      assert_scalar2(ip)
      assert_scalar2(port)
      self$.command(list("CLUSTER", "MEET", ip, port))
    },
    CLUSTER_NODES=function() {
      self$.command(list("CLUSTER", "NODES"))
    },
    CLUSTER_REPLICATE=function(node_id) {
      assert_scalar2(node_id)
      self$.command(list("CLUSTER", "REPLICATE", node_id))
    },
    CLUSTER_RESET=function(reset_type=NULL) {
      assert_match_value_or_null(reset_type, c("HARD", "SOFT"))
      self$.command(list("CLUSTER", "RESET", reset_type))
    },
    CLUSTER_SAVECONFIG=function() {
      self$.command(list("CLUSTER", "SAVECONFIG"))
    },
    CLUSTER_SET_CONFIG_EPOCH=function(config_epoch) {
      assert_scalar2(config_epoch)
      self$.command(list("CLUSTER", "SET-CONFIG-EPOCH", config_epoch))
    },
    CLUSTER_SETSLOT=function(slot, subcommand, node_id=NULL) {
      assert_scalar2(slot)
      assert_match_value(subcommand, c("IMPORTING", "MIGRATING", "STABLE", "NODE"))
      assert_scalar_or_null2(node_id)
      self$.command(list("CLUSTER", "SETSLOT", slot, subcommand, node_id))
    },
    CLUSTER_SLAVES=function(node_id) {
      assert_scalar2(node_id)
      self$.command(list("CLUSTER", "SLAVES", node_id))
    },
    CLUSTER_SLOTS=function() {
      self$.command(list("CLUSTER", "SLOTS"))
    },
    COMMAND=function() {
      self$.command(list("COMMAND"))
    },
    COMMAND_COUNT=function() {
      self$.command(list("COMMAND", "COUNT"))
    },
    COMMAND_GETKEYS=function() {
      self$.command(list("COMMAND", "GETKEYS"))
    },
    COMMAND_INFO=function(command_name) {
      self$.command(list("COMMAND", "INFO", command_name))
    },
    CONFIG_GET=function(parameter) {
      assert_scalar2(parameter)
      self$.command(list("CONFIG", "GET", parameter))
    },
    CONFIG_REWRITE=function() {
      self$.command(list("CONFIG", "REWRITE"))
    },
    CONFIG_SET=function(parameter, value) {
      assert_scalar2(parameter)
      assert_scalar2(value)
      self$.command(list("CONFIG", "SET", parameter, value))
    },
    CONFIG_RESETSTAT=function() {
      self$.command(list("CONFIG", "RESETSTAT"))
    },
    DBSIZE=function() {
      self$.command(list("DBSIZE"))
    },
    DEBUG_OBJECT=function(key) {
      assert_scalar2(key)
      self$.command(list("DEBUG", "OBJECT", key))
    },
    DEBUG_SEGFAULT=function() {
      self$.command(list("DEBUG", "SEGFAULT"))
    },
    DECR=function(key) {
      assert_scalar2(key)
      self$.command(list("DECR", key))
    },
    DECRBY=function(key, decrement) {
      assert_scalar2(key)
      assert_scalar2(decrement)
      self$.command(list("DECRBY", key, decrement))
    },
    DEL=function(key) {
      self$.command(list("DEL", key))
    },
    DISCARD=function() {
      self$.command(list("DISCARD"))
    },
    DUMP=function(key) {
      assert_scalar2(key)
      self$.command(list("DUMP", key))
    },
    ECHO=function(message) {
      assert_scalar2(message)
      self$.command(list("ECHO", message))
    },
    EVAL=function(script, numkeys, key, arg) {
      assert_scalar2(script)
      assert_scalar2(numkeys)
      self$.command(list("EVAL", script, numkeys, key, arg))
    },
    EVALSHA=function(sha1, numkeys, key, arg) {
      assert_scalar2(sha1)
      assert_scalar2(numkeys)
      self$.command(list("EVALSHA", sha1, numkeys, key, arg))
    },
    EXEC=function() {
      self$.command(list("EXEC"))
    },
    EXISTS=function(key) {
      self$.command(list("EXISTS", key))
    },
    EXPIRE=function(key, seconds) {
      assert_scalar2(key)
      assert_scalar2(seconds)
      self$.command(list("EXPIRE", key, seconds))
    },
    EXPIREAT=function(key, timestamp) {
      assert_scalar2(key)
      assert_scalar2(timestamp)
      self$.command(list("EXPIREAT", key, timestamp))
    },
    FLUSHALL=function() {
      self$.command(list("FLUSHALL"))
    },
    FLUSHDB=function() {
      self$.command(list("FLUSHDB"))
    },
    GEOADD=function(key, longitude, latitude, member) {
      assert_scalar2(key)
      longitude <- interleave(longitude, latitude)
      longitude <- interleave(longitude, member)
      self$.command(list("GEOADD", key, longitude))
    },
    GEOHASH=function(key, member) {
      assert_scalar2(key)
      self$.command(list("GEOHASH", key, member))
    },
    GEOPOS=function(key, member) {
      assert_scalar2(key)
      self$.command(list("GEOPOS", key, member))
    },
    GEODIST=function(key, member1, member2, unit=NULL) {
      assert_scalar2(key)
      assert_scalar2(member1)
      assert_scalar2(member2)
      assert_scalar_or_null2(unit)
      self$.command(list("GEODIST", key, member1, member2, unit))
    },
    GEORADIUS=function(key, longitude, latitude, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
      assert_scalar2(key)
      assert_scalar2(longitude)
      assert_scalar2(latitude)
      assert_scalar2(radius)
      assert_match_value(unit, c("m", "km", "ft", "mi"))
      assert_match_value_or_null(withcoord, c("WITHCOORD"))
      assert_match_value_or_null(withdist, c("WITHDIST"))
      assert_match_value_or_null(withhash, c("WITHHASH"))
      assert_scalar_or_null2(COUNT)
      self$.command(list("GEORADIUS", key, longitude, latitude, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE)))
    },
    GEORADIUSBYMEMBER=function(key, member, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
      assert_scalar2(key)
      assert_scalar2(member)
      assert_scalar2(radius)
      assert_match_value(unit, c("m", "km", "ft", "mi"))
      assert_match_value_or_null(withcoord, c("WITHCOORD"))
      assert_match_value_or_null(withdist, c("WITHDIST"))
      assert_match_value_or_null(withhash, c("WITHHASH"))
      assert_scalar_or_null2(COUNT)
      self$.command(list("GEORADIUSBYMEMBER", key, member, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE)))
    },
    GET=function(key) {
      assert_scalar2(key)
      self$.command(list("GET", key))
    },
    GETBIT=function(key, offset) {
      assert_scalar2(key)
      assert_scalar2(offset)
      self$.command(list("GETBIT", key, offset))
    },
    GETRANGE=function(key, start, end) {
      assert_scalar2(key)
      assert_scalar2(start)
      assert_scalar2(end)
      self$.command(list("GETRANGE", key, start, end))
    },
    GETSET=function(key, value) {
      assert_scalar2(key)
      assert_scalar2(value)
      self$.command(list("GETSET", key, value))
    },
    HDEL=function(key, field) {
      assert_scalar2(key)
      self$.command(list("HDEL", key, field))
    },
    HEXISTS=function(key, field) {
      assert_scalar2(key)
      assert_scalar2(field)
      self$.command(list("HEXISTS", key, field))
    },
    HGET=function(key, field) {
      assert_scalar2(key)
      assert_scalar2(field)
      self$.command(list("HGET", key, field))
    },
    HGETALL=function(key) {
      assert_scalar2(key)
      self$.command(list("HGETALL", key))
    },
    HINCRBY=function(key, field, increment) {
      assert_scalar2(key)
      assert_scalar2(field)
      assert_scalar2(increment)
      self$.command(list("HINCRBY", key, field, increment))
    },
    HINCRBYFLOAT=function(key, field, increment) {
      assert_scalar2(key)
      assert_scalar2(field)
      assert_scalar2(increment)
      self$.command(list("HINCRBYFLOAT", key, field, increment))
    },
    HKEYS=function(key) {
      assert_scalar2(key)
      self$.command(list("HKEYS", key))
    },
    HLEN=function(key) {
      assert_scalar2(key)
      self$.command(list("HLEN", key))
    },
    HMGET=function(key, field) {
      assert_scalar2(key)
      self$.command(list("HMGET", key, field))
    },
    HMSET=function(key, field, value) {
      assert_scalar2(key)
      field <- interleave(field, value)
      self$.command(list("HMSET", key, field))
    },
    HSET=function(key, field, value) {
      assert_scalar2(key)
      assert_scalar2(field)
      assert_scalar2(value)
      self$.command(list("HSET", key, field, value))
    },
    HSETNX=function(key, field, value) {
      assert_scalar2(key)
      assert_scalar2(field)
      assert_scalar2(value)
      self$.command(list("HSETNX", key, field, value))
    },
    HSTRLEN=function(key, field) {
      assert_scalar2(key)
      assert_scalar2(field)
      self$.command(list("HSTRLEN", key, field))
    },
    HVALS=function(key) {
      assert_scalar2(key)
      self$.command(list("HVALS", key))
    },
    INCR=function(key) {
      assert_scalar2(key)
      self$.command(list("INCR", key))
    },
    INCRBY=function(key, increment) {
      assert_scalar2(key)
      assert_scalar2(increment)
      self$.command(list("INCRBY", key, increment))
    },
    INCRBYFLOAT=function(key, increment) {
      assert_scalar2(key)
      assert_scalar2(increment)
      self$.command(list("INCRBYFLOAT", key, increment))
    },
    INFO=function(section=NULL) {
      assert_scalar_or_null2(section)
      self$.command(list("INFO", section))
    },
    KEYS=function(pattern) {
      assert_scalar2(pattern)
      self$.command(list("KEYS", pattern))
    },
    LASTSAVE=function() {
      self$.command(list("LASTSAVE"))
    },
    LINDEX=function(key, index) {
      assert_scalar2(key)
      assert_scalar2(index)
      self$.command(list("LINDEX", key, index))
    },
    LINSERT=function(key, where, pivot, value) {
      assert_scalar2(key)
      assert_match_value(where, c("BEFORE", "AFTER"))
      assert_scalar2(pivot)
      assert_scalar2(value)
      self$.command(list("LINSERT", key, where, pivot, value))
    },
    LLEN=function(key) {
      assert_scalar2(key)
      self$.command(list("LLEN", key))
    },
    LPOP=function(key) {
      assert_scalar2(key)
      self$.command(list("LPOP", key))
    },
    LPUSH=function(key, value) {
      assert_scalar2(key)
      self$.command(list("LPUSH", key, value))
    },
    LPUSHX=function(key, value) {
      assert_scalar2(key)
      assert_scalar2(value)
      self$.command(list("LPUSHX", key, value))
    },
    LRANGE=function(key, start, stop) {
      assert_scalar2(key)
      assert_scalar2(start)
      assert_scalar2(stop)
      self$.command(list("LRANGE", key, start, stop))
    },
    LREM=function(key, count, value) {
      assert_scalar2(key)
      assert_scalar2(count)
      assert_scalar2(value)
      self$.command(list("LREM", key, count, value))
    },
    LSET=function(key, index, value) {
      assert_scalar2(key)
      assert_scalar2(index)
      assert_scalar2(value)
      self$.command(list("LSET", key, index, value))
    },
    LTRIM=function(key, start, stop) {
      assert_scalar2(key)
      assert_scalar2(start)
      assert_scalar2(stop)
      self$.command(list("LTRIM", key, start, stop))
    },
    MGET=function(key) {
      self$.command(list("MGET", key))
    },
    MIGRATE=function(host, port, key, destination_db, timeout, copy=NULL, replace=NULL) {
      assert_scalar2(host)
      assert_scalar2(port)
      assert_scalar2(key)
      assert_scalar2(destination_db)
      assert_scalar2(timeout)
      assert_match_value_or_null(copy, c("COPY"))
      assert_match_value_or_null(replace, c("REPLACE"))
      self$.command(list("MIGRATE", host, port, key, destination_db, timeout, copy, replace))
    },
    MONITOR=function() {
      self$.command(list("MONITOR"))
    },
    MOVE=function(key, db) {
      assert_scalar2(key)
      assert_scalar2(db)
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
      assert_scalar2(subcommand)
      self$.command(list("OBJECT", subcommand, arguments))
    },
    PERSIST=function(key) {
      assert_scalar2(key)
      self$.command(list("PERSIST", key))
    },
    PEXPIRE=function(key, milliseconds) {
      assert_scalar2(key)
      assert_scalar2(milliseconds)
      self$.command(list("PEXPIRE", key, milliseconds))
    },
    PEXPIREAT=function(key, milliseconds_timestamp) {
      assert_scalar2(key)
      assert_scalar2(milliseconds_timestamp)
      self$.command(list("PEXPIREAT", key, milliseconds_timestamp))
    },
    PFADD=function(key, element) {
      assert_scalar2(key)
      self$.command(list("PFADD", key, element))
    },
    PFCOUNT=function(key) {
      self$.command(list("PFCOUNT", key))
    },
    PFMERGE=function(destkey, sourcekey) {
      assert_scalar2(destkey)
      self$.command(list("PFMERGE", destkey, sourcekey))
    },
    PING=function() {
      self$.command(list("PING"))
    },
    PSETEX=function(key, milliseconds, value) {
      assert_scalar2(key)
      assert_scalar2(milliseconds)
      assert_scalar2(value)
      self$.command(list("PSETEX", key, milliseconds, value))
    },
    PSUBSCRIBE=function(pattern) {
      self$.command(list("PSUBSCRIBE", pattern))
    },
    PUBSUB=function(subcommand, argument=NULL) {
      assert_scalar2(subcommand)
      self$.command(list("PUBSUB", subcommand, argument))
    },
    PTTL=function(key) {
      assert_scalar2(key)
      self$.command(list("PTTL", key))
    },
    PUBLISH=function(channel, message) {
      assert_scalar2(channel)
      assert_scalar2(message)
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
      assert_scalar2(key)
      assert_scalar2(newkey)
      self$.command(list("RENAME", key, newkey))
    },
    RENAMENX=function(key, newkey) {
      assert_scalar2(key)
      assert_scalar2(newkey)
      self$.command(list("RENAMENX", key, newkey))
    },
    RESTORE=function(key, ttl, serialized_value, replace=NULL) {
      assert_scalar2(key)
      assert_scalar2(ttl)
      assert_scalar2(serialized_value)
      assert_match_value_or_null(replace, c("REPLACE"))
      self$.command(list("RESTORE", key, ttl, serialized_value, replace))
    },
    ROLE=function() {
      self$.command(list("ROLE"))
    },
    RPOP=function(key) {
      assert_scalar2(key)
      self$.command(list("RPOP", key))
    },
    RPOPLPUSH=function(source, destination) {
      assert_scalar2(source)
      assert_scalar2(destination)
      self$.command(list("RPOPLPUSH", source, destination))
    },
    RPUSH=function(key, value) {
      assert_scalar2(key)
      self$.command(list("RPUSH", key, value))
    },
    RPUSHX=function(key, value) {
      assert_scalar2(key)
      assert_scalar2(value)
      self$.command(list("RPUSHX", key, value))
    },
    SADD=function(key, member) {
      assert_scalar2(key)
      self$.command(list("SADD", key, member))
    },
    SAVE=function() {
      self$.command(list("SAVE"))
    },
    SCARD=function(key) {
      assert_scalar2(key)
      self$.command(list("SCARD", key))
    },
    SCRIPT_EXISTS=function(script) {
      self$.command(list("SCRIPT", "EXISTS", script))
    },
    SCRIPT_FLUSH=function() {
      self$.command(list("SCRIPT", "FLUSH"))
    },
    SCRIPT_KILL=function() {
      self$.command(list("SCRIPT", "KILL"))
    },
    SCRIPT_LOAD=function(script) {
      assert_scalar2(script)
      self$.command(list("SCRIPT", "LOAD", script))
    },
    SDIFF=function(key) {
      self$.command(list("SDIFF", key))
    },
    SDIFFSTORE=function(destination, key) {
      assert_scalar2(destination)
      self$.command(list("SDIFFSTORE", destination, key))
    },
    SELECT=function(index) {
      assert_scalar2(index)
      self$.command(list("SELECT", index))
    },
    SET=function(key, value, EX=NULL, PX=NULL, condition=NULL) {
      assert_scalar2(key)
      assert_scalar2(value)
      assert_scalar_or_null2(EX)
      assert_scalar_or_null2(PX)
      assert_match_value_or_null(condition, c("NX", "XX"))
      self$.command(list("SET", key, value, command("EX", EX, FALSE), command("PX", PX, FALSE), condition))
    },
    SETBIT=function(key, offset, value) {
      assert_scalar2(key)
      assert_scalar2(offset)
      assert_scalar2(value)
      self$.command(list("SETBIT", key, offset, value))
    },
    SETEX=function(key, seconds, value) {
      assert_scalar2(key)
      assert_scalar2(seconds)
      assert_scalar2(value)
      self$.command(list("SETEX", key, seconds, value))
    },
    SETNX=function(key, value) {
      assert_scalar2(key)
      assert_scalar2(value)
      self$.command(list("SETNX", key, value))
    },
    SETRANGE=function(key, offset, value) {
      assert_scalar2(key)
      assert_scalar2(offset)
      assert_scalar2(value)
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
      assert_scalar2(destination)
      self$.command(list("SINTERSTORE", destination, key))
    },
    SISMEMBER=function(key, member) {
      assert_scalar2(key)
      assert_scalar2(member)
      self$.command(list("SISMEMBER", key, member))
    },
    SLAVEOF=function(host, port) {
      assert_scalar2(host)
      assert_scalar2(port)
      self$.command(list("SLAVEOF", host, port))
    },
    SLOWLOG=function(subcommand, argument=NULL) {
      assert_scalar2(subcommand)
      assert_scalar_or_null2(argument)
      self$.command(list("SLOWLOG", subcommand, argument))
    },
    SMEMBERS=function(key) {
      assert_scalar2(key)
      self$.command(list("SMEMBERS", key))
    },
    SMOVE=function(source, destination, member) {
      assert_scalar2(source)
      assert_scalar2(destination)
      assert_scalar2(member)
      self$.command(list("SMOVE", source, destination, member))
    },
    SORT=function(key, BY=NULL, LIMIT=NULL, GET=NULL, order=NULL, sorting=NULL, STORE=NULL) {
      assert_scalar2(key)
      assert_scalar_or_null2(BY)
      assert_length_or_null(LIMIT, 2L)
      assert_match_value_or_null(order, c("ASC", "DESC"))
      assert_match_value_or_null(sorting, c("ALPHA"))
      assert_scalar_or_null2(STORE)
      self$.command(list("SORT", key, command("BY", BY, FALSE), command("LIMIT", LIMIT, TRUE), command("GET", GET, FALSE), order, sorting, command("STORE", STORE, FALSE)))
    },
    SPOP=function(key, count=NULL) {
      assert_scalar2(key)
      assert_scalar_or_null2(count)
      self$.command(list("SPOP", key, count))
    },
    SRANDMEMBER=function(key, count=NULL) {
      assert_scalar2(key)
      assert_scalar_or_null2(count)
      self$.command(list("SRANDMEMBER", key, count))
    },
    SREM=function(key, member) {
      assert_scalar2(key)
      self$.command(list("SREM", key, member))
    },
    STRLEN=function(key) {
      assert_scalar2(key)
      self$.command(list("STRLEN", key))
    },
    SUBSCRIBE=function(channel) {
      self$.command(list("SUBSCRIBE", channel))
    },
    SUNION=function(key) {
      self$.command(list("SUNION", key))
    },
    SUNIONSTORE=function(destination, key) {
      assert_scalar2(destination)
      self$.command(list("SUNIONSTORE", destination, key))
    },
    SYNC=function() {
      self$.command(list("SYNC"))
    },
    TIME=function() {
      self$.command(list("TIME"))
    },
    TTL=function(key) {
      assert_scalar2(key)
      self$.command(list("TTL", key))
    },
    TYPE=function(key) {
      assert_scalar2(key)
      self$.command(list("TYPE", key))
    },
    UNSUBSCRIBE=function(channel=NULL) {
      self$.command(list("UNSUBSCRIBE", channel))
    },
    UNWATCH=function() {
      self$.command(list("UNWATCH"))
    },
    WAIT=function(numslaves, timeout) {
      assert_scalar2(numslaves)
      assert_scalar2(timeout)
      self$.command(list("WAIT", numslaves, timeout))
    },
    WATCH=function(key) {
      self$.command(list("WATCH", key))
    },
    ZADD=function(key, condition=NULL, change=NULL, increment=NULL, score, member) {
      assert_scalar2(key)
      assert_match_value_or_null(condition, c("NX", "XX"))
      assert_match_value_or_null(change, c("CH"))
      assert_match_value_or_null(increment, c("INCR"))
      score <- interleave(score, member)
      self$.command(list("ZADD", key, condition, change, increment, score))
    },
    ZCARD=function(key) {
      assert_scalar2(key)
      self$.command(list("ZCARD", key))
    },
    ZCOUNT=function(key, min, max) {
      assert_scalar2(key)
      assert_scalar2(min)
      assert_scalar2(max)
      self$.command(list("ZCOUNT", key, min, max))
    },
    ZINCRBY=function(key, increment, member) {
      assert_scalar2(key)
      assert_scalar2(increment)
      assert_scalar2(member)
      self$.command(list("ZINCRBY", key, increment, member))
    },
    ZINTERSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
      assert_scalar2(destination)
      assert_scalar2(numkeys)
      assert_scalar_or_null2(WEIGHTS)
      assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
      self$.command(list("ZINTERSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE)))
    },
    ZLEXCOUNT=function(key, min, max) {
      assert_scalar2(key)
      assert_scalar2(min)
      assert_scalar2(max)
      self$.command(list("ZLEXCOUNT", key, min, max))
    },
    ZRANGE=function(key, start, stop, withscores=NULL) {
      assert_scalar2(key)
      assert_scalar2(start)
      assert_scalar2(stop)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      self$.command(list("ZRANGE", key, start, stop, withscores))
    },
    ZRANGEBYLEX=function(key, min, max, LIMIT=NULL) {
      assert_scalar2(key)
      assert_scalar2(min)
      assert_scalar2(max)
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZRANGEBYLEX", key, min, max, command("LIMIT", LIMIT, TRUE)))
    },
    ZREVRANGEBYLEX=function(key, max, min, LIMIT=NULL) {
      assert_scalar2(key)
      assert_scalar2(max)
      assert_scalar2(min)
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZREVRANGEBYLEX", key, max, min, command("LIMIT", LIMIT, TRUE)))
    },
    ZRANGEBYSCORE=function(key, min, max, withscores=NULL, LIMIT=NULL) {
      assert_scalar2(key)
      assert_scalar2(min)
      assert_scalar2(max)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZRANGEBYSCORE", key, min, max, withscores, command("LIMIT", LIMIT, TRUE)))
    },
    ZRANK=function(key, member) {
      assert_scalar2(key)
      assert_scalar2(member)
      self$.command(list("ZRANK", key, member))
    },
    ZREM=function(key, member) {
      assert_scalar2(key)
      self$.command(list("ZREM", key, member))
    },
    ZREMRANGEBYLEX=function(key, min, max) {
      assert_scalar2(key)
      assert_scalar2(min)
      assert_scalar2(max)
      self$.command(list("ZREMRANGEBYLEX", key, min, max))
    },
    ZREMRANGEBYRANK=function(key, start, stop) {
      assert_scalar2(key)
      assert_scalar2(start)
      assert_scalar2(stop)
      self$.command(list("ZREMRANGEBYRANK", key, start, stop))
    },
    ZREMRANGEBYSCORE=function(key, min, max) {
      assert_scalar2(key)
      assert_scalar2(min)
      assert_scalar2(max)
      self$.command(list("ZREMRANGEBYSCORE", key, min, max))
    },
    ZREVRANGE=function(key, start, stop, withscores=NULL) {
      assert_scalar2(key)
      assert_scalar2(start)
      assert_scalar2(stop)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      self$.command(list("ZREVRANGE", key, start, stop, withscores))
    },
    ZREVRANGEBYSCORE=function(key, max, min, withscores=NULL, LIMIT=NULL) {
      assert_scalar2(key)
      assert_scalar2(max)
      assert_scalar2(min)
      assert_match_value_or_null(withscores, c("WITHSCORES"))
      assert_length_or_null(LIMIT, 2L)
      self$.command(list("ZREVRANGEBYSCORE", key, max, min, withscores, command("LIMIT", LIMIT, TRUE)))
    },
    ZREVRANK=function(key, member) {
      assert_scalar2(key)
      assert_scalar2(member)
      self$.command(list("ZREVRANK", key, member))
    },
    ZSCORE=function(key, member) {
      assert_scalar2(key)
      assert_scalar2(member)
      self$.command(list("ZSCORE", key, member))
    },
    ZUNIONSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
      assert_scalar2(destination)
      assert_scalar2(numkeys)
      assert_scalar_or_null2(WEIGHTS)
      assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
      self$.command(list("ZUNIONSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE)))
    },
    SCAN=function(cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar2(cursor)
      assert_scalar_or_null2(MATCH)
      assert_scalar_or_null2(COUNT)
      self$.command(list("SCAN", cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    SSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar2(key)
      assert_scalar2(cursor)
      assert_scalar_or_null2(MATCH)
      assert_scalar_or_null2(COUNT)
      self$.command(list("SSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    HSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar2(key)
      assert_scalar2(cursor)
      assert_scalar_or_null2(MATCH)
      assert_scalar_or_null2(COUNT)
      self$.command(list("HSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    },
    ZSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
      assert_scalar2(key)
      assert_scalar2(cursor)
      assert_scalar_or_null2(MATCH)
      assert_scalar_or_null2(COUNT)
      self$.command(list("ZSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE)))
    }
    ))
redis <- list2env(hash=TRUE, list(
  APPEND=function(key, value) {
    assert_scalar2(key)
    assert_scalar2(value)
    list("APPEND", key, value)
  },
  AUTH=function(password) {
    assert_scalar2(password)
    list("AUTH", password)
  },
  BGREWRITEAOF=function() {
    list("BGREWRITEAOF")
  },
  BGSAVE=function() {
    list("BGSAVE")
  },
  BITCOUNT=function(key, start=NULL, end=NULL) {
    assert_scalar2(key)
    assert_scalar_or_null2(start)
    assert_scalar_or_null2(end)
    list("BITCOUNT", key, start, end)
  },
  BITOP=function(operation, destkey, key) {
    assert_scalar2(operation)
    assert_scalar2(destkey)
    list("BITOP", operation, destkey, key)
  },
  BITPOS=function(key, bit, start=NULL, end=NULL) {
    assert_scalar2(key)
    assert_scalar2(bit)
    assert_scalar_or_null2(start)
    assert_scalar_or_null2(end)
    list("BITPOS", key, bit, start, end)
  },
  BLPOP=function(key, timeout) {
    assert_scalar2(timeout)
    list("BLPOP", key, timeout)
  },
  BRPOP=function(key, timeout) {
    assert_scalar2(timeout)
    list("BRPOP", key, timeout)
  },
  BRPOPLPUSH=function(source, destination, timeout) {
    assert_scalar2(source)
    assert_scalar2(destination)
    assert_scalar2(timeout)
    list("BRPOPLPUSH", source, destination, timeout)
  },
  CLIENT_KILL=function(ip_port=NULL, ID=NULL, TYPE=NULL, ADDR=NULL, SKIPME=NULL) {
    assert_scalar_or_null2(ip_port)
    assert_scalar_or_null2(ID)
    assert_match_value_or_null(TYPE, c("normal", "slave", "pubsub"))
    assert_scalar_or_null2(ADDR)
    assert_scalar_or_null2(SKIPME)
    list("CLIENT", "KILL", ip_port, command("ID", ID, FALSE), command("TYPE", TYPE, FALSE), command("ADDR", ADDR, FALSE), command("SKIPME", SKIPME, FALSE))
  },
  CLIENT_LIST=function() {
    list("CLIENT", "LIST")
  },
  CLIENT_GETNAME=function() {
    list("CLIENT", "GETNAME")
  },
  CLIENT_PAUSE=function(timeout) {
    assert_scalar2(timeout)
    list("CLIENT", "PAUSE", timeout)
  },
  CLIENT_SETNAME=function(connection_name) {
    assert_scalar2(connection_name)
    list("CLIENT", "SETNAME", connection_name)
  },
  CLUSTER_ADDSLOTS=function(slot) {
    list("CLUSTER", "ADDSLOTS", slot)
  },
  CLUSTER_COUNT_FAILURE_REPORTS=function(node_id) {
    assert_scalar2(node_id)
    list("CLUSTER", "COUNT-FAILURE-REPORTS", node_id)
  },
  CLUSTER_COUNTKEYSINSLOT=function(slot) {
    assert_scalar2(slot)
    list("CLUSTER", "COUNTKEYSINSLOT", slot)
  },
  CLUSTER_DELSLOTS=function(slot) {
    list("CLUSTER", "DELSLOTS", slot)
  },
  CLUSTER_FAILOVER=function(options=NULL) {
    assert_match_value_or_null(options, c("FORCE", "TAKEOVER"))
    list("CLUSTER", "FAILOVER", options)
  },
  CLUSTER_FORGET=function(node_id) {
    assert_scalar2(node_id)
    list("CLUSTER", "FORGET", node_id)
  },
  CLUSTER_GETKEYSINSLOT=function(slot, count) {
    assert_scalar2(slot)
    assert_scalar2(count)
    list("CLUSTER", "GETKEYSINSLOT", slot, count)
  },
  CLUSTER_INFO=function() {
    list("CLUSTER", "INFO")
  },
  CLUSTER_KEYSLOT=function(key) {
    assert_scalar2(key)
    list("CLUSTER", "KEYSLOT", key)
  },
  CLUSTER_MEET=function(ip, port) {
    assert_scalar2(ip)
    assert_scalar2(port)
    list("CLUSTER", "MEET", ip, port)
  },
  CLUSTER_NODES=function() {
    list("CLUSTER", "NODES")
  },
  CLUSTER_REPLICATE=function(node_id) {
    assert_scalar2(node_id)
    list("CLUSTER", "REPLICATE", node_id)
  },
  CLUSTER_RESET=function(reset_type=NULL) {
    assert_match_value_or_null(reset_type, c("HARD", "SOFT"))
    list("CLUSTER", "RESET", reset_type)
  },
  CLUSTER_SAVECONFIG=function() {
    list("CLUSTER", "SAVECONFIG")
  },
  CLUSTER_SET_CONFIG_EPOCH=function(config_epoch) {
    assert_scalar2(config_epoch)
    list("CLUSTER", "SET-CONFIG-EPOCH", config_epoch)
  },
  CLUSTER_SETSLOT=function(slot, subcommand, node_id=NULL) {
    assert_scalar2(slot)
    assert_match_value(subcommand, c("IMPORTING", "MIGRATING", "STABLE", "NODE"))
    assert_scalar_or_null2(node_id)
    list("CLUSTER", "SETSLOT", slot, subcommand, node_id)
  },
  CLUSTER_SLAVES=function(node_id) {
    assert_scalar2(node_id)
    list("CLUSTER", "SLAVES", node_id)
  },
  CLUSTER_SLOTS=function() {
    list("CLUSTER", "SLOTS")
  },
  COMMAND=function() {
    list("COMMAND")
  },
  COMMAND_COUNT=function() {
    list("COMMAND", "COUNT")
  },
  COMMAND_GETKEYS=function() {
    list("COMMAND", "GETKEYS")
  },
  COMMAND_INFO=function(command_name) {
    list("COMMAND", "INFO", command_name)
  },
  CONFIG_GET=function(parameter) {
    assert_scalar2(parameter)
    list("CONFIG", "GET", parameter)
  },
  CONFIG_REWRITE=function() {
    list("CONFIG", "REWRITE")
  },
  CONFIG_SET=function(parameter, value) {
    assert_scalar2(parameter)
    assert_scalar2(value)
    list("CONFIG", "SET", parameter, value)
  },
  CONFIG_RESETSTAT=function() {
    list("CONFIG", "RESETSTAT")
  },
  DBSIZE=function() {
    list("DBSIZE")
  },
  DEBUG_OBJECT=function(key) {
    assert_scalar2(key)
    list("DEBUG", "OBJECT", key)
  },
  DEBUG_SEGFAULT=function() {
    list("DEBUG", "SEGFAULT")
  },
  DECR=function(key) {
    assert_scalar2(key)
    list("DECR", key)
  },
  DECRBY=function(key, decrement) {
    assert_scalar2(key)
    assert_scalar2(decrement)
    list("DECRBY", key, decrement)
  },
  DEL=function(key) {
    list("DEL", key)
  },
  DISCARD=function() {
    list("DISCARD")
  },
  DUMP=function(key) {
    assert_scalar2(key)
    list("DUMP", key)
  },
  ECHO=function(message) {
    assert_scalar2(message)
    list("ECHO", message)
  },
  EVAL=function(script, numkeys, key, arg) {
    assert_scalar2(script)
    assert_scalar2(numkeys)
    list("EVAL", script, numkeys, key, arg)
  },
  EVALSHA=function(sha1, numkeys, key, arg) {
    assert_scalar2(sha1)
    assert_scalar2(numkeys)
    list("EVALSHA", sha1, numkeys, key, arg)
  },
  EXEC=function() {
    list("EXEC")
  },
  EXISTS=function(key) {
    list("EXISTS", key)
  },
  EXPIRE=function(key, seconds) {
    assert_scalar2(key)
    assert_scalar2(seconds)
    list("EXPIRE", key, seconds)
  },
  EXPIREAT=function(key, timestamp) {
    assert_scalar2(key)
    assert_scalar2(timestamp)
    list("EXPIREAT", key, timestamp)
  },
  FLUSHALL=function() {
    list("FLUSHALL")
  },
  FLUSHDB=function() {
    list("FLUSHDB")
  },
  GEOADD=function(key, longitude, latitude, member) {
    assert_scalar2(key)
    longitude <- interleave(longitude, latitude)
    longitude <- interleave(longitude, member)
    list("GEOADD", key, longitude)
  },
  GEOHASH=function(key, member) {
    assert_scalar2(key)
    list("GEOHASH", key, member)
  },
  GEOPOS=function(key, member) {
    assert_scalar2(key)
    list("GEOPOS", key, member)
  },
  GEODIST=function(key, member1, member2, unit=NULL) {
    assert_scalar2(key)
    assert_scalar2(member1)
    assert_scalar2(member2)
    assert_scalar_or_null2(unit)
    list("GEODIST", key, member1, member2, unit)
  },
  GEORADIUS=function(key, longitude, latitude, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
    assert_scalar2(key)
    assert_scalar2(longitude)
    assert_scalar2(latitude)
    assert_scalar2(radius)
    assert_match_value(unit, c("m", "km", "ft", "mi"))
    assert_match_value_or_null(withcoord, c("WITHCOORD"))
    assert_match_value_or_null(withdist, c("WITHDIST"))
    assert_match_value_or_null(withhash, c("WITHHASH"))
    assert_scalar_or_null2(COUNT)
    list("GEORADIUS", key, longitude, latitude, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE))
  },
  GEORADIUSBYMEMBER=function(key, member, radius, unit, withcoord=NULL, withdist=NULL, withhash=NULL, COUNT=NULL) {
    assert_scalar2(key)
    assert_scalar2(member)
    assert_scalar2(radius)
    assert_match_value(unit, c("m", "km", "ft", "mi"))
    assert_match_value_or_null(withcoord, c("WITHCOORD"))
    assert_match_value_or_null(withdist, c("WITHDIST"))
    assert_match_value_or_null(withhash, c("WITHHASH"))
    assert_scalar_or_null2(COUNT)
    list("GEORADIUSBYMEMBER", key, member, radius, unit, withcoord, withdist, withhash, command("COUNT", COUNT, FALSE))
  },
  GET=function(key) {
    assert_scalar2(key)
    list("GET", key)
  },
  GETBIT=function(key, offset) {
    assert_scalar2(key)
    assert_scalar2(offset)
    list("GETBIT", key, offset)
  },
  GETRANGE=function(key, start, end) {
    assert_scalar2(key)
    assert_scalar2(start)
    assert_scalar2(end)
    list("GETRANGE", key, start, end)
  },
  GETSET=function(key, value) {
    assert_scalar2(key)
    assert_scalar2(value)
    list("GETSET", key, value)
  },
  HDEL=function(key, field) {
    assert_scalar2(key)
    list("HDEL", key, field)
  },
  HEXISTS=function(key, field) {
    assert_scalar2(key)
    assert_scalar2(field)
    list("HEXISTS", key, field)
  },
  HGET=function(key, field) {
    assert_scalar2(key)
    assert_scalar2(field)
    list("HGET", key, field)
  },
  HGETALL=function(key) {
    assert_scalar2(key)
    list("HGETALL", key)
  },
  HINCRBY=function(key, field, increment) {
    assert_scalar2(key)
    assert_scalar2(field)
    assert_scalar2(increment)
    list("HINCRBY", key, field, increment)
  },
  HINCRBYFLOAT=function(key, field, increment) {
    assert_scalar2(key)
    assert_scalar2(field)
    assert_scalar2(increment)
    list("HINCRBYFLOAT", key, field, increment)
  },
  HKEYS=function(key) {
    assert_scalar2(key)
    list("HKEYS", key)
  },
  HLEN=function(key) {
    assert_scalar2(key)
    list("HLEN", key)
  },
  HMGET=function(key, field) {
    assert_scalar2(key)
    list("HMGET", key, field)
  },
  HMSET=function(key, field, value) {
    assert_scalar2(key)
    field <- interleave(field, value)
    list("HMSET", key, field)
  },
  HSET=function(key, field, value) {
    assert_scalar2(key)
    assert_scalar2(field)
    assert_scalar2(value)
    list("HSET", key, field, value)
  },
  HSETNX=function(key, field, value) {
    assert_scalar2(key)
    assert_scalar2(field)
    assert_scalar2(value)
    list("HSETNX", key, field, value)
  },
  HSTRLEN=function(key, field) {
    assert_scalar2(key)
    assert_scalar2(field)
    list("HSTRLEN", key, field)
  },
  HVALS=function(key) {
    assert_scalar2(key)
    list("HVALS", key)
  },
  INCR=function(key) {
    assert_scalar2(key)
    list("INCR", key)
  },
  INCRBY=function(key, increment) {
    assert_scalar2(key)
    assert_scalar2(increment)
    list("INCRBY", key, increment)
  },
  INCRBYFLOAT=function(key, increment) {
    assert_scalar2(key)
    assert_scalar2(increment)
    list("INCRBYFLOAT", key, increment)
  },
  INFO=function(section=NULL) {
    assert_scalar_or_null2(section)
    list("INFO", section)
  },
  KEYS=function(pattern) {
    assert_scalar2(pattern)
    list("KEYS", pattern)
  },
  LASTSAVE=function() {
    list("LASTSAVE")
  },
  LINDEX=function(key, index) {
    assert_scalar2(key)
    assert_scalar2(index)
    list("LINDEX", key, index)
  },
  LINSERT=function(key, where, pivot, value) {
    assert_scalar2(key)
    assert_match_value(where, c("BEFORE", "AFTER"))
    assert_scalar2(pivot)
    assert_scalar2(value)
    list("LINSERT", key, where, pivot, value)
  },
  LLEN=function(key) {
    assert_scalar2(key)
    list("LLEN", key)
  },
  LPOP=function(key) {
    assert_scalar2(key)
    list("LPOP", key)
  },
  LPUSH=function(key, value) {
    assert_scalar2(key)
    list("LPUSH", key, value)
  },
  LPUSHX=function(key, value) {
    assert_scalar2(key)
    assert_scalar2(value)
    list("LPUSHX", key, value)
  },
  LRANGE=function(key, start, stop) {
    assert_scalar2(key)
    assert_scalar2(start)
    assert_scalar2(stop)
    list("LRANGE", key, start, stop)
  },
  LREM=function(key, count, value) {
    assert_scalar2(key)
    assert_scalar2(count)
    assert_scalar2(value)
    list("LREM", key, count, value)
  },
  LSET=function(key, index, value) {
    assert_scalar2(key)
    assert_scalar2(index)
    assert_scalar2(value)
    list("LSET", key, index, value)
  },
  LTRIM=function(key, start, stop) {
    assert_scalar2(key)
    assert_scalar2(start)
    assert_scalar2(stop)
    list("LTRIM", key, start, stop)
  },
  MGET=function(key) {
    list("MGET", key)
  },
  MIGRATE=function(host, port, key, destination_db, timeout, copy=NULL, replace=NULL) {
    assert_scalar2(host)
    assert_scalar2(port)
    assert_scalar2(key)
    assert_scalar2(destination_db)
    assert_scalar2(timeout)
    assert_match_value_or_null(copy, c("COPY"))
    assert_match_value_or_null(replace, c("REPLACE"))
    list("MIGRATE", host, port, key, destination_db, timeout, copy, replace)
  },
  MONITOR=function() {
    list("MONITOR")
  },
  MOVE=function(key, db) {
    assert_scalar2(key)
    assert_scalar2(db)
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
    assert_scalar2(subcommand)
    list("OBJECT", subcommand, arguments)
  },
  PERSIST=function(key) {
    assert_scalar2(key)
    list("PERSIST", key)
  },
  PEXPIRE=function(key, milliseconds) {
    assert_scalar2(key)
    assert_scalar2(milliseconds)
    list("PEXPIRE", key, milliseconds)
  },
  PEXPIREAT=function(key, milliseconds_timestamp) {
    assert_scalar2(key)
    assert_scalar2(milliseconds_timestamp)
    list("PEXPIREAT", key, milliseconds_timestamp)
  },
  PFADD=function(key, element) {
    assert_scalar2(key)
    list("PFADD", key, element)
  },
  PFCOUNT=function(key) {
    list("PFCOUNT", key)
  },
  PFMERGE=function(destkey, sourcekey) {
    assert_scalar2(destkey)
    list("PFMERGE", destkey, sourcekey)
  },
  PING=function() {
    list("PING")
  },
  PSETEX=function(key, milliseconds, value) {
    assert_scalar2(key)
    assert_scalar2(milliseconds)
    assert_scalar2(value)
    list("PSETEX", key, milliseconds, value)
  },
  PSUBSCRIBE=function(pattern) {
    list("PSUBSCRIBE", pattern)
  },
  PUBSUB=function(subcommand, argument=NULL) {
    assert_scalar2(subcommand)
    list("PUBSUB", subcommand, argument)
  },
  PTTL=function(key) {
    assert_scalar2(key)
    list("PTTL", key)
  },
  PUBLISH=function(channel, message) {
    assert_scalar2(channel)
    assert_scalar2(message)
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
    assert_scalar2(key)
    assert_scalar2(newkey)
    list("RENAME", key, newkey)
  },
  RENAMENX=function(key, newkey) {
    assert_scalar2(key)
    assert_scalar2(newkey)
    list("RENAMENX", key, newkey)
  },
  RESTORE=function(key, ttl, serialized_value, replace=NULL) {
    assert_scalar2(key)
    assert_scalar2(ttl)
    assert_scalar2(serialized_value)
    assert_match_value_or_null(replace, c("REPLACE"))
    list("RESTORE", key, ttl, serialized_value, replace)
  },
  ROLE=function() {
    list("ROLE")
  },
  RPOP=function(key) {
    assert_scalar2(key)
    list("RPOP", key)
  },
  RPOPLPUSH=function(source, destination) {
    assert_scalar2(source)
    assert_scalar2(destination)
    list("RPOPLPUSH", source, destination)
  },
  RPUSH=function(key, value) {
    assert_scalar2(key)
    list("RPUSH", key, value)
  },
  RPUSHX=function(key, value) {
    assert_scalar2(key)
    assert_scalar2(value)
    list("RPUSHX", key, value)
  },
  SADD=function(key, member) {
    assert_scalar2(key)
    list("SADD", key, member)
  },
  SAVE=function() {
    list("SAVE")
  },
  SCARD=function(key) {
    assert_scalar2(key)
    list("SCARD", key)
  },
  SCRIPT_EXISTS=function(script) {
    list("SCRIPT", "EXISTS", script)
  },
  SCRIPT_FLUSH=function() {
    list("SCRIPT", "FLUSH")
  },
  SCRIPT_KILL=function() {
    list("SCRIPT", "KILL")
  },
  SCRIPT_LOAD=function(script) {
    assert_scalar2(script)
    list("SCRIPT", "LOAD", script)
  },
  SDIFF=function(key) {
    list("SDIFF", key)
  },
  SDIFFSTORE=function(destination, key) {
    assert_scalar2(destination)
    list("SDIFFSTORE", destination, key)
  },
  SELECT=function(index) {
    assert_scalar2(index)
    list("SELECT", index)
  },
  SET=function(key, value, EX=NULL, PX=NULL, condition=NULL) {
    assert_scalar2(key)
    assert_scalar2(value)
    assert_scalar_or_null2(EX)
    assert_scalar_or_null2(PX)
    assert_match_value_or_null(condition, c("NX", "XX"))
    list("SET", key, value, command("EX", EX, FALSE), command("PX", PX, FALSE), condition)
  },
  SETBIT=function(key, offset, value) {
    assert_scalar2(key)
    assert_scalar2(offset)
    assert_scalar2(value)
    list("SETBIT", key, offset, value)
  },
  SETEX=function(key, seconds, value) {
    assert_scalar2(key)
    assert_scalar2(seconds)
    assert_scalar2(value)
    list("SETEX", key, seconds, value)
  },
  SETNX=function(key, value) {
    assert_scalar2(key)
    assert_scalar2(value)
    list("SETNX", key, value)
  },
  SETRANGE=function(key, offset, value) {
    assert_scalar2(key)
    assert_scalar2(offset)
    assert_scalar2(value)
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
    assert_scalar2(destination)
    list("SINTERSTORE", destination, key)
  },
  SISMEMBER=function(key, member) {
    assert_scalar2(key)
    assert_scalar2(member)
    list("SISMEMBER", key, member)
  },
  SLAVEOF=function(host, port) {
    assert_scalar2(host)
    assert_scalar2(port)
    list("SLAVEOF", host, port)
  },
  SLOWLOG=function(subcommand, argument=NULL) {
    assert_scalar2(subcommand)
    assert_scalar_or_null2(argument)
    list("SLOWLOG", subcommand, argument)
  },
  SMEMBERS=function(key) {
    assert_scalar2(key)
    list("SMEMBERS", key)
  },
  SMOVE=function(source, destination, member) {
    assert_scalar2(source)
    assert_scalar2(destination)
    assert_scalar2(member)
    list("SMOVE", source, destination, member)
  },
  SORT=function(key, BY=NULL, LIMIT=NULL, GET=NULL, order=NULL, sorting=NULL, STORE=NULL) {
    assert_scalar2(key)
    assert_scalar_or_null2(BY)
    assert_length_or_null(LIMIT, 2L)
    assert_match_value_or_null(order, c("ASC", "DESC"))
    assert_match_value_or_null(sorting, c("ALPHA"))
    assert_scalar_or_null2(STORE)
    list("SORT", key, command("BY", BY, FALSE), command("LIMIT", LIMIT, TRUE), command("GET", GET, FALSE), order, sorting, command("STORE", STORE, FALSE))
  },
  SPOP=function(key, count=NULL) {
    assert_scalar2(key)
    assert_scalar_or_null2(count)
    list("SPOP", key, count)
  },
  SRANDMEMBER=function(key, count=NULL) {
    assert_scalar2(key)
    assert_scalar_or_null2(count)
    list("SRANDMEMBER", key, count)
  },
  SREM=function(key, member) {
    assert_scalar2(key)
    list("SREM", key, member)
  },
  STRLEN=function(key) {
    assert_scalar2(key)
    list("STRLEN", key)
  },
  SUBSCRIBE=function(channel) {
    list("SUBSCRIBE", channel)
  },
  SUNION=function(key) {
    list("SUNION", key)
  },
  SUNIONSTORE=function(destination, key) {
    assert_scalar2(destination)
    list("SUNIONSTORE", destination, key)
  },
  SYNC=function() {
    list("SYNC")
  },
  TIME=function() {
    list("TIME")
  },
  TTL=function(key) {
    assert_scalar2(key)
    list("TTL", key)
  },
  TYPE=function(key) {
    assert_scalar2(key)
    list("TYPE", key)
  },
  UNSUBSCRIBE=function(channel=NULL) {
    list("UNSUBSCRIBE", channel)
  },
  UNWATCH=function() {
    list("UNWATCH")
  },
  WAIT=function(numslaves, timeout) {
    assert_scalar2(numslaves)
    assert_scalar2(timeout)
    list("WAIT", numslaves, timeout)
  },
  WATCH=function(key) {
    list("WATCH", key)
  },
  ZADD=function(key, condition=NULL, change=NULL, increment=NULL, score, member) {
    assert_scalar2(key)
    assert_match_value_or_null(condition, c("NX", "XX"))
    assert_match_value_or_null(change, c("CH"))
    assert_match_value_or_null(increment, c("INCR"))
    score <- interleave(score, member)
    list("ZADD", key, condition, change, increment, score)
  },
  ZCARD=function(key) {
    assert_scalar2(key)
    list("ZCARD", key)
  },
  ZCOUNT=function(key, min, max) {
    assert_scalar2(key)
    assert_scalar2(min)
    assert_scalar2(max)
    list("ZCOUNT", key, min, max)
  },
  ZINCRBY=function(key, increment, member) {
    assert_scalar2(key)
    assert_scalar2(increment)
    assert_scalar2(member)
    list("ZINCRBY", key, increment, member)
  },
  ZINTERSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
    assert_scalar2(destination)
    assert_scalar2(numkeys)
    assert_scalar_or_null2(WEIGHTS)
    assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
    list("ZINTERSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE))
  },
  ZLEXCOUNT=function(key, min, max) {
    assert_scalar2(key)
    assert_scalar2(min)
    assert_scalar2(max)
    list("ZLEXCOUNT", key, min, max)
  },
  ZRANGE=function(key, start, stop, withscores=NULL) {
    assert_scalar2(key)
    assert_scalar2(start)
    assert_scalar2(stop)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    list("ZRANGE", key, start, stop, withscores)
  },
  ZRANGEBYLEX=function(key, min, max, LIMIT=NULL) {
    assert_scalar2(key)
    assert_scalar2(min)
    assert_scalar2(max)
    assert_length_or_null(LIMIT, 2L)
    list("ZRANGEBYLEX", key, min, max, command("LIMIT", LIMIT, TRUE))
  },
  ZREVRANGEBYLEX=function(key, max, min, LIMIT=NULL) {
    assert_scalar2(key)
    assert_scalar2(max)
    assert_scalar2(min)
    assert_length_or_null(LIMIT, 2L)
    list("ZREVRANGEBYLEX", key, max, min, command("LIMIT", LIMIT, TRUE))
  },
  ZRANGEBYSCORE=function(key, min, max, withscores=NULL, LIMIT=NULL) {
    assert_scalar2(key)
    assert_scalar2(min)
    assert_scalar2(max)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    assert_length_or_null(LIMIT, 2L)
    list("ZRANGEBYSCORE", key, min, max, withscores, command("LIMIT", LIMIT, TRUE))
  },
  ZRANK=function(key, member) {
    assert_scalar2(key)
    assert_scalar2(member)
    list("ZRANK", key, member)
  },
  ZREM=function(key, member) {
    assert_scalar2(key)
    list("ZREM", key, member)
  },
  ZREMRANGEBYLEX=function(key, min, max) {
    assert_scalar2(key)
    assert_scalar2(min)
    assert_scalar2(max)
    list("ZREMRANGEBYLEX", key, min, max)
  },
  ZREMRANGEBYRANK=function(key, start, stop) {
    assert_scalar2(key)
    assert_scalar2(start)
    assert_scalar2(stop)
    list("ZREMRANGEBYRANK", key, start, stop)
  },
  ZREMRANGEBYSCORE=function(key, min, max) {
    assert_scalar2(key)
    assert_scalar2(min)
    assert_scalar2(max)
    list("ZREMRANGEBYSCORE", key, min, max)
  },
  ZREVRANGE=function(key, start, stop, withscores=NULL) {
    assert_scalar2(key)
    assert_scalar2(start)
    assert_scalar2(stop)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    list("ZREVRANGE", key, start, stop, withscores)
  },
  ZREVRANGEBYSCORE=function(key, max, min, withscores=NULL, LIMIT=NULL) {
    assert_scalar2(key)
    assert_scalar2(max)
    assert_scalar2(min)
    assert_match_value_or_null(withscores, c("WITHSCORES"))
    assert_length_or_null(LIMIT, 2L)
    list("ZREVRANGEBYSCORE", key, max, min, withscores, command("LIMIT", LIMIT, TRUE))
  },
  ZREVRANK=function(key, member) {
    assert_scalar2(key)
    assert_scalar2(member)
    list("ZREVRANK", key, member)
  },
  ZSCORE=function(key, member) {
    assert_scalar2(key)
    assert_scalar2(member)
    list("ZSCORE", key, member)
  },
  ZUNIONSTORE=function(destination, numkeys, key, WEIGHTS=NULL, AGGREGATE=NULL) {
    assert_scalar2(destination)
    assert_scalar2(numkeys)
    assert_scalar_or_null2(WEIGHTS)
    assert_match_value_or_null(AGGREGATE, c("SUM", "MIN", "MAX"))
    list("ZUNIONSTORE", destination, numkeys, key, command("WEIGHTS", WEIGHTS, FALSE), command("AGGREGATE", AGGREGATE, FALSE))
  },
  SCAN=function(cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar2(cursor)
    assert_scalar_or_null2(MATCH)
    assert_scalar_or_null2(COUNT)
    list("SCAN", cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  },
  SSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar2(key)
    assert_scalar2(cursor)
    assert_scalar_or_null2(MATCH)
    assert_scalar_or_null2(COUNT)
    list("SSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  },
  HSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar2(key)
    assert_scalar2(cursor)
    assert_scalar_or_null2(MATCH)
    assert_scalar_or_null2(COUNT)
    list("HSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  },
  ZSCAN=function(key, cursor, MATCH=NULL, COUNT=NULL) {
    assert_scalar2(key)
    assert_scalar2(cursor)
    assert_scalar_or_null2(MATCH)
    assert_scalar_or_null2(COUNT)
    list("ZSCAN", key, cursor, command("MATCH", MATCH, FALSE), command("COUNT", COUNT, FALSE))
  }
))
