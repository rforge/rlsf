jobMonitor <- function(x, pause = 1, timeLimit = TRUE, buffer = 20, verbose = TRUE)
{

   if(!is.null(names(x))  & all(names(x) %in% c("jobid", "fname", "debug"))) x <- list(x)
   
   library(chron)
   chronNow <- function(times = 1) chron(
         rep(format(Sys.time(), "%m/%d/%Y"), times), 
         rep(format(Sys.time(), "%H:%M:%S"), times))

   flatTable <- function(x)
   {
      tab <- table(x)
      tmp <- paste(tolower(names(tab)), ": ", tab, sep = "")
         
      paste(tmp, collapse = ", ")
   }

   # check for x not being a list of jobs
   
   out <- vector(mode = "list", length = length(x))
   
   # we put a "position" value into the list so that
   # we can put the output in the same order as the
   # jobs were submitted
   for(i in seq(along = x)) x[[i]]$position <- i   
   
   isFini <- NULL
   
   # set time in chron
   current <- chronNow(length(x))   
   
   elapsedTime <- vector(mode = "numeric", length = length(x)) * 0
   jobStat <- rep("PEND", length = length(x))
   
   timeBound <- Inf
   
   while(TRUE)
   {
      
      lastStatus <- jobStat
      jobStat <- unlist(lapply(x, lsf.job.status))
      
      lastTime <- current
      current <- chronNow(length(x))
      elapsedTime[lastStatus == "RUN"] <- elapsedTime[lastStatus == "RUN"] + as.numeric(current[lastStatus == "RUN"] - lastTime[lastStatus == "RUN"])
      
      # mark done jobs that we have returned the results as processed
      # so that we don't try to get them again
      if(length(isFini) > 0) jobStat[isFini] <- "processed"
      
      if(verbose)
      {
         cat(format(Sys.time(), "%Y/%d/%m %H:%M:%S"), "\n")
         cat("  ", flatTable(jobStat), "\n")
         timeNote <- if(sum(jobStat == "RUN") == 0) max(elapsedTime, na.rm = TRUE) else max(elapsedTime[jobStat == "RUN"], na.rm = TRUE)
         
         if(timeLimit & is.finite(timeBound)) cat("   time limit:", timeBound, ", longest job:", timeNote, "\n")
      }
            
      if(any(jobStat %in% c("DONE", "EXIT")))
      {
         # we won't try to do anything with existed jobs
         isDone <- jobStat == "DONE"
         isFini <- unique(c(isFini, which(isDone)))

         for(j in seq(along = jobStat))
         {
        
            if(jobStat[j] == "DONE")
            {
               tmp <- lsf.get.result(x[[j]])
               
               if(is.null(tmp) & verbose)
               {
                  cat("!!! returned a null value\n")
                  print(x[[j]])
               }
               if((class(tmp) == "try-error") & verbose) cat("!!! returned an error", tmp, "\n")
               out[[ x[[j]]$position ]] <- tmp
         
            }

         } 
         jobStat[isFini] <- "processed"
      }
      
      if((mean(jobStat == "processed") > 1/2) & timeLimit & is.infinite(timeBound))
      {
         timeBound <- max(elapsedTime[jobStat == "processed"]) * buffer
         # if the currently done jobs all finished befor the first check, the 
         # bound is set to zero. We will force it to be 1/10 of a day
         if(timeBound == 0) timeBound <- .1
      }
      
      
      if(!any(jobStat %in% c("RUN", "PEND", "SSUSP", "USUSP", "PSUSP")))
      {
         if(verbose)
         {
            cat("\n", format(Sys.time(), "%Y/%d/%m %H:%M:%S"), "\n")
            cat("  ", flatTable(jobStat), "\n")
         }
         break()
      }
      
      flagJob <- (elapsedTime > timeBound) & (jobStat == "RUN")
      if(any(flagJob))
      {
         tooLong <- which(flagJob)
         for(k in seq(along = tooLong))
         {
            lsf.kill.job(x[[ tooLong[k] ]])
            if(verbose)
            {
               cat("  job",  x[[ tooLong[k] ]]$jobid, "may be hung -- killing it now\n")
            }
            out[[ tooLong[k] ]] <- "killed due to excessive run time"
         }  
         isFini <- unique(c(isFini, tooLong))
      }
      if(pause > 0) Sys.sleep(pause)      
      if(verbose) cat("\n\n")      
   }

   if(length(x) == 1) out <- out[[1]]

   # cleanup and lsf files specific to this run (exited)
   out

}

