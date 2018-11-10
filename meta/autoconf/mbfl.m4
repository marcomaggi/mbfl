#
# Part of: Marco's Bash Functions Library (MBFL)
# Contents: support for GNU Autoconf
# Date: Mon Apr 13, 2009
#
# Abstract
#
#	This  file  is meant  to  be  included  in the  distribution  of
#	packages using the MBFL and  using the GNU Autotools.  It should
#	be loaded into  "configure.ac" by putting the  following lin ein
#	"acinclude.m4":
#
#	   m4_include(path/to/mbfl.m4)
#
#	then in "configure.ac" we can use the macro:
#
#	   MBFL_SETUP
#
#	In  a  "Makefile.am"  we  are  interested  in  the  substitution
#	variables "MBFLPP" and "MBFLTEST".
#
# Copyright (c) 2009, 2012, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
#
# The author hereby grants  permission to use, copy, modify, distribute,
# and  license this  software  and its  documentation  for any  purpose,
# provided that  existing copyright notices  are retained in  all copies
# and that  this notice  is included verbatim in any  distributions.  No
# written agreement, license, or royalty  fee is required for any of the
# authorized uses.  Modifications to this software may be copyrighted by
# their authors and need not  follow the licensing terms described here,
# provided that the new terms are clearly indicated on the first page of
# each file where they apply.
#
# IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
# FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
# ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
# DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
# POSSIBILITY OF SUCH DAMAGE.
#
# THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
# INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
# MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
# NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
# AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

AC_DEFUN([MBFL_SETUP],
  [AC_PATH_PROG([MBFLCONFIG],[mbfl-config],[:])
   AC_PATH_PROG([MBFLPP],[mbflpp.sh],[:])
   AC_PATH_PROG([MBFLTEST],[mbfltest.sh],[:])
   mbfl_LIBRARY=$("${MBFLCONFIG}" --library)
   mbfl_TEST_LIBRARY=$("${MBFLCONFIG}" --testlib)
   MBFL_LIB=$("${MBFLCONFIG}" --libpath)
   AC_CHECK_FILE([${mbfl_LIBRARY}],,
       [AC_MSG_ERROR([cannot find MBFL library ${mbfl_LIBRARY}],2)])
   AC_CHECK_FILE([${mbfl_TEST_LIBRARY}],,
       [AC_MSG_ERROR([cannot find MBFL test library ${mbfl_TEST_LIBRARY}],2)])
   AC_SUBST(mbfl_LIBRARY)
   AC_SUBST(MBFL_LIB)])

### end of file
# Local Variables:
# mode: sh
# End:
