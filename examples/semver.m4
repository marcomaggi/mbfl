#!
#! Part of: Marco's Bash Functions Library
#! Contents: test script for "libmbfl", semantic versions
#! Date: Mar 13, 2023
#!
#! Abstract
#!
#!	This script exposes the features of the semver module in "libmbfl.bash".
#!
#! Copyright (C) 2023, 2024 Marco Maggi <mrc.mgg@gmail.com>
#!
#! This program is free software: you can redistribute it and/or modify it under the terms of the GNU
#! General Public  License as  published by  the Free Software  Foundation, either  version 3  of the
#! License, or (at your option) any later version.
#!
#! This program is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! General Public License for more details.
#!
#! You should  have received a copy  of the GNU General  Public License along with  this program.  If
#! not, see <http://www.gnu.org/licenses/>.
#!


#### global variables

declare -r script_REQUIRED_MBFL_VERSION=v3.0.0-devel.8
declare -r script_PROGNAME=semver
declare -r script_VERSION=1.0
declare -r script_COPYRIGHT_YEARS='2023'
declare -r script_AUTHOR='Marco Maggi'
declare -r script_LICENSE=GPL3
script_USAGE="usage: ${script_PROGNAME} [action] [options]"
script_DESCRIPTION='Semantic version handling built upon the MBFL.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} parse v1.2.3-devel.4+x86-64
\t${script_PROGNAME} compare SEMVER1 SEMVER2"

declare -r COMPLETIONS_SCRIPT_NAMESPACE='p-mbfl'
declare -r CDPATH=


#### library loading

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### declare exit codes

#mbfl_main_declare_exit_code 10 usb_stick_not_present


#### actions tree

mbfl_declare_action_set HELP
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action HELP	HELP_USAGE	NONE		usage		'Print the help screen and exit.'
mbfl_declare_action HELP	HELP_PRINT_COMPLETIONS_SCRIPT NONE print-completions-script 'Print the completions script for this program.'

## --------------------------------------------------------------------

mbfl_declare_action_set MAIN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action MAIN	PARSE		NONE		parse		'Parse semantic version specifications.'
mbfl_declare_action MAIN	COMPARE		NONE		compare		'Compare two semantic version specifications.'
mbfl_declare_action MAIN	HELP		HELP		help		'Help the user of this script.'


#### script action functions: main
#
# This is the default  main function.  It is invoked whenever the script  is executed without action
# arguments.
#

function main () {
    mbfl_actions_fake_action_set MAIN
    mbfl_main_print_usage_screen_brief
}


#### parse semantic version specifications

function script_before_parsing_options_PARSE () {
    script_USAGE="usage: ${script_PROGNAME} parse [options] SEMVER"
    script_DESCRIPTION='Parse the given semantic version specification.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} parse v1.2.3-devel.4+x86-64"
}
function script_action_PARSE () {
    if mbfl_wrong_num_args 1 $ARGC
    then
	mbfl_command_line_argument(SPEC, 0, -r)
	mbfl_declare_assoc_array_varref(RV)
	mbfl_declare_varref(START_INDEX,0,-i)

	mbfl_message_verbose_printf 'parsing semantic version specification: "%s"\n' "$SPEC"

	if mbfl_semver_parse _(RV) "$SPEC" _(START_INDEX)
	then
	    printf 'major number:         %s\n' mbfl_slot_qref(RV, MAJOR_NUMBER)
	    printf 'minor number:         %s\n' mbfl_slot_qref(RV, MINOR_NUMBER)
	    printf 'patch level:          %s\n' mbfl_slot_qref(RV, PATCH_LEVEL)
	    printf 'prerelease version:   %s\n' mbfl_slot_qref(RV, PRERELEASE_VERSION)
	    printf 'build metadata:       %s\n' mbfl_slot_qref(RV, BUILD_METADATA)
	    #printf '%s\n' mbfl_slot_qref(RV, START_INDEX)
	    #printf '%s\n' mbfl_slot_qref(RV, END_INDEX)
	else
	    mbfl_message_error_printf 'parsing semantic version specification: "%s"' "$SPEC"
	    exit_because_failure
	fi
    else exit_because_wrong_num_args
    fi
    exit_because_success
}


#### compare two parse semantic version specifications

function script_before_parsing_options_COMPARE () {
    script_USAGE="usage: ${script_PROGNAME} compare [options] SEMVER1 SEMVER2"
    script_DESCRIPTION='Compare two semantic version specifications.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} compare v1.2.3 v1.5.3"
}
function script_action_COMPARE () {
    if mbfl_wrong_num_args 2 $ARGC
    then
	mbfl_command_line_argument(SPEC1, 0, -r)
	mbfl_command_line_argument(SPEC2, 1, -r)
	mbfl_declare_varref(RV, -i)

	if mbfl_semver_compare_var _(RV) "$SPEC1" "$SPEC2"
	then printf '%d' $RV
	else
	    mbfl_message_error_printf 'parsing semantic version specifications: "%s", "%s"' "$SPEC1" "$SPEC2"
	    exit_because_failure
	fi
    else exit_because_wrong_num_args
    fi
    exit_because_success
}


#### help actions

function script_before_parsing_options_HELP () {
    script_USAGE="usage: ${script_PROGNAME} help [action] [options]"
    script_DESCRIPTION='Help the user of this program.'
}
function script_action_HELP () {
    # By faking the  selection of the MAIN action: we  cause "mbfl_main_print_usage_screen_brief" to
    # print the main usage screen.
    mbfl_actions_fake_action_set MAIN
    mbfl_main_print_usage_screen_brief
}

## ------------------------------------------------------------------------

function script_before_parsing_options_HELP_USAGE () {
    script_USAGE="usage: ${script_PROGNAME} help usage [options]"
    script_DESCRIPTION='Print the usage screen and exit.'
}
function script_action_HELP_USAGE () {
    if mbfl_wrong_num_args 0 $ARGC
    then
	# By faking the selection of  the MAIN action: we cause "mbfl_main_print_usage_screen_brief"
	# to print the main usage screen.
	mbfl_actions_fake_action_set MAIN
	mbfl_main_print_usage_screen_brief
    else
	mbfl_main_print_usage_screen_brief
	exit_because_wrong_num_args
    fi
}

## --------------------------------------------------------------------

function script_before_parsing_options_HELP_PRINT_COMPLETIONS_SCRIPT () {
    script_PRINT_COMPLETIONS="usage: ${script_PROGNAME} help print-completions-script [options]"
    script_DESCRIPTION='Print the command-line completions script and exit.'
}
function script_action_HELP_PRINT_COMPLETIONS_SCRIPT () {
    if mbfl_wrong_num_args 0 $ARGC
    then mbfl_actions_completion_print_script "$COMPLETIONS_SCRIPT_NAMESPACE" "$script_PROGNAME"
    else
	mbfl_main_print_usage_screen_brief
	exit_because_wrong_num_args
    fi
}


#### let's go

mbfl_main

### end of file
# Local Variables:
# mode: shell-script
# End:
