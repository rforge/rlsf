# $Id: lsf.kill.job.R 4 2006-12-15 15:23:10Z kuhn $

"lsf.kill.job" <-
  function(job)
  {
    .Call("lsf_kill_job", as.integer(job$jobid), PACKAGE="Rlsf")
  }
