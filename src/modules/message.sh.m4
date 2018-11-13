# message.sh --
#
# Part of: Marco's BASH function library
# Contents: message displaying functions
# Date: Sat Apr 19, 2003
#
# Abstract
#
#       This is a collection of functions for the GNU BASH shell. It's
#       purpose is to allow easy displaying of error and "verbose"
#       messages to the stderr channel of a script.
#
# Copyright (c) 2003-2005, 2009, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
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

#PAGE
#### configuration and low level functions

declare mbfl_message_PROGNAME=$script_PROGNAME
declare mbfl_message_CHANNEL=2

function mbfl_message_set_progname () {
    mbfl_message_PROGNAME=${1:?$FUNCNAME error: missing program name argument}
}
function mbfl_message_set_channel () {
    local CHANNEL=${1:?$FUNCNAME error: missing channel argument}

    if mbfl_string_is_digit "$CHANNEL"
    then mbfl_message_CHANNEL=$CHANNEL
    else
	mbfl_message_error_printf 'invalid message channel, expected digits: "%s"' "$CHANNEL"
	return 1
    fi
}
function mbfl_message_p_print () {
    printf "${2:?$1 error: missing template argument}" >&$mbfl_message_CHANNEL
}
function mbfl_message_p_print_prefix () {
    mbfl_message_p_print $1 "$mbfl_message_PROGNAME: $2"
}

#PAGE
#### printing plain messages

function mbfl_message_string () {
    mbfl_optional_parameter(STRING, 1, string)
    mbfl_message_p_print $FUNCNAME "$1"
    return 0
}
function mbfl_message_verbose () {
    if mbfl_option_verbose
    then mbfl_message_p_print_prefix $FUNCNAME "$1"
    fi
    return 0
}
function mbfl_message_verbose_end () {
    if mbfl_option_verbose
    then mbfl_message_p_print $FUNCNAME "$1\n"
    fi
    return 0
}
function mbfl_message_error () {
    mbfl_message_p_print_prefix $FUNCNAME "error: $1\n"
    return 0
}
function mbfl_message_warning () {
    mbfl_message_p_print_prefix $FUNCNAME "warning: $1\n"
    return 0
}
function mbfl_message_debug () {
    mbfl_option_debug && mbfl_message_p_print_prefix $FUNCNAME "debug: $1\n"
    return 0
}

#page
#### printing formatted messages

function mbfl_message_verbose_printf () {
    if mbfl_option_verbose
    then
        {
	    printf '%s: ' "$mbfl_message_PROGNAME"
            printf "$@"
	} >&$mbfl_message_CHANNEL
    fi
    return 0
}
function mbfl_message_error_printf () {
    {
        printf '%s: error: ' "$mbfl_message_PROGNAME"
        printf "$@"
        echo
    } >&$mbfl_message_CHANNEL
    return 0
}
function mbfl_message_warning_printf () {
    {
        printf '%s: warning: ' "$mbfl_message_PROGNAME"
        printf "$@"
        echo
    } >&$mbfl_message_CHANNEL
    return 0
}
function mbfl_message_debug_printf () {
    if mbfl_option_debug
    then
        {
            printf '%s: debug: ' "$mbfl_message_PROGNAME"
            printf "$@"
            echo
        } >&$mbfl_message_CHANNEL
    fi
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
