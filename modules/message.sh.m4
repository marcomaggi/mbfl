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

#PAGE
## ------------------------------------------------------------
## Message module variables.
## ------------------------------------------------------------

mbfl_message_PROGNAME="${0}"
mbfl_message_CHANNEL="2"

function mbfl_message_set_progname () {
    mbfl_message_PROGNAME="${1:?${FUNCNAME} error: missing program name argument}"
}
function mbfl_message_set_channel () {
    mbfl_message_CHANNEL="${1:?${FUNCNAME} error: missing channel argument}"
}
#PAGE
function mbfl_message_p_print () {
    echo -ne "${2:?${1} error: missing argument}" >&${mbfl_message_CHANNEL}
}
function mbfl_message_p_print_prefix () {
    mbfl_message_p_print ${1} "${mbfl_message_PROGNAME}: ${2}"
}
function mbfl_message_string () {
    mbfl_message_p_print ${FUNCNAME} "$1"
    return 0
}
function mbfl_message_verbose () {
    mbfl_option_verbose && mbfl_message_p_print_prefix ${FUNCNAME} "$1"
    return 0
}
function mbfl_message_verbose_end () {
    mbfl_option_verbose && mbfl_message_p_print ${FUNCNAME} "$1\n"
    return 0
}
function mbfl_message_debug () {
    mbfl_option_debug && mbfl_message_p_print_prefix ${FUNCNAME} "debug: $1\n"
    return 0
}
function mbfl_message_warning () {
    mbfl_message_p_print_prefix ${FUNCNAME} "warning: $1\n"
    return 0
}
function mbfl_message_error () {
    mbfl_message_p_print_prefix ${FUNCNAME} "error: $1\n"
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
