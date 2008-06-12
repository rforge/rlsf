\name{bqueues}
\alias{bqueues}
\title{Displays information about queues}
\description{
This function parses the command line output of the bqueues command line statement
}
\usage{
bqueues()
}
\details{
a system call is used to collect the bqueues output and this is imported into R
}
\value{
a data frame where each row is a queue. There are columns for the number of jobs suspended, pending, running etc. There is also a column, \code{ratio}, that is the logit of the ratio of non-active jobs (pending or suspended) out of all the jobs.
}
\author{Max Kuhn}

\keyword{ utilities}

