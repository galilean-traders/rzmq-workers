#!/usr/bin/env Rscript


pkgTest <- function(x)
  {
    write(paste0("Checking ",x,"...",collapse=NULL),stdout())
    if (x %in% rownames(installed.packages()) == FALSE)
    {
        install.packages(x)
    }
    else { write(" ok",stdout()) }
  }

# The list of needed packages
PKGs <- list("rzmq","rjson","xts","TTR","argparse","data.table")

for (name in PKGs) { pkgTest(name) }
