#!/usr/bin/env Rscript
path <- "revdep"
dir.create(path)

packages <- c("richfitz/storr",
              "richfitz/RedisHeartbeat",
              "traitecoevo/rrqueue")
prefix <- "https://github.com/"

for (p in packages) {
  system2("git", c("clone", paste0(prefix, p), file.path(path, p)))
  devtools::install(file.path(path, p))
}

res <- list()
for (p in packages) {
  res[[p]] <- devtools::test(file.path(path, p))
}

failed <- sum(vapply(res, function(x) sum(x$failed), integer(1)))
if (failed > 0) {
  stop(sprintf("%d tests failed", failed))
} else {
  message("All tests passed")
}
