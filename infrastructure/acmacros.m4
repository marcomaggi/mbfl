# acmacros --
# 
# Part of: DevelStuff
# Contents: more macros for GNU Autoconf
# Date: Thu Dec 18, 2003
# 
# Abstract
# 
# 
# 
# Copyright (c) 2003, 2007 Marco Maggi
# 
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
# 
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
# 

#page
## ------------------------------------------------------------
## Main macros.
## ------------------------------------------------------------

AC_DEFUN([DS_BEGIN],[
DS_DIRECTORIES

AC_ARG_ENABLE([versioned-layout],
    AC_HELP_STRING([--disable-versioned-layout], [Enable versioned directory layout.]), [
        if test "$enableval" = yes ; then
            ds_config_VERSIONED_LAYOUT=yes
        else
            ds_config_VERSIONED_LAYOUT=
        fi
        AC_SUBST([ds_config_VERSIONED_LAYOUT])
],[ds_config_VERSIONED_LAYOUT=yes])
])

AC_DEFUN([DS_END],[
DS_CONFIG_FILES
AC_OUTPUT
])

## ------------------------------------------------------------

AC_DEFUN([DS_CONFIG_FILES],[
AC_CONFIG_FILES([Makefile.library:infrastructure/Makefile.library.in])
AC_CONFIG_FILES([Makefile.ds])
AC_CONFIG_FILES([Makefile])
])

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Directories.
## ------------------------------------------------------------

AC_DEFUN([DS_DIRECTORIES],[
AC_SUBST([PKG_DIR],[\${PACKAGE_NAME_LOWERCASE}/\${PACKAGE_XVERSION}])
AC_SUBST([pkgdatadir],[\${datadir}/\${PKG_DIR}])
AC_SUBST([pkgdocdir],[\${docdir}/\${PKG_DIR}])
AC_SUBST([pkgexampledir],[\${pkgdocdir}/examples])
AC_SUBST([pkghtmldir],[\${pkgdocdir}/HTML])
AC_SUBST([pkginfodir],[\${pkgdocdir}/info])
AC_SUBST([pkgincludedir],[\${includedir}/\${PKG_DIR}])
AC_SUBST([pkglibdir],[\${libdir}/\${PKG_DIR}])
AC_SUBST([pkglibexecdir],[\${libexecdir}/\${PKG_DIR}])
AC_SUBST([pkgsysconfdir],[\${sysconfdir}/\${PKG_DIR}])
])

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Programs.
## ------------------------------------------------------------

AC_DEFUN([DS_COMMON_PROGRAMS],[
AC_PROG_INSTALL
AC_PROG_MAKE_SET

DS_PROGRAM_BASH_PROGRAM
DS_PROGRAM_BZIP
DS_PROGRAM_CAT
DS_PROGRAM_CP
DS_PROGRAM_DATE
DS_PROGRAM_GAWK
DS_PROGRAM_GREP
DS_PROGRAM_GZIP
DS_PROGRAM_M4
DS_PROGRAM_MAKEINFO
DS_PROGRAM_MKDIR
DS_PROGRAM_MV
DS_PROGRAM_RM
DS_PROGRAM_RMDIR
DS_PROGRAM_SED
DS_PROGRAM_SUDO
DS_PROGRAM_SYMLINK
DS_PROGRAM_TAR

CURRENT_DATE=$($DATE)
AC_SUBST(CURRENT_DATE)
])

AC_DEFUN([DS_P_MAKE_PROGRAM_DEFUN],[
AC_DEFUN([DS_PROGRAM_$1],[AC_PATH_PROG([$1], [$2], :)
AC_ARG_VAR([$1], [$3])])])

DS_P_MAKE_PROGRAM_DEFUN([BASH_PROGRAM],[bash],[the GNU bash shell])
DS_P_MAKE_PROGRAM_DEFUN([BZIP],[bzip2],[the bzip2 compressor program])
DS_P_MAKE_PROGRAM_DEFUN([CAT],[cat],[the GNU cat program])
DS_P_MAKE_PROGRAM_DEFUN([CP],[cp],[copies files])
DS_P_MAKE_PROGRAM_DEFUN([DATE],[date],[a program that prints the current date])
DS_P_MAKE_PROGRAM_DEFUN([GAWK],[gawk],[the GNU awk program])
DS_P_MAKE_PROGRAM_DEFUN([GREP],[grep],[the GNU grep program])
DS_P_MAKE_PROGRAM_DEFUN([GZIP],[gzip],[the gzip compressor program])
DS_P_MAKE_PROGRAM_DEFUN([M4],[m4],[the GNU m4 preprocessor])
DS_P_MAKE_PROGRAM_DEFUN([MAKEINFO],[makeinfo],[builds docs from Texinfo source])
DS_P_MAKE_PROGRAM_DEFUN([MKDIR],[mkdir],[creates directories recursively])
DS_P_MAKE_PROGRAM_DEFUN([MV],[mv],[move files around])
DS_P_MAKE_PROGRAM_DEFUN([RM],[rm],[deletes files and directories recursively])
DS_P_MAKE_PROGRAM_DEFUN([RMDIR],[rmdir],[deletes empty directories])
DS_P_MAKE_PROGRAM_DEFUN([SED],[sed],[the GNU sed program])
DS_P_MAKE_PROGRAM_DEFUN([SUDO],[sudo],[the sudo superuser executor])
DS_P_MAKE_PROGRAM_DEFUN([SYMLINK],[ln],[program used create symbolic links])
DS_P_MAKE_PROGRAM_DEFUN([TAR],[tar],[the GNU tar program])

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Slackware stuff.
## ------------------------------------------------------------

AC_DEFUN([DS_SLACKWARE_PROGRAMS],[

AC_ARG_ENABLE([local-slackware],
AC_HELP_STRING([--enable-local-slackware],
    [Enable usage of Slackware tools in '${prefix}/sbin'.]),[
if test "$enableval" = yes ; then
    ds_config_LOCAL_SLACKWARE=yes
else
    ds_config_LOCAL_SLACKWARE=no
fi
],[ds_config_LOCAL_SLACKWARE=yes])

## ------------------------------------------------------------

AC_ARG_ENABLE([slackware-rootdir],
    AC_HELP_STRING([--enable-slackware-rootdir=DIR],
        [Select root directory for Slackware tools (default: ${prefix}).]),[
        if test "x$enableval" != 'x' ; then
            ds_slackware_ROOTDIR=${enableval}
        else
            ds_slackware_ROOTDIR='$(prefix)'
        fi
        AC_SUBST([ds_slackware_ROOTDIR])
],[ds_slackware_ROOTDIR='$(prefix)'])
AC_MSG_NOTICE([Slackware packaging tools will use ROOT=${ds_slackware_ROOTDIR}])

## ------------------------------------------------------------

if test "${ds_config_LOCAL_SLACKWARE}" = 'yes' ; then
AC_SUBST([ds_slackware_PATH],['$$(prefix)/sbin:/sbin:$$(PATH)'])
else
AC_SUBST([ds_slackware_PATH],['/sbin:$$(PATH)'])
fi

## ------------------------------------------------------------

if test "${ds_config_LOCAL_SLACKWARE}" = 'yes' ; then
    AC_PATH_PROG([ds_slackware_MAKEPKG_PROGRAM],[makepkg],[:],[${prefix}/sbin:/sbin:${PATH}])
else
    AC_PATH_PROG([ds_slackware_MAKEPKG_PROGRAM],[makepkg],[:],[/sbin:${PATH}])
fi
AC_ARG_VAR([ds_slackware_MAKEPKG_PROGRAM],[Slackware Linux package maker.])

## ------------------------------------------------------------

if test "${ds_config_LOCAL_SLACKWARE}" = 'yes' ; then
    AC_PATH_PROG([ds_slackware_INSTALLPKG_PROGRAM],[installpkg],[:],[${prefix}/sbin:/sbin:${PATH}])
else
    AC_PATH_PROG([ds_slackware_INSTALLPKG_PROGRAM],[installpkg],[:],[/sbin:${PATH}])
fi
AC_ARG_VAR([ds_slackware_INSTALLPKG_PROGRAM],[Slackware Linux package installer.])

## ------------------------------------------------------------

if test "${ds_config_LOCAL_SLACKWARE}" = 'yes' ; then
    AC_PATH_PROG([ds_slackware_REMOVEPKG_PROGRAM],[removepkg],[:],[${prefix}/sbin:/sbin:${PATH}])
else
    AC_PATH_PROG([ds_slackware_REMOVEPKG_PROGRAM],[removepkg],[:],[/sbin:${PATH}])
fi
AC_ARG_VAR([ds_slackware_REMOVEPKG_PROGRAM],[Slackware Linux package remover.])

## ------------------------------------------------------------

if test "${ds_config_LOCAL_SLACKWARE}" = 'yes' ; then
    AC_PATH_PROG([ds_slackware_UPGRADEPKG_PROGRAM],[upgradepkg],[:],[${prefix}/sbin:/sbin:${PATH}])
else
    AC_PATH_PROG([ds_slackware_UPGRADEPKG_PROGRAM],[upgradepkg],[:],[/sbin:${PATH}])
fi
AC_ARG_VAR([ds_slackware_UPGRADEPKG_PROGRAM],[Slackware Linux package upgrader.])

])

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Application specific macros.
## ------------------------------------------------------------

AC_DEFUN([DS_CHECK_TCLPKG], [
    if test -z "${TCLSH}"; then
	AC_MSG_WARN([cannot test for package $1, TCLSH not set])
    else
	AC_MSG_CHECKING([package $1])

	changequote(<, >)
	ds_tmp=$(echo "if { [catch {package require $1 $2}] } \
	    { puts 1 }; exit" | ${TCLSH})
	changequote([, ])

	if test "${ds_tmp}" != "1"; then
	    ds_tmp=yes
	else
	    ds_tmp=no
	fi
	AC_MSG_RESULT([$ds_tmp])
    fi
])


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE"
# End:
