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
# Copyright (c) 2023, 2024 Marco Maggi
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

MBFL_DEFINE_UNDERSCORE_MACRO


#### simple tests

function hooks-simple-1.1 () {
    mbfl_hook_declare(HOOKS_SIMPLE_1_1)
    declare FLAG1=false FLAG2=false

    mbfl_hook_define _(HOOKS_SIMPLE_1_1)

    mbfl_hook_add _(HOOKS_SIMPLE_1_1) 'FLAG1=true'
    mbfl_hook_add _(HOOKS_SIMPLE_1_1) 'FLAG2=true'

    mbfl_hook_run _(HOOKS_SIMPLE_1_1)

    $FLAG1 && $FLAG2
}

function hooks-simple-1.2 () {
    mbfl_hook_declare(HOOKS_SIMPLE_1_2)
    declare FLAG1=false FLAG2=false FLAG2=false

    mbfl_hook_define _(HOOKS_SIMPLE_1_2)

    mbfl_hook_add _(HOOKS_SIMPLE_1_2) 'FLAG1=true'
    mbfl_hook_add _(HOOKS_SIMPLE_1_2) 'FLAG2=true'

    mbfl_hook_undefine _(HOOKS_SIMPLE_1_2)

    mbfl_hook_add _(HOOKS_SIMPLE_1_2) 'FLAG3=true'

    mbfl_hook_run _(HOOKS_SIMPLE_1_2)

    ! $FLAG1 && ! $FLAG2 && $FLAG3
}

### ------------------------------------------------------------------------

function hooks-simple-2.1 () {
    mbfl_hook_global_declare(HOOKS_SIMPLE_2_1)
    declare FLAG1=false FLAG2=false

    mbfl_hook_define _(HOOKS_SIMPLE_2_1)

    mbfl_hook_add _(HOOKS_SIMPLE_2_1) 'FLAG1=true'
    mbfl_hook_add _(HOOKS_SIMPLE_2_1) 'FLAG2=true'

    mbfl_hook_reverse_run _(HOOKS_SIMPLE_2_1)

    $FLAG1 && $FLAG2
}


#### inspection

function hooks-inspect-1.1 () {
    mbfl_hook_declare(HOOKS_INSPECT_1_1)

    mbfl_hook_define _(HOOKS_INSPECT_1_1)
    mbfl_hook_add _(HOOKS_INSPECT_1_1) 'true'
    mbfl_hook_has_commands _(HOOKS_INSPECT_1_1)
}
function hooks-inspect-1.2 () {
    mbfl_hook_declare(HOOKS_INSPECT_1_2)

    mbfl_hook_define _(HOOKS_INSPECT_1_2)
    ! mbfl_hook_has_commands _(HOOKS_INSPECT_1_2)
}


#### removing hooks

function hooks-remove-1.1 () {
    mbfl_hook_declare(HOOKS_REMOVE_1_1)
    declare -i RESULT=0 EXPECTED_RESULT=$((1 + 4))
    mbfl_declare_integer_varref(IDA)
    mbfl_declare_integer_varref(IDB)

    mbfl_hook_define _(HOOKS_REMOVE_1_1)
    mbfl_hook_add _(HOOKS_REMOVE_1_1) 'RESULT+=1'
    mbfl_hook_add _(HOOKS_REMOVE_1_1) 'RESULT+=2' _(IDA)
    mbfl_hook_add _(HOOKS_REMOVE_1_1) 'RESULT+=3' _(IDB)
    mbfl_hook_add _(HOOKS_REMOVE_1_1) 'RESULT+=4'

    #mbfl_array_dump _(HOOKS_REMOVE_1_1)
    mbfl_hook_remove _(HOOKS_REMOVE_1_1) $IDA
    mbfl_hook_remove _(HOOKS_REMOVE_1_1) $IDB
    #mbfl_array_dump _(HOOKS_REMOVE_1_1)

    mbfl_hook_run _(HOOKS_REMOVE_1_1)
    dotest-equal "$EXPECTED_RESULT" "$RESULT"
}


#### replacing hooks

function hooks-replace-1.1 () {
    mbfl_hook_declare(HOOKS_REPLACE_1_1)
    declare -i RESULT=0 EXPECTED_RESULT=$((1 + 20 + 30 + 4))
    mbfl_declare_integer_varref(IDA)
    mbfl_declare_integer_varref(IDB)

    mbfl_hook_define _(HOOKS_REPLACE_1_1)
    mbfl_hook_add _(HOOKS_REPLACE_1_1) 'RESULT+=1'
    mbfl_hook_add _(HOOKS_REPLACE_1_1) 'RESULT+=2' _(IDA)
    mbfl_hook_add _(HOOKS_REPLACE_1_1) 'RESULT+=3' _(IDB)
    mbfl_hook_add _(HOOKS_REPLACE_1_1) 'RESULT+=4'

    #mbfl_array_dump _(HOOKS_REPLACE_1_1)
    mbfl_hook_replace _(HOOKS_REPLACE_1_1) $IDA 'RESULT+=20'
    mbfl_hook_replace _(HOOKS_REPLACE_1_1) $IDB 'RESULT+=30'
    #mbfl_array_dump _(HOOKS_REPLACE_1_1)

    mbfl_hook_run _(HOOKS_REPLACE_1_1)
    dotest-equal "$EXPECTED_RESULT" "$RESULT"
}

# Call the replace function with an invalid hook id.
#
function hooks-replace-2.1 () {
    mbfl_hook_declare(HOOKS_REPLACE_2_1)
    declare -i RESULT=0 EXPECTED_RESULT=$((1 + 2 + 3 + 4))

    mbfl_hook_define _(HOOKS_REPLACE_2_1)
    mbfl_hook_add _(HOOKS_REPLACE_2_1) 'RESULT+=1'
    mbfl_hook_add _(HOOKS_REPLACE_2_1) 'RESULT+=2'
    mbfl_hook_add _(HOOKS_REPLACE_2_1) 'RESULT+=3'
    mbfl_hook_add _(HOOKS_REPLACE_2_1) 'RESULT+=4'

    #mbfl_array_dump _(HOOKS_REPLACE_2_1) HOOKS_REPLACE_2_1
    mbfl_hook_replace _(HOOKS_REPLACE_2_1) 'ciao' 'RESULT+=99'
    #mbfl_array_dump _(HOOKS_REPLACE_2_1) HOOKS_REPLACE_2_1

    mbfl_hook_run _(HOOKS_REPLACE_2_1)
    dotest-equal "$EXPECTED_RESULT" "$RESULT"
}


#### let's go

dotest hooks-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
