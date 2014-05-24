# @configure_input@
#

AC_PREREQ([2.69])
AC_INIT([Marcos Bash Functions Library],[2.0d2],[marco.maggi-ipsu@poste.it],
  [mbfl],[http://github.com/marcomaggi/mbfl])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_MACRO_DIR([autotools])
AC_CONFIG_AUX_DIR([autotools])
AM_INIT_AUTOMAKE([foreign dist-xz no-dist-gzip subdir-objects])
AM_MAINTAINER_MODE

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_CHECK_PROG([BASH_PROGRAM],[bash],[bash],[:])
AM_PATH_LISPDIR

AC_ARG_WITH([sendmail],
  AS_HELP_STRING([--with-sendmail],[enable installation of sendmail example script and emacs interface]),
  [true],[with_sendmail=no])
AC_MSG_CHECKING([whether sendmail support will be installed])
if test x$with_sendmail = xyes
then
  AC_MSG_RESULT([yes])
else
  AC_MSG_RESULT([no])
fi
AM_CONDITIONAL([WANT_SENDMAIL],[test x$with_sendmail = xyes])

AC_CONFIG_FILES([Makefile]
  [meta/mbfl-config]
  [meta/mbfl.pc])
AC_OUTPUT

### end of file
# Local Variables:
# mode: autoconf
# page-delimiter: "^#page"
# End:
