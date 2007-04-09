\name{jobMonitor}
\alias{jobMonitor}
\title{Management of one or more Rlsf jobs}
\description{
This function will monitor and manage jobs submitted using  \code{\link{lsf.submit}} or  \code{\link{lsf.submit2}}.
}
\usage{
jobMonitor(x, pause = 1, timeLimit = TRUE, buffer = 20, verbose = TRUE)
}
\arguments{
  \item{x}{a list. For one job, it can be the object produced by  \code{\link{lsf.submit}} or  \code{\link{lsf.submit2}}. When there are multiple jobs, \code{x} should be a list of objects resulting from either of these two functions}
  \item{pause}{the number of seconds to pause before checking the results again}
  \item{timeLimit}{a logical: should the function kill jobs that are taking an inordinate amount of time? (see details below)}
  \item{buffer}{a multiplier to create a failsafe time when \code{timeLimit = TRUE}.}
  \item{verbose}{a logical: should updates be printed?}
}
\details{
This function will check to see if jobs are completed (either with return codes of "DONE" or "EXIT"). Once a job is finished, the results are immediately obtained using \code{\link{lsf.get.result}}. If \code{x} contains more than one job, the results of all of the jobs are returned in a list; otherwise the results are returned directly.

The option \code{timeLimit = TRUE} is useful for cases where very similar jobs are being run, such as bootstrapping or cross-validation. In this case, the monitor will wait until half of the jobs are finished and when will estimate a "failsafe" for the remaining jobs. the failsafe takes the maximum execution time of the finished jobs and multiplies it by \code{buffer}. If the elapsed time for any of the remaining jobs exceeds this limit, they are killed.

If all of the jobs are done before \code{jobMonitor} is called, the failsafe is set to 0.1 (days).

}
\value{
When \code{x} contains more than one call to  \code{\link{lsf.submit}} or  \code{\link{lsf.submit2}} the output is a list of the results for each job; otherwise it is the result of the single job.

If the job is killed by \code{jobMonitor}, it will return the string "killed due to excessive run time"
}
\author{Max Kuhn}
\seealso{ \code{\link{lsf.submit}} and  \code{\link{lsf.submit2}}}
\examples{
test <- function(slowDown = FALSE)
{
   # add this or the jobs will be done before jobMonitor gets them
   Sys.sleep(15)
   
   out <- Sys.info()["version"]
   
   # test the failsafe by making the job run really long
   if(slowDown) Sys.sleep(600)
   out
}  

numJobs <- 20
jobData <- vector(mode = "list", length = numJobs)
for(i in 2:numJobs) jobData[[i]] <- lsf.submit2(test)
jobData[[1]] <- lsf.submit2(test, slowDown = TRUE)

# make the cutoff short for demo purposes
versionNames <- jobMonitor(jobData, buffer = 1)
}
\keyword{utilities}

