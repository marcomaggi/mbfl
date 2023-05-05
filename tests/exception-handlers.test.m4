#exception-handlers.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for exception handlers
# Date: May  4, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=exception-handlers-
#
#	that will select these tests.
#
# Copyright (c) 2023 Marco Maggi
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


#### setup

declare -r script_PROGNAME='exception-handlers.test'

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### helpers

function test_exception_handler_return_success () {
    mbfl_mandatory_nameref_parameter(CND, 1, condition object)

    return_success
}


#### basic tests

function exception-handlers-uncaught-exception-1.1 () {
    mbfl_default_object_declare(CND)
    declare -i RETURN_STATUS

    mbfl_runtime_error_condition_make _(CND) 'this is an error message' 'false'

    # Raise the exception in a subshell so we easily intercept its exit status.
    (mbfl_exception_raise _(CND))
    RETURN_STATUS=$?
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $RETURN_STATUS 'exit status after uncaught exception'
}

# Raise a non-continuable exception; the  handler returns success; "mbfl_exception_raise" exits with
# "exit_because_non_continuable_exception".
#
function exception-handlers-non-continuable-exception-1.1 () {
    declare -i RETURN_STATUS

    mbfl_location_enter
    {
	mbfl_exception_handler test_exception_handler_return_success

	{
	    mbfl_default_object_declare(CND)

	    mbfl_runtime_error_condition_make _(CND) 'this is an error message'
	    mbfl_runtime_error_condition_continuable_set _(CND) 'false'

	    # Raise the exception in a subshell so we easily intercept its exit status.
	    (mbfl_exception_raise _(CND))
	    RETURN_STATUS=$?
	}
    }
    mbfl_location_leave

    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, non_continuable_exception) $RETURN_STATUS 'exit status after non-continuable exception'
}

# Raise a continuable exception; the handler returns success; "mbfl_exception_raise" returns.
#
function exception-handlers-continuable-exception-1.1 () {
    declare -i RETURN_STATUS

    mbfl_location_enter
    {
	mbfl_exception_handler test_exception_handler_return_success

	{
	    mbfl_default_object_declare(CND)

	    mbfl_runtime_error_condition_make _(CND) 'this is an error message'
	    mbfl_runtime_error_condition_continuable_set _(CND) 'true'

	    (mbfl_exception_raise _(CND))
	    RETURN_STATUS=$?
	}
    }
    mbfl_location_leave

    dotest-equal 0 $RETURN_STATUS 'exit status after non-continuable exception'
}


#### multiple handlers

function exception-handlers-operations-1.1 () {
    # Configure which exceptional-condition will be raised.
    #
    declare -rA RAISE=([ALPHA]=false [BETA]=false [GAMMA]=false)

    # Configure which exceptional-condition will be handled successfully and will cause execution to
    # resume as if nothing happened.
    #
    declare -rA HANDLE_SUCCESSFULLY=([ALPHA]=true [BETA]=false [GAMMA]=false)

    # Describe which operatio step function returned successfully.
    #
    declare -a OPERATION_STEP_SUCCESS=([0]=false [1]=false [2]=false [3]=false)

    mbfl_declare_varref(CONDITION_MESSAGE)

    if test_operation_1_step_0
    then OPERATION_STEP_SUCCESS[0]=true
    fi

    dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 3)	'operation step 3 status'     &&
	dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 2)	'operation step 2 status'     &&
	dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 1)	'operation step 1 status'     &&
	dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 0)	'operation step 0 status'     &&
	mbfl_string_empty(CONDITION_MESSAGE)
}
function exception-handlers-operations-2.1 () {
    # Configure which exceptional-condition will be raised.
    #
    declare -rA RAISE=([ALPHA]=false [BETA]=false [GAMMA]=true)

    # Configure which exceptional-condition will be handled successfully and will cause execution to
    # resume as if nothing happened.
    #
    declare -rA HANDLE_SUCCESSFULLY=([ALPHA]=true [BETA]=false [GAMMA]=true)

    # Describe which operatio step function returned successfully.
    #
    declare -a OPERATION_STEP_SUCCESS=([0]=false [1]=false [2]=false [3]=false)

    mbfl_declare_varref(CONDITION_MESSAGE)

    dotest-set-debug

    if test_operation_1_step_0
    then OPERATION_STEP_SUCCESS[0]=true
    fi

    dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 3)	'operation step 3 status'     &&
	dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 2)	'operation step 2 status'     &&
	dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 1)	'operation step 1 status'     &&
	dotest-equal	'true'	_(OPERATION_STEP_SUCCESS, 0)	'operation step 0 status'     &&
	dotest-equal	'this is a gamma condition' "$CONDITION_MESSAGE"
}

### ------------------------------------------------------------------------

