# Vignette sources

The `RedisAPI.Rmd` file is automatically generated from `RedisAPI.R`; make edits in the `.R` file or they will be lost!

Because `RedisAPI.Rmd` requires Redis to be run, we use a trick (due to Carl Boettiger; see https://github.com/ropensci/RedisAPI/pulls/6) to avoid building the vignette on CRAN.  Running `make vignettes` (at the top level) will:

* Compile `vignettes/src/RedisAPI.R` -> `vignettes/src/RedisAPI.Rmd`
* Knit `vignettes/src/RedisAPI.Rmd` -> `vignettes/src/RedisAPI.md`
* Copy `vignettes/src/RedisAPI.md` to `vignettes/RedisAPI.Rmd`
* Knits `vignettes/RedisAPI.Rmd` (which has no executable code) to `inst/doc/`

The `R CMD check` vignette builder then repeats the last step which does not require Redis server to be run.

The travis build will rebuild the vignettes from scratch so we do get some level of checking there.
