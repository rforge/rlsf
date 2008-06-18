bqueues <- function() {
   tmpPath <- tempdir()
   rawOut <- system("bqueues", intern = TRUE)
   textOut <- strsplit(rawOut, " ")
   textOut <- lapply(textOut, function(x) x[x != ""])
   if(length(unique(unlist(lapply(textOut, length)))) != 1)
      stop("error parsing system information")
   colNames <- textOut[[1]]
   
   textOut <- textOut[-1]
   textOut <- lapply(textOut, function(x) gsub("-", "NA", x))
   
   matrixData <- t(as.data.frame(textOut))
   rownames(matrixData) <- NULL
   colnames(matrixData) <- colNames
   
   
   write.csv(matrixData, paste(tmpPath, "/bqueues.csv", sep = ""))
   tmp <-   read.csv(paste(tmpPath, "/bqueues.csv", sep = ""))
   try(file.remove(paste(tmpPath, "/bqueues.csv", sep = "")), silent = TRUE)
   
   logitFunc <- function(x) {
      x <- ifelse(x == 0, 0.001, x)
      x <- ifelse(x == 1, 0.999, x)
      log(x/(1-x))
   }
   
   
   tmp$ratio <- ifelse(tmp$RUN > 0, logitFunc((tmp$PEND + tmp$SUSP)/tmp$NJOBS), NA)
   
tmp
}
