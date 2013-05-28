# Part of: Marco's BASH Functions Library
# Contents: script template
# Date: Mon May 27, 2013
#
# Abstract
#
#	This script shows how an MBFL script should be organised
#	to use MBFL with command line actions processing.
#
# Copyright (c) 2013 Marco Maggi <marcomaggi@gna.org>
#
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
#
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
#
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
#

#page
#### MBFL's related options and variables

script_PROGNAME=template-actions.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2013'
script_AUTHOR='Marco Maggi'
script_LICENSE=BSD
script_USAGE="usage: ${script_PROGNAME} action ... [options] ..."
script_DESCRIPTION='This is an example script showing action arguments.'
script_EXAMPLES="Usage examples:

\t${script_PROGNAME} --alpha"

#page
#### library loading

mbfl_INTERACTIVE=no
mbfl_LOADED=no
mbfl_HARDCODED=
mbfl_INSTALLED=$(test -x mbfl-config && mbfl-config) &>/dev/null
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
    test -n "$item" -a -f "$item" -a -r "$item" && {
        source "$item" &>/dev/null || {
            printf '%s error: loading MBFL file "%s"\n' \
                "$script_PROGNAME" "$item" >&2
            exit 2
        }
    }
done
unset -v item
test "$mbfl_LOADED" = yes || {
    printf '%s error: incorrect evaluation of MBFL\n' \
        "$script_PROGNAME" >&2
    exit 2
}

#page
#### declaration of script actions tree

mbfl_declare_action_set MAIN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action MAIN	MAIN_ONE	ONE		one		'do main action one'
mbfl_declare_action MAIN	MAIN_TWO	TWO		two		'do main action two'
mbfl_declare_action MAIN	MAIN_THREE	THREE		three		'do main action three'

### --------------------------------------------------------------------

mbfl_declare_action_set ONE
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action ONE		ONE_GREEN	ONE_GREEN	green		'do main action one green'
mbfl_declare_action ONE		ONE_WHITE	ONE_WHITE	white		'do main action one white'
mbfl_declare_action ONE		ONE_RED		ONE_RED		red		'do main action one red'

mbfl_declare_action_set TWO
mbfl_declare_action TWO		TWO_GREEN	TWO_GREEN	green		'do main action two green'
mbfl_declare_action TWO		TWO_WHITE	TWO_WHITE	white		'do main action two white'
mbfl_declare_action TWO		TWO_RED		TWO_RED		red		'do main action two red'

mbfl_declare_action_set THREE
mbfl_declare_action THREE	THREE_GREEN	THREE_GREEN	green		'do main action three green'
mbfl_declare_action THREE	THREE_WHITE	THREE_WHITE	white		'do main action three white'
mbfl_declare_action THREE	THREE_RED	THREE_RED	red		'do main action three red'

### --------------------------------------------------------------------

mbfl_declare_action_set ONE_GREEN
mbfl_declare_action ONE_GREEN	one_green_solid		NONE	solid		'do main action one green solid'
mbfl_declare_action ONE_GREEN	one_green_liquid	NONE	liquid		'do main action one green liquid'
mbfl_declare_action ONE_GREEN	one_green_gas		NONE	gas		'do main action one green gas'

mbfl_declare_action_set ONE_WHITE
mbfl_declare_action ONE_WHITE	one_white_solid		NONE	solid		'do main action one white solid'
mbfl_declare_action ONE_WHITE	one_white_liquid	NONE	liquid		'do main action one white liquid'
mbfl_declare_action ONE_WHITE	one_white_gas		NONE	gas		'do main action one white gas'

mbfl_declare_action_set ONE_RED
mbfl_declare_action ONE_RED	one_red_solid		NONE	solid		'do main action one red solid'
mbfl_declare_action ONE_RED	one_red_liquid		NONE	liquid		'do main action one red liquid'
mbfl_declare_action ONE_RED	one_red_gas		NONE	gas		'do main action one red gas'

### --------------------------------------------------------------------

mbfl_declare_action_set TWO_GREEN
mbfl_declare_action TWO_GREEN	two_green_solid		NONE	solid		'do main action two green solid'
mbfl_declare_action TWO_GREEN	two_green_liquid	NONE	liquid		'do main action two green liquid'
mbfl_declare_action TWO_GREEN	two_green_gas		NONE	gas		'do main action two green gas'

