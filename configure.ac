# configure.ds --
#



#PAGE
## ------------------------------------------------------------
## Initialisation.
## ------------------------------------------------------------

AC_INIT([mbfl], [1.0.3], [marcomaggi@tiscalinet.it])
AC_PREREQ(2.57)
AC_COPYRIGHT([Copyright (C) 2003, 2004 by Marco Maggi])
AC_REVISION([$Revision: 1.1.1.131 $])
AC_CONFIG_SRCDIR([./lib/libmbfl.sh.m4])
AC_CONFIG_AUX_DIR([infrastructure])

AC_SUBST([PACKAGE_XVERSION], [1.0.3])
AC_DEFINE([PACKAGE_XVERSION], ["1.0.3"], [full version])
AC_SUBST([PACKAGE_NODOT_VERSION], [10])
AC_SUBST([PACKAGE_NAME_UPPERCASE], [MBFL])
AC_SUBST([PACKAGE_NAME_LOWERCASE], [mbfl])

AC_SUBST([PACKAGE_VERSION_MAJMIN], [1.0])
AC_SUBST([PACKAGE_VERSION_MAJOR], [1])
AC_SUBST([PACKAGE_VERSION_MINOR], [0])
AC_SUBST([PACKAGE_VERSION_PATCH], [3])


#PAGE
## ------------------------------------------------------------
## Common programs.
## ------------------------------------------------------------

AC_PROG_INSTALL
AC_PROG_MAKE_SET


AC_PATH_PROG([BASH], [bash], :)
AC_ARG_VAR([BASH], [the GNU bash shell])

AC_PATH_PROG([RM], [rm], :)
AC_ARG_VAR([RM], [deletes files and directories recursively])

AC_PATH_PROG([CAT], [cat], :)
AC_ARG_VAR([CAT], [the GNU cat program])

AC_PATH_PROG([SED], [sed], :)
AC_ARG_VAR([SED], [the GNU sed program])

AC_PATH_PROG([GREP], [grep], :)
AC_ARG_VAR([GREP], [the GNU grep program])

AC_PATH_PROG([GZIP], [gzip], :)
AC_ARG_VAR([GZIP], [the gzip compressor program])

AC_PATH_PROG([BZIP], [bzip2], :)
AC_ARG_VAR([BZIP], [the bzip2 compressor program])

AC_PATH_PROG([TAR], [tar], :)
AC_ARG_VAR([TAR], [the GNU tar program])

AC_PATH_PROG([SYMLINK], [ln], :)
AC_ARG_VAR([SYMLINK], [program used create symbolic links])

AC_PATH_PROG([MKDIR], [mkdir], :)
AC_ARG_VAR([MKDIR], [creates directories recursively])

AC_PATH_PROG([M4], [m4], :)
AC_ARG_VAR([M4], [the GNU m4 preprocessor])

AC_PATH_PROG([TCLSH], [tclsh], :)
AC_ARG_VAR([TCLSH], [the TCL shell])

AC_PATH_PROG([MAKEINFO], [makeinfo], :)
AC_ARG_VAR([MAKEINFO], [builds docs from Texinfo source])

AC_PATH_PROG([DATE], [date], :)
AC_ARG_VAR([DATE], [a program that prints the current date])

CURRENT_DATE=$($DATE)
AC_SUBST(CURRENT_DATE)


AC_CONFIG_FILES(mbfl-config:scripts/mbfl-config)

#PAGE
## ------------------------------------------------------------
## Finalisation.
## ------------------------------------------------------------

AC_CONFIG_FILES([Makefile])
AC_OUTPUT





### end of file
# Local Variables:
# mode: sh
# End:
