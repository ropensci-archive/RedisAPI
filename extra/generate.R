#!/usr/bin/env Rscript
library(methods)
path_R <- "../R"
source("generate_fun.R")

if (!file.exists("redis-doc")) {
  callr::call_system(callr::Sys_which("git"),
                     c("clone", "https://github.com/antirez/redis-doc"))
}

cmds <- read_commands()
dat_cl <- generate(cmds)
dat_other <- generate2(cmds)

writeLines(c(dat_cl, dat_other), file.path(path_R, "redis_generated.R"))
save(cmds, file=file.path(path_R, "sysdata.rda"))
