# script.test --
#
# Part of: MBFL
# Contents: template tests
# Date: Fri Aug  8, 2003
#
# Abstract
#
#
# Copyright (c) 2003, 2004, 2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
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

mbfl_load_library("$MBFL_TESTS_LIBMBFL_CORE")
mbfl_load_library("$MBFL_TESTS_LIBMBFL_TEST")

function script () {
    local -r examplesdir=${examplesdir:?'missing examplesdir in the environment'}
    "$mbfl_PROGRAM_BASH" "${examplesdir}/template.sh" "$@" 2>&1
}
function script_with_actions () {
    local -r examplesdir=${examplesdir:?'missing examplesdir in the environment'}
    "$mbfl_PROGRAM_BASH" "${examplesdir}/template-actions.sh" "$@" 2>&1
}


#### test template for basic options

function script-template-1.1 () {
    script --usage | dotest-output "usage: template.sh *"
}
function script-template-1.2 () {
    script --help | dotest-output "usage: template.sh *"
}
function script-template-1.3 () {
    script -h | dotest-output "usage: template.sh *"
}
function script-template-1.4 () {
    script --license | dotest-output "template.sh version *"
}
function script-template-1.5 () {
    script --version | dotest-output "template.sh version *"
}
function script-template-1.6 () {
    script --version-only | dotest-output 1.0
}


#### test template for custom non-action options

function script-template-2.1 () {
    script --beta=123 | dotest-output "option beta: 123\naction one, arguments: 0, ''"
}
function script-template-2.2 () {
    script --beta=123\\ | dotest-output "option beta: 123\\\naction one, arguments: 0, ''"
}
function script-template-2.3 () {
    script --beta="1 2" | dotest-output "option beta: 1 2\naction one, arguments: 0, ''"
}
function script-template-2.4 () {
    script --beta=123\\\\ | dotest-output "option beta: 123\\\\\naction one, arguments: 0, ''"
}
function script-template-2.5 () {
    script --alpha | dotest-output "option alpha\naction one, arguments: 0, ''"
}

# Option with argument used with an empty argument.
#
function script-template-2.6 () {
    script --beta= | dotest-output 'template.sh: error: invalid command line argument: "--beta="'
}

function script-template-2.7 () {
    script --= | dotest-output 'template.sh: error: invalid command line argument: "--="'
}


#### test template for arguments

function script-template-3.1 () {
    script a b c | dotest-output "action one, arguments: 3, 'a b c'"
}


#### test template for exit codes inspection

function script-template-4.1 () {
    script --list-exit-codes | dotest-output \
        "0 success\n1 failure\n100 error_loading_library\n99 program_not_found\n98 wrong_num_args\n97 invalid_action_set\n96 invalid_action_declaration\n95 invalid_action_argument\n94 missing_action_function\n93 invalid_option_declaration\n92 invalid_option_argument\n91 invalid_function_name\n90 invalid_sudo_username\n89 no_location\n88 invalid_mbfl_version\n2 second_error\n3 third_error\n3 fourth_error\n8 eighth_error"
}
function script-template-4.2 () {
    script --print-exit-code=second_error | dotest-output 2
}
function script-template-4.3 () {
    script --print-exit-code=eighth_error | dotest-output 8
}
function script-template-4.4 () {
    script --print-exit-code=third_error | dotest-output 3
}
function script-template-4.5 () {
    script --print-exit-code=unexistent | dotest-output ""
}
function script-template-4.6 () {
    script --print-exit-code=success | dotest-output 0
}
function script-template-4.7 () {
    script --print-exit-code-names=1 | dotest-output "failure"
}
function script-template-4.8 () {
    script --print-exit-code-names=8 | dotest-output "eighth_error"
}
function script-template-4.9 () {
    script --print-exit-code-names=3 | dotest-output "third_error\nfourth_error"
}
function script-template-4.10 () {
    script --print-exit-code-names=0 | dotest-output "success"
}


#### test template for custom action options

function script-template-5.1 () {
    script --one | dotest-output "action one, arguments: 0, ''"
}
function script-template-5.2 () {
    script --two | dotest-output 'action two'
}
function script-template-5.3 () {
    script --three | dotest-output "action three, arguments: 0, ''"
}
function script-template-5.4 () {
    script --three a b c | dotest-output "action three, arguments: 3, 'a b c'"
}
function script-template-5.5 () {
    script --four a b c | dotest-output "action four, arguments: 3, 'a b c'"
}
function script-template-5.6 () {
    script --four a --verbose b c | \
        dotest-output "template.sh: script_after_parsing_options\naction four, arguments: 3, 'a b c'"
}


#### test template-action: options parsing

function script-action-1.1.1 () {
    script_with_actions one green solid | dotest-output "action one green solid: A='no' B='' C='' ARGC=0 ARGV=''"
}
function script-action-1.1.2 () {
    script_with_actions one green solid alpha beta | dotest-output "action one green solid: A='no' B='' C='' ARGC=2 ARGV='alpha beta'"
}
function script-action-1.1.3 () {
    script_with_actions | dotest-output "action main: X='no' Y='' Z='' ARGC=0 ARGV=''"
}

# brief options
function script-action-1.2.1 () {
    script_with_actions one green solid -a -b2 -c3 | dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-1.2.2 () {
    script_with_actions one green solid -b2 -a -c3 | dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-1.2.3 () {
    script_with_actions one green solid -b2 -c3 -a | dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-1.2.4 () {
    script_with_actions -x -y2 -z3 | dotest-output "action main: X='yes' Y='2' Z='3' ARGC=0 ARGV=''"
}

# long options
function script-action-1.3.1 () {
    script_with_actions one green solid --a-opt --b-opt=2 --c-opt=3 | \
	dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-1.3.2 () {
    script_with_actions one green solid --b-opt=2 --a-opt --c-opt=3 | \
	dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-1.3.3 () {
    script_with_actions one green solid --b-opt=2 --c-opt=3 --a-opt | \
	dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-1.3.4 () {
    script_with_actions --x-opt --y-opt=2 --z-opt=3 | dotest-output "action main: X='yes' Y='2' Z='3' ARGC=0 ARGV=''"
}

# brief options and arguments
function script-action-1.4.1 () {
    script_with_actions one green solid alpha -a beta -b2 gamma -c3 | \
	dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=3 ARGV='alpha beta gamma'"
}

# long options and arguments
function script-action-1.5.1 () {
    script_with_actions one green solid alpha --a-opt beta --b-opt=2 gamma --c-opt=3 | \
	dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=3 ARGV='alpha beta gamma'"
}

### --------------------------------------------------------------------

# brief option wrongly without argument
function script-action-1.6.1 () {
    script_with_actions one green solid -b | \
	dotest-output "template-actions.sh: error: expected non-empty argument for option: \"b\""
}
function script-action-1.6.2 () {
    script_with_actions one green solid -b
    dotest-equal 92 $?
}

# long option wrongly without argument
function script-action-1.7.1 () {
    script_with_actions one green solid --b-opt | \
	dotest-output "template-actions.sh: error: expected non-empty argument for option: \"b-opt\""
}
function script-action-1.7.2 () {
    script_with_actions one green solid --b-opt
    dotest-equal 92 $?
}


#### script with actions: all the actions

function script-action-2.1.1 () {
    script_with_actions one green solid  | dotest-output "action one green solid: A='no' B='' C='' ARGC=0 ARGV=''"
}
function script-action-2.1.2 () {
    script_with_actions one green liquid | dotest-output "action one green liquid: D='no' E='' F='' ARGC=0 ARGV=''"
}
function script-action-2.1.3 () {
    script_with_actions one green gas    | dotest-output "action one green gas: G='no' H='' I='' ARGC=0 ARGV=''"
}

### --------------------------------------------------------------------

function script-action-2.2.1 () {
    script_with_actions one white solid  | dotest-output "action script_action_ONE_WHITE_SOLID"
}
function script-action-2.2.2 () {
    script_with_actions one white liquid | dotest-output "action script_action_ONE_WHITE_LIQUID"
}
function script-action-2.2.3 () {
    script_with_actions one white gas    | dotest-output "action script_action_ONE_WHITE_GAS"
}

### --------------------------------------------------------------------

function script-action-2.3.1 () {
    script_with_actions one red solid  | dotest-output "action script_action_ONE_RED_SOLID"
}
function script-action-2.3.2 () {
    script_with_actions one red liquid | dotest-output "action script_action_ONE_RED_LIQUID"
}
function script-action-2.3.3 () {
    script_with_actions one red gas    | dotest-output "action script_action_ONE_RED_GAS"
}

### --------------------------------------------------------------------

function script-action-3.1.1 () {
    script_with_actions two green solid  | dotest-output "action script_action_TWO_GREEN_SOLID"
}
function script-action-3.1.2 () {
    script_with_actions two green liquid | dotest-output "action script_action_TWO_GREEN_LIQUID"
}
function script-action-3.1.3 () {
    script_with_actions two green gas    | dotest-output "action script_action_TWO_GREEN_GAS"
}

### --------------------------------------------------------------------

function script-action-3.2.1 () {
    script_with_actions two white solid  | dotest-output "action script_action_TWO_WHITE_SOLID"
}
function script-action-3.2.2 () {
    script_with_actions two white liquid | dotest-output "action script_action_TWO_WHITE_LIQUID"
}
function script-action-3.2.3 () {
    script_with_actions two white gas    | dotest-output "action script_action_TWO_WHITE_GAS"
}

### --------------------------------------------------------------------

function script-action-3.3.1 () {
    script_with_actions two red solid  | dotest-output "action script_action_TWO_RED_SOLID"
}
function script-action-3.3.2 () {
    script_with_actions two red liquid | dotest-output "action script_action_TWO_RED_LIQUID"
}
function script-action-3.3.3 () {
    script_with_actions two red gas    | dotest-output "action script_action_TWO_RED_GAS"
}

### --------------------------------------------------------------------

function script-action-4.1.1 () {
    script_with_actions three green solid  | dotest-output "action script_action_THREE_GREEN_SOLID"
}
function script-action-4.1.2 () {
    script_with_actions three green liquid | dotest-output "action script_action_THREE_GREEN_LIQUID"
}
function script-action-4.1.3 () {
    script_with_actions three green gas    | dotest-output "action script_action_THREE_GREEN_GAS"
}

### --------------------------------------------------------------------

function script-action-4.2.1 () {
    script_with_actions three white solid  | dotest-output "action script_action_THREE_WHITE_SOLID"
}
function script-action-4.2.2 () {
    script_with_actions three white liquid | dotest-output "action script_action_THREE_WHITE_LIQUID"
}
function script-action-4.2.3 () {
    script_with_actions three white gas    | dotest-output "action script_action_THREE_WHITE_GAS"
}

### --------------------------------------------------------------------

function script-action-4.3.1 () {
    script_with_actions three red solid  | dotest-output "action script_action_THREE_RED_SOLID"
}
function script-action-4.3.2 () {
    script_with_actions three red liquid | dotest-output "action script_action_THREE_RED_LIQUID"
}
function script-action-4.3.3 () {
    script_with_actions three red gas    | dotest-output "action script_action_THREE_RED_GAS"
}


#### script with actions: different actions, different options

# brief options

function script-action-5.1.1 () {
    script_with_actions one green solid  -a -b2 -c3 | dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-5.1.2 () {
    script_with_actions one green liquid -d -e2 -f3 | dotest-output "action one green liquid: D='yes' E='2' F='3' ARGC=0 ARGV=''"
}
function script-action-5.1.3 () {
    script_with_actions one green gas    -g -h2 -i3 | dotest-output "action one green gas: G='yes' H='2' I='3' ARGC=0 ARGV=''"
}

# long options

function script-action-5.2.1 () {
    script_with_actions one green solid  --a-opt --b-opt=2 --c-opt=3 | \
	dotest-output "action one green solid: A='yes' B='2' C='3' ARGC=0 ARGV=''"
}
function script-action-5.2.2 () {
    script_with_actions one green liquid --d-opt --e-opt=2 --f-opt=3 | \
	dotest-output "action one green liquid: D='yes' E='2' F='3' ARGC=0 ARGV=''"
}
function script-action-5.2.3 () {
    script_with_actions one green gas    --g-opt --h-opt=2 --i-opt=3 | \
	dotest-output "action one green gas: G='yes' H='2' I='3' ARGC=0 ARGV=''"
}


#### script with actions: action errors

# Missing last action identifier
function script-action-6.1.1 () {
    script_with_actions one green
    dotest-equal $? 0
}

# Missing two last action identifier
function script-action-6.1.2 () {
    script_with_actions one
    dotest-equal $? 0
}


#### let's go

dotest script-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
