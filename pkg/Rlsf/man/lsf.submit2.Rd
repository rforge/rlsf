
\name{lsf.submit2}
\alias{lsf.submit2}
\title{Submit an \R function to run through LSF (remix)}
\description{
  Submit an \R function to run in batch through the LSF distributed
  queuing environment.
}
\usage{
lsf.submit2(func, ctrl=lsf.ctrl(), ...)
}
\arguments{
  \item{func}{This argument provides the name of the function that will
    be run through LSF. It must be defined within the current scope.}
  \item{\dots}{Any arguments to \code{func} should be passed after the
    function name. They must be within the current scope, and must be
    provided to the remote function call as part of the
    \code{savelist}} 
  \item{ctrl}{a list of options. See \code{\link{lsf.ctrl}}}

}
\details{

This function has the same purpose as  \code{\link{lsf.submit}} but it
has several differences.

First, the objects that are do be passed to teh function are copied to 
the fucntion's workspace. This adds some overhead, but makes the function
more modular and minimizes the scoping complexty (and thus shortens coding
time).

Second, many of the LSF command line options are now exposed through the control
object (see \code{\link{lsf.ctrl}} for more details). Now, the user can specify
specific isntalls of R to use, which queues to send the job to or a resource string
that can taget one or more machines. 

}
\value{
  \item{jobid}{The job identifier returned from LSF.}
  \item{fname}{The file name of the environment passed to the remote
    function call.}
  \item{debug}{A boolean flag indicating whether debugging should be
    turned on or not. If debugging is turned on, then the standard
    output and standard error of the remote \R process invocation will be
    placed in a file named Rlsf\_job\_output.<jobid>, where jobid is the
    same as the LSF job id returned by \code{lsf.submit}}
}
\author{Chris Smith \email{csmith@platform.com}, Max Kuhn  
\email{max.kuhn@pfizer.com} and Nathan Coulter  \email{nathan.coulter@pfizer.com}}
\note{When submitting parallel jobs (i.e. \code{ncpus} greater than 1),
  the Rlsf package will utilize the snow and Rmpi packages for managing
  the parallel job. At this time, no other parallel packages are
  supported (e.g. snow with PVM).} 
\seealso{\code{\link{lsf.job.status}},\code{\link{lsf.get.result}},
\code{\link{lsf.run.job}}} 
\examples{
data(iris)
library(MASS)

ldaJob1 <- lsf.submit2(
   func = lda,
   formula = as.formula(Species ~ .),
   data = iris,
   ctrl = lsf.ctrl(
      packages = "MASS",
      savelist = "iris",
      queue = "overnight_single"))
   
ldaFit <- jobMonitor(ldaJob1)
   

}
\keyword{utilities}
