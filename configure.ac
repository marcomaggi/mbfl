# configure.ds --
#



#PAGE
## ------------------------------------------------------------
## Initialisation.
## ------------------------------------------------------------

AC_INIT([mbfl], [1.1.3], [marcomaggi@tiscalinet.it])
AC_PREREQ(2.57)
AC_COPYRIGHT([Copyright (C) 2003, 2004 by Marco Maggi])
AC_REVISION([$Revision: 1.1.1.131 $])
AC_CONFIG_SRCDIR([./lib/libmbfl.sh.m4])
AC_CONFIG_AUX_DIR([infrastructure])

AC_SUBST([PACKAGE_XVERSION], [1.1.3])
AC_DEFINE([PACKAGE_XVERSION], ["1.1.3"], [full package version])
AC_SUBST([PACKAGE_NODOT_VERSION],  [11])
AC_DEFINE([PACKAGE_NODOT_VERSION],
    ["11"], [package version with no dots])
AC_SUBST([PACKAGE_NAME_UPPERCASE], [MBFL])
AC_DEFINE([PACKAGE_NAME_UPPERCASE],
    ["MBFL"], [package name in upper case chars])
AC_SUBST([PACKAGE_NAME_LOWERCASE],  [mbfl])
AC_DEFINE([PACKAGE_NAME_LOWERCASE], ["mbfl"],
    [package name in lower case chars])

AC_SUBST([PACKAGE_VERSION_MAJMIN],  [1.1])
AC_DEFINE([PACKAGE_VERSION_MAJMIN], ["1.1"],
    [major/minor package version])
AC_SUBST([PACKAGE_VERSION_MAJOR],  [1])
AC_DEFINE([PACKAGE_VERSION_MAJOR], ["1"],
    [major version number])
AC_SUBST([PACKAGE_VERSION_MINOR],  [1])
AC_DEFINE([PACKAGE_VERSION_MINOR], ["1"],
    [minor version number])
AC_SUBST([PACKAGE_VERSION_PATCH],  [3])
AC_DEFINE([PACKAGE_VERSION_PATCH], ["3"],
    [patch version number])
AC_SUBST([PACKAGE_VERSION_STATE],  [.])
AC_DEFINE([PACKAGE_VERSION_STATE], ["."],
    [state of the package])


#PAGE
## ------------------------------------------------------------
## Common programs.
## ------------------------------------------------------------

AC_PROG_INSTALL
AC_PROG_MAKE_SET


AC_PATH_PROG([BASH], [bash], :)
AC_ARG_VAR([BASH], [the GNU bash shell])

AC_PATH_PROG([BZIP], [bzip2], :)
AC_ARG_VAR([BZIP], [the bzip2 compressor program])

AC_PATH_PROG([CAT], [cat], :)
AC_ARG_VAR([CAT], [the GNU cat program])

AC_PATH_PROG([CP], [cp], :)
AC_ARG_VAR([CP], [copies files])

AC_PATH_PROG([DATE], [date], :)
AC_ARG_VAR([DATE], [a program that prints the current date])

AC_PATH_PROG([GREP], [grep], :)
AC_ARG_VAR([GREP], [the GNU grep program])

AC_PATH_PROG([GAWK], [gawk], :)
AC_ARG_VAR([GAWK], [the GNU awk program])

AC_PATH_PROG([GZIP], [gzip], :)
AC_ARG_VAR([GZIP], [the gzip compressor program])

AC_PATH_PROG([M4], [m4], :)
AC_ARG_VAR([M4], [the GNU m4 preprocessor])

AC_PATH_PROG([MAKEINFO], [makeinfo], :)
AC_ARG_VAR([MAKEINFO], [builds docs from Texinfo source])

AC_PATH_PROG([MKDIR], [mkdir], :)
AC_ARG_VAR([MKDIR], [creates directories recursively])

AC_PATH_PROG([RM], [rm], :)
AC_ARG_VAR([RM], [deletes files and directories recursively])

AC_PATH_PROG([SED], [sed], :)
AC_ARG_VAR([SED], [the GNU sed program])

AC_PATH_PROG([SYMLINK], [ln], :)
AC_ARG_VAR([SYMLINK], [program used create symbolic links])

AC_PATH_PROG([TAR], [tar], :)
AC_ARG_VAR([TAR], [the GNU tar program])

AC_PATH_PROG([TCLSH], [tclsh], :)
AC_ARG_VAR([TCLSH], [the TCL shell])

AC_PATH_PROG([DEVELSTUFF], [develstuff.sh], :)
AC_ARG_VAR([DEVELSTUFF], [an infrastructure script])

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
