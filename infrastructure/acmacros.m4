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
AC_SYS_INTERPRETER
AC_SYS_LARGEFILE
AC_SYS_LONG_FILE_NAMES
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
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

ds_VARIABLES=
])

AC_DEFUN([DS_END],[

if test -n "${ds_VARIABLES}" ; then
    echo "${ds_VARIABLES}" >${srcdir}/configuration/Makefile.variables.in
fi

DS_CONFIG_FILES
AC_OUTPUT
])

## ------------------------------------------------------------

# Synopsis:
#
#       DS_ADD_VARIABLES([...])
#
# Description:
#
#  Everything inside the square brackets is put in the
#  confguration file "Makefile.variables.in", where
#  it will undergo "configure"'s symbols substitution.

AC_DEFUN([DS_ADD_VARIABLES],[
ds_VARIABLES=$(printf '%s\n%s' "${ds_VARIABLES}" "$1")
])

## ------------------------------------------------------------

AC_DEFUN([DS_CONFIG_FILES],[
AC_CONFIG_FILES([Makefile.library:${ds_top_srcdir}/infrastructure/Makefile.library.in])
AC_CONFIG_FILES([Makefile.ds:${srcdir}/configuration/Makefile.ds.in])
AC_CONFIG_FILES([Makefile])
if test -n "${ds_VARIABLES}" ; then
AC_CONFIG_FILES([Makefile.variables:${srcdir}/configuration/Makefile.variables.in])
fi
])

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Directories.
## ------------------------------------------------------------

