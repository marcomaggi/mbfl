# @configure_input@
#

AC_PREREQ([2.69])
MMUX_PKG_VERSIONS([3],[0],[0],[devel.6],[noarch])
AC_INIT([Marcos Bash Functions Library],MMUX_PACKAGE_VERSION,[mrc.mgg@gmail.com],
  [mbfl],[http://github.com/marcomaggi/mbfl])
MMUX_INIT
dnl This is the revision number of this configure.ac
AC_REVISION([0.1])
AC_COPYRIGHT([Copyright (c) 2003-2005, 2009-2010, 2012-2014, 2017-2018, 2020 Marco Maggi <mrc.mgg@gmail.com>

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

AC_ARG_WITH([bash],
  AS_HELP_STRING([--with-bash],[select a pathname for the executable bash]),
  [MBFL_PROGRAM_BASH=$withval],
  [MBFL_PROGRAM_BASH=/bin/bash])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_BASH],[$MBFL_PROGRAM_BASH],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([sudo],
  AS_HELP_STRING([--with-sudo],[select a pathname for the executable sudo]),
  [MBFL_PROGRAM_SUDO=$withval],
  [MBFL_PROGRAM_SUDO=/usr/bin/sudo])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_SUDO],[$MBFL_PROGRAM_SUDO],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([whoami],
  AS_HELP_STRING([--with-whoami],[select a pathname for the executable whoami]),
  [MBFL_PROGRAM_WHOAMI=$withval],
  [MBFL_PROGRAM_WHOAMI=/bin/whoami])

dnl Remember  that  "AC_PATH_PROG"  already  calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_WHOAMI],[$MBFL_PROGRAM_WHOAMI],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([id],
  AS_HELP_STRING([--with-id],[select a pathname for the executable id]),
  [MBFL_PROGRAM_ID=$withval],
  [MBFL_PROGRAM_ID=/bin/id])

dnl Remember  that  "AC_PATH_PROG"  already  calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_ID],[$MBFL_PROGRAM_ID],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([stat],
  AS_HELP_STRING([--with-stat],[select a pathname for the executable stat]),
  [MBFL_PROGRAM_STAT=$withval],
  [MBFL_PROGRAM_STAT=/bin/stat])

dnl Remember  that  "AC_PATH_PROG"  already  calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_STAT],[$MBFL_PROGRAM_STAT],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([chown],
  AS_HELP_STRING([--with-chown],[select a pathname for the executable chown]),
  [MBFL_PROGRAM_CHOWN=$withval],
  [MBFL_PROGRAM_CHOWN=/bin/chown])

dnl Remember  that  "AC_PATH_PROG"  already  calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_CHOWN],[$MBFL_PROGRAM_CHOWN],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([chgrp],
  AS_HELP_STRING([--with-chgrp],[select a pathname for the executable chgrp]),
  [MBFL_PROGRAM_CHGRP=$withval],
  [MBFL_PROGRAM_CHGRP=/bin/chgrp])

dnl Remember  that  "AC_PATH_PROG"  already  calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_CHGRP],[$MBFL_PROGRAM_CHGRP],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([chmod],
  AS_HELP_STRING([--with-chmod],[select a pathname for the executable chmod]),
  [MBFL_PROGRAM_CHMOD=$withval],
  [MBFL_PROGRAM_CHMOD=/bin/chmod])

dnl Remember  that  "AC_PATH_PROG"  already  calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_CHMOD],[$MBFL_PROGRAM_CHMOD],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([realpath],
  AS_HELP_STRING([--with-realpath],[select a pathname for the executable realpath]),
  [MBFL_PROGRAM_REALPATH=$withval],
  [MBFL_PROGRAM_REALPATH=/bin/realpath])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_REALPATH],[$MBFL_PROGRAM_REALPATH],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([readlink],
  AS_HELP_STRING([--with-readlink],[select a pathname for the executable readlink]),
  [MBFL_PROGRAM_READLINK=$withval],
  [MBFL_PROGRAM_READLINK=/bin/readlink])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_READLINK],[$MBFL_PROGRAM_READLINK],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([ls],
  AS_HELP_STRING([--with-ls],[select a pathname for the executable ls]),
  [MBFL_PROGRAM_LS=$withval],
  [MBFL_PROGRAM_LS=/bin/ls])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_LS],[$MBFL_PROGRAM_LS],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([rm],
  AS_HELP_STRING([--with-rm],[select a pathname for the executable rm]),
  [MBFL_PROGRAM_RM=$withval],
  [MBFL_PROGRAM_RM=/bin/rm])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_RM],[$MBFL_PROGRAM_RM],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([rmdir],
  AS_HELP_STRING([--with-rmdir],[select a pathname for the executable rmdir]),
  [MBFL_PROGRAM_RMDIR=$withval],
  [MBFL_PROGRAM_RMDIR=/bin/rmdir])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_RMDIR],[$MBFL_PROGRAM_RMDIR],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([mv],
  AS_HELP_STRING([--with-mv],[select a pathname for the executable mv]),
  [MBFL_PROGRAM_MV=$withval],
  [MBFL_PROGRAM_MV=/bin/mv])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_MV],[$MBFL_PROGRAM_MV],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([cp],
  AS_HELP_STRING([--with-cp],[select a pathname for the executable cp]),
  [MBFL_PROGRAM_CP=$withval],
  [MBFL_PROGRAM_CP=/bin/cp])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_CP],[$MBFL_PROGRAM_CP],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([mkdir],
  AS_HELP_STRING([--with-mkdir],[select a pathname for the executable mkdir]),
  [MBFL_PROGRAM_MKDIR=$withval],
  [MBFL_PROGRAM_MKDIR=/bin/mkdir])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_MKDIR],[$MBFL_PROGRAM_MKDIR],[/bin/false])

dnl --------------------------------------------------------------------

AC_ARG_WITH([ln],
  AS_HELP_STRING([--with-ln],[select a pathname for the executable ln]),
  [MBFL_PROGRAM_LN=$withval],
  [MBFL_PROGRAM_LN=/bin/ln])

dnl Remember  that  "AC_PATH_PROG"  already calls  "AC_SUBST"  for  its
dnl variable argument.
AC_PATH_PROG([MBFL_PROGRAM_LN],[$MBFL_PROGRAM_LN],[/bin/false])


#### sendmail interface

AC_ARG_WITH([sendmail],
  AS_HELP_STRING([--with-sendmail],[enable installation of sendmail example script and emacs interface]),
  [true],[with_sendmail=no])
AC_MSG_CHECKING([whether sendmail support will be installed])
AS_VAR_IF(with_sendmail,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_SENDMAIL],[test x$with_sendmail = xyes])


#### let's go

AC_CONFIG_FILES([Makefile]
  [meta/scripts/mbfl-config]
  [tests/setup.sh]
  [src/modules/config-pathnames.sh.m4])
MMUX_OUTPUT
AC_OUTPUT

### end of file
