#!/usr/bin/env Rscript
path <- "revdep"
if (file.exists(path)) {
  unlink(path, recursive=TRUE)
}
dir.create(path)

devtools::install(".")

packages <- c("ropensci/rrlite",
              "richfitz/storr",
              "richfitz/RedisHeartbeat",
              "traitecoevo/rrqueue")
if (Sys.getenv("USER") == "rich") {
  prefix <- "/Users/rich/Documents/src"
  packages <- basename(packages)
} else {
  prefix <- "https://github.com"

  deps <- c("richfitz/callr")
  for (d in deps) {
    devtools::install_github(d)
  }
}

for (p in packages) {
  system2("git", c("clone", "--recursive",
                   file.path(prefix, p), file.path(path, p)))
  devtools::install(file.path(path, p))
}

res <- list()
for (p in packages) {
  res[[p]] <- devtools::test(file.path(path, p))
}

nb <- sum(vapply(res, function(x) sum(as.data.frame(x)$nb), integer(1)))
failed <- sum(vapply(res, function(x) sum(as.data.frame(x)$failed), integer(1)))
if (failed > 0) {
  stop(sprintf("%d / %d tests failed", failed, nb))
} else {
  message(sprintf("All %d tests passed", nb))
}
