# $Id: Last.lib.R 4 2006-12-15 15:23:10Z kuhn $

.Last.lib <- function(libpath)
  {
    dyn.unload(file.path(libpath, "libs",
                         paste("Rlsf", .Platform$"dynlib.ext", sep="")))
  }
