#!# tests.test --
#!#
#!# Part of: Marco's BASH Functions Library
#!# Contents: tests for libmbfl-tests.bash
#!# Date: Oct 23, 2024
#!#
#!# Abstract
#!#
#!#	To select the tests in this file:
#!#
#!#		$ make all test file=tests.test
#!#
#!# Copyright (c) 2024 Marco Maggi
#!# <mrc.mgg@gmail.com>
#!#
#!# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
#!# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
#!# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
#!# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
#!# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
#!# here, provided that the new terms are clearly indicated  on the first page of each file where they
#!# apply.
#!#
#!# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
#!# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
#!# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
#!# DAMAGE.
#!#
#!# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
#!# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
#!# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
#!# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#!#


#### setup

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)

MBFL_DEFINE_SPECIAL_MACROS
MBFL_DEFINE_UNDERSCORE_MACRO


#### dotest-equal

function tests-dotest-equal-1.1 () {
    dotest-equal abc abc
}
function tests-dotest-equal-1.2 () {
    ! dotest-equal abc def
}


#### dotest-equal-according-to

function my-compar () {
    declare ONE=PP(1)
    declare TWO=PP(2)

    test WW(ONE) = WW(TWO)
}
function tests-dotest-equal-according-to-1.1 () {
    dotest-equal-according-to my-compar abc abc
}
function tests-dotest-equal-according-to-1.2 () {
    ! dotest-equal-according-to my-compar abc def
}


#### dotest-predicate

function tests-dotest-predicate-1.1 () {
    dotest-predicate true
}
function tests-dotest-predicate-1.2 () {
    ! dotest-predicate false
}


#### let's go

dotest tests-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
