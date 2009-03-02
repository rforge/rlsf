# $Id: scat.R 4 2006-12-15 15:23:10Z kuhn $

# cat to stdout and immediately flush
scat <- function(...)
  {
    DEBUG <- options()$DEBUG
    if( !is.null(DEBUG) && DEBUG)
      {
        cat("### ", file=stderr())
        cat(..., file=stderr())
        cat(" ###\n", file=stderr())
        flush(stderr())
      }
    invisible(NULL)
  }
