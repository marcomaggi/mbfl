# functions.bash.m4 --
#
# Part of: Marco's BASH function libraries
# Contents: tests for function handling functions
# Date: Mar 29, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=functions-
#
#	will select these tests.
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
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### copying functions

function testee_functions_copy_1_1 () {
    printf 'here %s\n' $FUNCNAME
}
function functions-copy-1.1 () {
    mbfl_function_copy 'testee_functions_copy_1_1' '_testee_functions_copy_1_1'

    testee_functions_copy_1_1 | dotest-output 'here testee_functions_copy_1_1' &&
	_testee_functions_copy_1_1 | dotest-output 'here _testee_functions_copy_1_1'
}


#### renaming functions

function testee_functions_rename_1_1 () {
    printf 'here %s\n' $FUNCNAME
}
function functions-rename-1.1 () {
    mbfl_function_rename 'testee_functions_rename_1_1' '_testee_functions_rename_1_1'

    _testee_functions_rename_1_1 | dotest-output 'here _testee_functions_rename_1_1'
}


#### renaming functions

function testee_functions_exists_1_1 () { : ; }
function functions-exists-1.1 () {
    mbfl_function_exists 'testee_functions_exists_1_1'
}
function functions-exists-1.2 () {
    ! mbfl_function_exists 'testee_functions_does_not_exist_1_1'
}


#### let's go

dotest functions-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
