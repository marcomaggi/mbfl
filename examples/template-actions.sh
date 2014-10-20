# Part of: Marco's BASH Functions Library
# Contents: script template
# Date: Mon May 27, 2013
#
# Abstract
#
#	This script shows how an MBFL script should be organised
#	to use MBFL with command line actions processing.
#
# Copyright (c) 2013, 2014 Marco Maggi <marco.maggi-ipsu@poste.it>
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
script_COPYRIGHT_YEARS='2013, 2014'
script_AUTHOR='Marco Maggi'
script_LICENSE=BSD

#page
#### library loading

mbfl_INTERACTIVE=no
mbfl_LOADED=no
mbfl_HARDCODED=
mbfl_INSTALLED=$(type -p mbfl-config &>/dev/null && mbfl-config) &>/dev/null
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
    if test -n "$item" -a -f "$item" -a -r "$item"
    then
        if ! source "$item" &>/dev/null
	then
            printf '%s error: loading MBFL file "%s"\n' \
                "$script_PROGNAME" "$item" >&2
            exit 2
        fi
	break
    fi
done
unset -v item
if test "$mbfl_LOADED" != yes
then
    printf '%s error: incorrect evaluation of MBFL\n' \
        "$script_PROGNAME" >&2
    exit 2
fi

#page
#### declaration of script actions tree

mbfl_declare_action_set ONE_GREEN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action ONE_GREEN	one_green_solid		NONE	solid		'Do main action one green solid.'
mbfl_declare_action ONE_GREEN	one_green_liquid	NONE	liquid		'Do main action one green liquid.'
mbfl_declare_action ONE_GREEN	one_green_gas		NONE	gas		'Do main action one green gas.'

mbfl_declare_action_set ONE_WHITE
mbfl_declare_action ONE_WHITE	one_white_solid		NONE	solid		'Do main action one white solid.'
mbfl_declare_action ONE_WHITE	one_white_liquid	NONE	liquid		'Do main action one white liquid.'
mbfl_declare_action ONE_WHITE	one_white_gas		NONE	gas		'Do main action one white gas.'

mbfl_declare_action_set ONE_RED
mbfl_declare_action ONE_RED	one_red_solid		NONE	solid		'Do main action one red solid.'
mbfl_declare_action ONE_RED	one_red_liquid		NONE	liquid		'Do main action one red liquid.'
mbfl_declare_action ONE_RED	one_red_gas		NONE	gas		'Do main action one red gas.'

### --------------------------------------------------------------------

mbfl_declare_action_set TWO_GREEN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action TWO_GREEN	two_green_solid		NONE	solid		'Do main action two green solid.'
mbfl_declare_action TWO_GREEN	two_green_liquid	NONE	liquid		'Do main action two green liquid.'
mbfl_declare_action TWO_GREEN	two_green_gas		NONE	gas		'Do main action two green gas.'

mbfl_declare_action_set TWO_WHITE
mbfl_declare_action TWO_WHITE	two_white_solid		NONE	solid		'Do main action two white solid.'
mbfl_declare_action TWO_WHITE	two_white_liquid	NONE	liquid		'Do main action two white liquid.'
mbfl_declare_action TWO_WHITE	two_white_gas		NONE	gas		'Do main action two white gas.'

mbfl_declare_action_set TWO_RED
mbfl_declare_action TWO_RED	two_red_solid		NONE	solid		'Do main action two red solid.'
mbfl_declare_action TWO_RED	two_red_liquid		NONE	liquid		'Do main action two red liquid.'
mbfl_declare_action TWO_RED	two_red_gas		NONE	gas		'Do main action two red gas.'

### --------------------------------------------------------------------

mbfl_declare_action_set THREE_GREEN
mbfl_declare_action THREE_GREEN	three_green_solid	NONE	solid		'Do main action three green solid.'
mbfl_declare_action THREE_GREEN	three_green_liquid	NONE	liquid		'Do main action three green liquid.'
mbfl_declare_action THREE_GREEN	three_green_gas		NONE	gas		'Do main action three green gas.'

mbfl_declare_action_set THREE_WHITE
mbfl_declare_action THREE_WHITE	three_white_solid	NONE	solid		'Do main action three white solid.'
mbfl_declare_action THREE_WHITE	three_white_liquid	NONE	liquid		'Do main action three white liquid.'
mbfl_declare_action THREE_WHITE	three_white_gas		NONE	gas		'Do main action three white gas.'

mbfl_declare_action_set THREE_RED
mbfl_declare_action THREE_RED	three_red_solid		NONE	solid		'Do main action three red solid.'
mbfl_declare_action THREE_RED	three_red_liquid	NONE	liquid		'Do main action three red liquid.'
mbfl_declare_action THREE_RED	three_red_gas		NONE	gas		'Do main action three red gas.'

### --------------------------------------------------------------------

mbfl_declare_action_set ONE
#                   action-set	keyword			subset		identifier	description
mbfl_declare_action ONE		MAIN_ONE_GREEN		ONE_GREEN	green		'Do main action one green.'
mbfl_declare_action ONE		MAIN_ONE_WHITE		ONE_WHITE	white		'Do main action one white.'
mbfl_declare_action ONE		MAIN_ONE_RED		ONE_RED		red		'Do main action one red.'

mbfl_declare_action_set TWO
mbfl_declare_action TWO		MAIN_TWO_GREEN		TWO_GREEN	green		'Do main action two green.'
mbfl_declare_action TWO		MAIN_TWO_WHITE		TWO_WHITE	white		'Do main action two white.'
mbfl_declare_action TWO		MAIN_TWO_RED		TWO_RED		red		'Do main action two red.'

mbfl_declare_action_set THREE
mbfl_declare_action THREE	MAIN_THREE_GREEN	THREE_GREEN	green		'Do main action three green.'
mbfl_declare_action THREE	MAIN_THREE_WHITE	THREE_WHITE	white		'Do main action three white.'
mbfl_declare_action THREE	MAIN_THREE_RED		THREE_RED	red		'Do main action three red.'

### --------------------------------------------------------------------

mbfl_declare_action_set MAIN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action MAIN	MAIN_ONE	ONE		one		'Do main action one.'
mbfl_declare_action MAIN	MAIN_TWO	TWO		two		'Do main action two.'
mbfl_declare_action MAIN	MAIN_THREE	THREE		three		'Do main action three.'

#page
#### script actions tree: non-leaf help screen
#
# For  every non-leaf  node  in the  actions  tree we  want  to print  a
# meaningful help screen.
#

# When the script is executed without action arguments: we still want to
# print a meaningful help screen and to offer some option.
#
function script_before_parsing_options () {
    script_USAGE="usage: ${script_PROGNAME} [action] [options]"
    script_DESCRIPTION='This is an example script showing action arguments.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} --x-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option X no x x-opt noarg   'Selects option x.'
    mbfl_declare_option Y '' y y-opt witharg 'Selects option y.'
    mbfl_declare_option Z '' z z-opt witharg 'Selects option z.'
}

## --------------------------------------------------------------------

function script_before_parsing_options_MAIN_ONE () {
    script_USAGE="usage: ${script_PROGNAME} one [action] [options]"
    script_DESCRIPTION='Example action tree: one.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one green solid"
}
function script_before_parsing_options_MAIN_TWO () {
    script_USAGE="usage: ${script_PROGNAME} two [action] [options]"
    script_DESCRIPTION='Example action tree: two.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two green solid"
}
function script_before_parsing_options_MAIN_THREE () {
    script_USAGE="usage: ${script_PROGNAME} three [action] [options]"
    script_DESCRIPTION='Example action tree: three.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} three green solid"
}

## --------------------------------------------------------------------

