# conditions.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for file module
# Date: May  2, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=conditions-
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

declare -r script_PROGNAME='conditions.test'

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### base class tests

function conditions-base-define-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_condition_is_a _(ERR)
}
function conditions-base-accessors-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is an error message' "$MSG"
}
function conditions-base-mutators-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_condition_message_set _(ERR) 'this is another error message'
    mbfl_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is another error message' "$MSG"
}
function conditions-base-method-print-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_condition_print _(ERR) |& dotest-output 'this is an error message'
}


#### error class tests

function conditions-error-maker-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_error_condition_define _(ERR) 'this is an error message'
    mbfl_error_condition_is_a _(ERR)
}
function conditions-error-accessors-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_error_condition_define _(ERR) 'this is an error message'
    mbfl_error_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is an error message' "$MSG"
}
function conditions-error-mutators-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_error_condition_message_set _(ERR) 'this is another error message'
    mbfl_error_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is another error message' "$MSG"
}
function conditions-error-method-pring-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_error_condition_define _(ERR) 'this is an error message'
    mbfl_condition_print _(ERR) |& dotest-output 'conditions.test: error: this is an error message'
}


#### warning class tests

function conditions-warning-maker-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_warning_condition_define _(ERR) 'this is an warning message'
    mbfl_warning_condition_is_a _(ERR)
}
function conditions-warning-accessors-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_warning_condition_define _(ERR) 'this is an warning message'
    mbfl_warning_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is an warning message' "$MSG"
}
function conditions-warning-mutators-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_condition_define _(ERR) 'this is an warning message'
    mbfl_warning_condition_message_set _(ERR) 'this is another warning message'
    mbfl_warning_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is another warning message' "$MSG"
}
function conditions-warning-method-print-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_warning_condition_define _(ERR) 'this is an warning message'
    mbfl_condition_print _(ERR) |& dotest-output 'conditions.test: warning: this is an warning message'
}


#### runtime-error class tests

function conditions-runtime-error-maker-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_runtime_error_condition_define _(ERR) 'this is an error message'
    mbfl_runtime_error_condition_is_a _(ERR)
}
function conditions-runtime-error-accessors-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_runtime_error_condition_define _(ERR) 'this is an error message'
    mbfl_runtime_error_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is an error message' "$MSG"
}
function conditions-runtime-error-mutators-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_runtime_error_condition_message_set _(ERR) 'this is another error message'
    mbfl_runtime_error_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is another error message' "$MSG"
}
function conditions-runtime-error-method-print-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_runtime_error_condition_define _(ERR) 'this is an error message'
    mbfl_condition_print _(ERR) |& dotest-output 'conditions.test: error: this is an error message'
}


#### logic-error class tests

function conditions-logic-error-maker-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_logic_error_condition_define _(ERR) 'this is an error message'
    mbfl_logic_error_condition_is_a _(ERR)
}
function conditions-logic-error-accessors-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_logic_error_condition_define _(ERR) 'this is an error message'
    mbfl_logic_error_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is an error message' "$MSG"
}
function conditions-logic-error-mutators-1.1 () {
    mbfl_default_object_declare(ERR)
    mbfl_declare_varref(MSG)

    mbfl_condition_define _(ERR) 'this is an error message'
    mbfl_logic_error_condition_message_set _(ERR) 'this is another error message'
    mbfl_logic_error_condition_message_var _(MSG) _(ERR)
    dotest-equal 'this is another error message' "$MSG"
}
function conditions-logic-error-method-print-1.1 () {
    mbfl_default_object_declare(ERR)

    mbfl_logic_error_condition_define _(ERR) 'this is an error message'
    mbfl_condition_print _(ERR) |& dotest-output 'conditions.test: error: this is an error message'
}


#### condition objects handling with locations

# Build a condition object, store it into a global varref, use it upon exiting a location, unset it.
#
function conditions-location-mechanism-1.1 () {
    mbfl_default_object_declare_global(condition_object_conditions_location_mechanism_1_1)
    mbfl_declare_varref(FLAG, false)

    mbfl_location_enter
    {
	mbfl_location_handler "handler_conditions_location_mechanism_1_1"

	mbfl_condition_define _(condition_object_conditions_location_mechanism_1_1) "this is condition conditions_location_1_1"
    }
    mbfl_location_leave
    dotest-equal 'this is condition conditions_location_1_1' "$FLAG"
}
function handler_conditions_location_mechanism_1_1 () {
    if mbfl_condition_is_a _(condition_object_conditions_location_mechanism_1_1)
    then
	mbfl_condition_message_var _(FLAG) _(condition_object_conditions_location_mechanism_1_1)
	mbfl_variable_unset(_(condition_object_conditions_location_mechanism_1_1))
    fi
}

### ------------------------------------------------------------------------

# Build a condition object,  store it into a global variable, use it  upon exiting a location, unset
# it.
#
function conditions-location-mechanism-1.2 () {
    declare -g condition_object_conditions_location_mechanism_1_2
    mbfl_declare_varref(FLAG, false)

    mbfl_location_enter
    {
	mbfl_location_handler "handler_conditions_location_mechanism_1_2"

	mbfl_default_object_declare(CND)
	mbfl_condition_define _(CND) "this is condition conditions_location_1_2"
	condition_object_conditions_location_mechanism_1_2=_(CND)
    }
    mbfl_location_leave
    dotest-equal 'this is condition conditions_location_1_2' "$FLAG" && ! test -v "$condition_object_conditions_location_mechanism_1_2"
}
function handler_conditions_location_mechanism_1_2 () {
    if mbfl_condition_is_a "$condition_object_conditions_location_mechanism_1_2"
    then
	mbfl_declare_nameref(CND, "$condition_object_conditions_location_mechanism_1_2")
	mbfl_condition_message_var _(FLAG) _(CND)
	mbfl_variable_unset(_(CND))
    fi
}


#### let's go

dotest conditions-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
