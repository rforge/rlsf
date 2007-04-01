lsfTmpDir <- function() 
{
    tmpPath <- tempdir()
    suffix <- paste("Rlsf", format(Sys.time(), "%d%H%M%S"), 
        round(runif(1) * 1000, 0), sep = "")
    newPath <- paste(tmpPath, "/", suffix, sep = "")
    if (!dir.create(newPath)) 
        stop(paste("could not create", newPath))
    newPath
}

lsf.ctrl <- function (
	savelist=c(),
	packages=NULL,
	dbg=FALSE,
	env = sys.frame(sys.parent()),
	tmpPath = getwd(),
	#tmpPath = lsfTmpDir(),
	jobName = NULL, # -J
	queue = NULL, # -q
	#numAskedHosts = NULL, # -m -- calculated form askedHosts
	askedHosts = NULL, # -m
	resReq = NULL, # -R
	#rLimits = c(0),
	rlimit_cpu = NULL,
	rlimit_fsize = NULL,
	rlimit_data = NULL,
	rlimit_stack = NULL, # -S
	rlimit_core = NULL,
	rlimit_rss = NULL, # -M, resident memory size, in kilobytes
	rlimit_nofile = NULL,
	rlimit_open_max = NULL,
	rlimit_swap = NULL, # -v, in KB
	rlimit_run = NULL,
	rlimit_process = NULL, #-p
	hostSpec = NULL, # -c
	numProcessors = 1,
	dependCond = NULL, # -w
	beginTime = NULL, # -b, seconds since 00:00:00 GMT, Jan. 1, 1970
	termTime = NULL,  # -t, seconds since 00:00:00 GMT, Jan. 1, 1970
	sigValue = NULL,
	inFile = NULL, # -i
	outFile = "/dev/null", # -o
	errFile = NULL, # -e
	command = NULL,
	chkpntPeriod = NULL, # -k
	chkpntDir = NULL, # -k
	nxf = NULL, # -f, implement later (probably should be computed from xFile)
	xFile = NULL, # -f, files to be transfered, implement later 
	preExecCmd = NULL, # -E
	mailUser = NULL,
	delOptions = 0,
	projectName = NULL, # -P
	maxNumProcessors = 1,
	loginShell = NULL,
	userGroup = NULL, # -G
	exceptList = NULL,
	exclusive = NULL, # -x
	notifyBegin = NULL, # -B
	notifyEnd = NULL, # -N
	restart = NULL, #brestart
	restartForce = NULL, #brestart -f 
	rerunnable = NULL, #-r
	chkpnt_copy = NULL, #see lsf_submit(3)
	chkpnt_force = NULL, #see lsf_submit(3)
	interactive = NULL, # -I
	pty = NULL, # -Ip, requires "interactive" argument
	pty_shell = NULL, # requires "pty" and "interactive"
	hold = NULL, # -H
	#wait = NULL, # -K -- not yet implemented
	#the name to invoke R by 
	R = "R"
) {
	ctrl <- lapply(names(formals()), function(x) eval(as.name(x)))
	names(ctrl) <- names(formals())
	ctrl
}

#comments below show equivalent bsub command-line options
"lsf.submit2" <- function( func, ctrl=lsf.ctrl(), ...) {
	# savelist is a character vector of *names* of objects to be
	# copied to the remote R session

	ctrl <- ctrl[!sapply(ctrl, is.null)]

	dbg <- ctrl$dbg

	Rname=""
	if (!is.na(ctrl$R) & ctrl$R != "") {
		Rname <-ctrl$R
	}

	fname <- tempfile(pattern = "Rlsf_data", tmpdir = ctrl$tmpPath)
	lsf.call <- as.call(list(func, ...) )

	# we need to bring all the objects to be passed in to the current
	# environment. This can be slow for large objects
	for(i in seq(along = ctrl$savelist))
		assign(ctrl$savelist[i], get(ctrl$savelist[i], ctrl$env))

	packages <- ctrl$packages
	savelist <- c(ctrl$savelist, "lsf.call", "packages")

	# Why didn't we just use the envir arg here? We need to save lsf.call 
	# and packages to the output, so everything has to be in the same frame

	save(list = savelist, file = fname)

	ctrl$command <- paste(file.path(.path.package("Rlsf"), "RunLsfJob"), fname, Rname)

	#workaround: convert x to list to make sure as.character handles it
	ctrl <- lapply(
		ctrl,
		function(x) {
			tryCatch(as.character(x), error=function(ex)as.character(list(x)))
		}
	)
	jobid <- .Call("lsf_job_submit2", ctrl, PACKAGE="Rlsf")

	if (jobid)
		list(jobid=jobid,fname=fname,debug=dbg)
	else 
		return(NULL)

}
