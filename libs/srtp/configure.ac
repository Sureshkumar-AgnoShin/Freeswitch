AC_PREREQ(2.59)
AC_INIT(srtp, 2.4.0, mcgrew@cisco.com)
AC_CONFIG_AUX_DIR(build)
AM_INIT_AUTOMAKE

CFLAGS="$CFLAGS $CONFIGURE_CFLAGS"
CXXFLAGS="$CXXFLAGS $CONFIGURE_CXXFLAGS"
LDFLAGS="$LDFLAGS $CONFIGURE_LDFLAGS"

#Set default language
AC_LANG_C
# Checks for programs.
AC_PROG_CC
AC_PROG_AWK
AC_PROG_MAKE_SET
AC_PROG_INSTALL
AC_PROG_LIBTOOL
AX_COMPILER_VENDOR

# Optimization
AC_ARG_ENABLE(optimization,
[AC_HELP_STRING([--enable-optimization],[Set if you want us to add max optimising compiler flags])],[enable_optimizer="$enableval"],[enable_optimizer="no"])

if test "${enable_optimizer}" = "yes" ; then
        AC_DEFINE([OPTIMZER],[],[Enable Optimization.])
        AX_CC_MAXOPT
fi

#  Enable debugging
AC_ARG_ENABLE(debug,
[AC_HELP_STRING([--enable-debug],[build with debug information])],[enable_debug="$enable_debug"],[enable_debug="yes"])

if test "${enable_debug}" = "yes"; then
        AC_DEFINE([DEBUG],[],[Enable extra debugging.])
        AX_CFLAGS_WARN_ALL_ANSI
fi


AM_CONDITIONAL([WANT_DEBUG],[test "${enable_debug}" = "yes"])

IN_LINE=inline

case "$host" in
                *-solaris2*)
                        if test "x${ax_cv_c_compiler_vendor}"  = "xsun" ; then
                                SOLINK="-Bdynamic -dy -G"
                                new_AM_CFLAGS="-KPIC -DPIC"
                                new_AM_LDFLAGS="-R${prefix}/lib"
                                FUNC_DEF=__func__
                                IN_LINE=""
                        elif test "x${ax_cv_c_compiler_vendor}" = "xgnu" ; then
                                SOLINK="-Bdynamic -dy -G"
                                new_AM_CFLAGS="-fPIC -Wall -O4 -fexpensive-optimizations -funroll-loops"
                                new_AM_LDFLAGS=""
                                IN_LINE=inline
                        fi
                ;;
                *-darwin*)
                        if test "x${ax_cv_c_compiler_vendor}"="xgnu" ; then
                                SOLINK="-dynamic -bundle -force-flat-namespace"
                                new_AM_CFLAGS="-DMACOSX"
                                new_AM_LDFLAGS=""
                        fi
                ;;
                x86_64-*-linux-gnu)
                        if test "x${ax_cv_c_compiler_vendor}" = "xsun" ; then
                                SOLINK="-Bdynamic -dy -G"
                                new_AM_CFLAGS="-KPIC -DPIC"
                                new_AM_LDFLAGS="-R${prefix}/lib"
                                FUNC_DEF=__func__
                        elif test "x${ax_cv_c_compiler_vendor}"="xgnu" ; then
                               SOLINK="-shared -Xlinker -x"
                                new_AM_CFLAGS="-fPIC -Wall -O4 -fexpensive-optimizations -funroll-loops"
                                new_AM_LDFLAGS=""
                        fi
                ;;
                i*6-*-linux-gnu)
                        if test "x${ax_cv_c_compiler_vendor}" = "xsun" ; then
                                SOLINK="-Bdynamic -dy -G"
                                new_AM_CFLAGS="-KPIC -DPIC"
                                new_AM_LDFLAGS="-R${prefix}/lib"
                                FUNC_DEF=__func__
                        elif test "x${ax_cv_c_compiler_vendor}"="xgnu" ; then
                                SOLINK="-shared -Xlinker -x"
                                new_AM_CFLAGS="-fpic -Wall -O4 -fexpensive-optimizations -funroll-loops"
                                new_AM_LDFLAGS=""
                        fi
                ;;
		i*6*-*-freebsd*)
                        SOLINK="-shared -Xlinker -x"
                        new_AM_CFLAGS="-fPIC -Wall -O4 -fexpensive-optimizations -funroll-loops"
                        new_AM_LDFLAGS=""
		;;
		x86_64-*-freebsd*|amd64-*-freebsd*)
                        SOLINK="-shared -Xlinker -x"
                        new_AM_CFLAGS="-fPIC -Wall -O4 -fexpensive-optimizations -funroll-loops"
                        new_AM_LDFLAGS=""
		;;
esac

#  Enable 64 bit build
AC_ARG_ENABLE(64,
[AC_HELP_STRING([--enable-64],[build with 64 bit support])],[enable_64="$enable_64"],[enable_64="no"])

if test "x${ax_cv_c_compiler_vendor}"  =  "xsun" ; then
    if test "${enable_64}" = "yes"; then
        new_AM_CFLAGS="$new_AM_CFLAGS -m64"
    fi
fi

AC_SUBST(new_AM_CFLAGS)
AC_SUBST(new_AM_LDFLAGS)
AC_SUBST(SOLINK)
if test "x$FUNC_DEF" != "x"; then
   AC_DEFINE_UNQUOTED([__FUNCTION__],[$FUNC_DEF],[define it the right way ;)])
fi
AC_DEFINE_UNQUOTED([inline],[$IN_LINE],[sunpro is bad at inline])


AC_ARG_ENABLE(kernel-linux,
  [AS_HELP_STRING([--enable-kernel-linux],
		  [build library to run in Linux kernel context])],
  [], enable_kernel_linux=no)
AC_MSG_CHECKING(whether to build for Linux kernel context)
if test "$enable_kernel_linux" = "yes"; then
   AC_DEFINE(SRTP_KERNEL, 1,
	[Define to compile for kernel contexts.])
   AC_DEFINE(SRTP_KERNEL_LINUX, 1,
	[Define to compile for Linux kernel context.])
fi
AC_MSG_RESULT($enable_kernel_linux)

dnl Check for /dev/urandom
AC_CHECK_FILE(/dev/urandom, DEV_URANDOM=/dev/urandom,
   [AC_CHECK_FILE(/dev/random, DEV_URANDOM=/dev/random)])

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(stdlib.h)
AC_CHECK_HEADERS(unistd.h)
AC_CHECK_HEADERS(stdint.h)
AC_CHECK_HEADERS(sys/uio.h)
AC_CHECK_HEADERS(inttypes.h)
AC_CHECK_HEADERS(sys/types.h)
AC_CHECK_HEADERS(machine/types.h)
AC_CHECK_HEADERS(sys/int_types.h)

AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <inttypes.h>
#include <byteswap.h>
]],[[
uint64_t y = 0x1122334455667788LL;
bswap_64(y);
]])],byteswap_cv_bswap_64_usable=yes,byteswap_cv_bswap_64_usable=no)

if test "x${byteswap_cv_bswap_64_usable}" = "xyes" ; then
AC_DEFINE([HAVE_BYTESWAP_H],1,[define if you have a usable bswap_64 in byteswap.h])
fi

dnl socket() and friends
AC_CHECK_HEADERS(sys/socket.h netinet/in.h arpa/inet.h)
AC_CHECK_HEADERS(windows.h, [AC_CHECK_HEADERS(winsock2.h)])

AC_CHECK_HEADERS(syslog.h)

AC_CHECK_TYPES([int8_t,uint8_t,int16_t,uint16_t,int32_t,uint32_t,uint64_t])
AC_CHECK_SIZEOF(unsigned long)
AC_CHECK_SIZEOF(unsigned long long)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_SIZE_T

dnl Checks for library functions.
AC_CHECK_FUNCS(socket inet_aton usleep sigaction)

dnl Find socket function if not found yet.
if test "x$ac_cv_func_socket" = "xno"; then
  AC_CHECK_LIB(socket, socket)
  AC_MSG_CHECKING([for socket in -lwsock32])
  SAVELIBS="$LIBS"
  LIBS="$LIBS -lwsock32"
  AC_TRY_LINK([
#include <winsock2.h>
],[
socket(0, 0, 0);
],
    ac_cv_func_socket=yes
    AC_MSG_RESULT(yes),
    LIBS="$SAVELIBS"
    AC_MSG_RESULT(no))
fi

dnl Check the byte order
AC_C_BIGENDIAN


dnl check host_cpu type, set defines appropriately
case $host_cpu in
     i*86 | x86_64 )
	AC_DEFINE(CPU_CISC, 1,
	   [Define if building for a CISC machine (e.g. Intel).])
	# Do not enable use of asm for MACOSX
        if test "x$new_AM_CFLAGS" != "x-DMACOSX"; then 
	  AC_DEFINE(HAVE_X86, 1,
	   [Define to use X86 inlined assembly code]) 
	fi
	;;
	* )
	# CPU_RISC is only supported for big endian machines.
	if test "$ac_cv_c_bigendian" = "yes"; then
	   AC_DEFINE(CPU_RISC, 1,
	    [Define if building for a RISC machine (assume slow byte access).])
	else
	   AC_DEFINE(CPU_CISC, 1)
	fi
	;;
esac	

dnl Check if we're on a Windows platform.
case $host_os in
  *cygwin*|*mingw* ) 
	      EXE=.exe;;
         * )  EXE="";;
esac

AC_SUBST(EXE)   # define executable suffix; this is needed for `make clean'

AC_MSG_CHECKING(whether to compile in debugging)
AC_ARG_ENABLE(debug,
  [AS_HELP_STRING([--disable-debug],
		  [do not compile in dynamic debugging system])],
  [], enable_debug=yes)
if test "$enable_debug" = "yes"; then
   AC_DEFINE(ENABLE_DEBUGGING, 1,
      [Define to compile in dynamic debugging system.])
fi
AC_MSG_RESULT($enable_debug)

AC_MSG_CHECKING(whether to use ISMAcryp code)
AC_ARG_ENABLE(generic-aesicm,
  [AS_HELP_STRING([--enable-generic-aesicm],
		  [compile in changes for ISMAcryp])],
  [], enable_generic_aesicm=no)
if test "$enable_generic_aesicm" = "yes"; then
   AC_DEFINE(GENERIC_AESICM, 1, [Define this to use ISMAcryp code.])
fi
AC_MSG_RESULT($enable_generic_aesicm)

AC_MSG_CHECKING(whether to leverage OpenSSL crypto)
AC_ARG_ENABLE(openssl,
  [AS_HELP_STRING([--enable-openssl],
		  [compile in OpenSSL crypto engine])],
  [], enable_openssl=no)
if test "$enable_openssl" = "yes"; then
   echo $enable_openssl
   LDFLAGS="$LDFLAGS $(pkg-config --libs openssl)";
   CFLAGS="$CFLAGS $(pkg-config --cflags openssl)";

   AC_CHECK_LIB([crypto], [EVP_EncryptInit], [],
             [AC_MSG_FAILURE([can't find openssl >1.0.1 crypto lib])])
   AC_CHECK_LIB([crypto], [EVP_aes_128_ctr], [],
             [AC_MSG_FAILURE([can't find openssl >1.0.1 crypto lib])])
   AC_CHECK_LIB([crypto], [EVP_aes_128_gcm], [],
             [AC_MSG_FAILURE([can't find openssl >1.0.1 crypto lib])])
   AC_DEFINE(OPENSSL, 1, [Define this to use OpenSSL crypto.])
   AES_ICM_OBJS="crypto/cipher/aes_icm_ossl.o crypto/cipher/aes_gcm_ossl.o"
   HMAC_OBJS=crypto/hash/hmac_ossl.o
   USE_OPENSSL=1
   AC_SUBST(USE_OPENSSL)
else
   echo $enable_openssl
   AES_ICM_OBJS="crypto/cipher/aes_icm.o crypto/cipher/aes.o crypto/cipher/aes_cbc.o"
   AC_MSG_CHECKING(which random device to use)
   if test "$enable_kernel_linux" = "yes"; then
      AC_MSG_RESULT([Linux kernel builtin])
   else
      if test -n "$DEV_URANDOM"; then
         AC_DEFINE_UNQUOTED(DEV_URANDOM, "$DEV_URANDOM",[Path to random device])
         AC_MSG_RESULT([$DEV_URANDOM])
      else
         AC_MSG_RESULT([standard rand() function...])
      fi
   fi
   HMAC_OBJS="crypto/hash/hmac.o crypto/hash/sha1.o"
fi
AM_CONDITIONAL([ENABLE_OPENSSL],[test "${enable_openssl}" = "yes"])
AM_CONDITIONAL([GCM],[test "${enable_openssl}" = "yes"])

AC_SUBST(AES_ICM_OBJS)                              
AC_SUBST(HMAC_OBJS)
AC_MSG_RESULT($enable_openssl)

AC_MSG_CHECKING(whether to use syslog for error reporting)
AC_ARG_ENABLE(syslog,
  [AS_HELP_STRING([--enable-syslog], [use syslog for error reporting])],
  [], enable_syslog=no)
if test "$enable_syslog" = "yes"; then
   AC_DEFINE(USE_SYSLOG, 1, [Define to use syslog logging.])
fi
AC_MSG_RESULT($enable_syslog)

AC_MSG_CHECKING(whether to use stdout for error reporting)
AC_ARG_ENABLE(stdout,
  [AS_HELP_STRING([--disable-stdout], [don't use stdout for error reporting])],
  [], enable_stdout=yes)
if test "$enable_stdout" = "yes"; then
   AC_DEFINE(ERR_REPORTING_STDOUT, 1, [Define to use logging to stdout.])
fi
AC_MSG_RESULT($enable_stdout)

AC_MSG_CHECKING(whether to use /dev/console for error reporting)
AC_ARG_ENABLE(console,
  [AS_HELP_STRING([--enable-console], [use /dev/console for error reporting])],
  [], enable_console=no)
if test "$enable_console" = "yes"; then
   AC_DEFINE(USE_ERR_REPORTING_FILE, 1, [Write errors to this file])
   AC_DEFINE(ERR_REPORTING_FILE, "/dev/console", [Report errors to this file.])
fi
AC_MSG_RESULT($enable_console)

AC_CONFIG_HEADERS(crypto/include/config.h:config_in.h)

AC_OUTPUT(Makefile crypto/Makefile doc/Makefile libsrtp2.pc)

# This is needed when building outside the source dir.
AS_MKDIR_P(crypto/cipher)
AS_MKDIR_P(crypto/hash)
AS_MKDIR_P(crypto/kernel)
AS_MKDIR_P(crypto/math)
AS_MKDIR_P(crypto/replay)
AS_MKDIR_P(crypto/test)
AS_MKDIR_P(doc)
AS_MKDIR_P(srtp)
AS_MKDIR_P(tables)
AS_MKDIR_P(test)
