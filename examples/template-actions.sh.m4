# Part of: Marco's BASH Functions Library
# Contents: script template
# Date: Mon May 27, 2013
#
# Abstract
#
#	This script template shows  how an MBFL script should be organised to  use MBFL with command
#	line actions processing.  This script uses  the "actions" module to configure its behaviour,
#	similarly to what "git" does with its subcommands.
#
# Copyright (c) 2013, 2014, 2018, 2020 Marco Maggi <mrc.mgg@gmail.com>
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
# THIS SOFTWARE IS PROVIDED ON AN "AS IS"  BASIS, AND THE AUTHOR AND DISTRIBUTORS HAVE NO OBLIGATION
# TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

#page
#### MBFL's related options and variables

declare -r script_PROGNAME=template-actions.sh
declare -r script_VERSION=1.0
declare -r script_COPYRIGHT_YEARS='2013, 2014, 2018, 2020'
declare -r script_AUTHOR='Marco Maggi'
declare -r script_LICENSE=liberal

# This  variable   declaration  is   just  a   comment,  because  below   we  define   the  function
# "script_check_mbfl_semantic_version()", which  is actually  used to  validate the  MBFL's required
# version.
declare -r script_REQUIRED_MBFL_VERSION=v3.0.0-devel.4

declare -r COMPLETIONS_SCRIPT_NAMESPACE='p-mbfl-examples'

#page
#### library loading

mbfl_library_loader

#page
#### declare external programs usage

#mbfl_file_enable_compress
#mbfl_file_enable_copy
#mbfl_file_enable_make_directory
#mbfl_file_enable_listing
#mbfl_file_enable_stat
#mbfl_file_enable_owner_and_group
#mbfl_file_enable_permissions
#mbfl_file_enable_move
#mbfl_file_enable_remove
#mbfl_file_enable_symlink
#mbfl_file_enable_tar
#mbfl_declare_program git

#page
#### declare exit codes

# mbfl_declare_exit_code 2 second_error
# mbfl_declare_exit_code 3 third_error
# mbfl_declare_exit_code 4 fourth_error
# mbfl_declare_exit_code 8 eighth_error

#page
#### configure global behaviour

mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit

#page
#### declaration of script actions tree
#
# main --+-- one ---+--- green --+--- solid
#        |          |            +--- liquid
#        |          |             --- gas
#        |          |
#        |          +--- white --+--- solid
#        |          |            +--- liquid
#        |          |             --- gas
#        |          |
#        |           --- red ----+--- solid
#        |                       +--- liquid
#        |                        --- gas
#        |
#        +-- two ---+--- green --+--- solid
#        |          |            +--- liquid
#        |          |             --- gas
#        |          |
#        |          +--- white --+--- solid
#        |          |            +--- liquid
#        |          |             --- gas
#        |          |
#        |           --- red ----+--- solid
#        |                       +--- liquid
#        |                        --- gas
#        |
#        +-- three -+--- green --+--- solid
#        !          |            +--- liquid
#        !          |             --- gas
#        !          |
#        !          +--- white --+--- solid
#        !          |            +--- liquid
#        !          |             --- gas
#        !          |
#        !           --- red ----+--- solid
#        !                       +--- liquid
#        !                        --- gas
#        |
#         -- help --+--- usage
#                   |
#                    --- print-completions-script
#

mbfl_declare_action_set ONE_GREEN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action ONE_GREEN	ONE_GREEN_SOLID		NONE	solid		'Do main action one green solid.'
mbfl_declare_action ONE_GREEN	ONE_GREEN_LIQUID	NONE	liquid		'Do main action one green liquid.'
mbfl_declare_action ONE_GREEN	ONE_GREEN_GAS		NONE	gas		'Do main action one green gas.'

mbfl_declare_action_set ONE_WHITE
mbfl_declare_action ONE_WHITE	ONE_WHITE_SOLID		NONE	solid		'Do main action one white solid.'
mbfl_declare_action ONE_WHITE	ONE_WHITE_LIQUID	NONE	liquid		'Do main action one white liquid.'
mbfl_declare_action ONE_WHITE	ONE_WHITE_GAS		NONE	gas		'Do main action one white gas.'

mbfl_declare_action_set ONE_RED
mbfl_declare_action ONE_RED	ONE_RED_SOLID		NONE	solid		'Do main action one red solid.'
mbfl_declare_action ONE_RED	ONE_RED_LIQUID		NONE	liquid		'Do main action one red liquid.'
mbfl_declare_action ONE_RED	ONE_RED_GAS		NONE	gas		'Do main action one red gas.'

