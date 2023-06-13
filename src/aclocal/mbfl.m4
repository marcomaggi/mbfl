#
# Part of: Marco's Bash Functions Library (MBFL)
# Contents: support for GNU Autoconf
# Date: Mon Apr 13, 2009
#
# Abstract
#
#	This file is meant  to be included in the distribution of packages  using the MBFL and using
#	the GNU Autotools.  It should be loaded into "configure.ac" by putting the following lin ein
#	"acinclude.m4":
#
#	   m4_include(path/to/mbfl.m4)
#
#	then in "configure.ac" we can use the macro:
#
#	   MBFL_SETUP
#
#	In a "Makefile.am" we are interested in the substitution variables "MBFLPP" and "MBFLTEST".
#
# Copyright (c) 2009, 2012, 2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS SOFTWARE IS PROVIDED ON AN "AS IS"  BASIS, AND THE AUTHOR AND DISTRIBUTORS HAVE NO OBLIGATION
# TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

AC_DEFUN([MBFL_SETUP],
  [AC_PATH_PROG([MBFLPP],[mbflpp.bash],[:])

   AS_VAR_SET([mbfl_MINIMUM_REQUIRED_SEMANTIC_VERSION],[$1])
   AC_CACHE_CHECK([minimum required MBFL semantic version $mbfl_MINIMUM_REQUIRED_SEMANTIC_VERSION],
     [mbfl_cv_compliant_version],
     [AS_IF([test "x$mbfl_MINIMUM_REQUIRED_SEMANTIC_VERSION" = "x"],
            [echo empty >&2 ; AS_VAR_SET([mbfl_cv_compliant_version],[yes])],
            ["$MBFLPP" --check-version="$mbfl_MINIMUM_REQUIRED_SEMANTIC_VERSION"],
            [AS_VAR_SET([mbfl_cv_compliant_version],[yes])],
            [AS_VAR_SET([mbfl_cv_compliant_version],[no])])])

   AS_IF([test "x$mbfl_cv_compliant_version" = "xno"],
         [AS_VAR_SET([mbfl_SEMANTIC_VERSION],[$("$MBFLPP" --version-only)])
          AC_MSG_ERROR([the installed MBFL package is too old: $mbfl_SEMANTIC_VERSION],[1])])

   AC_CACHE_CHECK([installation directory of MBFL libraries],
     [mbfl_cv_pathname_libdir],
     [AS_VAR_SET([mbfl_cv_pathname_libdir],[$("${MBFLPP}" --print-libdir)])])

   AC_CACHE_CHECK([pathname of library "libmbfl"],
     [mbfl_cv_pathname_libmbfl_core],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_core],[$("${MBFLPP}" --print-libmbfl)])
      AS_VAR_SET([mbfl_cv_pathname_libmbfl],["$mbfl_cv_pathname_libmbfl_core"])])

   AC_CACHE_CHECK([pathname of library "libmbfl-linker"],
     [mbfl_cv_pathname_libmbfl_linker],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_linker],[$("${MBFLPP}" --print-libmbfl-linker)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-tests"],
     [mbfl_cv_pathname_libmbfl_tests],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_tests],[$("${MBFLPP}" --print-libmbfl-tests)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-utils"],
     [mbfl_cv_pathname_libmbfl_utils],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_utils],[$("${MBFLPP}" --print-libmbfl-utils)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-at"],
     [mbfl_cv_pathname_libmbfl_at],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_at],[$("${MBFLPP}" --print-libmbfl-at)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-arch"],
     [mbfl_cv_pathname_libmbfl_arch],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_arch],[$("${MBFLPP}" --print-libmbfl-arch)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-passwords"],
     [mbfl_cv_pathname_libmbfl_passwords],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_passwords],[$("${MBFLPP}" --print-libmbfl-passwords)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-git"],
     [mbfl_cv_pathname_libmbfl_git],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_git],[$("${MBFLPP}" --print-libmbfl-git)])])

   AC_CACHE_CHECK([pathname of library "libmbfl-containers"],
     [mbfl_cv_pathname_libmbfl_containers],
     [AS_VAR_SET([mbfl_cv_pathname_libmbfl_containers],[$("${MBFLPP}" --print-libmbfl-containers)])])

   AC_SUBST(MBFL_LIBDIR,                ["$mbfl_cv_pathname_libdir"])
   AC_SUBST(MBFL_LIBMBFL,               ["$mbfl_cv_pathname_libmbfl"])
   AC_SUBST(MBFL_LIBMBFL_CORE,          ["$mbfl_cv_pathname_libmbfl_core"])
   AC_SUBST(MBFL_LIBMBFL_LINKER,        ["$mbfl_cv_pathname_libmbfl_linker"])
   AC_SUBST(MBFL_LIBMBFL_TESTS,         ["$mbfl_cv_pathname_libmbfl_tests"])
   AC_SUBST(MBFL_LIBMBFL_AT,            ["$mbfl_cv_pathname_libmbfl_at"])
   AC_SUBST(MBFL_LIBMBFL_ARCH,          ["$mbfl_cv_pathname_libmbfl_arch"])
   AC_SUBST(MBFL_LIBMBFL_UTILS,         ["$mbfl_cv_pathname_libmbfl_utils"])
   AC_SUBST(MBFL_LIBMBFL_PASSWORDS,     ["$mbfl_cv_pathname_libmbfl_passwords"])
   AC_SUBST(MBFL_LIBMBFL_GIT,           ["$mbfl_cv_pathname_libmbfl_git"])
   AC_SUBST(MBFL_LIBMBFL_CONTAINERS,    ["$mbfl_cv_pathname_libmbfl_containers"])
   ])

### end of file
# Local Variables:
# mode: autoconf
# End:
