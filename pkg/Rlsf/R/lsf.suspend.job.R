# $Id: lsf.suspend.job.R 4 2006-12-15 15:23:10Z kuhn $

"lsf.suspend.job" <-
  function(job)
  {
    .Call("lsf_suspend_job", as.integer(job$jobid), PACKAGE="Rlsf")
  }