### --------------------------------------------------------------------

mbfl_declare_action_set TWO_GREEN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action TWO_GREEN	TWO_GREEN_SOLID		NONE	solid		'Do main action two green solid.'
mbfl_declare_action TWO_GREEN	TWO_GREEN_LIQUID	NONE	liquid		'Do main action two green liquid.'
mbfl_declare_action TWO_GREEN	TWO_GREEN_GAS		NONE	gas		'Do main action two green gas.'

mbfl_declare_action_set TWO_WHITE
mbfl_declare_action TWO_WHITE	TWO_WHITE_SOLID		NONE	solid		'Do main action two white solid.'
mbfl_declare_action TWO_WHITE	TWO_WHITE_LIQUID	NONE	liquid		'Do main action two white liquid.'
mbfl_declare_action TWO_WHITE	TWO_WHITE_GAS		NONE	gas		'Do main action two white gas.'

mbfl_declare_action_set TWO_RED
mbfl_declare_action TWO_RED	TWO_RED_SOLID		NONE	solid		'Do main action two red solid.'
mbfl_declare_action TWO_RED	TWO_RED_LIQUID		NONE	liquid		'Do main action two red liquid.'
mbfl_declare_action TWO_RED	TWO_RED_GAS		NONE	gas		'Do main action two red gas.'

### --------------------------------------------------------------------

mbfl_declare_action_set THREE_GREEN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action THREE_GREEN	THREE_GREEN_SOLID	NONE	solid		'Do main action three green solid.'
mbfl_declare_action THREE_GREEN	THREE_GREEN_LIQUID	NONE	liquid		'Do main action three green liquid.'
mbfl_declare_action THREE_GREEN	THREE_GREEN_GAS		NONE	gas		'Do main action three green gas.'

mbfl_declare_action_set THREE_WHITE
mbfl_declare_action THREE_WHITE	THREE_WHITE_SOLID	NONE	solid		'Do main action three white solid.'
mbfl_declare_action THREE_WHITE	THREE_WHITE_LIQUID	NONE	liquid		'Do main action three white liquid.'
mbfl_declare_action THREE_WHITE	THREE_WHITE_GAS		NONE	gas		'Do main action three white gas.'

mbfl_declare_action_set THREE_RED
mbfl_declare_action THREE_RED	THREE_RED_SOLID		NONE	solid		'Do main action three red solid.'
mbfl_declare_action THREE_RED	THREE_RED_LIQUID	NONE	liquid		'Do main action three red liquid.'
mbfl_declare_action THREE_RED	THREE_RED_GAS		NONE	gas		'Do main action three red gas.'

### --------------------------------------------------------------------

mbfl_declare_action_set ONE
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action ONE		ONE_GREEN	ONE_GREEN	green		'Do main action one green.'
mbfl_declare_action ONE		ONE_WHITE	ONE_WHITE	white		'Do main action one white.'
mbfl_declare_action ONE		ONE_RED		ONE_RED		red		'Do main action one red.'

mbfl_declare_action_set TWO
mbfl_declare_action TWO		TWO_GREEN	TWO_GREEN	green		'Do main action two green.'
mbfl_declare_action TWO		TWO_WHITE	TWO_WHITE	white		'Do main action two white.'
mbfl_declare_action TWO		TWO_RED		TWO_RED		red		'Do main action two red.'

mbfl_declare_action_set THREE
mbfl_declare_action THREE	THREE_GREEN	THREE_GREEN	green		'Do main action three green.'
mbfl_declare_action THREE	THREE_WHITE	THREE_WHITE	white		'Do main action three white.'
mbfl_declare_action THREE	THREE_RED	THREE_RED	red		'Do main action three red.'

## --------------------------------------------------------------------

mbfl_declare_action_set HELP
mbfl_declare_action HELP	HELP_USAGE	NONE		usage		'Print the help screen and exit.'
mbfl_declare_action HELP	HELP_PRINT_COMPLETIONS_SCRIPT NONE print-completions-script 'Print the completions script for this program.'

### --------------------------------------------------------------------

mbfl_declare_action_set MAIN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action MAIN	ONE		ONE		one		'Do main action one.'
mbfl_declare_action MAIN	TWO		TWO		two		'Do main action two.'
mbfl_declare_action MAIN	THREE		THREE		three		'Do main action three.'
mbfl_declare_action MAIN	HELP		HELP		help		'Help the user of this script.'

#page
#### script action functions: main

