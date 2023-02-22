# main.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the main module
# Date: Nov 26, 2018
#
# Abstract
#
#	To select the tests in this file:
#
#		$ TESTMATCH=main- make all tests
#
# Copyright (c) 2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
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

mbfl_load_library("$MBFL_TESTS_LIBMBFL_CORE")
mbfl_load_library("$MBFL_TESTS_LIBMBFL_TEST")


#### return values

function main-return-value-1.1 () {
    (return_because_success)
    dotest-equal 0 $?
}

function main-return-value-1.2 () {
    (return_because_failure)
    dotest-equal 1 $?
}

function main-return-value-1.3 () {
    (return_because_error_loading_library)
    dotest-equal 100 $?
}

### ------------------------------------------------------------------------

function main-return-value-2.1 () {
    return_because_success
}

function main-return-value-2.2 () {
    return_success
}


#### let's go

dotest main-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
