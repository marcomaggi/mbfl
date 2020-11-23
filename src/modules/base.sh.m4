# base.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: base functions
# Date: Oct  6, 2004
#
# Abstract
#
#
#
# Copyright (c) 2004-2005, 2009, 2013, 2018, 2020 Marco Maggi
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

#page
#### global variables

declare -r mbfl_LOADED='yes'

: ${script_PROGNAME:='<unknown>'}
: ${script_VERSION:='<unknown>'}
: ${script_COPYRIGHT_YEARS:='<unknown>'}
: ${script_AUTHOR:='<unknown>'}
: ${script_LICENSE:='<unknown>'}
: ${script_USAGE:='<unknown>'}
: ${script_DESCRIPTION:='<unknown>'}
: ${script_EXAMPLES:=}

#page
#### miscellaneous functions

function mbfl_set_maybe () {
    if mbfl_string_is_not_empty "$1"
    then eval $1=\'"$2"\'
    fi
}
function mbfl_read_maybe_null () {
    mbfl_mandatory_parameter(VARNAME, 1, variable name)

    if mbfl_option_null
    then IFS= read -rs -d $'\x00' $VARNAME
    else IFS= read -rs $VARNAME
    fi
}

#page
#### global option creation functions

m4_define([[[MBFL_CREATE_OPTION_PROCEDURES]]],[[[
function mbfl_set_option_$1 ()   { function mbfl_option_$1 () { true;  }; }
function mbfl_unset_option_$1 () { function mbfl_option_$1 () { false; }; }
mbfl_unset_option_$1
MBFL_CREATE_OPTION_SAVE_AND_RESTORE_PROCEDURES([[[$1]]],m4_translit([[[$1]]],[[[a-z]]],[[[A-Z]]]))
]]])

m4_define([[[MBFL_CREATE_OPTION_SAVE_AND_RESTORE_PROCEDURES]]],[[[
declare mbfl_saved_option_$2
declare mbfl_saved_option_$2

function mbfl_option_$1_save () {
    local LAST_EXIT_STATUS=$?
    if mbfl_option_$1
    then mbfl_saved_option_$2=true
    fi
    mbfl_unset_option_$1
    return $LAST_EXIT_STATUS
}
function mbfl_option_$1_restore () {
    local LAST_EXIT_STATUS=$?
    if mbfl_string_equal "$mbfl_saved_option_$2" 'true'
    then mbfl_set_option_$1
    fi
    return $LAST_EXIT_STATUS
}
]]])

MBFL_CREATE_OPTION_PROCEDURES([[[debug]]])
MBFL_CREATE_OPTION_PROCEDURES([[[encoded_args]]])
MBFL_CREATE_OPTION_PROCEDURES([[[force]]])
MBFL_CREATE_OPTION_PROCEDURES([[[interactive]]])
MBFL_CREATE_OPTION_PROCEDURES([[[null]]])
MBFL_CREATE_OPTION_PROCEDURES([[[show_program]]])
MBFL_CREATE_OPTION_PROCEDURES([[[test]]])
MBFL_CREATE_OPTION_PROCEDURES([[[verbose]]])
MBFL_CREATE_OPTION_PROCEDURES([[[verbose_program]]])

#page
#### exit codes and return codes

