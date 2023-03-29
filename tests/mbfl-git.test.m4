# mbfl-git.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-git library
# Date: Mar 29, 2023
#
# Abstract
#
#	This file must be executed with one among:
#
#		$ make all test TESTMATCH=mbfl-git-
#		$ make all check TESTS=tests/mbfl-git.test ; less tests/mbfl-git.log
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


#### macros

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],$#,2,[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]],[[[MBFL_P_WRONG_NUM_ARGS($#,1 or 2)]]])]]])


#### setup

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_GIT")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### configuration options

function mbfl-git-config-option-1.1 () {
    mbfl_default_object_declare(thing)

    mbfl_vc_git_config_option_define _(thing) 'mine'

    mbfl_default_object_is_a _(thing) &&
	mbfl_vc_git_config_option_is_a _(thing)
}
function mbfl-git-config-option-1.2 () {
    mbfl_default_object_declare(thing)
    declare DATABASE KEY DEFAULT_VALUE TYPE TERMINATOR

    mbfl_vc_git_config_option_define _(thing) 'mine'

    mbfl_vc_git_config_option_database_var	DATABASE	_(thing)
    mbfl_vc_git_config_option_key_var		KEY		_(thing)
    mbfl_vc_git_config_option_default_value_var	DEFAULT_VALUE	_(thing)
    mbfl_vc_git_config_option_type_var		TYPE		_(thing)
    mbfl_vc_git_config_option_terminator_var	TERMINATOR	_(thing)

    dotest-equal 'unspecified'	"$DATABASE"		&&
	dotest-equal 'mine'	"$KEY"			&&
	dotest-equal ''		"$DEFAULT_VALUE"	&&
	dotest-equal 'no-type'	"$TYPE"			&&
	dotest-equal 'newline'	"$TERMINATOR"
}
function mbfl-git-config-option-1.3 () {
    mbfl_default_object_declare(thing)
    declare DATABASE KEY DEFAULT_VALUE TYPE TERMINATOR

    mbfl_vc_git_config_option_define _(thing) 'mine'

    mbfl_vc_git_config_option_database_set	_(thing)	'local'
    mbfl_vc_git_config_option_key_set		_(thing)	'mine'
    mbfl_vc_git_config_option_default_value_set	_(thing)	'true'
    mbfl_vc_git_config_option_type_set		_(thing)	'bool'
    mbfl_vc_git_config_option_terminator_set	_(thing)	'null'

    mbfl_vc_git_config_option_database_var	DATABASE	_(thing)
    mbfl_vc_git_config_option_key_var		KEY		_(thing)
    mbfl_vc_git_config_option_default_value_var	DEFAULT_VALUE	_(thing)
    mbfl_vc_git_config_option_type_var		TYPE		_(thing)
    mbfl_vc_git_config_option_terminator_var	TERMINATOR	_(thing)

    dotest-equal 'local'	"$DATABASE"		&&
	dotest-equal 'mine'	"$KEY"			&&
	dotest-equal 'true'	"$DEFAULT_VALUE"	&&
	dotest-equal 'bool'	"$TYPE"			&&
	dotest-equal 'null'	"$TERMINATOR"
}


#### let's go

dotest mbfl-git-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
