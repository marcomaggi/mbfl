# functions.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: functions handling
# Date: Mar 29, 2023
#
# Abstract
#
#	Special handling GNU Bash functions.
#
# Copyright (c) 2023 Marco Maggi
# <mrc.mgg@gmail.com>
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


#### copying and renaming

function mbfl_function_copy () {
    mbfl_mandatory_parameter(mbfl_SRC_FUNCNAME, 1, source function name)
    mbfl_mandatory_parameter(mbfl_DST_FUNCNAME, 2, destination function name)

    if ! mbfl_string_is_identifier "$mbfl_SRC_FUNCNAME"
    then
	mbfl_message_error_printf 'expected identifier as source function name in call to "%s", got: "%s"' \
				  $FUNCNAME "$mbfl_SRC_FUNCNAME"
	return_because_failure
    fi

    if ! mbfl_string_is_identifier "$mbfl_DST_FUNCNAME"
    then
	mbfl_message_error_printf 'expected identifier as destination function name in call to "%s", got: "%s"' \
				  $FUNCNAME "$mbfl_DST_FUNCNAME"
	return_because_failure
    fi

    mbfl_p_function_copy "$mbfl_SRC_FUNCNAME" "$mbfl_DST_FUNCNAME"
}
function mbfl_function_rename () {
    mbfl_mandatory_parameter(mbfl_SRC_FUNCNAME, 1, source function name)
    mbfl_mandatory_parameter(mbfl_DST_FUNCNAME, 2, destination function name)

    if ! mbfl_string_is_identifier "$mbfl_SRC_FUNCNAME"
    then
	mbfl_message_error_printf 'expected identifier as source function name in call to "%s", got: "%s"' \
				  $FUNCNAME "$mbfl_SRC_FUNCNAME"
	return_because_failure
    fi

    if ! mbfl_string_is_identifier "$mbfl_DST_FUNCNAME"
    then
	mbfl_message_error_printf 'expected identifier as destination function name in call to "%s", got: "%s"' \
				  $FUNCNAME "$mbfl_DST_FUNCNAME"
	return_because_failure
    fi

    if mbfl_p_function_copy "$mbfl_SRC_FUNCNAME" "$mbfl_DST_FUNCNAME"
    then unset -f "$mbfl_SRC_FUNCNAME"
    fi
}

# The following implementation comes from:
#
# <https://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function>
#
# According to the documentation  of the Bash variable "_": the expression '$_'  expands to the last
# argument to the previous simple command executed in the foreground, after expansion.
#
# By executing:
#
#    test -n "$(declare -f ${mbfl_SRC_FUNCNAME})"
#
# we make '$_' expand into the result of:
#
#    "$(declare -f ${mbfl_SRC_FUNCNAME})"
#
# which is a string representing the full function definition.  Then we use the parameter expansion:
#
#    "${_/${mbfl_SRC_FUNCNAME}/${mbfl_DST_FUNCNAME}}"
#
# to replace the fist occurrence of the function name in its definition string.
#
function mbfl_p_function_copy () {
    mbfl_mandatory_parameter(mbfl_SRC_FUNCNAME, 1, source function name)
    mbfl_mandatory_parameter(mbfl_DST_FUNCNAME, 2, destination function name)

    if test -n "$(declare -f ${mbfl_SRC_FUNCNAME})"
    then eval "${_/${mbfl_SRC_FUNCNAME}/${mbfl_DST_FUNCNAME}}"
    else
	mbfl_message_error_printf 'expected function name as source identifier in call to "%s", got: "%s"' \
				  $FUNCNAME "$mbfl_SRC_FUNCNAME"
	return_because_failure
    fi
}
function mbfl_function_exists () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    declare JUNK

    JUNK=$(declare -fp "$mbfl_FUNCNAME" 2>&1)
}
function mbfl_function_unset () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    unset -f "$mbfl_FUNCNAME"
}

### end of file
# Local Variables:
# mode: sh
# End:
