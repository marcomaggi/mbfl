# signaltest.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: test script for signal handling
# Date: Mon Jul  7, 2003
#
# Abstract
#
#
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

#page
#### MBFL's related options and variables

script_PROGNAME=signaltest.sh
script_VERSION=2.0
script_COPYRIGHT_YEARS='2003, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=LGPL
script_USAGE="usage: ${script_PROGNAME} [options]"
script_DESCRIPTION='Test scripts for signal handling.'
script_EXAMPLES=

#page
#### load library

mbfl_INTERACTIVE='no'
source "${MBFL_LIBRARY:=libmbfl.sh}"

#page
#### global variables

declare SIGSPEC='none'

#page
#### functions

function main () {
    local flag=0

    # Enable job control.  So we can "suspend" later.
    set -m

    mbfl_message_debug "running: pid $$"

    mbfl_signal_attach SIGUSR1 handler_one
    mbfl_signal_attach SIGUSR1 handler_two

    mbfl_signal_attach SIGUSR2 handler_three
    mbfl_signal_attach SIGUSR2 handler_four

    mbfl_message_debug "waiting for SIGCONT"
    suspend
    mbfl_message_debug "exiting"
    trap quitting EXIT
    exit 0
}

function handler_one () {
    SIGSPEC=SIGUSR1
    mbfl_message_debug "interrupted by signal (handler one)"
    let ++flag
}
function handler_two () {
    SIGSPEC=SIGUSR1
    mbfl_message_debug "interrupted by signal (handler two)"
    let ++flag
}
function handler_three () {
    SIGSPEC=SIGUSR2
    mbfl_message_debug "interrupted by signal (${FUNCNAME})"
    let ++flag
}
function handler_four () {
    SIGSPEC=SIGUSR2
    mbfl_message_debug "interrupted by signal (${FUNCNAME})"
    let ++flag
}
function output_and_debug () {
    echo "$1"
    mbfl_message_debug "$1"
    sync
}
function quitting () {
    local msg="exiting with no interruption"

    if test $flag != 0
    then
	msg="exiting after interruption ($SIGSPEC, $flag handlers)"
    fi
    output_and_debug "$msg"
}

mbfl_main

### end of file
