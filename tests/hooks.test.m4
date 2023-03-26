# hooks.test.m4 --
#
# Part of: Marco's BASH function libraries
# Contents: tests for hooks
# Date: Mar 26, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=hooks-
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

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]])]]])


#### simple tests

function hooks-simple-1.1 () {
    mbfl_declare_varref(HOOKS_SIMPLE_1_1,,-g)
    declare FLAG1=false FLAG2=false

    mbfl_hook_define _(HOOKS_SIMPLE_1_1)

    mbfl_hook_add _(HOOKS_SIMPLE_1_1) 'FLAG1=true'
    mbfl_hook_add _(HOOKS_SIMPLE_1_1) 'FLAG2=true'

    mbfl_hook_run _(HOOKS_SIMPLE_1_1)

    $FLAG1 && $FLAG2
}

function hooks-simple-2.1 () {
    mbfl_declare_varref(HOOKS_SIMPLE_2_1,,-g)
    declare FLAG1=false FLAG2=false FLAG2=false

    mbfl_hook_define _(HOOKS_SIMPLE_2_1)

    mbfl_hook_add _(HOOKS_SIMPLE_2_1) 'FLAG1=true'
    mbfl_hook_add _(HOOKS_SIMPLE_2_1) 'FLAG2=true'

    mbfl_hook_reset _(HOOKS_SIMPLE_2_1)

    mbfl_hook_add _(HOOKS_SIMPLE_2_1) 'FLAG3=true'

    mbfl_hook_run _(HOOKS_SIMPLE_2_1)

    ! $FLAG1 && ! $FLAG2 && $FLAG3
}


#### let's go

dotest hooks-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End: