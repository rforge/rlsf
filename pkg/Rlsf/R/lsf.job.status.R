# $Id: lsf.job.status.R 4 2006-12-15 15:23:10Z kuhn $

"lsf.job.status" <-
  function(job)
  {
    .Call("lsf_job_status", as.integer(job$jobid), PACKAGE="Rlsf")
  }
