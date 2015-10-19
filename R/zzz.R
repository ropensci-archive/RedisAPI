.onLoad <- function(libname, pkgname) {
  C_serializeToRaw <<- getNativeSymbolInfo("serializeToRaw",
                                           "RApiSerialize")
  C_unserializeFromRaw <<- getNativeSymbolInfo("unserializeFromRaw",
                                               "RApiSerialize")
}
