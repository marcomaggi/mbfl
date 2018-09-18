#
# Part of: Marco's Bash Functions Library (MBFL)
# Contents: support for GNU Autoconf
# Date: Mon Apr 13, 2009
#
# Abstract
#
#
#
# Copyright (c) 2009, 2012 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This  program  is free  software:  you  can redistribute  it
# and/or modify it  under the terms of the  GNU General Public
# License as published by the Free Software Foundation, either
# version  3 of  the License,  or (at  your option)  any later
# version.
#
# This  program is  distributed in  the hope  that it  will be
# useful, but  WITHOUT ANY WARRANTY; without  even the implied
# warranty  of  MERCHANTABILITY or  FITNESS  FOR A  PARTICULAR
# PURPOSE.   See  the  GNU  General Public  License  for  more
# details.
#
# You should  have received a  copy of the GNU  General Public
# License   along   with    this   program.    If   not,   see
# <http://www.gnu.org/licenses/>.
#
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