# Set up main variables and action-specific options for the main action:
#
#   template-actions.sh [options]
#
function script_before_parsing_options () {
    script_USAGE="usage: ${script_PROGNAME} [action] [options]"
    script_DESCRIPTION='This is an example script showing action arguments.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} --x-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option X no x x-opt noarg   'Selects option x.'
    mbfl_declare_option Y '' y y-opt witharg 'Selects option y.'
    mbfl_declare_option Z '' z z-opt witharg 'Selects option z.'
}

# This is the default main function.   It is invoked whenever the script
# is executed without action arguments:
#
#   template-action.sh [options]
#
function main () {
    printf "action main: X='%s' Y='%s' Z='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_X" "$script_option_Y" "$script_option_Z" "$ARGC" "${ARGV[*]}"
}

#page
#### script action functions: first level

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one [options]
#
function script_before_parsing_options_ONE () {
    script_USAGE="usage: ${script_PROGNAME} one [action] [options]"
    script_DESCRIPTION='Example action tree: one.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green solid"
}
function script_action_ONE () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two [options]
#
function script_before_parsing_options_TWO () {
    script_USAGE="usage: ${script_PROGNAME} two [action] [options]"
    script_DESCRIPTION='Example action tree: two.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green solid"
}
function script_action_TWO () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three [options]
#
function script_before_parsing_options_THREE () {
    script_USAGE="usage: ${script_PROGNAME} three [action] [options]"
    script_DESCRIPTION='Example action tree: three.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green solid"
}
function script_action_THREE () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

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

#page
#### script action functions: second level, action root "one"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one green [options]
#
function script_before_parsing_options_ONE_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} one green [action] [options]"
    script_DESCRIPTION='Example action tree: one green.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green solid"
}
function script_action_ONE_GREEN () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one white [options]
#
function script_before_parsing_options_ONE_WHITE () {
    script_USAGE="usage: ${script_PROGNAME} one white [action] [options]"
    script_DESCRIPTION='Example action tree: one white.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white solid"
}
function script_action_ONE_WHITE () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one red [options]
#
function script_before_parsing_options_ONE_RED () {
    script_USAGE="usage: ${script_PROGNAME} one red [action] [options]"
    script_DESCRIPTION='Example action tree: one red.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red solid"
}
function script_action_ONE_RED () {
    mbfl_main_print_usage_screen_brief
}

#page
#### script action functions: second level, action root "two"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two green [options]
#
function script_before_parsing_options_TWO_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} two green [action] [options]"
    script_DESCRIPTION='Example action tree: two green.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green solid"
}
function script_action_TWO_GREEN () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two white [options]
#
function script_before_parsing_options_TWO_WHITE () {
    script_USAGE="usage: ${script_PROGNAME} two white [action] [options]"
    script_DESCRIPTION='Example action tree: two white.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white solid"
}
function script_action_TWO_WHITE () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two red [options]
#
function script_before_parsing_options_TWO_RED () {
    script_USAGE="usage: ${script_PROGNAME} two red [action] [options]"
    script_DESCRIPTION='Example action tree: two red.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red solid"
}
function script_action_TWO_RED () {
    mbfl_main_print_usage_screen_brief
}

#page
#### script action functions: second level, action root "three"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three green [options]
#
function script_before_parsing_options_THREE_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} three green [action] [options]"
    script_DESCRIPTION='Example action tree: three green.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green solid"
}
function script_action_THREE_GREEN () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three white [options]
#
function script_before_parsing_options_THREE_WHITE () {
    script_USAGE="usage: ${script_PROGNAME} three white [action] [options]"
    script_DESCRIPTION='Example action tree: three white.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white solid"
}
function script_action_THREE_WHITE () {
    mbfl_main_print_usage_screen_brief
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three red [options]
#
function script_before_parsing_options_THREE_RED () {
    script_USAGE="usage: ${script_PROGNAME} three red [action] [options]"
    script_DESCRIPTION='Example action tree: three red.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red solid"
}
function script_action_THREE_RED () {
    mbfl_main_print_usage_screen_brief
}

#page
#### script action functions: second level, action root "help"

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

#page
#### script action functions: third level, action root "one green"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one green solid [options]
#
function script_before_parsing_options_ONE_GREEN_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} one green solid [options]"
    script_DESCRIPTION='Example action: one green solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green solid --a-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option A no a a-opt noarg   'Selects option a.'
    mbfl_declare_option B '' b b-opt witharg 'Selects option b.'
    mbfl_declare_option C '' c c-opt witharg 'Selects option c.'
}
function script_action_ONE_GREEN_SOLID () {
    printf "action one green solid: A='%s' B='%s' C='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_A" "$script_option_B" "$script_option_C" "$ARGC" "${ARGV[*]}"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one green liquid [options]
#
function script_before_parsing_options_ONE_GREEN_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} one green liquid [options]"
    script_DESCRIPTION='Example action: one green liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green liquid --d-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option D no d d-opt noarg   'Selects option d.'
    mbfl_declare_option E '' e e-opt witharg 'Selects option e.'
    mbfl_declare_option F '' f f-opt witharg 'Selects option f.'
}
function script_action_ONE_GREEN_LIQUID () {
    printf "action one green liquid: D='%s' E='%s' F='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_D" "$script_option_E" "$script_option_F" "$ARGC" "${ARGV[*]}"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one green gas [options]
#
function script_before_parsing_options_ONE_GREEN_GAS () {
    script_USAGE="usage: ${script_PROGNAME} one green gas [options]"
    script_DESCRIPTION='Example action: one green gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green gas --d-opt"

    # keyword default-value brief-option long-option has-argument description
    mbfl_declare_option G no g g-opt noarg   'Selects option d.'
    mbfl_declare_option H '' h h-opt witharg 'Selects option e.'
    mbfl_declare_option I '' i i-opt witharg 'Selects option f.'
}
function script_action_ONE_GREEN_GAS () {
    printf "action one green gas: G='%s' H='%s' I='%s' ARGC=%s ARGV='%s'\n" \
	"$script_option_G" "$script_option_H" "$script_option_I" "$ARGC" "${ARGV[*]}"
}

#page
#### script action functions: third level, action root "one white"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one white solid [options]
#
function script_before_parsing_options_ONE_WHITE_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} one white solid [options]"
    script_DESCRIPTION='Example action: one white solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white solid"
}
function script_action_ONE_WHITE_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one white liquid [options]
#
function script_before_parsing_options_ONE_WHITE_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} one white liquid [options]"
    script_DESCRIPTION='Example action: one white liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white liquid"
}
function script_action_ONE_WHITE_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one white gas [options]
#
function script_before_parsing_options_ONE_WHITE_GAS () {
    script_USAGE="usage: ${script_PROGNAME} one white gas [options]"
    script_DESCRIPTION='Example action: one white gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white gas"
}
function script_action_ONE_WHITE_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "one red"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one red solid [options]
#
function script_before_parsing_options_ONE_RED_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} one red solid [options]"
    script_DESCRIPTION='Example action: one red solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red solid"
}
function script_action_ONE_RED_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one red liquid [options]
#
function script_before_parsing_options_ONE_RED_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} one red liquid [options]"
    script_DESCRIPTION='Example action: one red liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red liquid"
}
function script_action_ONE_RED_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh one red gas [options]
#
function script_before_parsing_options_ONE_RED_GAS () {
    script_USAGE="usage: ${script_PROGNAME} one red gas [options]"
    script_DESCRIPTION='Example action: one red gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red gas"
}
function script_action_ONE_RED_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "two green"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two green solid [options]
#
function script_before_parsing_options_TWO_GREEN_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} two green solid [options]"
    script_DESCRIPTION='Example action: two green solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green solid --a-opt"
}
function script_action_TWO_GREEN_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two green liquid [options]
#
function script_before_parsing_options_TWO_GREEN_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} two green liquid [options]"
    script_DESCRIPTION='Example action: two green liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green liquid --d-opt"
}
function script_action_TWO_GREEN_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two green gas [options]
#
function script_before_parsing_options_TWO_GREEN_GAS () {
    script_USAGE="usage: ${script_PROGNAME} two green gas [options]"
    script_DESCRIPTION='Example action: two green gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green gas --d-opt"
}
function script_action_TWO_GREEN_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "two white"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two white solid [options]
#
function script_before_parsing_options_TWO_WHITE_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} two white solid [options]"
    script_DESCRIPTION='Example action: two white solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white solid"
}
function script_action_TWO_WHITE_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two white liquid [options]
#
function script_before_parsing_options_TWO_WHITE_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} two white liquid [options]"
    script_DESCRIPTION='Example action: two white liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white liquid"
}
function script_action_TWO_WHITE_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two white gas [options]
#
function script_before_parsing_options_TWO_WHITE_GAS () {
    script_USAGE="usage: ${script_PROGNAME} two white gas [options]"
    script_DESCRIPTION='Example action: two white gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white gas"
}
function script_action_TWO_WHITE_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "two red"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two red solid [options]
#
function script_before_parsing_options_TWO_RED_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} two red solid [options]"
    script_DESCRIPTION='Example action: two red solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red solid"
}
function script_action_TWO_RED_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two red liquid [options]
#
function script_before_parsing_options_TWO_RED_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} two red liquid [options]"
    script_DESCRIPTION='Example action: two red liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red liquid"
}
function script_action_TWO_RED_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh two red gas [options]
#
function script_before_parsing_options_TWO_RED_GAS () {
    script_USAGE="usage: ${script_PROGNAME} two red gas [options]"
    script_DESCRIPTION='Example action: two red gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red gas"
}
function script_action_TWO_RED_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "three green"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three green solid [options]
#
function script_before_parsing_options_THREE_GREEN_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} three green solid [options]"
    script_DESCRIPTION='Example action: three green solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green solid --a-opt"
}
function script_action_THREE_GREEN_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three green liquid [options]
#
function script_before_parsing_options_THREE_GREEN_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} three green liquid [options]"
    script_DESCRIPTION='Example action: three green liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green liquid --d-opt"
}
function script_action_THREE_GREEN_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three green gas [options]
#
function script_before_parsing_options_THREE_GREEN_GAS () {
    script_USAGE="usage: ${script_PROGNAME} three green gas [options]"
    script_DESCRIPTION='Example action: three green gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green gas --d-opt"
}
function script_action_THREE_GREEN_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "three white"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three white solid [options]
#
function script_before_parsing_options_THREE_WHITE_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} three white solid [options]"
    script_DESCRIPTION='Example action: three white solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white solid"
}
function script_action_THREE_WHITE_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three white liquid [options]
#
function script_before_parsing_options_THREE_WHITE_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} three white liquid [options]"
    script_DESCRIPTION='Example action: three white liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white liquid"
}
function script_action_THREE_WHITE_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three white gas [options]
#
function script_before_parsing_options_THREE_WHITE_GAS () {
    script_USAGE="usage: ${script_PROGNAME} three white gas [options]"
    script_DESCRIPTION='Example action: three white gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white gas"
}
function script_action_THREE_WHITE_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### script action functions: third level, action root "three red"

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three red solid [options]
#
function script_before_parsing_options_THREE_RED_SOLID () {
    script_USAGE="usage: ${script_PROGNAME} three red solid [options]"
    script_DESCRIPTION='Example action: three red solid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red solid"
}
function script_action_THREE_RED_SOLID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three red liquid [options]
#
function script_before_parsing_options_THREE_RED_LIQUID () {
    script_USAGE="usage: ${script_PROGNAME} three red liquid [options]"
    script_DESCRIPTION='Example action: three red liquid.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red liquid"
}
function script_action_THREE_RED_LIQUID () {
    printf "action ${FUNCNAME}\n"
}

### --------------------------------------------------------------------

# Set up main variables and action-specific options for the action:
#
#   template-actions.sh three red gas [options]
#
function script_before_parsing_options_THREE_RED_GAS () {
    script_USAGE="usage: ${script_PROGNAME} three red gas [options]"
    script_DESCRIPTION='Example action: three red gas.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red gas"
}
function script_action_THREE_RED_GAS () {
    printf "action ${FUNCNAME}\n"
}

#page
#### required MBFL's version

function script_check_mbfl_semantic_version () {
    local -r REQUIRED_MBFL_VERSION=v3.0.0-devel.4
    mbfl_local_varref(RV)

    mbfl_message_debug_printf 'library version "%s", version required by the script "%s"' \
			      "$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
    if {
	mbfl_location_enter
	{
	    mbfl_location_handler 'mbfl_semver_reset_config'
	    mbfl_semver_config[PARSE_LEADING_V]='optional'
	    mbfl_semver_compare_var mbfl_datavar(RV) "$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
	}
	mbfl_location_leave
    }
    then
	if (( RV >= 0 ))
	then return 0
	else
	    mbfl_message_error_printf \
		'hard-coded MBFL library version "%s" is lesser than the minimum version required by the script "%s"' \
		"$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
	    exit_because_invalid_mbfl_version
	fi
    else
	mbfl_message_error_printf 'invalid required semantic version for MBFL: "%s"' "$REQUIRED_MBFL_VERSION"
	exit_because_invalid_mbfl_version
    fi
}

#page
#### let's go

#mbfl_set_option_debug
mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
