lsfTmpDir <- function() 
{
    tmpPath <- tempdir()
    suffix <- paste("Rlsf", format(Sys.time(), "%d%H%M%S"), 
        round(runif(1) * 1000, 0), sep = "")
    newPath <- paste(tmpPath, "/", suffix, sep = "")
    if (!dir.create(newPath)) 
        stop(paste("could not create", newPath))
    newPath
}


"lsf.submit2" <-
  function(func, savelist=c(), packages=NULL, ncpus=1, debug=FALSE, env = sys.frame(sys.parent()), tmpPath = lsfTmpDir(), ...)
  # savelist is a character vector of *names* of objects to be
  # copied to the remote R session
  {
    fname <- tempfile(pattern = "Rlsf_data", tmpdir = tmpPath)

    lsf.call <- as.call(list(func, ...) )

    # we need to bring all the objects to be passed in to the current
    # environment. This can be slow for large objects
    for(i in seq(along = savelist)) assign(savelist[i], get(savelist[i], env))

    savelist <- c(savelist, "lsf.call", "packages")

    # Why didn't we just use the envir arg here? We need to save lsf.call 
    # and packages to the output, so everything has to be in the same frame
    
    save(list = savelist, file = fname)

    script <- paste(file.path(.path.package("Rlsf"), "RunLsfJob"), fname)

    jobid <- .Call("lsf_job_submit",
                   as.integer(debug),
                   script,
                   as.integer(ncpus),
                   PACKAGE="Rlsf")

    if (jobid)
      list(jobid=jobid,fname=fname,debug=debug)
    else 
      return(NULL)
  }