mbfl_declare_action_set TWO_WHITE
mbfl_declare_action TWO_WHITE	two_white_solid		NONE	solid		'do main action two white solid'
mbfl_declare_action TWO_WHITE	two_white_liquid	NONE	liquid		'do main action two white liquid'
mbfl_declare_action TWO_WHITE	two_white_gas		NONE	gas		'do main action two white gas'

mbfl_declare_action_set TWO_RED
mbfl_declare_action TWO_RED	two_red_solid		NONE	solid		'do main action two red solid'
mbfl_declare_action TWO_RED	two_red_liquid		NONE	liquid		'do main action two red liquid'
mbfl_declare_action TWO_RED	two_red_gas		NONE	gas		'do main action two red gas'

### --------------------------------------------------------------------

mbfl_declare_action_set THREE_GREEN
mbfl_declare_action THREE_GREEN	three_green_solid	NONE	solid		'do main action three green solid'
mbfl_declare_action THREE_GREEN	three_green_liquid	NONE	liquid		'do main action three green liquid'
mbfl_declare_action THREE_GREEN	three_green_gas		NONE	gas		'do main action three green gas'

mbfl_declare_action_set THREE_WHITE
mbfl_declare_action THREE_WHITE	three_white_solid	NONE	solid		'do main action three white solid'
mbfl_declare_action THREE_WHITE	three_white_liquid	NONE	liquid		'do main action three white liquid'
mbfl_declare_action THREE_WHITE	three_white_gas		NONE	gas		'do main action three white gas'

mbfl_declare_action_set THREE_RED
mbfl_declare_action THREE_RED	three_red_solid		NONE	solid		'do main action three red solid'
mbfl_declare_action THREE_RED	three_red_liquid	NONE	liquid		'do main action three red liquid'
mbfl_declare_action THREE_RED	three_red_gas		NONE	gas		'do main action three red gas'

#page
#### script action options declarations

function script_before_parsing_options_one_green_solid () {
    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option A no a a-opt noarg   'selects option a'
    mbfl_declare_option B '' b b-opt witharg 'selects option b'
    mbfl_declare_option C '' c c-opt witharg 'selects option c'
}
function script_before_parsing_options_one_green_liquid () {
    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option D no d d-opt noarg   'selects option d'
    mbfl_declare_option E '' e e-opt witharg 'selects option e'
    mbfl_declare_option F '' f f-opt witharg 'selects option f'
}
function script_before_parsing_options_one_green_gas () {
    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option G no g g-opt noarg   'selects option d'
    mbfl_declare_option H '' h h-opt witharg 'selects option e'
    mbfl_declare_option I '' i i-opt witharg 'selects option f'
}

#page
#### script action main functions

function script_action_one_green_solid () {
    printf "action one green solid: A='%s' B='%s' C='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_A" "$script_option_B" "$script_option_C" "$ARGC" "${ARGV[*]}"
}
function script_action_one_green_liquid () {
    printf "action one green liquid: D='%s' E='%s' F='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_D" "$script_option_E" "$script_option_F" "$ARGC" "${ARGV[*]}"
}
function script_action_one_green_gas () {
    printf "action one green gas: G='%s' H='%s' I='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_G" "$script_option_H" "$script_option_I" "$ARGC" "${ARGV[*]}"
}

## --------------------------------------------------------------------

function script_action_one_white_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_one_white_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_one_white_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_one_red_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_one_red_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_one_red_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_two_green_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_two_green_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_two_green_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_two_white_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_two_white_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_two_white_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_two_red_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_two_red_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_two_red_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_three_green_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_three_green_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_three_green_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_three_white_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_three_white_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_three_white_gas () {
    printf "action ${FUNCNAME}\n"
}

## --------------------------------------------------------------------

function script_action_three_red_solid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_three_red_liquid () {
    printf "action ${FUNCNAME}\n"
}
function script_action_three_red_gas () {
    printf "action ${FUNCNAME}\n"
}

#page
#### declare external programs usage

#mbfl_file_enable_make_compress
#mbfl_file_enable_make_copy
#mbfl_file_enable_make_directory
#mbfl_file_enable_make_listing
#mbfl_file_enable_make_move
#mbfl_file_enable_make_permissions
#mbfl_file_enable_make_remove
#mbfl_file_enable_make_symlink
#mbfl_file_enable_make_tar
#mbfl_declare_program ls

#page
#### declare exit codes

# mbfl_main_declare_exit_code 2 second_error
# mbfl_main_declare_exit_code 8 eighth_error
# mbfl_main_declare_exit_code 3 third_error
# mbfl_main_declare_exit_code 3 fourth_error

#page
#### start

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
