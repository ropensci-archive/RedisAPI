# Knit to execute all the R code and replace with appropriate markdown chunks
# We don't use render because we want the yaml intact, and we want syntax highlighting
knitr::knit("RedisAPI.Rmd")

## Move the output .md to vignettes as if it were an .Rmd source
file.copy("RedisAPI.md", "../../../vignettes/RedisAPI.Rmd")
