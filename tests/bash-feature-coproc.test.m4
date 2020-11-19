# bash-feature-coproc.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the Bash feature "coproc"
# Date: Mon Dec 10, 2018
#
# Abstract
#
#	To select the tests in this file:
#
#		$ make all test file=bash-feature-coproc
#
# Copyright (c) 2018, 2020 Marco Maggi <mrc.mgg@gmail.com>
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

#page
#### setup

source setup.sh

#page
#### chatting with a coprocess

function coproc-1.1 () {
    local LINE1 LINE2 EXIT_CODE

    coproc worker-coproc-1.1

    if read -t 4 -u ${COPROC[0]} LINE1
    then
	printf 'hello slave\n' >&${COPROC[1]}
	if read -t 4 -u ${COPROC[0]} LINE2
	then printf 'bye slave\n' >&${COPROC[1]}
	else return 1
	fi
    else return 1
    fi

    wait $COPROC_PID
    EXIT_CODE=$?
    dotest-equal 0 $EXIT_CODE && dotest-equal 'hello master' "$LINE1" && dotest-equal 'bye master' "$LINE2"
}
function worker-coproc-1.1 () {
    local LINE1 LINE2

    printf 'hello master\n'
    if read -t 4 LINE1
    then
	printf 'bye master\n'
	if ! read -t 4 LINE2
	then exit 1
	fi
    else exit 1
    fi
    dotest-equal 'hello slave' "$LINE1" && dotest-equal 'bye slave' "$LINE2"
    mbfl_exit $?
}

#page
#### let's go

dotest coproc-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
