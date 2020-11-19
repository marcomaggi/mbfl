# getopts.test --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the getopts library
# Date: Tue Apr 22, 2003
#
# Abstract
#
#	To execute the tests in this file:
#
#		$ TESTMATCH=getopts- bash getopts.test
#
# Copyright (c) 2003, 2004, 2005, 2009, 2013, 2018, 2020 Marco Maggi
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

#PAGE
#### setup

mbfl_load_library("$MBFL_TESTS_LIBMBFL")
mbfl_load_library("$MBFL_TESTS_LIBMBFLTEST")

#page

function getopts-1.1 () { mbfl_getopts_islong --option; }
function getopts-1.2 () { ! mbfl_getopts_islong -option;  }
function getopts-1.3 () { ! mbfl_getopts_islong -- ;  }
function getopts-1.4 () { ! mbfl_getopts_islong --optio\\\) ; }
function getopts-1.5 () { mbfl_getopts_islong --option1 ; }
function getopts-1.6 () { mbfl_getopts_islong --option-one ; }
function getopts-1.7 () {
    local name
    mbfl_getopts_islong --option name
    dotest-equal option $name
}

#page

function getopts-2.1 () { mbfl_getopts_islong_with --option=one ; }
function getopts-2.2 () { ! mbfl_getopts_islong_with --option ; }
function getopts-2.3 () { ! mbfl_getopts_islong_with -option=one ; }
function getopts-2.4 () {
    local p_name p_value
    mbfl_getopts_islong_with --option=two p_name p_value
    dotest-equal option $p_name && dotest-equal two $p_value
}
function getopts-2.5 () {
    local p_name p_value
    mbfl_getopts_islong_with --a=1 p_name p_value
    dotest-equal a $p_name && dotest-equal 1 $p_value
}
function getopts-2.6 () {
    local p_name p_value
    mbfl_getopts_islong_with --a="1 2" p_name p_value
    dotest-equal a $p_name && dotest-equal "1 2" "$p_value"
}
function getopts-2.7 () {
    local p_name p_value
    mbfl_getopts_islong_with --a=1\\\\ p_name p_value
    dotest-equal a $p_name && dotest-equal "1\\\\" $p_value
}
function getopts-2.8 () { ! mbfl_getopts_islong_with --afasd= ; }

#page

function getopts-3.1 () { mbfl_getopts_isbrief -a; }
function getopts-3.2 () { ! mbfl_getopts_isbrief -aa; }
function getopts-3.3 () { mbfl_getopts_isbrief -1; }
function getopts-3.4 () { ! mbfl_getopts_isbrief -_ ; }
function getopts-3.5 () { ! mbfl_getopts_isbrief -\[; }
function getopts-3.6 () { mbfl_getopts_isbrief -o a ; }

function getopts-4.1 () { mbfl_getopts_isbrief_with -a123; }
function getopts-4.2 () { ! mbfl_getopts_isbrief_with -a; }
function getopts-4.3 () { ! mbfl_getopts_isbrief_with -_123; }
function getopts-4.4 () {
    local p_name p_value
    mbfl_getopts_isbrief_with -A123 p_name p_value
    dotest-equal A $p_name && dotest-equal 123 $p_value
}

#page

function getopts-5.1 () {
    mbfl_getopts_reset
    mbfl_declare_option A yes o option noarg 'an option' | dotest-output
}
function getopts-5.2 () {
    mbfl_getopts_reset
    mbfl_declare_option A no o option noarg 'an option' | dotest-output
}
function getopts-5.3 () {
    mbfl_getopts_reset
    mbfl_declare_option A a o option witharg 'an option' | dotest-output
}

function getopts-5.4 () {
    mbfl_getopts_reset
    mbfl_main_set_main wao
    dotest-equal wao ${mbfl_main_SCRIPT_FUNCTION}
    mbfl_declare_option ACTION_ALPHA yes a alpha noarg 'an option'
    mbfl_declare_option ACTION_BETA no b beta noarg 'an option'
    dotest-equal script_action_alpha ${mbfl_main_SCRIPT_FUNCTION}
}

#page

function getopts-6.1 () {
    mbfl_getopts_reset
    mbfl_declare_option A a o option wappa 'an option' 2>&1 | \
	dotest-output '<unknown>: error: wrong value "wappa" to hasarg field in option declaration number 1'
}
function getopts-6.2 () {
    mbfl_getopts_reset
    mbfl_declare_option A a o option noarg 'an option' 2>&1 | \
	dotest-output '<unknown>: error: wrong value "a" as default for option with no argument number 1'
}
function getopts-6.3 () {
    mbfl_getopts_reset
    mbfl_declare_option ACTION_DELTA no o option witharg 'an option' 2>&1 | \
	dotest-output '<unknown>: error: action option must be with no argument "ACTION_DELTA"'
}

#page

function getopts-7.1 () {
    mbfl_getopts_reset
    mbfl_declare_option A yes o option noarg 'an option'
    mbfl_declare_option B yes a another noarg 'an option'
    mbfl_getopts_print_long_switches | dotest-output \
        '--option --another'
}

#page
#### parsing tests: brief options

# brief options with no argument

function getopts-8.1.1 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=()
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal no "$script_option_A"	\
	&& dotest-equal no "$script_option_B"	\
	&& dotest-equal 0  ${#ARGV[@]}		\
	&& dotest-equal 0  ${ARGC}
}
function getopts-8.1.2 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=("-a" "-b")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal yes "$script_option_A"		\
	&& dotest-equal yes "$script_option_B"		\
	&& dotest-equal 0   ${#ARGV[@]}			\
	&& dotest-equal 0   ${ARGC}
}

## --------------------------------------------------------------------
## brief options with argument

function getopts-8.2.1 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=()
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal _ "$script_option_A"	\
	&& dotest-equal _ "$script_option_B"	\
	&& dotest-equal 0 ${#ARGV[@]}		\
	&& dotest-equal 0 ${ARGC} 0
}
function getopts-8.2.2 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=("-a123" "-b456")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal 123 "$script_option_A"	\
	&& dotest-equal 456 "$script_option_B"	\
	&& dotest-equal 0 ${#ARGV[@]}		\
	&& dotest-equal 0 ${ARGC}
}
function getopts-8.2.3 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=("-b456")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal _   "$script_option_A"	\
	&& dotest-equal 456 "$script_option_B"	\
	&& dotest-equal 0   ${#ARGV[@]}		\
	&& dotest-equal 0   ${ARGC}
}
function getopts-8.2.4 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=("-b")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal 1 $?
}

#page
#### parsing tests: long options

## long options with no argument

function getopts-9.1.1 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=()
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal no "$script_option_A"	\
	&& dotest-equal no "$script_option_B"	\
	&& dotest-equal 0  ${#ARGV[@]}		\
	&& dotest-equal 0  ${ARGC}
}
function getopts-9.1.2 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=("--alpha" "--beta")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal yes "$script_option_A"		\
	&& dotest-equal yes "$script_option_B"		\
	&& dotest-equal 0   ${#ARGV[@]}			\
	&& dotest-equal 0   ${ARGC}
}

### --------------------------------------------------------------------

# long options with argument

function getopts-9.2.1 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=()
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal _ "$script_option_A"	\
	&& dotest-equal _ "$script_option_B"	\
	&& dotest-equal 0 ${#ARGV[@]}		\
	&& dotest-equal 0 ${ARGC} 0
}
function getopts-9.2.2 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=("--alpha=123" "--beta=456")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal 123 "$script_option_A"	\
	&& dotest-equal 456 "$script_option_B"	\
	&& dotest-equal 0 ${#ARGV[@]}		\
	&& dotest-equal 0 ${ARGC}
}
function getopts-9.2.3 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=("--beta=456")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal _   "$script_option_A"	\
	&& dotest-equal 456 "$script_option_B"	\
	&& dotest-equal 0   ${#ARGV[@]}		\
	&& dotest-equal 0   ${ARGC}
}
function getopts-9.2.4 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	_		a		alpha		witharg	      'an option'
    mbfl_declare_option B	_		b		beta		witharg	      'an option'
    local -a ARGV1=("--beta")
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal 1 $?
}

#page
#### parsing tests: end of options marker

function getopts-10.1 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=(-a -b -- ciao hello)
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal yes "$script_option_A"	\
	&& dotest-equal yes "$script_option_B"	\
	&& dotest-equal 2  ${#ARGV[@]}		\
	&& dotest-equal 2  ${ARGC}		\
	&& dotest-equal 'ciao' ${ARGV[0]}	\
	&& dotest-equal 'hello' ${ARGV[1]}
}

function getopts-10.2 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=(-a -b -- ciao hello -a -b)
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal yes "$script_option_A"	\
	&& dotest-equal yes "$script_option_B"	\
	&& dotest-equal 4  ${#ARGV[@]}		\
	&& dotest-equal 4  ${ARGC}		\
	&& dotest-equal 'ciao'  ${ARGV[0]}	\
	&& dotest-equal 'hello' ${ARGV[1]}	\
	&& dotest-equal '-a'    ${ARGV[2]}	\
	&& dotest-equal '-b'    ${ARGV[3]}
}

function getopts-10.3 () {
    mbfl_getopts_reset
    #                   keyword	default-value	brief-option	long-option	has-argument  description
    mbfl_declare_option A	no		a		alpha		noarg	      'an option'
    mbfl_declare_option B	no		b		beta		noarg	      'an option'
    local -a ARGV1=(-a -b --)
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    dotest-equal $? 0 \
	&& dotest-equal yes "$script_option_A"	\
	&& dotest-equal yes "$script_option_B"	\
	&& dotest-equal 0  ${#ARGV[@]}		\
	&& dotest-equal 0  ${ARGC}
}

#page
#### miscellaneous functions

# Gather MBFL options: empty FLAGS, no options.
#
function getopts-11.0 () {
    mbfl_local_varref(FLAGS)

    mbfl_getopts_reset
    local -a ARGV1=()
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    mbfl_getopts_gather_mbfl_options_var mbfl_datavar(FLAGS)
    dotest-equal '' "$FLAGS"
}

# Gather MBFL options: non-empty FLAGS, no options.
#
function getopts-11.1 () {
    mbfl_local_varref(FLAGS)

    mbfl_getopts_reset
    local -a ARGV1=()
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    mbfl_getopts_parse
    FLAGS='-a -b -c'
    mbfl_getopts_gather_mbfl_options_var mbfl_datavar(FLAGS)
    dotest-equal '-a -b -c' "$FLAGS"
}

# Gather MBFL options: non-empty FLAGS, some options.
#
function getopts-11.2 () {
    mbfl_local_varref(FLAGS)

    mbfl_getopts_reset
    mbfl_unset_option_verbose
    mbfl_unset_option_verbose_program
    mbfl_unset_option_debug
    mbfl_unset_option_show_program
    mbfl_unset_option_test

    local -a ARGV1=('--show-program' '--verbose-program')
    local -i ARGC1=${#ARGV1[@]}
    local -i ARG1ST=0
    local -a ARGV
    local -i ARGC=0
    mbfl_getopts_parse

    FLAGS='-a -b -c'
    mbfl_getopts_gather_mbfl_options_var mbfl_datavar(FLAGS)
    dotest-equal '-a -b -c --verbose-program --show-program' "$FLAGS"
}

# Gather MBFL options: non-empty FLAGS, some options.
#
function getopts-11.3 () {
    mbfl_local_varref(FLAGS)

    mbfl_getopts_reset
    mbfl_unset_option_verbose
    mbfl_unset_option_verbose_program
    mbfl_unset_option_debug
    mbfl_unset_option_show_program
    mbfl_unset_option_test

    FLAGS='-a -b -c'
    mbfl_set_option_verbose
    mbfl_set_option_test
    mbfl_getopts_gather_mbfl_options_var mbfl_datavar(FLAGS)
    dotest-equal '-a -b -c --verbose --test' "$FLAGS"
}

#page
#### let's go

dotest getopts-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
