#!/bin/sh

AC_INIT([Rlsf], [1.1.1], [max.kuhn@pfizer.com])
AC_CONFIG_SRCDIR([src/Rlsf.c])

if test -z "${R_HOME}"; then
    R_HOME=$(R RHOME)
fi
if test -z "${R_HOME}"; then
    AC_MSG_ERROR(["could not determine R_HOME"])
fi

AC_MSG_NOTICE([CC before:  ${CC}])
CC=$(${R_HOME}/bin/R CMD config CC)
AC_MSG_NOTICE([CC after:  ${CC}])
#CC="libtool $CC"
AC_MSG_NOTICE([CFLAGS before:  ${CFLAGS}])
CFLAGS=$(${R_HOME}/bin/R CMD config CFLAGS)
AC_MSG_NOTICE([CFLAGS after:  ${CFLAGS}])
AC_MSG_NOTICE([CPPFLAGS before:  ${CPPFLAGS}])
CPPFLAGS=$(${R_HOME}/bin/R CMD config CPPFLAGS)
AC_MSG_NOTICE([CPPFLAGS after:  ${CPPFLAGS}])

### optional features ###
AC_ARG_ENABLE(
    [embed-lsfpaths],
    [AC_HELP_STRING(
        [--disable-embed-lsfpaths],
        [do not embed lsf library paths in 'Rlsf' @<:@enable@:>@]
        )
    ],
    [arg_embed=''],
    [arg_embed=1]
)

AC_ARG_WITH(
    [lsf],
    [AC_HELP_STRING(
        [--with-lsf],
        [choose @<:@dynamic@:>@ to link against liblsf.so, or "'static'" to link liblsf.a ]
    )],
    [
        AC_MSG_NOTICE([--with-lsf was used])
        with_lsf="${withval}"
    ],
    [
        AC_MSG_NOTICE([--with-lsf was not used])
        with_lsf=dynamic
    ]
)

AC_ARG_WITH(
    [bat],
    [AC_HELP_STRING(
        [--with-bat],
        [choose @<:@dynamic@:>@ to link against libbat.so, or "'static'" to link libbat.a ]
    )],
    [
        AC_MSG_NOTICE([--with-bat was used])
        with_bat=${withval}
    ],
    [
        AC_MSG_NOTICE([--with-bat was not used])
        with_bat=dynamic
    ]
)

### /optional features ###

if test "${with_bat}" = dynamic -o "${with_lsf}" = dynamic; then
    with_dynamic=1
fi


if test -z "${LSF_ENVDIR}"; then
    LSF_ENVDIR=/etc
fi

if test -f ${LSF_ENVDIR}/profile.lsf; then
    . ${LSF_ENVDIR}/profile.lsf
fi

if test -f ${LSF_ENVDIR}/lsf.conf; then
    . ${LSF_ENVDIR}/lsf.conf
else
    AC_MSG_RESULT(["Cannot find the lsf.conf file in $LSF_ENVDIR"])
    AC_MSG_ERROR(["Please set the LSF_ENVDIR variable to the LSF 'conf'
    directory"])
fi

LSF_INCLUDE=""
AC_MSG_NOTICE(["Try to find lsf/lsf.h ..."])
if test -f ${LSF_INCLUDEDIR}/lsf/lsf.h; then
    AC_MSG_RESULT(["Found in ${LSF_INCLUDEDIR}"])
    LSF_INCLUDE="-I${LSF_INCLUDEDIR}"
else 
    AC_MSG_RESULT([echo "Cannot find lsf.h header file"])
    AC_MSG_ERROR([echo "Please check if LSF_ENVDIR is set properly."])
fi

AC_MSG_NOTICE(["Try to find lsf/lsbatch.h ..."])
if test -f ${LSF_INCLUDEDIR}/lsf/lsbatch.h; then
    AC_MSG_RESULT(["Found in ${LSF_INCLUDEDIR}"])
else 
    AC_MSG_RESULT(["Cannot find lsbatch.h header file"])
    AC_MSG_ERROR(["Please check if LSF_ENVDIR is set properly."])
fi

if test "${with_dynamic}" -a "${arg_embed}"; then
    AC_MSG_NOTICE([how to embed library paths])
    embed_linux="rpath"
    embed_solaris="R"
    for i in "${embed_linux}" "${embed_solaris}"; do
        embed_string="-Wl,-${i},${LSF_LIBDIR}"
        if test -z "${embed_success}"; then
            save_LIBS=${LIBS}
            LIBS="${embed_string} ${LIBS}"
            AC_LINK_IFELSE(
                [
                    int main() {
                    }
                ],
                [
                    AC_MSG_RESULT([successfully linked using ${LIBS}])
                    embed_success=1
                ],
                [
                    AC_MSG_RESULT([unsuccessfuly linked using ${LIBS}])
                    LIBS=${save_LIBS}
                ]
            )
        fi
    done
fi



if test -n "$LSF_LIBS"; then
    AC_MSG_NOTICE(["Using LSF_LIBS environment variable: $LSF_LIBS"])
else
    AC_MSG_NOTICE(["Try to find libbat ..."])
    if test "${with_bat}" = dynamic; then
        if test -f ${LSF_LIBDIR}/libbat.so; then
            AC_MSG_RESULT(["Found libbat.so in ${LSF_LIBDIR}"])
            LSF_LIBS="-L${LSF_LIBDIR} -lbat"
        else
            AC_MSG_RESULT(["Cannot find libbat.so"])
            AC_MSG_ERROR(["Please check if LSF_ENVDIR is set properly."])
        fi    
    else
        if test -f ${LSF_LIBDIR}/libbat.a; then
            AC_MSG_RESULT(["Found libbat.a in ${LSF_LIBDIR}"])
            LSF_LIBS="${LSF_LIBDIR}/libbat.a"
        else
            AC_MSG_RESULT(["Cannot find libbat.a"])
            AC_MSG_ERROR(["Please check if LSF_ENVDIR is set properly."])
        fi    
    fi

    AC_MSG_NOTICE(["Try to find liblsf ..."])
    if test "${with_lsf}" = dynamic; then
        if test -f ${LSF_LIBDIR}/liblsf.so; then
            AC_MSG_RESULT(["Found liblsf.so in ${LSF_LIBDIR}"])
            LSF_LIBS="${LSF_LIBS} -L${LSF_LIBDIR} -llsf"
        else
            AC_MSG_RESULT(["Cannot find liblsf.so"])
            AC_MSG_ERROR(["Please check if LSF_ENVDIR is set properly."])
        fi    
    else
        if test -f ${LSF_LIBDIR}/liblsf.a; then
            AC_MSG_RESULT(["Found liblsf.a in ${LSF_LIBDIR}"])
            LSF_LIBS="${LSF_LIBS} ${LSF_LIBDIR}/liblsf.a"
        else
            AC_MSG_RESULT(["Cannot find liblsf.a"])
            AC_MSG_ERROR(["Please check if LSF_ENVDIR is set properly."])
        fi    
    fi

fi

AC_MSG_NOTICE(["Check for libsocket ..."])
AC_SEARCH_LIBS( setsockopt, [socket],,
    [AC_SEARCH_LIBS(setsockopt,[socket],,,[-lnsl])]

)
dnl probably best to add libnsl  last
AC_MSG_NOTICE(["Check for libnsl ..."])
AC_SEARCH_LIBS(ypprot_err, [nsl])

LSF_LIBS="$LSF_LIBS $LIBS"
AC_MSG_NOTICE(["LSF_LIBS looks like:  ${LSF_LIBS}"])
AC_MSG_NOTICE(["LIBS looks like:  ${LIBS}"])

AC_SUBST([LSF_INCLUDE])
AC_SUBST([LSF_LIBS])
AC_CONFIG_FILES([src/Makevars])
AC_MSG_NOTICE([Creating src/Makevars])
AC_OUTPUT
