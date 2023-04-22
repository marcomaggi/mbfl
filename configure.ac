# @configure_input@
#

AC_PREREQ([2.69])
MMUX_PKG_VERSIONS([3],[0],[0],[devel.8],[noarch])
AC_INIT([Marcos Bash Functions Library],MMUX_PACKAGE_VERSION,[mrc.mgg@gmail.com],
  [mbfl],[http://github.com/marcomaggi/mbfl])
MMUX_INIT
dnl This is the revision number of this configure.ac
AC_REVISION([0.1])
AC_COPYRIGHT([Copyright (c) 2003-2005, 2009-2010, 2012-2014, 2017-2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>

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
AM_INIT_AUTOMAKE([1.16 foreign subdir-objects info-in-builddir])
AM_MAINTAINER_MODE

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AM_PATH_LISPDIR

AC_SUBST([MBFL_CORE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL)
AC_SUBST([MBFL_SEMANTIC_VERSION],MMUX_PACKAGE_SEMANTIC_VERSION)


#### external programs

AC_PATH_PROG([MBFL_PROGRAM_BASH],       [bash])
AC_PATH_PROG([MBFL_PROGRAM_M4],         [m4])
AC_PATH_PROG([MBFL_PROGRAM_SUDO],       [sudo])
AC_PATH_PROG([MBFL_PROGRAM_GAWK],       [gawk])

# The following are the GNU Coreutils.
AC_PATH_PROG([MBFL_PROGRAM_CHGRP],	[chgrp])
AC_PATH_PROG([MBFL_PROGRAM_CHMOD],	[chmod])
AC_PATH_PROG([MBFL_PROGRAM_CHOWN],	[chown])
AC_PATH_PROG([MBFL_PROGRAM_CP],         [cp])
AC_PATH_PROG([MBFL_PROGRAM_DATE],	[date])
AC_PATH_PROG([MBFL_PROGRAM_ID],         [id])
AC_PATH_PROG([MBFL_PROGRAM_INSTALL],	[install])
AC_PATH_PROG([MBFL_PROGRAM_LN],         [ln])
AC_PATH_PROG([MBFL_PROGRAM_LS],         [ls])
AC_PATH_PROG([MBFL_PROGRAM_MKDIR],	[mkdir])
AC_PATH_PROG([MBFL_PROGRAM_MKFIFO],	[mkfifo])
AC_PATH_PROG([MBFL_PROGRAM_MV],         [mv])
AC_PATH_PROG([MBFL_PROGRAM_READLINK],	[readlink])
AC_PATH_PROG([MBFL_PROGRAM_REALPATH],	[realpath])
AC_PATH_PROG([MBFL_PROGRAM_RMDIR],	[rmdir])
AC_PATH_PROG([MBFL_PROGRAM_RM],         [rm])
AC_PATH_PROG([MBFL_PROGRAM_SLEEP],	[sleep])
AC_PATH_PROG([MBFL_PROGRAM_STAT],	[stat])
AC_PATH_PROG([MBFL_PROGRAM_WHOAMI],	[whoami])


#### sendmail interface

AC_ARG_WITH([sendmail],
  AS_HELP_STRING([--with-sendmail],[enable installation of sendmail example script and emacs interface]),
  [true],[with_sendmail=no])
AC_MSG_CHECKING([whether sendmail support will be installed])
AS_VAR_IF(with_sendmail,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_SENDMAIL],[test x$with_sendmail = xyes])

AC_ARG_WITH([vc],
  AS_HELP_STRING([--with-vc],[enable installation of vc example script]),
  [true],[with_vc=no])
AC_MSG_CHECKING([whether vc script will be installed])
AS_VAR_IF(with_vc,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_VC],[test x$with_vc = xyes])

AC_ARG_WITH([semver],
  AS_HELP_STRING([--with-semver],[enable installation of semver example script]),
  [true],[with_semver=no])
AC_MSG_CHECKING([whether semver script will be installed])
AS_VAR_IF(with_semver,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_SEMVER],[test x$with_semver = xyes])

AC_ARG_WITH([emacs],
  AS_HELP_STRING([--with-emacs],[enable installation of GNU Emacs module]),
  [true],[with_emacs=no])
AC_MSG_CHECKING([whether GNU Emacs module will be installed])
AS_VAR_IF(with_emacs,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_EMACS],[test x$with_emacs = xyes])


#### let's go

AC_CONFIG_FILES([Makefile]
  [src/bin/mbflpp.bash.m4]
  [src/modules/config-values.bash.m4])
MMUX_OUTPUT
AC_OUTPUT

### end of file