if test "$mbfl_INTERACTIVE" != yes
then
    mbfl_declare_numeric_array(mbfl_EXIT_CODES)
    mbfl_declare_numeric_array(mbfl_EXIT_NAMES)
    mbfl_declare_symbolic_array(mbfl_EXIT_CODES_BY_NAME)
    mbfl_EXIT_CODES[0]=0
    mbfl_EXIT_NAMES[0]=success
    mbfl_EXIT_CODES_BY_NAME[success]=0
    function exit_because_success   () { mbfl_exit 0; }
    alias return_because_success='return 0'

    mbfl_EXIT_CODES[1]=1
    mbfl_EXIT_NAMES[1]=failure
    mbfl_EXIT_CODES_BY_NAME[failure]=1
    function exit_because_failure   () { mbfl_exit 1; }
    alias return_because_failure='return 1'

    mbfl_EXIT_CODES[2]=100
    mbfl_EXIT_NAMES[2]=error_loading_library
    mbfl_EXIT_CODES_BY_NAME[error_loading_library]=100
    function exit_because_error_loading_library   () { mbfl_exit 100; }
    alias return_because_error_loading_library='return 100'

    mbfl_EXIT_CODES[3]=99
    mbfl_EXIT_NAMES[3]=program_not_found
    mbfl_EXIT_CODES_BY_NAME[program_not_found]=99
    function exit_because_program_not_found   () { mbfl_exit 99; }
    alias return_because_program_not_found='return 99'

    mbfl_EXIT_CODES[4]=98
    mbfl_EXIT_NAMES[4]=wrong_num_args
    mbfl_EXIT_CODES_BY_NAME[wrong_num_args]=98
    function exit_because_wrong_num_args   () { mbfl_exit 98; }
    alias return_because_wrong_num_args='return 98'

    mbfl_EXIT_CODES[5]=97
    mbfl_EXIT_NAMES[5]=invalid_action_set
    mbfl_EXIT_CODES_BY_NAME[invalid_action_set]=97
    function exit_because_invalid_action_set   () { mbfl_exit 97; }
    alias return_because_invalid_action_set='return 97'

    mbfl_EXIT_CODES[6]=96
    mbfl_EXIT_NAMES[6]=invalid_action_declaration
    mbfl_EXIT_CODES_BY_NAME[invalid_action_declaration]=96
    function exit_because_invalid_action_declaration   () { mbfl_exit 96; }
    alias return_because_invalid_action_declaration='return 96'

    mbfl_EXIT_CODES[7]=95
    mbfl_EXIT_NAMES[7]=invalid_action_argument
    mbfl_EXIT_CODES_BY_NAME[invalid_action_argument]=95
    function exit_because_invalid_action_argument   () { mbfl_exit 95; }
    alias return_because_invalid_action_argument='return 95'

    mbfl_EXIT_CODES[8]=94
    mbfl_EXIT_NAMES[8]=missing_action_function
    mbfl_EXIT_CODES_BY_NAME[missing_action_function]=94
    function exit_because_missing_action_function   () { mbfl_exit 94; }
    alias return_because_missing_action_function='return 94'

    mbfl_EXIT_CODES[9]=93
    mbfl_EXIT_NAMES[9]=invalid_option_declaration
    mbfl_EXIT_CODES_BY_NAME[invalid_option_declaration]=93
    function exit_because_invalid_option_declaration   () { mbfl_exit 93; }
    alias return_because_invalid_option_declaration='return 93'

    mbfl_EXIT_CODES[10]=92
    mbfl_EXIT_NAMES[10]=invalid_option_argument
    mbfl_EXIT_CODES_BY_NAME[invalid_option_argument]=92
    function exit_because_invalid_option_argument   () { mbfl_exit 92; }
    alias return_because_invalid_option_argument='return 92'

    mbfl_EXIT_CODES[11]=91
    mbfl_EXIT_NAMES[11]=invalid_function_name
    mbfl_EXIT_CODES_BY_NAME[invalid_function_name]=91
    function exit_because_invalid_function_name   () { mbfl_exit 91; }
    alias return_because_invalid_function_name='return 91'

    mbfl_EXIT_CODES[12]=90
    mbfl_EXIT_NAMES[12]=invalid_sudo_username
    mbfl_EXIT_CODES_BY_NAME[invalid_sudo_username]=90
    function exit_because_invalid_sudo_username   () { mbfl_exit 90; }
    alias return_because_invalid_sudo_username='return 90'

    mbfl_EXIT_CODES[13]=89
    mbfl_EXIT_NAMES[13]=no_location
    mbfl_EXIT_CODES_BY_NAME[no_location]=89
    function exit_because_no_location   () { mbfl_exit 89; }
    alias return_because_no_location='return 89'

    mbfl_EXIT_CODES[14]=88
    mbfl_EXIT_NAMES[14]=invalid_mbfl_version
    mbfl_EXIT_CODES_BY_NAME[invalid_mbfl_version]=88
    function exit_because_invalid_mbfl_version   () { mbfl_exit 88; }
    alias return_because_invalid_mbfl_version='return 88'
fi

alias exit_success='exit_because_success'
alias exit_failure='exit_because_failure'
alias return_success='return_because_success'
alias return_failure='return_because_failure'

function mbfl_declare_exit_code () {
    mbfl_mandatory_parameter(CODE, 1, exit code)
    mbfl_mandatory_parameter(DESCRIPTION, 2, exit code name)

    if ! mbfl_string_is_digit "$CODE"
    then
    	mbfl_message_error_printf 'invalid exit code (not a digit string): "%s"' "$CODE"
    	return_because_failure
    fi

    if ! mbfl_string_is_identifier "$DESCRIPTION"
    then
	mbfl_message_error_printf 'invalid exit code name (not an identifier): "%s"' "$DESCRIPTION"
	return_because_failure
    fi

    local -i i=mbfl_slots_number(mbfl_EXIT_CODES)
    mbfl_slot_set(mbfl_EXIT_NAMES, $i, $DESCRIPTION)
    mbfl_slot_set(mbfl_EXIT_CODES, $i, $CODE)
    mbfl_slot_set(mbfl_EXIT_CODES_BY_NAME, "$DESCRIPTION", $i)

    {
	local COMMMAND
	printf -v COMMAND 'function exit_because_%s () { mbfl_exit %d; }' "$DESCRIPTION" $CODE
	eval "$COMMAND"
    }

    {
	local COMMAND
	printf -v COMMAND 'alias return_because_%s="return %d"' "$DESCRIPTION" $CODE
	eval "$COMMAND"
    }
}

#page
#### exit codes inspection

function mbfl_list_exit_codes () {
    local -i i
    for ((i=0; i < mbfl_slots_number(mbfl_EXIT_CODES); ++i))
    do printf '%d %s\n' mbfl_slot_ref(mbfl_EXIT_CODES, $i) mbfl_slot_ref(mbfl_EXIT_NAMES, $i)
    done
}
function mbfl_print_exit_code () {
    mbfl_mandatory_parameter(NAME, 1, exit code name)
    local -i i
    for ((i=0; i < mbfl_slots_number(mbfl_EXIT_CODES); ++i))
    do
	if mbfl_string_equal "mbfl_slot_ref(mbfl_EXIT_NAMES, $i)" "$NAME"
	then printf '%d\n' mbfl_slot_ref(mbfl_EXIT_CODES, $i)
	fi
    done
}
function mbfl_print_exit_code_names () {
    mbfl_mandatory_parameter(CODE, 1, exit code)
    local -i i
    for ((i=0; i < mbfl_slots_number(mbfl_EXIT_CODES); ++i))
    do
	if mbfl_string_equal "mbfl_slot_ref(mbfl_EXIT_CODES, $i)" "$CODE"
	then printf '%s\n' mbfl_slot_ref(mbfl_EXIT_NAMES, $i)
	fi
    done
}

#page
#### script termination facilities

if test "$mbfl_INTERACTIVE" != yes
then declare -i mbfl_PENDING_EXIT_CODE=0
fi

function mbfl_script_is_exiting () { return_failure; }

function mbfl_exit () {
    mbfl_optional_parameter(CODE, 1, 0)

    # NOTE Use of this variable is deprecated; it is still here for backwards compatibility.  (Marco
    # Maggi; Nov 11, 2020)
    mbfl_main_pending_EXIT_CODE=$CODE

    mbfl_PENDING_EXIT_CODE=$CODE
    function mbfl_script_is_exiting () { return_success; }
    exit $CODE
}

### end of file
# Local Variables:
# mode: sh
# End:
