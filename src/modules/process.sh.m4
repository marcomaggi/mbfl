#
# Part of: Marco's Bash Functions Library
# Contents: file descriptor functions
# Date: Nov  3, 2020
#
# Abstract
#
#
#
# Copyright (C) 2020 Marco Maggi <mrc.mgg@gmail.com>
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

function mbfl_process_disown () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin disown '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin disown "$@"
    fi
}
function mbfl_process_wait () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin wait '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin wait "$@"
    fi
}
function mbfl_process_kill () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin kill '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin kill "$@"
    fi
}
function mbfl_process_suspend () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin suspend '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin suspend "$@"
    fi
}
function mbfl_process_bg () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin bg '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin bg "$@"
    fi
}
function mbfl_process_fg () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin fg '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin fg "$@"
    fi
}
function mbfl_process_jobs () {
    if mbfl_option_test || mbfl_option_show_program
    then
	{
	    printf 'builtin jobs '
	    echo -n "$@"
	    printf '\n'
	} >&2
    fi
    if ! mbfl_option_test
    then builtin jobs "$@"
    fi
}

function mbfl_process_sleep () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_SLEEP"
    then mbfl_program_exec "$mbfl_PROGRAM_SLEEP"
    else return_failure
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
