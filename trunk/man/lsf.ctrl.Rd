\name{lsf.ctrl}
\alias{lsf.ctrl}
\title{Control over job parameters}
\description{
This function sets many, many arguments for LSF jobs. 
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
  \item{dbg}{ Nathan }
  \item{env}{the environment to get teh R objects from}
  \item{tmpPath}{a path where temporary files are stored}
  \item{jobName}{a label for the jobs (\code{-J})}
  \item{queue}{the job queue (\code{-q}). fo Pfizer, either "immed$\_$single", "immed$\_$multi", "overnight$\_$single", "overnight$\_$multi" or "asavailable"}
  \item{askedHosts}{the machine name \code{-m}}
  \item{resReq}{a resource string \code{-R}}
  \item{rlimit_cpu}{ see LSF documentation } 
  \item{rlimit_fsize}{ see LSF documentation } 
  \item{rlimit_data}{ see LSF documentation } 
  \item{rlimit_stack}{the service class where the job is run \code{-S}}
  \item{rlimit_core}{ see LSF documentation } 
  \item{rlimit_rss}{resident memory size, in kilobytes. see LSF documentation on \code{-M}} 
  \item{rlimit_nofile}{ see LSF documentation } 
  \item{rlimit_open_max}{ see LSF documentation } 
  \item{rlimit_swap}{the virtual memory swap limit (in KB) \code{-v}} 
  \item{rlimit_run}{ see LSF documentation } 
  \item{rlimit_process}{the limit on the number of processes \code{-p}}
  \item{hostSpec}{the total CPU time for the job \code{-c} }
  \item{numProcessors}{ see LSF documentation }
  \item{dependCond}{a dependency condition for starting the job \code{-w}} 
  \item{beginTime}{the start time for the job in seconds since 00:00:00  GMT, Jan. 1, 1970 \code{-b}}
  \item{termTime}{the termination deadline for the job in seconds since 00:00:00 GMT, Jan. 1, 1970 \code{-t}}
  \item{sigValue}{ see LSF documentation }
  \item{inFile}{a file to get standard input from \code{-i}}
  \item{outFile}{a file to append standard out to \code{-o}}
  \item{errFile}{a file to append standard error output to \code{-e}}
  \item{command}{see LSF documentation  }
  \item{chkpntPeriod}{enables checkpoints for a period of time \code{-k}}
  \item{chkpntDir}{a directory path for checkpoints\code{-k}}
  \item{nxf}{a file to copy between th submission host and the execution server \code{-f}} 
  \item{xFile}{a file to copy between th submission host and the execution server \code{-f}} 
  \item{preExecCmd}{a command to execute prior to running the remote job \code{-E}}
  \item{mailUser}{ see LSF documentation } 
  \item{delOptions}{ see LSF documentation } 
  \item{projectName}{assigns the job to the specified project \code{-P}} 
  \item{maxNumProcessors}{ the maximum number of processors to run the job } 
  \item{loginShell}{initalizes the execution environment using a loginf shell \code{-L} } 
  \item{userGroup}{a user group to associate the job with \code{-G} }
  \item{exceptList}{ see LSF documentation } 
  \item{exclusive}{exclusive execution mode \code{-x} } 
  \item{notifyBegin}{an email address to send an email to once the process is started; see LSF documentation on \code{-B} } 
  \item{notifyEnd}{an email address to send an email to once the process is finished; see LSF documentation on \code{-N}} 
  \item{restart}{ see LSF documentation } 
  \item{restartForce}{ see LSF documentation } 
  \item{rerunnable}{ make the job re-runnable \code{-r} } 
  \item{chkpnt_copy}{ see LSF documentation on \code{lsf_submit(3)} } 
  \item{chkpnt_force}{ see LSF documentation on \code{lsf_submit(3)} } 
  \item{interactive}{  see LSF documentation on \code{-I}, requires "interactive" argument  } 
  \item{pty}{see LSF documentation on \code{-Ip}, requires "pty" and "interactive" } 
  \item{pty_shell}{ interactive mode; new jobs cannot be submitted until the current oe is finished \code{-I}} 
  \item{hold}{ suspend the job in \code{PSUP} mode \code{-H} } 
  \item{R}{the command-line call to R (could be an alias or a path)}
}

\value{ 
 a list or arguments specified by the function call or the defaults
}
\references{ \url{http://www.platform.com/Products/Platform.LSF.Family/Platform.LSF/Home.htm} } 
\author{Nathan coulter} 

\keyword{utilities} 

