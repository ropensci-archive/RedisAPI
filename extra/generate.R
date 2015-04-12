#!/usr/bin/env Rscript
library(methods)
path_R <- "../R"
source("generate_fun.R")

if (!file.exists("redis-doc")) {
  system("git clone https://github.com/antirez/redis-doc")
}

cmds <- read_commands()
dat <- generate(cmds)
writeLines(dat, file.path(path_R, "redis_generated.R"))
save(cmds, file=file.path(path_R, "sysdata.rda"))

## TODO: I want to get the help files added by cloning that from
## redis-cli which already formats things nicely.
