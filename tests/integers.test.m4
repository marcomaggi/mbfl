# integers.test.m4 --
#
# Part of: Marco's BASH function libraries
# Contents: tests for integers
# Date: Apr 18, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=integers-
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

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)


#### comparison macros

function integers-compar-macro-1.1 () {
    mbfl_integer_eq(111,111)
}
function integers-compar-macro-1.2 () {
    ! mbfl_integer_eq(111,222)
}
function integers-compar-macro-2.1 () {
    ! mbfl_integer_neq(111,111)
}
function integers-compar-macro-2.2 () {
    mbfl_integer_neq(111,222)
}

function integers-compar-macro-3.1 () {
    ! mbfl_integer_lt(111,111)
}
function integers-compar-macro-3.2 () {
    mbfl_integer_lt(111,222)
}
function integers-compar-macro-3.2 () {
    ! mbfl_integer_lt(333,222)
}

function integers-compar-macro-4.1 () {
    ! mbfl_integer_gt(111,111)
}
function integers-compar-macro-4.2 () {
    ! mbfl_integer_gt(111,222)
}
function integers-compar-macro-4.2 () {
    mbfl_integer_gt(333,222)
}

function integers-compar-macro-5.1 () {
    mbfl_integer_le(111,111)
}
function integers-compar-macro-5.2 () {
    mbfl_integer_le(111,222)
}
function integers-compar-macro-5.2 () {
    ! mbfl_integer_le(333,222)
}

function integers-compar-macro-6.1 () {
    mbfl_integer_ge(111,111)
}
function integers-compar-macro-6.2 () {
    ! mbfl_integer_ge(111,222)
}
function integers-compar-macro-6.2 () {
    mbfl_integer_ge(333,222)
}


#### comparison functions

function integers-compar-function-1.1 () {
    mbfl_integer_equal 111 111
}
function integers-compar-function-1.2 () {
    ! mbfl_integer_equal 111 222
}
function integers-compar-function-2.1 () {
    ! mbfl_integer_not_equal 111 111
}
function integers-compar-function-2.2 () {
    mbfl_integer_not_equal 111 222
}

function integers-compar-function-3.1 () {
    ! mbfl_integer_less 111 111
}
function integers-compar-function-3.2 () {
    mbfl_integer_less 111 222
}
function integers-compar-function-3.2 () {
    ! mbfl_integer_less 333 222
}

function integers-compar-function-4.1 () {
    ! mbfl_integer_greater 111 111
}
function integers-compar-function-4.2 () {
    ! mbfl_integer_greater 111 222
}
function integers-compar-function-4.2 () {
    mbfl_integer_greater 333 222
}

function integers-compar-function-5.1 () {
    mbfl_integer_less_or_equal 111 111
}
function integers-compar-function-5.2 () {
    mbfl_integer_less_or_equal 111 222
}
function integers-compar-function-5.2 () {
    ! mbfl_integer_less_or_equal 333 222
}

function integers-compar-function-6.1 () {
    mbfl_integer_greater_or_equal 111 111
}
function integers-compar-function-6.2 () {
    ! mbfl_integer_greater_or_equal 111 222
}
function integers-compar-function-6.2 () {
    mbfl_integer_greater_or_equal 333 222
}


#### let's go

dotest integers-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
