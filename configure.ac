# @configure_input@
#

AC_PREREQ([2.69])
AC_INIT([Marcos Bash Functions Library],[1.3b8],[marco.maggi-ipsu@poste.it],
  [mbfl],[http://github.com/marcomaggi/mbfl])
AC_CONFIG_SRCDIR([src/])
AM_INIT_AUTOMAKE

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET

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

AC_CHECK_PROG([BASH_PROGRAM],[bash],[bash],[:])

AC_CONFIG_FILES([Makefile meta/Makefile
  src/Makefile doc/Makefile tests/Makefile
  examples/Makefile
  meta/mbfl-config meta/mbfl.pc])
AC_OUTPUT

### end of file
# Local Variables:
# mode: autoconf
# page-delimiter: "^#page"
# End:
