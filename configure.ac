# configure.ds --
# 
# Part of: Marco's BASH Functions Library
# Contents: configuration script
# Date: Sat Apr 19, 2003
# 
# Abstract
# 
#	Configuration script. This template must be parsed by GNU
#	autoconf to build the "configure" executable script.
# 
# Copyright (c) 2003, 2004 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
# your option) any later version.
# 
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
# 
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA
# 


#PAGE
## ------------------------------------------------------------
## Initialisation.
## ------------------------------------------------------------

AC_INIT([mbfl], [0.7.4], [marcomaggi@tiscalinet.it])
AC_PREREQ(2.57)
AC_COPYRIGHT([Copyright (C) 2003, 2004 by Marco Maggi])
AC_REVISION([$Revision: 1.1.1.131 $])

AC_CONFIG_SRCDIR([./lib/libmbfl.sh.m4])
AC_CONFIG_AUX_DIR([gnuconfig])
AC_SUBST([CONFIGDIR], ["\$(top_srcdir)/gnuconfig"])

AC_SUBST([PACKAGE_XVERSION], [0.7b4])
AC_DEFINE([PACKAGE_XVERSION], ["0.7b4"], [full version])
AC_SUBST([PACKAGE_NODOT_VERSION], [07])
AC_SUBST([PACKAGE_NAME_UPPERCASE], [MBFL])
AC_SUBST([PACKAGE_NAME_LOWERCASE], [mbfl])

AC_SUBST([PACKAGE_VERSION_MAJMIN], [0.7])
AC_SUBST([PACKAGE_VERSION_MAJOR], [0])
AC_SUBST([PACKAGE_VERSION_MINOR], [7])
AC_SUBST([PACKAGE_VERSION_PATCH], [4])

#PAGE
## ------------------------------------------------------------
## Common programs.
## ------------------------------------------------------------

AC_PROG_INSTALL
AC_PROG_MAKE_SET

AC_CHECK_PROG([BASH], [bash], [bash], :)
AC_ARG_VAR([BASH], [the GNU bash shell])

AC_CHECK_PROG([RM], [rm], [rm -f -r], :)
AC_ARG_VAR([RM], [program used to delete files and directories recursively])

AC_CHECK_PROG([SYMLINK], [ln], [ln -sv], :)
AC_ARG_VAR([SYMLINK], [program used create symbolic links])

AC_CHECK_PROG([MKDIR], [mkdir], [mkdir -p], :)
AC_ARG_VAR([MKDIR], [program used to create directories recursively])

AC_CHECK_PROG([DPKG], [dpkg], [dpkg], :)
AC_ARG_VAR([DPKG], [program used to build .deb packages])

AC_CHECK_PROG([M4], [m4], [m4], :)
AC_ARG_VAR([M4], [the GNU m4 preprocessor])

AC_PATH_PROG([TCLSH], [tclsh], :)
AC_ARG_VAR([TCLSH], [the TCL shell used to run tests and scripts, full pathname])

AC_CHECK_PROG([MAKEINFO], [makeinfo], [makeinfo], :)
AC_ARG_VAR([MAKEINFO], [program that builds documentation from Texinfo source])

AC_CHECK_PROG([DATE], [date], [date], :)
AC_ARG_VAR([DATE], [the standard date program])

AC_CHECK_PROG([SED], [sed], [sed], :)
AC_CHECK_PROG([GREP], [grep], [grep], :)

AC_CHECK_PROG([SPKG], [spkg.sh], [spkg.sh], :)

CURRENT_DATE=$($DATE)
AC_SUBST(CURRENT_DATE)


AC_CHECK_PROG([SED], [sed], [sed], :)
AC_CHECK_PROG([GREP], [grep], [grep], :)

#PAGE
## ------------------------------------------------------------
## Finalisation.
## ------------------------------------------------------------

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([meta/DESCRIPTION.txt])

AC_CONFIG_FILES([debian/dev/control])
AC_CONFIG_FILES([debian/doc/control])

AC_OUTPUT


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE"
# End:
