# @configure_input@
#

AC_PREREQ([2.69])
AC_INIT([Marcos Bash Functions Library],[1.3.0],[marco.maggi-ipsu@poste.it],
  [mbfl],[http://github.com/marcomaggi/mbfl])
AC_CONFIG_SRCDIR([src/])
AM_INIT_AUTOMAKE

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET

AC_ARG_WITH([sendmail],
  AS_HELP_STRING([--with-sendmail],[enable installation of sendmail example script and emacs interface]),
  [true],[with_sendmail=false])
AM_CONDITIONAL([WANT_SENDMAIL],[test x$with_iconv = xyes])

AC_CONFIG_FILES([Makefile
  src/Makefile doc/Makefile tests/Makefile])
AC_OUTPUT

### end of file
# Local Variables:
# mode: autoconf
# page-delimiter: "^#page"
# End:
