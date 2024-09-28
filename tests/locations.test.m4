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
# Copyright (c) 2018, 2020, 2023, 2024 Marco Maggi <mrc.mgg@gmail.com>
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


#### setup

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS
MBFL_DEFINE_QQ_MACRO


#### simple handlers

# Access the variables "R_one" and "X" in the uplevel syntactic environment.
#
function one () {
    R_one=$X
}

# Access the variables "R_two" and "Y" in the uplevel syntactic environment.
#
function two () {
    R_two=$Y
}

# Access the variables "R_three" and "Z" in the uplevel syntactic environment.
#
function three () {
    R_three=$Z
}

### ------------------------------------------------------------------------

function handler_append () {
    local THING=${1:?"missing thing parameter for '${FUNCNAME}'"}
    RESULT+=$THING
}


#### basics

function locations-1.1 () {
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


#### nested locations
#
# Remember that the handlers are called when a location is left.
#

# Two nested locations.
#
function locations-2.1 () {
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
function locations-2.2 () {
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


#### nested function calls

# Two nested function calls.
#
function locations-3.1 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	sub-locations-3.1
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 02314 "$RESULT"
}
function sub-locations-3.1 () {
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
function locations-3.2 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	sub-locations-3.2
    }
    mbfl_location_leave
    handler_append 6

    dotest-equal 0342516 "$RESULT"
}
function sub-locations-3.2 () {
    mbfl_location_handler "handler_append 1"
    mbfl_location_enter
    {
	sub-sub-locations-3.2
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 5"
}
function sub-sub-locations-3.2 () {
    mbfl_location_handler "handler_append 2"
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 3"
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 4"
}


#### locations sequence

function locations-4.1 () {
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


#### running location handlers upon exiting a script

function locations-5.1 () {
    local LINE1 LINE2 EXIT_CODE

    coproc worker_locations_5_1

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
function worker_locations_5_1 () {
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

function locations-5.2 () {
    local LINE1 LINE2 EXIT_CODE

    coproc worker_locations_5_2

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
function worker_locations_5_2 () {
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


#### running all location handlers

function locations-run-all-1.1 () {
    local RESULT

    handler_append 0
    mbfl_location_enter
    {
	sub_locations_run_all_1_1
	mbfl_location_run_all
    }
    mbfl_location_leave
    handler_append 6

    dotest-equal 0342516 "$RESULT"
}
function sub_locations_run_all_1_1 () {
    mbfl_location_handler "handler_append 1"
    mbfl_location_enter
    {
	sub_sub_locations_run_all_1_1
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 5"
}
function sub_sub_locations_run_all_1_1 () {
    mbfl_location_handler "handler_append 2"
    mbfl_location_enter
    {
	mbfl_location_handler "handler_append 3"
    }
    mbfl_location_leave
    mbfl_location_handler "handler_append 4"
}


#### accessing hooks

function locations-hook-1.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(HOOK_RV)

	mbfl_location_handler 'handler_append 1'
	if ! mbfl_location_hook_var _(HOOK_RV)
	then return_failure
	fi
	mbfl_declare_nameref(HOOK, $HOOK_RV)

	mbfl_hook_add $HOOK_RV 'handler_append 2'
	mbfl_hook_add _(HOOK)  'handler_append 3'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03214 "$RESULT"
}

### ------------------------------------------------------------------------

# Store handlers in uplevel hooks.
#
function locations-hook-2.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(OUTER_HOOK_RV)
	mbfl_location_hook_var _(OUTER_HOOK_RV)

	mbfl_location_handler 'handler_append 1'

	mbfl_location_enter
	{
	    mbfl_location_handler 'handler_append 2'
	    mbfl_hook_add $OUTER_HOOK_RV 'handler_append 3'
	}
	mbfl_location_leave
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 02314 "$RESULT"
}


#### maker handlers

# Maker handler NOT run.
#
function locations-maker-handlers-1.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(HOOK_RV)

	mbfl_location_handler 'handler_append 1'
	mbfl_location_maker_handler 'handler_append 2'
	mbfl_location_handler 'handler_append 3'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 0314 "$RESULT"
}
# Maker handler run.
#
function locations-maker-handlers-1.2 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(HOOK_RV)

	mbfl_location_handler 'handler_append 1'
	mbfl_location_maker_handler 'handler_append 2'
	mbfl_location_handler 'handler_append 3'
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03214 "$RESULT"
}


#### remobing handlers by id

# Remove nothing.
#
function locations-remove-handler-by-id-1.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_handler 'handler_append 1'
	mbfl_location_handler 'handler_append 2' _(ID)
	mbfl_location_handler 'handler_append 3'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03214 "$RESULT"
}
function locations-remove-handler-by-id-1.2 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_handler 'handler_append 1'
	mbfl_location_handler 'handler_append 2' _(ID)
	mbfl_location_handler 'handler_append 3'

	mbfl_location_remove_handler_by_id QQ(ID)
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 0314 "$RESULT"
}
function locations-remove-handler-by-id-1.3 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID1)
	mbfl_declare_varref(ID2)
	mbfl_declare_varref(ID3)

	mbfl_location_handler 'handler_append 1' _(ID1)
	mbfl_location_handler 'handler_append 2' _(ID2)
	mbfl_location_handler 'handler_append 3' _(ID3)

	mbfl_location_remove_handler_by_id QQ(ID3)
	mbfl_location_remove_handler_by_id QQ(ID2)
	mbfl_location_remove_handler_by_id QQ(ID1)
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 04 "$RESULT"
}

