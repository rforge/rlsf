# $Id: lsf.resume.job.R 4 2006-12-15 15:23:10Z kuhn $

"lsf.resume.job" <-
  function(job)
  {
    .Call("lsf_resume_job", as.integer(job$jobid), PACKAGE="Rlsf")
  }
