# configure.ds --
#



#PAGE
## ------------------------------------------------------------
## Initialisation.
## ------------------------------------------------------------

AC_INIT([mbfl], [1.2.32], [marcomaggi@tiscalinet.it])
AC_PREREQ(2.57)
AC_COPYRIGHT([Copyright (C) 2003, 2004, 2005 by Marco Maggi])
AC_REVISION([$Revision: 1.1.1.131 $])
AC_CONFIG_SRCDIR([./lib/libmbfl.sh.m4])
AC_CONFIG_AUX_DIR([infrastructure])

AC_SUBST([PACKAGE_XVERSION], [1.2a32])
AC_DEFINE([PACKAGE_XVERSION], ["1.2a32"], [full package version])
AC_SUBST([PACKAGE_NODOT_VERSION],  [12])
AC_DEFINE([PACKAGE_NODOT_VERSION], ["12"], [package version with no dots])
AC_SUBST([PACKAGE_NAME_UPPERCASE], [MBFL])
AC_DEFINE([PACKAGE_NAME_UPPERCASE], ["MBFL"], [package name in upper case chars])
AC_SUBST([PACKAGE_NAME_LOWERCASE],  [mbfl])
AC_DEFINE([PACKAGE_NAME_LOWERCASE], ["mbfl"], [package name in lower case chars])

AC_SUBST([PACKAGE_VERSION_MAJMIN],  [1.2])
AC_DEFINE([PACKAGE_VERSION_MAJMIN], ["1.2"], [major/minor package version])
AC_SUBST([PACKAGE_VERSION_MAJOR],  [1])
AC_DEFINE([PACKAGE_VERSION_MAJOR], ["1"], [major version number])
AC_SUBST([PACKAGE_VERSION_MINOR],  [2])
AC_DEFINE([PACKAGE_VERSION_MINOR], ["2"], [minor version number])
AC_SUBST([PACKAGE_VERSION_PATCH],  [32])
AC_DEFINE([PACKAGE_VERSION_PATCH], ["32"], [patch version number])
AC_SUBST([PACKAGE_VERSION_STATE],  [a])
AC_DEFINE([PACKAGE_VERSION_STATE], ["a"], [state of the package])


#PAGE
## ------------------------------------------------------------
## Common programs.
## ------------------------------------------------------------

AC_PATH_PROG([DEVELSTUFF],[develstuff.sh], :)
AC_ARG_VAR([DEVELSTUFF], [an infrastructure script])


AC_DEFUN([DS_PROGRAM_BASH_PROGRAM], [AC_PATH_PROG([BASH_PROGRAM], [bash], :)
AC_ARG_VAR([BASH_PROGRAM], [the GNU bash shell])])

AC_DEFUN([DS_PROGRAM_BZIP], [AC_PATH_PROG([BZIP], [bzip2], :)
AC_ARG_VAR([BZIP], [the bzip2 compressor program])])

AC_DEFUN([DS_PROGRAM_CAT], [AC_PATH_PROG([CAT], [cat], :)
AC_ARG_VAR([CAT], [the GNU cat program])])

AC_DEFUN([DS_PROGRAM_CP], [AC_PATH_PROG([CP], [cp], :)
AC_ARG_VAR([CP], [copies files])])

AC_DEFUN([DS_PROGRAM_DATE], [AC_PATH_PROG([DATE], [date], :)
AC_ARG_VAR([DATE], [a program that prints the current date])])

AC_DEFUN([DS_PROGRAM_GREP], [AC_PATH_PROG([GREP], [grep], :)
AC_ARG_VAR([GREP], [the GNU grep program])])

AC_DEFUN([DS_PROGRAM_GAWK], [AC_PATH_PROG([GAWK], [gawk], :)
AC_ARG_VAR([GAWK], [the GNU awk program])])

AC_DEFUN([DS_PROGRAM_GZIP], [AC_PATH_PROG([GZIP], [gzip], :)
AC_ARG_VAR([GZIP], [the gzip compressor program])])

AC_DEFUN([DS_PROGRAM_M4], [AC_PATH_PROG([M4], [m4], :)
AC_ARG_VAR([M4], [the GNU m4 preprocessor])])

AC_DEFUN([DS_PROGRAM_MAKEINFO], [AC_PATH_PROG([MAKEINFO], [makeinfo], :)
AC_ARG_VAR([MAKEINFO], [builds docs from Texinfo source])])

AC_DEFUN([DS_PROGRAM_MKDIR], [AC_PATH_PROG([MKDIR], [mkdir], :)
AC_ARG_VAR([MKDIR], [creates directories recursively])])

AC_DEFUN([DS_PROGRAM_RM], [AC_PATH_PROG([RM], [rm], :)
AC_ARG_VAR([RM], [deletes files and directories recursively])])

AC_DEFUN([DS_PROGRAM_SED], [AC_PATH_PROG([SED], [sed], :)
AC_ARG_VAR([SED], [the GNU sed program])])

AC_DEFUN([DS_PROGRAM_SYMLINK], [AC_PATH_PROG([SYMLINK], [ln], :)
AC_ARG_VAR([SYMLINK], [program used create symbolic links])])

AC_DEFUN([DS_PROGRAM_TAR], [AC_PATH_PROG([TAR], [tar], :)
AC_ARG_VAR([TAR], [the GNU tar program])])

AC_DEFUN([DS_PROGRAM_TCLSH], [AC_PATH_PROG([TCLSH], [tclsh], :)
AC_ARG_VAR([TCLSH], [the TCL shell])])

AC_DEFUN([DS_PROGRAM_SPKG], [AC_PATH_PROG([SPKG], [spkg], :)
AC_ARG_VAR([SPKG], [an infrastructure script])])


AC_DEFUN([DS_PROGRAM_EMACS], [AC_PATH_PROG([EMACS], [emacs], :)
AC_ARG_VAR([EMACS], [GNU Emacs editor])])

AC_PROG_INSTALL
AC_PROG_MAKE_SET

DS_PROGRAM_BASH_PROGRAM
DS_PROGRAM_BZIP
DS_PROGRAM_CAT
DS_PROGRAM_CP
DS_PROGRAM_DATE
DS_PROGRAM_GREP
DS_PROGRAM_GAWK
DS_PROGRAM_GZIP
DS_PROGRAM_M4
DS_PROGRAM_MAKEINFO
DS_PROGRAM_MKDIR
DS_PROGRAM_RM
DS_PROGRAM_SED
DS_PROGRAM_SYMLINK
DS_PROGRAM_TAR
DS_PROGRAM_TCLSH
DS_PROGRAM_SPKG

CURRENT_DATE=$($DATE)
AC_SUBST(CURRENT_DATE)



AC_CONFIG_FILES(meta/mbfl-config:meta/mbfl-config.in)


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