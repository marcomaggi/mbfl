# struct.test.m4 --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the struct module
# Date: Mar 12, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=struct-
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

m4_define([[[_]]],[[[mbfl_datavar([[[$1]]])]]])


#### simple tests

function struct-1.1 () {
    mbfl_struct_define_type greek alpha beta gamma
    mbfl_struct_declare(stru)
    local A=0 B=0 C=0

    greek_init stru 1 2 3
    if false
    then mbfl_array_dump _(stru)
    fi
    greek_alpha_ref _(stru) A
    greek_beta_ref  _(stru) B
    greek_gamma_ref _(stru) C

    greek? _(stru) &&
	mbfl_struct_is_a _(stru) greek &&
	dotest-equal 1 $A &&
	dotest-equal 2 $B &&
	dotest-equal 3 $C
}

function struct-1.2 () {
    mbfl_struct_define_type greek alpha beta gamma
    mbfl_struct_declare(stru)
    local A=0 B=0 C=0

    greek_init stru 1 2 3
    if false
    then mbfl_array_dump _(stru)
    fi

    greek_alpha_set _(stru) 11
    greek_beta_set  _(stru) 22
    greek_gamma_set _(stru) 33

    if false
    then mbfl_array_dump _(stru)
    fi

    greek_alpha_ref _(stru) A
    greek_beta_ref  _(stru) B
    greek_gamma_ref _(stru) C

    greek? _(stru) &&
	mbfl_struct_is_a _(stru) greek &&
	dotest-equal 11 $A &&
	dotest-equal 22 $B &&
	dotest-equal 33 $C
}


#### let's go

dotest struct-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
