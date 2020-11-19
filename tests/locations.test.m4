# locations.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the locations module functions
# Date: Nov 28, 2018
#
# Abstract
#
#	To select the tests in this file:
#
#		$ make all test file=locations
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
#### simple handlers

# Access  the  variables  "R_one"  and  "X"  in  the  uplevel  syntactic
# environment.
#
function one () {
    R_one=$X
}

# Access  the  variables  "R_two"  and  "Y"  in  the  uplevel  syntactic
# environment.
#
function two () {
    R_two=$Y
}

# Access  the  variables "R_three"  and  "Z"  in the  uplevel  syntactic
# environment.
#
function three () {
    R_three=$Z
}

### ------------------------------------------------------------------------

function handler_append () {
    local THING=${1:?"missing thing parameter for '${FUNCNAME}'"}
    RESULT+=$THING
}

#page
#### basics

function locations-01.1 () {
    local R_one R_two R_three
    local X=1 Y=2 Z=3

    mbfl_location_enter
    {
	mbfl_location_handler one
	mbfl_location_handler two
	mbfl_location_handler three
    }
    mbfl_location_leave
    { dotest-equal 1 $R_one; } && { dotest-equal 2 $R_two; } && { dotest-equal 3 $R_three; }
}

#page
#### nested locations
#
# Remember that the handlers are called when a location is left.
#

# Two nested locations.
#
function locations-02.1 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 1"
	mbfl_location_enter
	{
	    mbfl_location_handler "handler_append 2"
	}
	mbfl_location_leave
	mbfl_location_handler "handler_append 3"
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 02314 "$RESULT"
}

# Three nested locations.
#
function locations-02.2 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 1"
	mbfl_location_enter
	{
	    mbfl_location_handler "handler_append 2"
	    mbfl_location_enter
	    {
		mbfl_location_handler "handler_append 3"
	    }
	    mbfl_location_leave
	    mbfl_location_handler "handler_append 4"
	}
	mbfl_location_leave
	mbfl_location_handler "handler_append 5"
    }
    mbfl_location_leave
    handler_append 6

    dotest-equal 0342516 "$RESULT"
}

#page
#### nested function calls

# Two nested function calls.
#
function locations-03.1 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	sub-locations-03.1
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 02314 "$RESULT"
}
function sub-locations-03.1 () {
    mbfl_location_handler "handler_append 1"
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 2"
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 3"
}

### ------------------------------------------------------------------------

# Three nested function calls.
#
function locations-03.2 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	sub-locations-03.2
    }
    mbfl_location_leave
    handler_append 6

    dotest-equal 0342516 "$RESULT"
}
function sub-locations-03.2 () {
    mbfl_location_handler "handler_append 1"
    mbfl_location_enter
    {
	sub-sub-locations-03.2
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 5"
}
function sub-sub-locations-03.2 () {
    mbfl_location_handler "handler_append 2"
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 3"
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 4"
}

#page
#### locations sequence

function locations-04.1 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_location_handler 'handler_append 1'
    }
    mbfl_location_leave
    handler_append 2
    mbfl_location_enter
    {
	mbfl_location_handler 'handler_append 3'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 01234 "$RESULT"
}

#page
#### running location handlers upon exiting a script

function locations-05.1 () {
    local LINE1 LINE2 EXIT_CODE

    coproc worker-locations-05.1

    if ! read -t 4 -u ${COPROC[0]} LINE1
    then return 1
    fi

    if ! read -t 4 -u ${COPROC[0]} LINE2
    then return 1
    fi

    wait $COPROC_PID
    EXIT_CODE=$?

    dotest-equal 0 $EXIT_CODE && dotest-equal 456 "$LINE1" && dotest-equal 123 "$LINE2"
}
function worker-locations-05.1 () {
    mbfl_atexit_enable
    mbfl_location_enable_cleanup_atexit

    #dotest-set-debug
    dotest-debug "worker function"

    mbfl_location_enter
    {
	mbfl_location_handler 'echo 123'
	mbfl_location_handler 'echo 456'
	exit_because_success
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function locations-06.1 () {
    local LINE1 LINE2 EXIT_CODE

    coproc worker-locations-06.1

    if ! read -t 4 -u ${COPROC[0]} LINE1
    then return 1
    fi

    if ! read -t 4 -u ${COPROC[0]} LINE2
    then return 1
    fi

    wait $COPROC_PID
    EXIT_CODE=$?

    dotest-equal 77 $EXIT_CODE && dotest-equal 77 "$LINE1" && dotest-equal 66 "$LINE2"
}
function worker-locations-06.1 () {
    mbfl_atexit_enable
    mbfl_location_enable_cleanup_atexit

    #dotest-set-debug
    dotest-debug "worker function"

    mbfl_location_enter
    {
	mbfl_location_handler 'if mbfl_main_is_exiting ; then echo 66 ; else echo bad; fi'
	mbfl_location_handler 'echo $mbfl_main_pending_EXIT_CODE'
	mbfl_exit 77
    }
    mbfl_location_leave
}

#page
#### special handlers: test mode suspension

function locations-test-suspension-1.0 () {
    local RESULT_INNER RESULT_OUTER RESULT_BRANCH

    mbfl_option_test_save
    {
	mbfl_set_option_test
	if {
	    mbfl_location_enter
	    {
		# Suspend testing.
		mbfl_location_handler_suspend_testing
		# This returns 0 if testing is enabled; it returns 1 otherwise.  So it should return
		# 1.
		mbfl_option_test
		RESULT_INNER=$?
		mbfl_option_test
	    }
	    mbfl_location_leave
	}
	then true
	else false
	fi
	RESULT_BRANCH=$?
	mbfl_option_test
	RESULT_OUTER=$?
    }
    mbfl_option_test_restore
    dotest-equal 1 $RESULT_INNER 'result of suspending inner' &&
	dotest-equal 0 $RESULT_OUTER 'result of suspending outer' &&
	dotest-equal 1 $RESULT_BRANCH 'result of suspending branch'
}

function locations-test-suspension-1.1 () {
    local RESULT_INNER RESULT_OUTER RESULT_BRANCH

    mbfl_option_test_save
    {
	mbfl_unset_option_test
	if {
	    mbfl_location_enter
	    {
		# Suspend testing.
		mbfl_location_handler_suspend_testing
		# This returns 0 if testing is enabled; it returns 1 otherwise.  So it should return
		# 1.
		mbfl_option_test
		RESULT_INNER=$?
		mbfl_option_test
	    }
	    mbfl_location_leave
	}
	then true
	else false
	fi
	RESULT_BRANCH=$?
	mbfl_option_test
	RESULT_OUTER=$?
    }
    mbfl_option_test_restore
    dotest-equal 1 $RESULT_INNER 'result of suspending inner' &&
	dotest-equal 1 $RESULT_OUTER 'result of suspending outer' &&
	dotest-equal 1 $RESULT_BRANCH 'result of suspending branch'
}

#page
#### internals inspection

# After all the tests we have run: the counter must be back to zero.
#
function locations-98.1 () {
    dotest-equal 0 ${mbfl_location_COUNTER}
}

# After all the tests we have run: all count fields must be empty.
#
function locations-98.2 () {
    local -i i max=100

    for ((i=0; i < max; ++i))
    do dotest-equal '' "${mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]}"
    done
}

#page
#### running all location handlers

function locations-99.1 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	sub-locations-99.2
	mbfl_location_run_all
	locations-98.1
	locations-98.2
    }
    mbfl_location_leave
    handler_append 6

    dotest-equal 0342516 "$RESULT"
}
function sub-locations-99.2 () {
    mbfl_location_handler "handler_append 1"
    mbfl_location_enter
    {
	sub-sub-locations-99.2
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 5"
}
function sub-sub-locations-99.2 () {
    mbfl_location_handler "handler_append 2"
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 3"
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 4"
}

#page
#### let's go

dotest locations-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
