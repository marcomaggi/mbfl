# mbfl-containers.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-containers library
# Date: Apr  9, 2023
#
# Abstract
#
#	This file must be executed with one among:
#
#		$ make all test TESTMATCH=mbfl-containers-
#		$ make all check TESTS=tests/mbfl-containers.test ; less tests/mbfl-containers.log
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

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_CONTAINERS")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_METHODS


#### stacks

function mbfl-containers-stack-1.1 () {
    mbfl_default_object_declare(STK)
    mbfl_declare_varref(TOP_A)
    mbfl_declare_varref(POP_A)
    mbfl_declare_varref(POP_B)
    mbfl_declare_integer_varref(SIZE)

    mbfl_location_enter
    {
	mbfl_stack_make _(STK)
	mbfl_location_handler "mbfl_stack_unmake _(STK)"

	mbfl_stack_push _(STK) 'ciao'
	mbfl_stack_push _(STK) 'mamma'

	mbfl_stack_size _(SIZE) _(STK)

	mbfl_stack_top _(TOP_A) _(STK)
	# #mbfl_array_dump _(STK) STK
	mbfl_stack_pop _(POP_A) _(STK)
	# #mbfl_array_dump _(STK) STK
	mbfl_stack_pop _(POP_B) _(STK)

	#mbfl_array_dump _(STK) STK

	dotest-equal	 2	 "$SIZE"  'stack size'	&&
	    dotest-equal 'mamma' "$TOP_A" 'top A'	&&
	    dotest-equal 'mamma' "$POP_A" 'pop A'	&&
	    dotest-equal 'ciao'	 "$POP_B" 'pop B'
    }
    mbfl_location_leave
}


#### let's go

dotest mbfl-containers-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
