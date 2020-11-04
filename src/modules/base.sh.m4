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
declare -r mbfl_SEMANTIC_VERSION='__SEMANTIC_VERSION__'

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

### end of file
# Local Variables:
# mode: sh
# End:
