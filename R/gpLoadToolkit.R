gpLoadToolkit <- function(gppath=NULL) {
  library(spam)

  if (is.null(gppath)) {
    if (.Platform$OS.type == "unix") {
      dir = "~/mlprojects/gp/R/R/"
    } else if (.Platform$OS.type == "windows") {
      dir = "C:\\mlprojects\\gp\\R\\R\\"
    }
  } else dir = gppath

  ## source() a bunch of files
  sourceDir <- function(path, trace = TRUE, ...) {
    for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
      if(trace) cat(nm,":")           
      source(file.path(path, nm), ...)
      if(trace) cat("\n")
    }
  }

  
  sourceDir(dir)
}
