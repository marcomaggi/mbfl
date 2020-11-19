# signal.test --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the signal library
# Date: Mon Jul  7, 2003
#
# Abstract
#
#
# Copyright (c) 2003, 2004, 2005, 2013, 2018, 2020 Marco Maggi
# <mrc.mgg@gmail.com>
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

#PAGE
#### setup

mbfl_load_library("$MBFL_TESTS_LIBMBFL")
mbfl_load_library("$MBFL_TESTS_LIBMBFLTEST")

dotest-set-debug

function debug-wait () {
    local -i thousands=${1:?"missing thousands argument to '${FUNCNAME}'"}
    local -i i
    for ((i=0; i < ((thousands * 1000)); ++i)); do :; done
}

function signaltest () {
    local SIGSPEC="$1"
    local i pid
    local tmpfile="$(dotest-mkfile result.txt)"
    local SIGNALTEST_FLAGS

    # Enable job control.
    set -m

    if dotest-option-debug
    then SIGNALTEST_FLAGS+=' --debug'
    fi

    dotest-debug "executing test script"
    PATH="$PATH" $BASH "$testsdir"/signaltest.sh ${SIGNALTEST_FLAGS} >"$tmpfile" &
    pid=$!
    dotest-debug "test script pid: $pid"

    # Let the process start and register its signal handlers.
    debug-wait 30
    dotest-debug "sending ${SIGSPEC} signal to pid '$pid'"
    kill -${SIGSPEC} $pid
    dotest-debug "sending SIGCONT signal to pid '$pid' to wake it up"
    kill -SIGCONT $pid

    dotest-debug "waiting for pid '$pid'"
    wait $pid
    dotest-debug "received finalisation of pid '$pid'"
    debug-wait 30
    dotest-equal "exiting after interruption ($SIGSPEC, 2 handlers)" "$(<${tmpfile})"
    dotest-clean-files
}

#PAGE
#### tests

function signal-1.1 () {
    signaltest "SIGUSR1"
}
function signal-1.2 () {
    signaltest "SIGUSR2"
}

#PAGE
#### let's go

dotest signal-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