function script_before_parsing_options_MAIN_ONE_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} one green [action] [options]"
    script_DESCRIPTION='Example action tree: one green.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one green solid"
}
function script_before_parsing_options_MAIN_ONE_WHITE () {
    script_USAGE="usage: ${script_PROGNAME} one white [action] [options]"
    script_DESCRIPTION='Example action tree: one white.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one white solid"
}
function script_before_parsing_options_MAIN_ONE_RED () {
    script_USAGE="usage: ${script_PROGNAME} one red [action] [options]"
    script_DESCRIPTION='Example action tree: one red.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one red solid"
}

## --------------------------------------------------------------------

function script_before_parsing_options_MAIN_TWO_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} two green [action] [options]"
    script_DESCRIPTION='Example action tree: two green.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two green solid"
}
function script_before_parsing_options_MAIN_TWO_WHITE () {
    script_USAGE="usage: ${script_PROGNAME} two white [action] [options]"
    script_DESCRIPTION='Example action tree: two white.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two white solid"
}
function script_before_parsing_options_MAIN_TWO_RED () {
    script_USAGE="usage: ${script_PROGNAME} two red [action] [options]"
    script_DESCRIPTION='Example action tree: two red.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two red solid"
}

## --------------------------------------------------------------------

function script_before_parsing_options_MAIN_THREE_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} three green [action] [options]"
    script_DESCRIPTION='Example action tree: three green.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} three green solid"
}
function script_before_parsing_options_MAIN_THREE_WHITE () {
    script_USAGE="usage: ${script_PROGNAME} three white [action] [options]"
    script_DESCRIPTION='Example action tree: three white.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} three white solid"
}
function script_before_parsing_options_MAIN_THREE_RED () {
    script_USAGE="usage: ${script_PROGNAME} three red [action] [options]"
    script_DESCRIPTION='Example action tree: three red.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} three red solid"
}

#page
#### script actions tree: options and help screen for leaf nodes
#
# For every leaf node in the actions  tree we want to print a meaningful
# help screen and declare action-specific options.
#

function script_before_parsing_options_one_green_solid () {
    script_USAGE="usage: ${script_PROGNAME} one green solid [options]"
    script_DESCRIPTION='Example action: one green solid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one green solid --a-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option A no a a-opt noarg   'Selects option a.'
    mbfl_declare_option B '' b b-opt witharg 'Selects option b.'
    mbfl_declare_option C '' c c-opt witharg 'Selects option c.'
}
function script_before_parsing_options_one_green_liquid () {
    script_USAGE="usage: ${script_PROGNAME} one green liquid [options]"
    script_DESCRIPTION='Example action: one green liquid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one green liquid --d-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option D no d d-opt noarg   'Selects option d.'
    mbfl_declare_option E '' e e-opt witharg 'Selects option e.'
    mbfl_declare_option F '' f f-opt witharg 'Selects option f.'
}
function script_before_parsing_options_one_green_gas () {
    script_USAGE="usage: ${script_PROGNAME} one green gas [options]"
    script_DESCRIPTION='Example action: one green gas.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one green gas --d-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option G no g g-opt noarg   'Selects option d.'
    mbfl_declare_option H '' h h-opt witharg 'Selects option e.'
    mbfl_declare_option I '' i i-opt witharg 'Selects option f.'
}

### --------------------------------------------------------------------

function script_before_parsing_options_one_white_solid () {
    script_USAGE="usage: ${script_PROGNAME} one white solid [options]"
    script_DESCRIPTION='Example action: one white solid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one white solid"
}
function script_before_parsing_options_one_white_liquid () {
    script_USAGE="usage: ${script_PROGNAME} one white liquid [options]"
    script_DESCRIPTION='Example action: one white liquid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one white liquid"
}
function script_before_parsing_options_one_white_gas () {
    script_USAGE="usage: ${script_PROGNAME} one white gas [options]"
    script_DESCRIPTION='Example action: one white gas.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one white gas"
}

### --------------------------------------------------------------------

function script_before_parsing_options_one_red_solid () {
    script_USAGE="usage: ${script_PROGNAME} one red solid [options]"
    script_DESCRIPTION='Example action: one red solid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one red solid"
}
function script_before_parsing_options_one_red_liquid () {
    script_USAGE="usage: ${script_PROGNAME} one red liquid [options]"
    script_DESCRIPTION='Example action: one red liquid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one red liquid"
}
function script_before_parsing_options_one_red_gas () {
    script_USAGE="usage: ${script_PROGNAME} one red gas [options]"
    script_DESCRIPTION='Example action: one red gas.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} one red gas"
}

### --------------------------------------------------------------------

function script_before_parsing_options_two_green_solid () {
    script_USAGE="usage: ${script_PROGNAME} two green solid [options]"
    script_DESCRIPTION='Example action: two green solid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two green solid --a-opt"
}
function script_before_parsing_options_two_green_liquid () {
    script_USAGE="usage: ${script_PROGNAME} two green liquid [options]"
    script_DESCRIPTION='Example action: two green liquid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two green liquid --d-opt"
}
function script_before_parsing_options_two_green_gas () {
    script_USAGE="usage: ${script_PROGNAME} two green gas [options]"
    script_DESCRIPTION='Example action: two green gas.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two green gas --d-opt"
}

### --------------------------------------------------------------------

function script_before_parsing_options_two_white_solid () {
    script_USAGE="usage: ${script_PROGNAME} two white solid [options]"
    script_DESCRIPTION='Example action: two white solid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two white solid"
}
function script_before_parsing_options_two_white_liquid () {
    script_USAGE="usage: ${script_PROGNAME} two white liquid [options]"
    script_DESCRIPTION='Example action: two white liquid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two white liquid"
}
function script_before_parsing_options_two_white_gas () {
    script_USAGE="usage: ${script_PROGNAME} two white gas [options]"
    script_DESCRIPTION='Example action: two white gas.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two white gas"
}

### --------------------------------------------------------------------

function script_before_parsing_options_two_red_solid () {
    script_USAGE="usage: ${script_PROGNAME} two red solid [options]"
    script_DESCRIPTION='Example action: two red solid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two red solid"
}
function script_before_parsing_options_two_red_liquid () {
    script_USAGE="usage: ${script_PROGNAME} two red liquid [options]"
    script_DESCRIPTION='Example action: two red liquid.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two red liquid"
}
function script_before_parsing_options_two_red_gas () {
    script_USAGE="usage: ${script_PROGNAME} two red gas [options]"
    script_DESCRIPTION='Example action: two red gas.'
    script_EXAMPLES="Usage examples:

\t${script_PROGNAME} two red gas"
}

#page
#### script actions tree: main functions

# This is the default main function.   It is invoked whenever the script
# is executed without action arguments.
#
function main () {
    printf "action main: X='%s' Y='%s' Z='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_X" "$script_option_Y" "$script_option_Z" "$ARGC" "${ARGV[*]}"
}

## --------------------------------------------------------------------
## These are  the main functions for  each non-leaf node in  the actions
## tree.  For  each of them: we  want to print a  meaningful help screen
## then exit.

function script_action_MAIN_ONE () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_TWO () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_THREE () {
    mbfl_main_print_usage_screen_brief
}

function script_action_MAIN_ONE_GREEN () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_ONE_WHITE () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_ONE_RED () {
    mbfl_main_print_usage_screen_brief
}

function script_action_MAIN_TWO_GREEN () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_TWO_WHITE () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_TWO_RED () {
    mbfl_main_print_usage_screen_brief
}

function script_action_MAIN_THREE_GREEN () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_THREE_WHITE () {
    mbfl_main_print_usage_screen_brief
}
function script_action_MAIN_THREE_RED () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------
## These are the main functions for  the leaf nodes in the actions tree.
## Each of the performs an action.

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

#mbfl_set_option_debug
mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