AC_DEFUN([DS_DIRECTORIES],[
AC_SUBST([ds_top_srcdir],[${srcdir}])

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
## C language macros.
## ------------------------------------------------------------

# Synopsis:
#
#       DS_C_LANGUAGE
#
# Description:
#
#  Add common stuff for C compiler usage.

AC_DEFUN([DS_C_LANGUAGE],[

AC_CONFIG_HEADERS(config.h)

AC_ARG_ENABLE([assert],
    AC_HELP_STRING([--disable-assert],[disable assertions]),[
        if test "$enableval" = yes ; then
            ds_config_ENABLE_ASSERTIONS=yes
        else
            ds_config_ENABLE_ASSERTIONS=no
        fi],[ds_config_ENABLE_ASSERTIONS=yes])
AC_DEFINE_UNQUOTED([ds_config_ENABLE_ASSERTIONS],
    [$ds_config_ENABLE_ASSERTIONS],[turns off assertions])
AC_SUBST([ds_config_ENABLE_ASSERTIONS])

AC_DEFINE([_GNU_SOURCE],[1],[GNU libc symbol, see its documentation])

## ------------------------------------------------------------
## Compiler stuff.

# Programs.
AC_PROG_CC
AC_PROG_CC_C_O
AC_PROG_CPP
AC_PROG_RANLIB
AC_PATH_PROG([AR],[ar],:)
AC_PATH_PROG([STRIP], [strip],:)
AC_PATH_PROG([GDB],[GDB],:)
#AC_PROG_CC_STDC
AC_PROG_CC_C99

# Headers and C compiler features.
AC_INCLUDES_DEFAULT
AC_HEADER_STDC
AC_CHECK_HEADERS([assert.h])
AC_CHECK_HEADERS([limits.h])
AC_CHECK_HEADERS([dlfcn.h])
AC_C_BIGENDIAN
AC_C_CHAR_UNSIGNED
AC_C_CONST
AC_C_FLEXIBLE_ARRAY_MEMBER
AC_C_INLINE
AC_C_TYPEOF
AC_C_RESTRICT
AC_C_VARARRAYS
AC_C_VOLATILE
AC_CHECK_TYPES([ptrdiff_t])
AC_TYPE_SIZE_T
AC_FUNC_MALLOC
AC_CHECK_FUNCS([memmove memset strerror strchr])

AC_SUBST([NO_MINUS_C_MINUS_O])
AC_ARG_VAR([GNU_C_FLAGS],[fixed GNU C compiler flags])

## ------------------------------------------------------------
## Preprocessor stuff.

AC_ARG_VAR([INCLUDES],[directory options for include files])

# Note: 'DEFS' substitution is automatically handled.
# Note: 'CPPFLAGS' substitution is automatically handled.

## ------------------------------------------------------------
## Linker stuff.

AC_SUBST([LIBS])
AC_SUBST([LDFLAGS_RPATH],['-Wl,-rpath,$(libdir)'])
AC_ARG_VAR([LDFLAGS],[fixed linker flags])

AC_CHECK_LIB([dl],[dlopen],[LDFLAGS_DL=-ldl])
AC_SUBST(LDFLAGS_DL)

## ------------------------------------------------------------

AC_CACHE_SAVE
])

## ------------------------------------------------------------

# Synopsis:
#
#       DS_C_LANGUAGE_COMMON_LIBRARY
#
# Description:
#
#  Add common stuff for C language library building.

AC_DEFUN([DS_C_LANGUAGE_COMMON_LIBRARY],[

AC_ARG_ENABLE([shared],
    AC_HELP_STRING([--enable-shared],[enable shared library (default: ENabled)]),[
        if test "$enableval" = yes ; then
            ds_config_ENABLE_SHARED=yes
        else
            ds_config_ENABLE_SHARED=no
        fi],[ds_config_ENABLE_SHARED=yes])
AC_SUBST([ds_config_ENABLE_SHARED])

AC_ARG_ENABLE([static],
    AC_HELP_STRING([--enable-static],[enable static library (default: DISabled)]),[
        if test "$enableval" = yes ; then
            ds_config_ENABLE_STATIC=yes
        else
            ds_config_ENABLE_STATIC=no
        fi],[ds_config_ENABLE_STATIC=no])
AC_SUBST([ds_config_ENABLE_STATIC])

])

# Synopsis:
#
#       DS_C_LANGUAGE_COMMON_STUB_LIBRARY
#
# Description:
#
#  Add common stuff for C language stub library building.

AC_DEFUN([DS_C_LANGUAGE_COMMON_STUB_LIBRARY],[

AC_ARG_ENABLE([stub-library],
    AC_HELP_STRING([--enable-stub-library],[enable building of stub library (default: ENabled)]),[
        if test "$enableval" = yes ; then
            ds_config_ENABLE_STUB=yes
        else
            ds_config_ENABLE_STUB=no
        fi],[ds_config_ENABLE_STUB=yes])
AC_SUBST([ds_config_ENABLE_STUB])

])

## ------------------------------------------------------------

# Synopsis:
#
#       DS_C_LANGUAGE_LIBRARY(<LIBRARY_PREFIX>,<MAJOR_INTERFACE_VERSION>,<MINOR_INTERFACE_VERSION>)
#
# Description:
#
#  Add stuff for a specific library. Example:
#
#       DS_C_LANGUAGE_LIBRARY([ucl],[1],[2])
#
#  declares a library whose identifier is 'ucl' and whose
#  interface version is '1.2':
#
#  - the shared library file name will be 'libucl1.2.so';
#
#  - the shared library file name will be 'libucl1.2.a';
#
#  - to link with the library we will do '-lucl1.2'.
#
#  Variables definitions are put in "Makefile.variables.in".

AC_DEFUN([DS_C_LANGUAGE_LIBRARY],[
DS_C_LANGUAGE_LIBRARY_STUB(m4_translit($1,-,_),$2,$3,$1)
])

AC_DEFUN([DS_C_LANGUAGE_LIBRARY_STUB],[

AC_SUBST([$1_LIBRARY_ID],[$4$2.$3])
AC_SUBST([$1_INTERFACE_VERSION],[$2.$3])
AC_SUBST([$1_INTERFACE_MAJOR_VERSION],[$2])
AC_SUBST([$1_INTERFACE_MINOR_VERSION],[$3])

AC_DEFINE([$1_LIBRARY_ID],[$4$2.$3],[the library identifier])
AC_DEFINE([$1_INTERFACE_VERSION],[$2.$3],[library interface version])
AC_DEFINE([$1_INTERFACE_MAJOR_VERSION],[$2],[library interface major version])
AC_DEFINE([$1_INTERFACE_MINOR_VERSION],[$3],[library interface minor version])

$1_SHARED_LIBRARY_NAME=lib${$1_LIBRARY_ID}.so
$1_STATIC_LIBRARY_NAME=lib${$1_LIBRARY_ID}.a

$1_stub_SHARED_LIBRARY_ID=$4stub$2.$3
$1_stub_SHARED_LIBRARY_NAME=lib${$1_stub_SHARED_LIBRARY_ID}.so
$1_stub_SHARED_LIBRARY_LINK_NAME=lib$4stub$2.so
$1_stub_SHARED_LIBRARY_LINK_ID=$4stub$2
$1_stub_STATIC_LIBRARY_ID=$4staticstub$2.$3
$1_stub_STATIC_LIBRARY_NAME=lib${$1_stub_STATIC_LIBRARY_ID}.a

AC_SUBST([$1_SHARED_LIBRARY_NAME])
AC_SUBST([$1_STATIC_LIBRARY_NAME])
AC_SUBST([$1_stub_SHARED_LIBRARY_ID])
AC_SUBST([$1_stub_SHARED_LIBRARY_NAME])
AC_SUBST([$1_stub_SHARED_LIBRARY_LINK_NAME])
AC_SUBST([$1_stub_SHARED_LIBRARY_LINK_ID])
AC_SUBST([$1_stub_STATIC_LIBRARY_ID])
AC_SUBST([$1_stub_STATIC_LIBRARY_NAME])

AC_DEFINE_UNQUOTED([$1_stub_SHARED_LIBRARY_NAME],["${$1_stub_SHARED_LIBRARY_NAME}"],[shared library name])
AC_DEFINE_UNQUOTED([$1_stub_SHARED_LIBRARY_LINK_NAME],["${$1_stub_SHARED_LIBRARY_LINK_NAME}"],\
    [unversioned link to the shared library])

DS_ADD_VARIABLES([
$1_LIBRARY_ID                   = @$1_LIBRARY_ID@
$1_INTERFACE_VERSION            = @$1_INTERFACE_VERSION@
$1_INTERFACE_MAJOR_VERSION      = @$1_INTERFACE_MAJOR_VERSION@
$1_INTERFACE_MINOR_VERSION      = @$1_INTERFACE_MINOR_VERSION@
$1_SHARED_LIBRARY_NAME          = @$1_SHARED_LIBRARY_NAME@
$1_STATIC_LIBRARY_NAME          = @$1_STATIC_LIBRARY_NAME@

$1_stub_SHARED_LIBRARY_ID       = @$1_stub_SHARED_LIBRARY_ID@
$1_stub_SHARED_LIBRARY_NAME     = @$1_stub_SHARED_LIBRARY_NAME@
$1_stub_SHARED_LIBRARY_LINK_NAME= @$1_stub_SHARED_LIBRARY_LINK_NAME@
$1_stub_SHARED_LIBRARY_LINK_ID  = @$1_stub_SHARED_LIBRARY_LINK_ID@
$1_stub_STATIC_LIBRARY_ID       = @$1_stub_STATIC_LIBRARY_ID@
$1_stub_STATIC_LIBRARY_NAME     = @$1_stub_STATIC_LIBRARY_NAME@
])

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