### ------------------------------------------------------------------------

# Remove nothing.
#
function locations-remove-handler-by-id-2.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_maker_handler 'handler_append 1'
	mbfl_location_maker_handler 'handler_append 2' _(ID)
	mbfl_location_maker_handler 'handler_append 3'

	# By setting  the location  exit status to  1 we tell  "mbfl_location_leave" to  trigger the
	# execution of the maker handlers.
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03214 "$RESULT"
}
function locations-remove-handler-by-id-2.2 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_maker_handler 'handler_append 1'
	mbfl_location_maker_handler 'handler_append 2' _(ID)
	mbfl_location_maker_handler 'handler_append 3'

	mbfl_location_remove_handler_by_id QQ(ID)

	# By setting  the location  exit status to  1 we tell  "mbfl_location_leave" to  trigger the
	# execution of the maker handlers.
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 0314 "$RESULT"
}
function locations-remove-handler-by-id-2.3 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID1)
	mbfl_declare_varref(ID2)
	mbfl_declare_varref(ID3)

	mbfl_location_maker_handler 'handler_append 1' _(ID1)
	mbfl_location_maker_handler 'handler_append 2' _(ID2)
	mbfl_location_maker_handler 'handler_append 3' _(ID3)

	mbfl_location_remove_handler_by_id QQ(ID3)
	mbfl_location_remove_handler_by_id QQ(ID2)
	mbfl_location_remove_handler_by_id QQ(ID1)

	# By setting  the location  exit status to  1 we tell  "mbfl_location_leave" to  trigger the
	# execution of the maker handlers.
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 04 "$RESULT"
}


#### remobing handlers by id

# Replace nothing.
#
function locations-replace-handler-by-id-1.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_handler 'handler_append 1'
	mbfl_location_handler 'handler_append 2' _(ID)
	mbfl_location_handler 'handler_append 3'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03214 "$RESULT"
}
function locations-replace-handler-by-id-1.2 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_handler 'handler_append 1'
	mbfl_location_handler 'handler_append 2' _(ID)
	mbfl_location_handler 'handler_append 3'

	mbfl_location_replace_handler_by_id WW(ID) 'handler_append 9'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03914 "$RESULT"
}
function locations-replace-handler-by-id-1.3 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID1)
	mbfl_declare_varref(ID2)
	mbfl_declare_varref(ID3)

	mbfl_location_handler 'handler_append 1' _(ID1)
	mbfl_location_handler 'handler_append 2' _(ID2)
	mbfl_location_handler 'handler_append 3' _(ID3)

	mbfl_location_replace_handler_by_id WW(ID3) 'handler_append 9'
	mbfl_location_replace_handler_by_id WW(ID2) 'handler_append 8'
	mbfl_location_replace_handler_by_id WW(ID1) 'handler_append 7'
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 09874 "$RESULT"
}

### ------------------------------------------------------------------------

# Replace nothing.
#
function locations-replace-handler-by-id-2.1 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_maker_handler 'handler_append 1'
	mbfl_location_maker_handler 'handler_append 2' _(ID)
	mbfl_location_maker_handler 'handler_append 3'

	# By setting  the location  exit status to  1 we tell  "mbfl_location_leave" to  trigger the
	# execution of the maker handlers.
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03214 "$RESULT"
}
function locations-replace-handler-by-id-2.2 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	mbfl_location_maker_handler 'handler_append 1'
	mbfl_location_maker_handler 'handler_append 2' _(ID)
	mbfl_location_maker_handler 'handler_append 3'

	mbfl_location_replace_handler_by_id WW(ID) 'handler_append 9'

	# By setting  the location  exit status to  1 we tell  "mbfl_location_leave" to  trigger the
	# execution of the maker handlers.
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 03914 "$RESULT"
}
function locations-replace-handler-by-id-2.3 () {
    declare RESULT

    handler_append 0
    mbfl_location_enter
    {
	mbfl_declare_varref(ID1)
	mbfl_declare_varref(ID2)
	mbfl_declare_varref(ID3)

	mbfl_location_maker_handler 'handler_append 1' _(ID1)
	mbfl_location_maker_handler 'handler_append 2' _(ID2)
	mbfl_location_maker_handler 'handler_append 3' _(ID3)

	mbfl_location_replace_handler_by_id WW(ID3) 'handler_append 9'
	mbfl_location_replace_handler_by_id WW(ID2) 'handler_append 8'
	mbfl_location_replace_handler_by_id WW(ID1) 'handler_append 7'

	# By setting  the location  exit status to  1 we tell  "mbfl_location_leave" to  trigger the
	# execution of the maker handlers.
	false
    }
    mbfl_location_leave
    handler_append 4

    dotest-equal 09874 "$RESULT"
}


#### let's go

dotest locations-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
