#
# Part of: Marco's Bash Functions Library
# Contents: file descriptor functions
# Date: Sat Dec  8, 2018
#
# Abstract
#
#
#
# Copyright (C) 2018, 2020 Marco Maggi <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#


#### helpers

function mbfl_fd_p_check_fd () {
    mbfl_mandatory_parameter(FD,  1, file descriptor)
    mbfl_mandatory_parameter(POS, 2, positional argument index)

    if mbfl_string_is_digit "$1"
    then return 1
    else
	mbfl_message_error_printf 'file descriptor positional argument %d is not a digit: "%s"' $POS "$FD"
	return 0
    fi
}

m4_define([[[MBFL_FD_CHECK]]],[[[
    if mbfl_fd_p_check_fd "$1" $2
    then return 1
    fi
]]])

function mbfl_fd_p_execute_operation () {
    mbfl_mandatory_parameter(COMMAND, 1, statement to execute)

    if { mbfl_option_test || mbfl_option_show_program; }
    then echo "$COMMAND" >&2
    fi
    eval "$COMMAND"
}


#### opening file descriptors

function mbfl_fd_open_input () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(FILE, 2, file pathname)

    MBFL_FD_CHECK($FD, 1)
    {
	local COMMAND TEMPLATE='exec %s<"%s"'

	printf -v COMMAND "$TEMPLATE" "$FD" "$FILE"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}

function mbfl_fd_open_output () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(FILE, 2, file pathname)

    MBFL_FD_CHECK($FD, 1)
    {
	local COMMAND TEMPLATE='exec %s>"%s"'

	printf -v COMMAND "$TEMPLATE" "$FD" "$FILE"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}

function mbfl_fd_open_input_output () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)
    mbfl_mandatory_parameter(FILE, 2, file pathname)

    MBFL_FD_CHECK($FD, 1)
    {
	local COMMAND TEMPLATE='exec %s<>"%s"'

	printf -v COMMAND "$TEMPLATE" "$FD" "$FILE"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}


#### closing file descriptors

function mbfl_fd_close () {
    mbfl_mandatory_parameter(FD, 1, file descriptor)

    MBFL_FD_CHECK($FD, 1)
    {
	local COMMAND TEMPLATE='exec %s<&-'

	printf -v COMMAND "$TEMPLATE" "$FD"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}


#### duplicating file descriptors

function mbfl_fd_dup_input () {
    mbfl_mandatory_parameter(SRCFD, 1, source file descriptor)
    mbfl_mandatory_parameter(DSTFD, 2, dest file descriptor)

    MBFL_FD_CHECK($SRCFD, 1)
    MBFL_FD_CHECK($DSTFD, 2)
    {
	local COMMAND TEMPLATE='exec %s<&%s'

	# NOTE Yes, DSTFD  is the first argument,  SRCFD is the second  argument!!!  Checkout Bash's
	# documentation, node "Redirections".  (Marco Maggi; Nov  9, 2020)
	printf -v COMMAND "$TEMPLATE" "$DSTFD" "$SRCFD"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}

function mbfl_fd_dup_output () {
    mbfl_mandatory_parameter(SRCFD, 1, source file descriptor)
    mbfl_mandatory_parameter(DSTFD, 2, dest file descriptor)

    MBFL_FD_CHECK($SRCFD, 1)
    MBFL_FD_CHECK($DSTFD, 2)
    {
	local COMMAND TEMPLATE='exec %s>&%s'

	# NOTE Yes, DSTFD  is the first argument,  SRCFD is the second  argument!!!  Checkout Bash's
	# documentation, node "Redirections".  (Marco Maggi; Nov  9, 2020)
	printf -v COMMAND "$TEMPLATE" "$DSTFD" "$SRCFD"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}


#### moving file descriptors

function mbfl_fd_move () {
    mbfl_mandatory_parameter(SRCFD, 1, source file descriptor)
    mbfl_mandatory_parameter(DSTFD, 2, dest file descriptor)

    MBFL_FD_CHECK($SRCFD, 1)
    MBFL_FD_CHECK($DSTFD, 2)
    {
	local COMMAND TEMPLATE='exec %s<&%s-'

	printf -v COMMAND "$TEMPLATE" "$DSTFD" "$SRCFD"
	mbfl_fd_p_execute_operation "$COMMAND"
    }
}

### end of file
# Local Variables:
# mode: sh
# End:
