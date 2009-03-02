/* $Id: Rlsf.c 21 2008-06-12 17:38:24Z ncoult $ */

#include <stdlib.h>
#include <netdb.h>
#include <signal.h>
#include <string.h>

#include <lsf/lsbatch.h>

#include <R.h>
#include <Rdefines.h>
#include <R_ext/PrtUtil.h>

SEXP AsInt(int);

SEXP
lsf_initialize(void)
{
  if (lsb_init("R")) {
    Rprintf("lsf_initialize: lsb_init: %s\n", lsb_sysmsg());
    return AsInt(-1);
  }
  else {
    return AsInt(0);
  }
  if (putenv("BSUB_QUIET=1")) {
    return AsInt(0);
  }
}

SEXP
lsf_job_submit2(SEXP ctrl) {
	char *name;
	char *val;
	int jobId, debug, i, j;
	SEXP elmt = R_NilValue;
	SEXP names = getAttrib(ctrl, R_NamesSymbol);
	struct submit submitRequest;
	struct submitReply submitReply;

	memset(&submitRequest, 0, sizeof(submitRequest));
	for (i = 0; i < LSF_RLIM_NLIMITS; i++)
		submitRequest.rLimits[i] = DEFAULT_RLIMIT;
	for (i = 0; i < length(names); i++) {
		name = CHAR(STRING_ELT(names, i));
		elmt = VECTOR_ELT(ctrl, i);
		val = CHAR(STRING_ELT(elmt, 0));
		if (0) {
		} else if (!strcmp(name, "jobName")) {
			submitRequest.options |= SUB_JOB_NAME;
			submitRequest.jobName = val;
		} else if (!strcmp(name, "queue")) {
			submitRequest.options |= SUB_QUEUE;
			submitRequest.queue = val;
		} else if (!strcmp(name, "askedHosts")){
			submitRequest.options |= SUB_HOST;
			char **chars;
			chars = (char **)calloc(length(elmt), sizeof(char *));
			for (j = 0; j < length(elmt); j++){
				val=CHAR(STRING_ELT(elmt, j));
				chars[j] = val;
			}
			submitRequest.numAskedHosts = length(elmt);
			submitRequest.askedHosts = chars;
		} else if (!strcmp(name, "resReq")){
			submitRequest.options |= SUB_RES_REQ;
			submitRequest.resReq = val;
		} else if (!strcmp(name, "rlimit_cpu")) {
			submitRequest.rLimits[LSF_RLIMIT_CPU] = atoi(val);
		} else if (!strcmp(name, "rlimit_fsize")) {
			submitRequest.rLimits[LSF_RLIMIT_FSIZE] = atoi(val);
		} else if (!strcmp(name, "rlimit_data")) {
			submitRequest.rLimits[LSF_RLIMIT_DATA] = atoi(val);
		} else if (!strcmp(name, "rlimit_stack")) {
			submitRequest.rLimits[LSF_RLIMIT_STACK] = atoi(val);
		} else if (!strcmp(name, "rlimit_core")) {
			submitRequest.rLimits[LSF_RLIMIT_CORE] = atoi(val);
		} else if (!strcmp(name, "rlimit_rss")) {
			submitRequest.rLimits[LSF_RLIMIT_RSS] = atoi(val);
		} else if (!strcmp(name, "rlimit_nofile")) {
			submitRequest.rLimits[LSF_RLIMIT_NOFILE] = atoi(val);
		} else if (!strcmp(name, "rlimit_open_max")) {
			submitRequest.rLimits[LSF_RLIMIT_OPEN_MAX] = atoi(val);
		} else if (!strcmp(name, "rlimit_swap")) {
			submitRequest.rLimits[LSF_RLIMIT_SWAP] = atoi(val);
		} else if (!strcmp(name, "rlimit_run")) {
			submitRequest.rLimits[LSF_RLIMIT_RUN] = atoi(val);
		} else if (!strcmp(name, "rlimit_process")) {
			submitRequest.rLimits[LSF_RLIMIT_PROCESS] = atoi(val);
		} else if (!strcmp(name, "hostSpec")) {
			submitRequest.options |= SUB_HOST_SPEC;
			submitRequest.hostSpec = val;
		} else if (!strcmp(name, "numProcessors")){
			submitRequest.numProcessors = atoi(val);
		} else if (!strcmp(name, "dependCond")){
			submitRequest.options |= SUB_DEPEND_COND;
			submitRequest.dependCond = val;
		} else if (!strcmp(name, "beginTime")) {
			submitRequest.beginTime = atoi(val);
		} else if (!strcmp(name, "termTime")) {
			submitRequest.termTime = atoi(val);
		} else if (!strcmp(name, "sigValue")) {
			submitRequest.options |= SUB_WINDOW_SIG;
			submitRequest.sigValue= atoi(val);
		} else if (!strcmp(name, "command")){
			submitRequest.command = val;
		} else if (!strcmp(name, "inFile")){
			submitRequest.options |= SUB_IN_FILE;
			submitRequest.inFile = val;
		} else if (!strcmp(name, "outFile")){
			submitRequest.options |= SUB_OUT_FILE;
			submitRequest.outFile = val;
		} else if (!strcmp(name, "errFile")){
			submitRequest.options |= SUB_ERR_FILE;
			submitRequest.errFile = val;
		} else if (!strcmp(name, "chkpntPeriod")){
			submitRequest.options |= SUB_CHKPNTABLE;
			submitRequest.options |= SUB_CHKPNT_PERIOD;
			submitRequest.chkpntPeriod = atoi(val);
		} else if (!strcmp(name, "chkpntDir")){
			submitRequest.options |= SUB_CHKPNTABLE;
			submitRequest.options |= SUB_CHKPNT_DIR;
			submitRequest.chkpntDir = val;
		} else if (!strcmp(name, "xFile")){
			/*not implemented*/
			/* SUB_OTHER_FILES probably should be set  */
			/* submitRequest.nxf should be assigned */
		} else if (!strcmp(name, "preExecCmd")){
			submitRequest.options |= SUB_PRE_EXEC;
			submitRequest.preExecCmd = val;
		} else if (!strcmp(name, "mailUser")){
			submitRequest.options |= SUB_MAIL_USER;
			submitRequest.mailUser = val;
		} else if (!strcmp(name, "delOptions")){
			submitRequest.delOptions = atoi(val);
		} else if (!strcmp(name, "projectName")){
			submitRequest.options |= SUB_PROJECT_NAME;
			submitRequest.projectName = val;
		} else if (!strcmp(name, "maxNumProcessors")){
			submitRequest.maxNumProcessors = atoi(val);
		} else if (!strcmp(name, "loginShell")){
			submitRequest.options |= SUB_LOGIN_SHELL; 
			submitRequest.loginShell = val; }
		else if (!strcmp(name, "userGroup")){
			submitRequest.options |= SUB_USER_GROUP;
			submitRequest.loginShell = val;
		} else if (!strcmp(name, "exceptList")){
			submitRequest.exceptList = val;
		} else if (!strcmp(name, "exclusive")){
			submitRequest.options |= SUB_EXCLUSIVE;
		} else if (!strcmp(name, "notifyBegin")){
			submitRequest.options |= SUB_NOTIFY_BEGIN; 
		} else if (!strcmp(name, "notifyEnd")){
			submitRequest.options |= SUB_NOTIFY_END; 
		} else if (!strcmp(name, "restart")){
			submitRequest.options |= SUB_RESTART;
		} else if (!strcmp(name, "restartForce")){
			submitRequest.options |= SUB_RESTART_FORCE;
		} else if (!strcmp(name, "rerunnable")){
			submitRequest.options |= SUB_RERUNNABLE;
		/*} else if (!strcmp(name, "chkpnt_copy")){
			submitRequest.options |= SUB_CHKPNT_COPY;*/
		/*} else if (!strcmp(name, "chkpnt_force")){
			submitRequest.options |= SUB_CHKPNT_FORCE;*/
		} else if (!strcmp(name, "interactive")){
			submitRequest.options |= SUB_INTERACTIVE;
		} else if (!strcmp(name, "pty")){
			submitRequest.options |= SUB_PTY;
		} else if (!strcmp(name, "pty_shell")){
			submitRequest.options |= SUB_PTY_SHELL;
		} else if (!strcmp(name, "hold")){
			submitRequest.options2 |= SUB2_HOLD;
		} else if (!strcmp(name, "wait")){
			/* This will require forking */
			/*submitRequest.options2 |= SUB2_BSUB_BLOCK;*/
		} else if (!strcmp(name, "debug")){
			/* is debug used anymore? */
			if (val) debug = 1;
		}
		val = "";
	}

	jobId = lsb_submit(&submitRequest, &submitReply);
	if (jobId == -1) {
	 Rprintf("lsf_job_submit: lsb_submit: %s\n", lsb_sysmsg());
	 return AsInt(0);
	}
	return AsInt(jobId);
}

SEXP
lsf_job_submit(SEXP sexp_debug, SEXP sexp_command, SEXP sexp_ncpus)
{
  int jobId, debug, i;
  struct submit submitRequest;
  struct submitReply submitReply;

  debug = INTEGER(sexp_debug)[0];
  memset(&submitRequest, 0, sizeof(submitRequest));
  for (i = 0; i < LSF_RLIM_NLIMITS; i++)
    submitRequest.rLimits[i] = DEFAULT_RLIMIT;
  submitRequest.command = CHAR(STRING_ELT(sexp_command, 0));
  submitRequest.options |= SUB_OUT_FILE;
  if (debug) {
    submitRequest.outFile = "Rlsf_job_output.%J";
  } else {
    submitRequest.outFile = "/dev/null";
  }
  submitRequest.numProcessors = INTEGER(sexp_ncpus)[0];
  submitRequest.maxNumProcessors = INTEGER(sexp_ncpus)[0];

  jobId = lsb_submit(&submitRequest, &submitReply);
  if (jobId == -1) {
    Rprintf("lsf_job_submit: lsb_submit: %s\n", lsb_sysmsg());
    return AsInt(0);
  }

  return AsInt(jobId);
}

SEXP
lsf_job_status(SEXP sexp_jobid)
{
  int jobid, numrec;
  struct jobInfoEnt *jInfo;
  SEXP status;

  jobid = INTEGER(sexp_jobid)[0];

  if ((numrec = lsb_openjobinfo(jobid, NULL, NULL, NULL, NULL, ALL_JOB)) < 0) {
    Rprintf("lsf_job_status: lsb_openjobinfo: %s\n", lsb_sysmsg());
    return R_NilValue;
  }

  jInfo = lsb_readjobinfo(&numrec);
  if (jInfo == NULL) {
    Rprintf("lsf_job_status: lsb_readjobinfo: %s\n", lsb_sysmsg());
    lsb_closejobinfo();
    return R_NilValue;
  }

  lsb_closejobinfo();

  PROTECT(status = allocVector(STRSXP, 1));
  switch(jInfo->status) {
  case JOB_STAT_NULL:
    SET_STRING_ELT(status, 0, mkChar("NULL"));
    break;
  case JOB_STAT_PEND:
    SET_STRING_ELT(status, 0, mkChar("PEND"));
    break;
  case JOB_STAT_PSUSP:
    SET_STRING_ELT(status, 0, mkChar("PSUSP"));
    break;
  case JOB_STAT_RUN:
    SET_STRING_ELT(status, 0, mkChar("RUN"));
    break;
  case JOB_STAT_RUN|JOB_STAT_WAIT:
    SET_STRING_ELT(status, 0, mkChar("WAIT"));
    break;
  case JOB_STAT_SSUSP:
    SET_STRING_ELT(status, 0, mkChar("SSUSP"));
    break;
  case JOB_STAT_USUSP:
    SET_STRING_ELT(status, 0, mkChar("USUSP"));
    break;
  case JOB_STAT_EXIT:
    if (jInfo->reasons & EXIT_ZOMBIE)
      SET_STRING_ELT(status, 0, mkChar("ZOMBI"));
    else
      SET_STRING_ELT(status, 0, mkChar("EXIT"));
    break;
  case JOB_STAT_DONE:
  case JOB_STAT_DONE|JOB_STAT_PDONE:
  case JOB_STAT_DONE|JOB_STAT_PERR:
  case JOB_STAT_DONE|JOB_STAT_WAIT:
    SET_STRING_ELT(status, 0, mkChar("DONE"));
    break;
  case JOB_STAT_UNKWN:
    SET_STRING_ELT(status, 0, mkChar("UNKWN"));
    break;
  default:
    Rprintf("lsf_job_status: job state <%d> is unknown.\n", jInfo->status);
    SET_STRING_ELT(status, 0, mkChar("ERROR"));
    break;
  }
  UNPROTECT(1);

  return status;
}



SEXP
AsInt(int x)
{
  SEXP sexp_x;
  PROTECT(sexp_x = allocVector(INTSXP, 1));
  INTEGER(sexp_x)[0] = x;
  UNPROTECT(1);
  return sexp_x;
}

SEXP
showArgs(SEXP args)
{
  int i, nargs;
  char *name;
  Rcomplex cpl;

  if ((nargs = length(args) - 1) > 0) {
    for (i = 0; i < nargs; i++) {
      args = CDR(args);
      name = CHAR(PRINTNAME(TAG(args)));
      switch (TYPEOF(CAR(args))) {
      case REALSXP:
	Rprintf("[%d] '%s' %f\n", i+1, name, REAL(CAR(args))[0]);
	break;
      case LGLSXP:
      case INTSXP:
	Rprintf("[%d] '%s' %d\n", i+1, name, INTEGER(CAR(args))[0]);
	break;
      case CPLXSXP:
	cpl = COMPLEX(CAR(args))[0];
	Rprintf("[%d] '%s' %f + %fi\n", i+1, name, cpl.r, cpl.i);
	break;
      case STRSXP:
	Rprintf("[%d] '%s' %s\n", i+1, name, CHAR(STRING_ELT(CAR(args), 0)));
	break;
      default:
	Rprintf("[%d] '%s' R type\n", i+1, name);
      }
    }
  }
  return R_NilValue;
}

SEXP
lsf_kill_job(SEXP sexp_jobid)
{
  int jobid, rc;

  jobid = INTEGER(sexp_jobid)[0];

  rc = lsb_signaljob(jobid, SIGKILL);

  if (rc < 0) {
    Rprintf("lsf_kill_job: lsb_signaljob: %s\n", lsb_sysmsg());
    return AsInt(-1);
  }

  return AsInt(0);
}

SEXP
lsf_suspend_job(SEXP sexp_jobid)
{
  int jobid, rc;

  jobid = INTEGER(sexp_jobid)[0];

  rc = lsb_signaljob(jobid, SIGSTOP);

  if (rc < 0) {
    Rprintf("lsf_suspend_job: lsb_signaljob: %s\n", lsb_sysmsg());
    return AsInt(-1);
  }

  return AsInt(0);
}

SEXP
lsf_resume_job(SEXP sexp_jobid)
{
  int jobid, rc;

  jobid = INTEGER(sexp_jobid)[0];

  rc = lsb_signaljob(jobid, SIGCONT);

  if (rc < 0) {
    Rprintf("lsf_resume_job: lsb_signaljob: %s\n", lsb_sysmsg());
    return AsInt(-1);
  }

  return AsInt(0);
}


