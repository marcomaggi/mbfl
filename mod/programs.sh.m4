# programs.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: program variables
# Date: Thu May  1, 2003
# 
# Abstract
# 
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

m4_include(macros.m4)

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