function test_operation_1_step_0 () {
    mbfl_default_class_declare(test_condition_1_alpha_t)
    mbfl_default_class_declare(test_condition_1_beta_t)
    mbfl_default_class_declare(test_condition_1_gamma_t)

    mbfl_default_class_define _(test_condition_1_alpha_t) _(mbfl_condition_t) 'test_condition_1_alpha'
    mbfl_default_class_define _(test_condition_1_beta_t)  _(mbfl_condition_t) 'test_condition_1_beta'
    mbfl_default_class_define _(test_condition_1_gamma_t) _(mbfl_condition_t) 'test_condition_1_gamma'

    dotest-debug enter
    mbfl_location_enter
    {
	if test_operation_1_step_1
	then _(OPERATION_STEP_SUCCESS, 1, true)
	else
	    mbfl_location_leave
	    return_failure
	fi
    }
    mbfl_location_leave
}
function test_operation_1_step_1 () {
    dotest-debug enter
    mbfl_location_enter
    {
	mbfl_exception_handler test_operation_1_exception_handler_1
	if test_operation_1_step_2
	then _(OPERATION_STEP_SUCCESS, 2, true)
	else
	    mbfl_location_leave
	    return_failure
	fi
    }
    mbfl_location_leave
}
function test_operation_1_step_2 () {
    dotest-debug enter
    mbfl_location_enter
    {
	mbfl_exception_handler test_operation_1_exception_handler_2
	if test_operation_1_step_3
	then _(OPERATION_STEP_SUCCESS, 3, true)
	else
	    mbfl_location_leave
	    return_failure
	fi
    }
    mbfl_location_leave
}
function test_operation_1_step_3 () {
    dotest-debug enter
    mbfl_location_enter
    {
	mbfl_exception_handler test_operation_1_exception_handler_3
	mbfl_default_object_declare(CND)

	if _(RAISE, ALPHA)
	then
	    test_condition_1_alpha_define _(CND) 'this is an alpha condition' 'true'
	    dotest-debug raising alpha condition datavar="_(CND)"
	    if ! test_operation_1_raise _(CND)
	    then return_failure
	    fi
	elif _(RAISE, BETA)
	then
	    test_condition_1_beta_define  _(CND) 'this is a beta condition'   'true'
	    dotest-debug raising beta condition datavar="_(CND)"
	    if ! test_operation_1_raise _(CND)
	    then return_failure
	    fi
	elif _(RAISE, GAMMA)
	then
	    test_condition_1_gamma_define _(CND) 'this is a gamma condition'  'true'
	    dotest-debug raising gamma condition datavar="_(CND)"
	    if ! test_operation_1_raise _(CND)
	    then return_failure
	    fi
	else
 	    dotest-debug no-exception execution path
	fi
    }
    mbfl_location_leave
    return_success
}

### ------------------------------------------------------------------------

function test_operation_1_exception_handler_1 () {
    mbfl_mandatory_nameref_parameter(CND, 1, condition object)

    if dotest-option-debug
    then
	mbfl_declare_varref(CLASS)
	mbfl_declare_varref(NAME)

	mbfl_default_object_class_var _(CLASS) _(CND)
	mbfl_default_class_name_var   _(NAME)  "$CLASS"
	dotest-debug condition class name="$NAME"
    fi

    if test_condition_1_alpha_is_a _(CND)
    then
	dotest-debug handling alpha condition
	test_condition_1_alpha_message_var _(CONDITION_MESSAGE) _(CND)

	if _(HANDLE_SUCCESSFULLY, ALPHA)
	then return_success_after_handling_exception
	else return_failure_after_handling_exception
	fi
    else return_after_not_handling_exception
    fi
}
function test_operation_1_exception_handler_2 () {
    mbfl_mandatory_nameref_parameter(CND, 1, condition object)

    if dotest-option-debug
    then
	mbfl_declare_varref(CLASS)
	mbfl_declare_varref(NAME)

	mbfl_default_object_class_var _(CLASS) _(CND)
	mbfl_default_class_name_var   _(NAME)  "$CLASS"
	dotest-debug condition class name="$NAME"
    fi

    if test_condition_1_beta_is_a _(CND)
    then
	dotest-debug handling beta condition
	test_condition_1_beta_message_var _(CONDITION_MESSAGE) _(CND)

	if _(HANDLE_SUCCESSFULLY, BETA)
	then return_success_after_handling_exception
	else return_failure_after_handling_exception
	fi
    else return_after_not_handling_exception
    fi
}
function mbfl_default_object_class_name_var () {
    mbfl_mandatory_nameref_parameter(NAME, 1, result variable)
    mbfl_mandatory_nameref_parameter(OBJ,  2, default object)
    mbfl_declare_varref(CLASS)

    mbfl_default_object_class_var _(CLASS) _(OBJ)
    mbfl_default_class_name_var   _(NAME)  "$CLASS"
}
function test_operation_1_exception_handler_3 () {
    mbfl_mandatory_nameref_parameter(CND, 1, condition object)

    if dotest-option-debug
    then
	mbfl_declare_varref(NAME)
	mbfl_default_object_class_name_var _(NAME) _(CND)
	dotest-debug condition class name="$NAME"
    fi

    if test_condition_1_gamma_is_a _(CND)
    then
	dotest-debug handling gamma condition
	test_condition_1_gamma_message_var _(CONDITION_MESSAGE) _(CND)

	if _(HANDLE_SUCCESSFULLY, GAMMA)
	then return_success_after_handling_exception
	else return_failure_after_handling_exception
	fi
    else return_after_not_handling_exception
    fi
}

### ------------------------------------------------------------------------

function test_operation_1_raise () {
    mbfl_mandatory_nameref_parameter(CND, 1, condition object)

    if mbfl_exception_raise _(CND)
    then
	TEST_EXCEPTION_HANDLED_SUCCESSFULLY=true
	return_success
    else
	TEST_EXCEPTION_HANDLED_SUCCESSFULLY=false
	mbfl_location_leave
	return_failure
    fi
}


#### let's go

dotest exception-handlers-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
