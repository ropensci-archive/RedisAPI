##' List of valid redis commands supported by hiredis, and therefore
##' by RedisAPI.
##' @title List of valid redis commands
##' @param group Optional group name (run \code{redis_commands_groups}
##' for valid names here).
##' @export
##' @examples
##' redis_commands()
##' redis_commands_groups()
##' redis_commands("string")
redis_commands <- function(group=NULL) {
  if (is.null(group)) {
    names(cmds)
  } else {
    names(cmds)[vcapply(cmds, "[[", "group") %in% group]
  }
}

##' @export
##' @rdname redis_commands
redis_commands_groups <- function() {
  sort(unique(vcapply(cmds, "[[", "group")))
}

##' Print help for redis command
##' @title Print help for redis command
##' @param command Name of a command (see \code{\link{redis_commands}})
##' @export
##' @examples
##' redis_help("SET")
redis_help <- function(command) {
  dat <- cmds[[toupper(command)]]
  if (is.null(dat)) {
    stop(sprintf("Command '%s' not valid", toupper(command)))
  }
  cat(paste0(dat$summary, "\n"))
  f <- redis_api_generator$public_methods[[toupper(command)]]
  args <- capture.output(args(f))
  cat(paste0(paste(args[-length(args)], collapse="\n"), "\n"))
  cat(sprintf("See: http://redis.io/commands/%s\n", tolower(command)))
}
