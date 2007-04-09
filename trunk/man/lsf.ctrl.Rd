\name{lsf.ctrl}
\alias{lsf.ctrl}
\title{Control over job parameters}
\description{
This function sets many, many arguments for LSF jobs
}
\usage{
lsf.ctrl(
   savelist = c(), packages = NULL, dbg = FALSE, env = sys.frame(sys.parent()), 
   tmpPath = getwd(), jobName = NULL, queue = NULL, askedHosts = NULL, 
   resReq = NULL, rlimit_cpu = NULL, rlimit_fsize = NULL, rlimit_data = NULL, 
   rlimit_stack = NULL, rlimit_core = NULL, rlimit_rss = NULL, 
   rlimit_nofile = NULL, rlimit_open_max = NULL, rlimit_swap = NULL, 
   rlimit_run = NULL, rlimit_process = NULL, hostSpec = NULL, numProcessors = 1, 
   dependCond = NULL, beginTime = NULL, termTime = NULL, sigValue = NULL, 
   inFile = NULL, outFile = "/dev/null", errFile = NULL, command = NULL, 
   chkpntPeriod = NULL, chkpntDir = NULL, nxf = NULL, xFile = NULL, 
   preExecCmd = NULL, mailUser = NULL, delOptions = 0, projectName = NULL, 
   maxNumProcessors = 1, loginShell = NULL, userGroup = NULL, exceptList = NULL, 
   exclusive = NULL, notifyBegin = NULL, notifyEnd = NULL, restart = NULL, 
   restartForce = NULL, rerunnable = NULL, chkpnt_copy = NULL, 
   chkpnt_force = NULL, interactive = NULL, pty = NULL, pty_shell = NULL, 
   hold = NULL, R = "R")
}
\arguments{
  \item{savelist}{character vector giving the names of local objects
    that should be copied to each worker process before computation is
    started.}
  \item{packages}{List of library packages to be loaded by each worker
    process before computation is started.}
  \item{dbg}{see LSF documentation  }
  \item{env}{see LSF documentation }
  \item{tmpPath}{a path where temporary files are stored}
  \item{jobName}{a label for the jobs (\code{-J})}
  \item{queue}{the job queue (\code{-q}). fo Pfizer, either "immed_single", "immed_multi", "overnight_single" or "overnight_multi"}
  \item{askedHosts}{see LSF documentation on \code{-m}}
  \item{resReq}{see LSF documentation on \code{-R}}
  \item{rlimit_cpu}{ see LSF documentation }
  \item{rlimit_fsize}{ see LSF documentation }
  \item{rlimit_data}{ see LSF documentation }
  \item{rlimit_stack}{see LSF documentation on \code{-S}}
  \item{rlimit_core}{ see LSF documentation }
  \item{rlimit_rss}{resident memory size, in kilobytes. see LSF documentation on \code{-M}}
  \item{rlimit_nofile}{ see LSF documentation }
  \item{rlimit_open_max}{ see LSF documentation }
  \item{rlimit_swap}{see LSF documentation on \code{-v}}
  \item{rlimit_run}{ see LSF documentation }
  \item{rlimit_process}{see LSF documentation on \code{-p}}
  \item{hostSpec}{see LSF documentation on \code{-c} }
  \item{numProcessors}{ see LSF documentation }
  \item{dependCond}{see LSF documentation on \code{-w}}
  \item{beginTime}{seconds since 00:00:00 GMT, Jan. 1, 1970, see LSF documentation on \code{-b}}
  \item{termTime}{seconds since 00:00:00 GMT, Jan. 1, 1970, see LSF documentation on \code{-t}}
  \item{sigValue}{ see LSF documentation }
  \item{inFile}{see LSF documentation on \code{-i}}
  \item{outFile}{see LSF documentation on \code{-o}}
  \item{errFile}{see LSF documentation on \code{-e}}
  \item{command}{see LSF documentation  }
  \item{chkpntPeriod}{see LSF documentation on \code{-k}}
  \item{chkpntDir}{see LSF documentation on \code{-k}}
  \item{nxf}{see LSF documentation on \code{-f}}
  \item{xFile}{see LSF documentation on \code{-f}}
  \item{preExecCmd}{see LSF documentation on \code{-E}}
  \item{mailUser}{ see LSF documentation }
  \item{delOptions}{ see LSF documentation }
  \item{projectName}{see LSF documentation on \code{-P}}
  \item{maxNumProcessors}{ see LSF documentation }
  \item{loginShell}{ see LSF documentation }
  \item{userGroup}{ see LSF documentation on \code{-G} }
  \item{exceptList}{ see LSF documentation }
  \item{exclusive}{ see LSF documentation on \code{-x} }
  \item{notifyBegin}{an email address to send an email to once the process is started; see LSF documentation on \code{-B} }
  \item{notifyEnd}{an email address to send an email to once the process is finished; see LSF documentation on \code{-N}}
  \item{restart}{ see LSF documentation }
  \item{restartForce}{ see LSF documentation }
  \item{rerunnable}{ see LSF documentation on \code{-r} }
  \item{chkpnt_copy}{ see LSF documentation on \code{lsf_submit(3)} }
  \item{chkpnt_force}{ see LSF documentation on \code{lsf_submit(3)} }
  \item{interactive}{  see LSF documentation on \code{-I}, requires "interactive" argument  }
  \item{pty}{see LSF documentation on \code{-Ip}, requires "pty" and "interactive" }
  \item{pty_shell}{ see LSF documentation on \code{-I}}
  \item{hold}{  see LSF documentation on \code{-H} }
  \item{R}{the command-line call to R (could be an alias or a path)}
}

\value{
 a list or arguments specified by the function call or the defaults
}
\references{ \url{http://www.platform.com/Products/Platform.LSF.Family/Platform.LSF/Home.htm} }
\author{Nathan coulter}

\keyword{utilities}

