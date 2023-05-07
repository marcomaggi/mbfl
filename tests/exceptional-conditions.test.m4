# conditions.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for exceptional-condition objects
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

declare -r script_PROGNAME='exceptional-conditions.test'

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### base class tests

mbfl_default_class_declare_global(my_something_happened_t)

mbfl_default_class_define _(my_something_happened_t) _(mbfl_exceptional_condition_t) 'my_something_happened'

function my_something_happened_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(MESSAGE,		3, exceptional-condition description message)
    mbfl_mandatory_parameter(CONTINUABLE,	4, condition continuable state)

    my_something_happened_define _(CND) "$WHO" "$MESSAGE" "$CONTINUABLE"
}

function conditions-base-define-1.1 () {
    mbfl_default_object_declare(CND)

    my_something_happened_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_exceptional_condition_is_a _(CND)
}
function conditions-base-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_something_happened_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_exceptional_condition_who_var		_(WHO)		_(CND)
    mbfl_exceptional_condition_message_var	_(MESSAGE)	_(CND)
    mbfl_exceptional_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-base-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_something_happened_make _(CND) $FUNCNAME 'this is an error message' 'false'

    mbfl_exceptional_condition_who_set		_(CND) 'another_who'
    mbfl_exceptional_condition_message_set	_(CND) 'this is another error message'
    mbfl_exceptional_condition_continuable_set	_(CND) 'true'

    mbfl_exceptional_condition_who_var		_(WHO)		_(CND)
    mbfl_exceptional_condition_message_var	_(MESSAGE)	_(CND)
    mbfl_exceptional_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-base-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    my_something_happened_make _(CND) $FUNCNAME 'this is an exception message' 'false'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "$FUNCNAME: this is an exception message"
}


#### warning class tests

function conditions-warning-maker-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an warning message'
    mbfl_warning_condition_is_a _(CND)
}
function conditions-warning-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_warning_condition_who_var		_(WHO)		_(CND)
    mbfl_warning_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_warning_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-warning-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an error message'

    mbfl_warning_condition_who_set		_(CND) 'another_who'
    mbfl_warning_condition_message_set		_(CND) 'this is another error message'
    mbfl_warning_condition_continuable_set	_(CND) 'false'

    mbfl_warning_condition_who_var		_(WHO)		_(CND)
    mbfl_warning_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_warning_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-warning-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an warning message'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: warning: $FUNCNAME: this is an warning message"
}


#### error class tests

mbfl_default_class_declare_global(my_some_error_happened_condition_t)

mbfl_default_class_define _(my_some_error_happened_condition_t) _(mbfl_error_condition_t) 'my_some_error_happened_condition'

function my_some_error_happened_condition_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(MESSAGE,		3, exceptional-condition description message)
    mbfl_mandatory_parameter(CONTINUABLE,	4, exceptional-condition continuable state)

    my_some_error_happened_condition_define _(CND) "$WHO" "$MESSAGE" "$CONTINUABLE"
}

function conditions-error-maker-1.1 () {
    mbfl_default_object_declare(CND)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_error_condition_is_a _(CND)
}
function conditions-error-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-error-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'

    mbfl_error_condition_who_set		_(CND) 'another_who'
    mbfl_error_condition_message_set		_(CND) 'this is another error message'
    mbfl_error_condition_continuable_set	_(CND) 'true'

    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-error-method-pring-1.1 () {
    mbfl_default_object_declare(CND)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: error: $FUNCNAME: this is an error message"
}


#### runtime-error class tests

function conditions-runtime-error-maker-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_runtime_error_condition_is_a _(CND)
}
function conditions-runtime-error-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-runtime-error-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'

    mbfl_error_condition_who_set		_(CND) 'another_who'
    mbfl_error_condition_message_set		_(CND) 'this is another error message'
    mbfl_error_condition_continuable_set	_(CND) 'false'

    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-runtime-error-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: error: $FUNCNAME: this is an error message"
}


#### logic-error class tests

function conditions-logic-error-maker-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_logic_error_condition_is_a _(CND)
}
function conditions-logic-error-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-logic-error-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'

    mbfl_error_condition_who_set		_(CND) 'another_who'
    mbfl_error_condition_message_set		_(CND) 'this is another error message'
    mbfl_error_condition_continuable_set	_(CND) 'true'

    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-logic-error-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: error: $FUNCNAME: this is an error message"
}


#### let's go

dotest conditions-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
