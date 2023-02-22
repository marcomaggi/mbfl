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
# Copyright (c) 2003, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#


#### MBFL's related options and variables

script_REQUIRED_MBFL_VERSION=v3.0.0-devel.3
script_PROGNAME=signaltest.sh
script_VERSION=2.0
script_COPYRIGHT_YEARS='2003, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=LGPL
script_USAGE="usage: ${script_PROGNAME} [options]"
script_DESCRIPTION='Test scripts for signal handling.'
script_EXAMPLES=


#### load library

mbfl_INTERACTIVE='no'
mbfl_load_library("$MBFL_TESTS_LIBMBFL_CORE")


#### global variables

declare SIGSPEC='none'


#### functions

function main () {
    local -i flag=0

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
}
function quitting () {
    local msg="exiting with no interruption"

    if ((0 != flag))
    then msg="exiting after interruption ($SIGSPEC, $flag handlers)"
    fi
    output_and_debug "$msg"
}

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
