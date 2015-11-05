indent <- function(x, n=2) {
  indent <- paste0(rep_len(" ", n), collapse="")
  paste0(indent, x)
}

reindent <- function(x, n) {
  vcapply(strsplit(x, "\n", fixed=TRUE),
          function(x) paste(indent(x, n), collapse="\n"))
}

## duplicated from package
vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
}
viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}
vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}

dquote <- function(x) {
  sprintf('"%s"', x)
}

## TODO: now that this approximately works, it'd be nice to refactor
## it to make it less awful.

## There's not actually enough information here to work out what is
## required with these commands.  For example in SET, the official
## docs say:
##
##     SET key value [EX seconds] [PX milliseconds] [NX|XX]
##
## but what they actually mean is EX *or* PX
##
## It's actuallly possible that only a single "command" is allowed;
## that'd be easy enough to enforce, but would be frustrating if
## incorrect.  Redis will throw a syntax error if incorrect output is
## given so it's no great deal.

is_field <- function(name, args) {
  if (is.null(args[[name]])) {
    rep(FALSE, nrow(args))
  } else {
    !is.na(args[[name]])
  }
}

hiredis_cmd <- function(name, args, standalone=FALSE) {
  is_multiple <- is_field("multiple", args)
  is_command <- is_field("command", args)
  is_paired <- viapply(args$name, length) > 1L

  if (any(is_command)) {
    j <- is_command & !(is_paired & is_multiple)
    args$name_orig <- args$name
    args$command_length <- viapply(args$name, length)
    args$name[j] <- args$command[j]
    is_paired <- viapply(args$name, length) > 1L
  }

  ## need to be same length, share optional status.
  if (any(is_paired)) {
    if (sum(is_paired) > 1L) {
      stop("multiple paired groups")
    }
    len <- length(args$name[[which(is_paired)]])
    args1 <- args[!is_paired, , drop=FALSE]

    ## Lots of assumptions here:
    args2 <- args[rep(which(is_paired), len), ]
    args2$name <- args$name[[which(is_paired)]]
    args2$type <- args$type[[which(is_paired)]]

    args3 <- rbind(args1, args2)
    ## Reorder:
    args3 <- args3[match(unlist(args$name), args3$name), ]
    rownames(args3) <- NULL
    pair_from <- args$name[[which(is_paired)]][[1L]]
    pair_to   <- args$name[[which(is_paired)]][-1L]
    args3$paired <- ""
    args3$paired[match(pair_to, args3$name)] <- pair_from

    args3$name <- unlist(args3$name)

    args <- args3

    ## NOTE: Need to redo this here because the number of rows has changed.
    is_multiple <- is_field("multiple", args)
    is_command <- is_field("command", args)
  }

  ## At this point we should have no duplicates
  if (any(duplicated(args$name))) {
    stop("duplicate names")
  }
  args$name <- gsub("-", "_", args$name, fixed=TRUE)
  if (any(grepl("[^A-Za-z0-9._]", args$name))) {
    stop("invalid names")
  }

  is_optional <- is_field("optional", args)

  r_fn_args <- args$name
  r_fn_args[is_optional] <- paste0(r_fn_args[is_optional], "=NULL")
  r_fn_args <- paste(c(character(0), r_fn_args), collapse=", ")

  ## Generate the check string
  ## TODO: Consider dealing with integer types here?
  check <- sprintf("assert_scalar%s2(%s)",
                   ifelse(is_optional, "_or_null", ""),
                   args$name)
  ## Then, for things that take multiple arguments:
  if (any(is_command)) {
    j <- is_command & args$command_length > 1L
    check[j] <- sprintf("assert_length%s(%s, %dL)",
                        ifelse(is_optional[j], "_or_null", ""),
                        args$name[j], args$command_length[j])
  }

  is_enum <- !vlapply(args$enum, is.null)
  if (any(is_enum)) {
    tmp <- vcapply(args$enum[is_enum],
                   function(x) paste(dquote(x), collapse=", "))
    check[is_enum] <- sprintf("assert_match_value%s(%s, c(%s))",
                              ifelse(is_optional[is_enum], "_or_null", ""),
                              args$name[is_enum], tmp)
  }

  ## NOTE: This assumes that multipleness overrides everything else
  ## (no multiple enums, no multiple commands)
  check <- check[!is_multiple]

  is_paired <- args$paired != ""
  ## Here we can't use c() to pull args together but have to
  ## interleave for the paired ones.  This bit of hackery depends
  ## crucially on the single pair rule.
  if (any(is_paired & is_multiple)) {
    pair <- sprintf("%s <- interleave(%s, %s)",
                    pair_from, pair_from, pair_to)
    vars <- setdiff(args$name, pair_to)
  } else {
    pair <- NULL
    vars <- args$name
  }

  if (any(is_command)) {
    vars[is_command] <- sprintf("command(%s, %s, %s)",
                                dquote(vars[is_command]),
                                vars[is_command],
                                args$command_length[is_command] > 1L)
  }

  args <- paste(c(dquote(name), vars), collapse=", ")
  run <- sprintf("list(%s)", args)
  if (!standalone) {
    run <- sprintf("self$.command(%s)", run)
  }
  fn_body <- paste(indent(c(check, pair, run)), collapse="\n")
  fmt <- "%s=function(%s) {\n%s\n}"
  sprintf(fmt, toupper(name), r_fn_args, fn_body)
}

read_commands <- function() {
  cmds <- jsonlite::fromJSON("redis-doc/commands.json")

  ## For now, nothing supported that is in two bits:
  cmds <- cmds[!grepl(" ", names(cmds))]

  ##   cmds_ok <- jsonlite::fromJSON("supported.json")
  ##   cmds <- cmds[sort(cmds_ok)]

  ## Now, go through and get the extra doc:
  ## for (i in names(cmds)) {
  ##   p <- sprintf("redis-doc/commands/%s.md", tolower(i))
  ##   if (file.exists(p)) {
  ##     cmds[[i]]$description <- paste(readLines(p), collapse="\n")
  ##   }
  ## }
  cmds
}

generate <- function(cmds) {
  header <- "## Automatically generated: do not edit by hand"
  template <- 'redis_api_generator <- R6::R6Class(
  "redis_api",
  public=list(
    config=NULL,
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
%s
    ))'

  args <- lapply(cmds, function(x) as.data.frame(x$arguments))
  dat <- vcapply(names(args), function(x) hiredis_cmd(x, args[[x]]),
                 USE.NAMES=FALSE)
  str <- paste(reindent(dat, 4), collapse=",\n")
  c(header, sprintf(template, str))
}

generate2 <- function(cmds) {
  template <- 'redis <- list2env(hash=TRUE, list(\n%s\n))'

  args <- lapply(cmds, function(x) as.data.frame(x$arguments))
  dat <- vcapply(names(args), function(x) hiredis_cmd(x, args[[x]], TRUE),
                 USE.NAMES=FALSE)
  str <- paste(reindent(dat, 2), collapse=",\n")
  sprintf(template, str)
}
