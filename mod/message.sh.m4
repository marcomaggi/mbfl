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
#         All the function names are prefixed with "mbfl_message_". All
#       the messages will have the forms:
#
#               <progname>: <message>
#               <progname> [error|warning]: <message>
#
#         The following global variables are declared:
#
#       mbfl_message_PROGNAME -         must be initialised with the
#                                       name of the script that'll be
#                                       displayed at the beginning of
#                                       each message;
#
#       mbfl_message_VERBOSE -          "yes" if verbose messages
#                                       should be displayed, else "no";
#
#       mbfl_message_DEBUGGING -        "yes" if debugging messages
#                                       should be displayed, else "no";
#
#       mbfl_message_STDERR -           the channel used to output
#                                       messages.
#
#         All the functions will return with code zero.
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
# $Id: message.sh.m4,v 1.1.1.10 2003/12/21 07:45:36 marco Exp $
#

m4_include(macros.m4)

#PAGE
## ------------------------------------------------------------
## Message module variables.
## ------------------------------------------------------------

mbfl_message_PROGNAME="${0}"
mbfl_message_VERBOSE="no"
mbfl_message_DEBUGGING="no"
mbfl_message_STDERR="2"


function mbfl_message_set_progname () {
    local PROGNAME="${1:?}"
    mbfl_message_PROGNAME="${PROGNAME}"
    return 0
}
function mbfl_message_set_verbosity () {
    local VERBOSE="${1:?}"
    mbfl_message_VERBOSE="${VERBOSE}"
    return 0
}
function mbfl_message_set_debugging () {
    local DEBUGGING="${1:?}"
    mbfl_message_DEBUGGING="${DEBUGGING}"
    return 0
}
function mbfl_message_set_stderr () {
    local STDERR="${1:?}"
    mbfl_message_STDERR="${STDERR}"
    return 0
}

#PAGE
# mbfl_message_string --
#
#       Outputs a message to the "stderr" channel.
#
#  Arguments:
#
#       $1 -    the message string
#
#  Results:
#
#       Echoes a string composed of: the content of the
#       "mbfl_message_PROGNAME" global variable; a colon; a space;
#       the provided message.
#
#         A newline character is NOT appended to the message. Escape
#       characters are allowed in the message.
#
#  Side effects:
#
#       None.
#

function mbfl_message_string () {
    local MSG="${1:?missing argument to \"mbfl_message_string\"}"
    echo -ne "${mbfl_message_PROGNAME}: ${MSG}" >&${mbfl_message_STDERR}
    return 0
}

#PAGE
# mbfl_message_verbose --
#
#       Outputs a message to the "stderr" channel, but only if the
#       global variable "mbfl_message_VERBOSE" is set to "yes".
#
#  Arguments:
#
#       $1 -    the message string
#
#  Results:
#
#       Echoes a string composed of: the content of the
#       "mbfl_message_PROGNAME" global variable; a colon; a space;
#       the provided message.
#
#         A newline character is NOT appended to the message. Escape
#       characters are allowed in the message.
#
#  Side effects:
#
#       None.
#

function mbfl_message_verbose () {
    local MSG="${1:?missing argument to \"mbfl_message_verbose\"}"
    if test "${mbfl_message_VERBOSE}" = 'yes'
    then echo -ne "${mbfl_message_PROGNAME}: ${MSG}" >&${mbfl_message_STDERR}
    fi
    return 0
}

#PAGE
# mbfl_message_verbose_end --
#
#       Outputs a message to the "stderr" channel, but only if the
#       global variable "mbfl_message_VERBOSE" is set to "yes".
#
#  Arguments:
#
#       $1 -    the message string
#
#  Results:
#
#       Echoes the string. A newline character is NOT appended to
#       the message. Escape characters are allowed in the message.
#
#  Side effects:
#
#       None.
#

function mbfl_message_verbose_end () {
    local MSG="${1:?missing argument to \"mbfl_message_verbose_end\"}"
    if test "${mbfl_message_VERBOSE}" = 'yes'
    then echo -ne "${MSG}" >&${mbfl_message_STDERR}
    fi
    return 0
}

#PAGE
# mbfl_message_debug --
#
#       Outputs a message to the "stderr" channel, but only if the
#       global variable "mbfl_message_DEBUGGING" is set to "yes".
#
#  Arguments:
#
#       $1 -    the message string
#
#  Results:
#
#       Echoes a string composed of: the content of the
#       "mbfl_message_PROGNAME" global variable; a colon; a space;
#       the provided message.
#
#         A newline character is NOT appended to the message. Escape
#       characters are allowed in the message.
#
#  Side effects:
#
#       None.
#

function mbfl_message_debug () {
    local MSG="${1:?missing argument to \"mbfl_message_debug\"}"
    if test "${mbfl_message_DEBUGGING}" = 'yes'
    then echo -ne "${mbfl_message_PROGNAME}: ${MSG}" >&${mbfl_message_STDERR}
    fi
    return 0
}

#PAGE
# mbfl_message_warning --
#
#       Outputs a warning message to the "stderr" channel.
#
#  Arguments:
#
#       $1 -    the message string
#
#  Results:
#
#       Echoes a string composed of: the content of the
#       "_message_PROGNAME" global variable; a space; the string
#       "warning"; a colon; a space; the provided message.
#
#         A newline character IS appended to the message. Escape
#       characters are allowed in the message.
#
#  Side effects:
#
#       None.
#

function mbfl_message_warning () {
    local MSG="${1:?missing argument to \"mbfl_message_warning\"}"
    echo -e "${mbfl_message_PROGNAME} warning: ${MSG}" >&${mbfl_message_STDERR}
    return 0
}

#PAGE
# mbfl_message_error --
#
#       Outputs an error message to the "stderr" channel.
#
#  Arguments:
#
#       $1 -    the message string
#
#  Results:
#
#       Echoes a string composed of: the content of the
#       "_message_PROGNAME" global variable; a space; the string
#       "error"; a colon; a space; the provided message.
#
#         A newline character IS appended to the message. Escape
#       characters are allowed in the message.
#
#  Side effects:
#
#       None.
#

function mbfl_message_error () {
    local MSG="${1:?missing argument to \"mbfl_message_error\"}"
    echo -e "${mbfl_message_PROGNAME} error: ${MSG}" >&${mbfl_message_STDERR}
    return 0
}


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# indent-tabs-mode: nil
# End:
