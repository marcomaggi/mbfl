#
# Part of: Marco's Bash Functions Library
# Contents: file descriptor functions
# Date: Sat Dec  8, 2018
#
# Abstract
#
#
#
# Copyright (C) 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
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
# USA.
#
#

#page
#### helpers

function mbfl_p_check_fd () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(POS, 2, positional argument index)

    if mbfl_string_is_digit "$1"
    then return 1
    else
	mbfl_message_error_printf 'file descriptor positional argument %d is not a digit: "%s"' $POS "$FD"
	return 0
    fi
}

m4_define([[[MBFL_CHECK_FD]]],[[[
    if mbfl_p_check_fd "$1" $2
    then return 1
    fi
]]])

#page
#### opening file descriptors

function mbfl_fd_open_input () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(FILE, 2, file pathname)

    MBFL_CHECK_FD($FD, 1)

    # Notice how this works:
    #
    # 1. The external double quotes are processed, the line becomes:
    #
    #    eval exec 3<>"${FILE}"
    #
    # 2. The command "eval" is executed:
    #
    # 2.1. The internal double quotes are processed, the line becomes:
    #
    #    exec 3<>/path/to/file.ext
    #
    # 2.2. The command "exec" is executed.
    #
    eval "exec ${FD}<\"\${FILE}\""
}

function mbfl_fd_open_output () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(FILE, 2, file pathname)

    MBFL_CHECK_FD($FD, 1)
    eval "exec ${FD}>\"\${FILE}\""
}

function mbfl_fd_open_input_output () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(FILE, 2, file pathname)

    MBFL_CHECK_FD($FD, 1)
    eval "exec ${FD}<>\"\${FILE}\""
}

#page
#### closing file descriptors

function mbfl_fd_close () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)

    MBFL_CHECK_FD($FD, 1)
    eval "exec ${FD}<&-"
}

#page
#### duplicating file descriptors

function mbfl_fd_dup_input () {
    mbfl_mandatory_parameter(SRCFD, 1, source file descriptor)
    mbfl_mandatory_parameter(DSTFD, 2, dest file descriptor)

    MBFL_CHECK_FD($SRCFD, 1)
    MBFL_CHECK_FD($DSTFD, 2)
    eval "exec ${DSTFD}<&${SRCFD}"
}

function mbfl_fd_dup_output () {
    mbfl_mandatory_parameter(SRCFD, 1, source file descriptor)
    mbfl_mandatory_parameter(DSTFD, 2, dest file descriptor)

    MBFL_CHECK_FD($SRCFD, 1)
    MBFL_CHECK_FD($DSTFD, 2)
    eval "exec ${DSTFD}>&${SRCFD}"
}

#page
#### moving file descriptors

function mbfl_fd_move () {
    mbfl_mandatory_parameter(SRCFD, 1, source file descriptor)
    mbfl_mandatory_parameter(DSTFD, 2, dest file descriptor)

    MBFL_CHECK_FD($SRCFD, 1)
    MBFL_CHECK_FD($DSTFD, 2)
    eval "exec ${DSTFD}<&${SRCFD}-"
}

### end of file
# Local Variables:
# mode: sh
# End:
