# atexit.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the atexit module
# Date: Nov 25, 2018
#
# Abstract
#
#	To select the tests in this file:
#
#		$ make all test TESTMATCH=atexit-
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


#### helpers

declare -i flag1=0 flag2=0 flag3=0

function reset_flags () {
    flag1=0
    flag2=0
    flag3=0
}

function flag_it_1 () {
    let ++flag1
}
function flag_it_2 () {
    let ++flag2
}
function flag_it_3 () {
    let ++flag3
}


#### tests with no identifiers

function atexit-1.1 () {
    reset_flags
    mbfl_atexit_enable
    mbfl_atexit_register flag_it_1
    mbfl_atexit_run
    dotest-equal 1 ${flag1} && dotest-equal 0 ${flag2} && dotest-equal 0 ${flag3}
}

function atexit-1.2 () {
    reset_flags
    mbfl_atexit_enable
    mbfl_atexit_register flag_it_1
    mbfl_atexit_register flag_it_2
    mbfl_atexit_register flag_it_3
    mbfl_atexit_run
    dotest-equal 1 ${flag1} && dotest-equal 1 ${flag2} && dotest-equal 1 ${flag3}
}


#### tests with identifier

function atexit-2.1 () {
    local ID1 ID2 ID3

    reset_flags
    mbfl_atexit_enable
    mbfl_atexit_register flag_it_1 ID1
    mbfl_atexit_register flag_it_2 ID2
    mbfl_atexit_register flag_it_3 ID3
    mbfl_atexit_forget $ID2
    mbfl_atexit_run
    dotest-equal 1 ${flag1} && dotest-equal 0 ${flag2} && dotest-equal 1 ${flag3}
}



dotest atexit-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
