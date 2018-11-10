# @configure_input@
#

AC_PREREQ([2.69])
MMUX_PKG_VERSIONS([3],[0],[0],[devel.0],[noarch])
AC_INIT([Marcos Bash Functions Library],MMUX_PACKAGE_VERSION,[marco.maggi-ipsu@poste.it],
  [mbfl],[http://github.com/marcomaggi/mbfl])
MMUX_INIT
dnl This is the revision number of this configure.ac
AC_REVISION([0.1])
AC_COPYRIGHT([Copyright (c) 2003-2005, 2009-2010, 2012-2014, 2017-2018 Marco Maggi <marco.maggi-ipsu@poste.it>

This is  free software; you can  redistribute it and/or modify  it under
the terms of  the GNU Lesser General Public License  as published by the
Free Software Foundation; either version 3.0 of the License, or (at your
option) any later version.

This library  is distributed  in the  hope that it  will be  useful, but
WITHOUT   ANY   WARRANTY;  without   even   the   implied  warranty   of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this library; if not,  write to the Free Software Foundation,
Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_MACRO_DIR([meta/autotools])
AC_CONFIG_AUX_DIR([meta/autotools])
AM_INIT_AUTOMAKE([1.14 -Wall foreign subdir-objects info-in-builddir])
AM_MAINTAINER_MODE

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_CHECK_PROG([BASH_PROGRAM],[bash],[bash],[:])
AM_PATH_LISPDIR

AC_SUBST([MBFL_CORE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL)

dnl --------------------------------------------------------------------

AC_ARG_WITH([sudo],
  AS_HELP_STRING([--with-sudo],[select a pathname for the executable sudo]),
  [PATHNAME_SUDO=$withval],
  [PATHNAME_SUDO=/usr/bin/sudo])

AC_CHECK_PROG(PATHNAME_SUDO,$PATHNAME_SUDO,$PATHNAME_SUDO)
AC_SUBST([PATHNAME_SUDO])

dnl --------------------------------------------------------------------

AC_ARG_WITH([whoami],
  AS_HELP_STRING([--with-whoami],[select a pathname for the executable whoami]),
  [PATHNAME_WHOAMI=$withval],
  [PATHNAME_WHOAMI=/usr/bin/whoami])

AC_CHECK_PROG(PATHNAME_WHOAMI,$PATHNAME_WHOAMI,$PATHNAME_WHOAMI)
AC_SUBST([PATHNAME_WHOAMI])

dnl --------------------------------------------------------------------

AC_ARG_WITH([sendmail],
  AS_HELP_STRING([--with-sendmail],[enable installation of sendmail example script and emacs interface]),
  [true],[with_sendmail=no])
AC_MSG_CHECKING([whether sendmail support will be installed])
AS_VAR_IF(with_sendmail,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_SENDMAIL],[test x$with_sendmail = xyes])

AC_CONFIG_FILES([Makefile]
  [meta/scripts/mbfl-config])
MMUX_OUTPUT
AC_OUTPUT

### end of file
