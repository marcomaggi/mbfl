# programs.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: program variables
# Date: Thu May  1, 2003
# 
# Abstract
# 
#       This is a collection of variables identifying common POSIX
#       binary utilities. All the program variables are prefixed
#       with "program_".
#
#         The suggested way to use them is the following:
#
#               function myfun () {
#                   local RM="${program_RM} --verbose"
#                   local MV="${program_MB} --verbose"
#
#                   if ! mbfl_program_check ${program_MV} ${program_RM}
#                   then return 1
#                   fi
#
#                   # function body that makes use of ${RM} and ${MV}
#                   return 0
#               }
# 
# Copyright (c) 2003 Marco Maggi
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
# $Id: programs.sh.m4,v 1.1.1.17 2004/02/04 14:21:21 marco Exp $
#

m4_include(macros.m4)

#PAGE
## ------------------------------------------------------------
## Basic shell utilities.
## ------------------------------------------------------------

program_SHELL="/bin/bash"

program_CAT="/bin/cat"
program_CHGRP="/bin/chgrp"
program_CHMOD="/bin/chmod"
program_CHOWN="/bin/chown"
program_CP="/bin/cp"
program_DATE="/bin/date"
program_FILE="/usr/bin/file"
program_FIND="/usr/bin/find"
program_GREP="/bin/grep"
program_LN="/bin/ln"
program_LS="/bin/ls"
program_MKDIR="/bin/mkdir"
program_MV="/bin/mv"
program_READLINK="/bin/readlink"
program_RM="/bin/rm"
program_RMDIR="/bin/rmdir"
program_SED="/bin/sed"
program_SORT="/usr/bin/sort"
program_TEMPFILE="/bin/tempfile"
program_TOUCH="/usr/bin/touch"
program_XARGS="/usr/bin/xargs"


#PAGE
## ------------------------------------------------------------
## Other shell utilities.
## ------------------------------------------------------------

program_INSTALL="/usr/bin/install"
program_SU="/usr/bin/su"
program_SUDO="/usr/bin/sudo"
program_STRIP="/usr/bin/strip"
program_MAKE="/usr/bin/make"


#PAGE
## ------------------------------------------------------------
## Filters.
## ------------------------------------------------------------

program_AWK="/usr/bin/gawk"
program_M4="/usr/bin/m4"

#PAGE
## ------------------------------------------------------------
## Archive utilities.
## ------------------------------------------------------------

program_BZIP2="/usr/bin/bzip2"
program_CPIO="/bin/cpio"
program_GUNZIP="/bin/gunzip"
program_GZIP="/bin/gzip"
program_TAR="/bin/tar"


#PAGE
## ------------------------------------------------------------
## Revision Control System programs.
## ------------------------------------------------------------

program_CI="/usr/bin/ci"
program_CO="/usr/bin/co"
program_IDENT="/usr/bin/ident"
program_RCS="/usr/bin/rcs"
program_RCSCLEAN="/usr/bin/rcsclean"
program_RCSDIFF="/usr/bin/rcsdiff"
program_RLOG="/usr/bin/rlog"


#PAGE
## ------------------------------------------------------------
## System utilities.
## ------------------------------------------------------------

program_SYNC="/bin/sync"
program_MOUNT="/bin/mount"
program_UMOUNT="/bin/umount"

#PAGE
# mbfl_program_check --
#
#       Checks the availability of programs. This function assumes
#       that the program pathnames do not contain blank characters.
#
#  Arguments:
#
#       $* -    the list of program pathnames
#
#  Results:
#
#       Returns true if a program can't be found, false otherwise.
#
#  Side effects:
#
#       None.
#

function mbfl_program_check () {
    local PROGRAMS=${*}


    for item in ${PROGRAMS}
    do
        if test ! -x "${item}"
        then
            mbfl_message_error "cannot find executable \"${item}\""
            return 1
        fi
    done

    return 0
}
#PAGE
# mbfl_program_exec --
#
#	Evaluates a command line. If the variable "mbfl_program_TEST"
#       is set to "yes": instead of evaluation, the command line
#       is sent to stderr.
#
#  Arguments:
#
#	$@ -            The command line to execute.
#
#  Results:
#
#	Returns the empty string.
#

function mbfl_program_exec () {
    if test "${mbfl_program_TEST}" = "yes"; then
        echo "${@}" >&2
        return 0
    else
        eval "${@}"
    fi
}

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# indent-tabs-mode: nil
# End:
