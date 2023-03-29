#!
#! Part of: Marco's Bash Functions Library
#! Contents: test script for "libmbfl-git"
#! Date: Mar  6, 2023
#!
#! Abstract
#!
#!	This is a wrapper for GIT built on the  facilities of MBFL.  In theory it can be extented to
#!	support other version control systems.
#!
#! Copyright (C) 2023 Marco Maggi <mrc.mgg@gmail.com>
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


#### macros

m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],$#,2,[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]],[[[MBFL_P_WRONG_NUM_ARGS($#,1 or 2)]]])]]])


#### global variables

declare -r script_REQUIRED_MBFL_VERSION=v3.0.0-devel.8
declare -r script_PROGNAME=vc
declare -r script_VERSION=1.0
declare -r script_COPYRIGHT_YEARS='2023'
declare -r script_AUTHOR='Marco Maggi'
declare -r script_LICENSE=GPL3
script_USAGE="usage: ${script_PROGNAME} [action] [options]"
script_DESCRIPTION='Version control facilities built upon the MBFL.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} git commit ARG ...
\t${script_PROGNAME} git config local get KEY"

declare -r COMPLETIONS_SCRIPT_NAMESPACE='p-mbfl'
declare -r CDPATH=


#### library loading

mbfl_embed_library
mbfl_embed_library(__LIBMBFL_GIT__)


#### declare external programs usage

mbfl_vc_git_enable


#### declare exit codes

#mbfl_main_declare_exit_code 10 usb_stick_not_present


#### configure global behaviour

mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit


#### actions tree

mbfl_declare_action_set GIT_CONFIG_LOCAL
#                   action-set		keyword			subset		identifier	description
mbfl_declare_action GIT_CONFIG_LOCAL	GIT_CONFIG_LOCAL_GET	NONE		get		'Get values from repository configuration.'
mbfl_declare_action GIT_CONFIG_LOCAL	GIT_CONFIG_LOCAL_SET	NONE		set		'Set values into repository configuration.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_CONFIG_GLOBAL
#                   action-set		keyword			subset		identifier	description
mbfl_declare_action GIT_CONFIG_GLOBAL	GIT_CONFIG_GLOBAL_GET	NONE		get		'Get values from global configuration.'
mbfl_declare_action GIT_CONFIG_GLOBAL	GIT_CONFIG_GLOBAL_SET	NONE		set		'Set values into global configuration.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_CONFIG
#                   action-set	keyword			subset			identifier	description
mbfl_declare_action GIT_CONFIG	GIT_CONFIG_LOCAL	GIT_CONFIG_LOCAL	local		'Repository configuration management.'
mbfl_declare_action GIT_CONFIG	GIT_CONFIG_GLOBAL	GIT_CONFIG_GLOBAL	global		'Global configuration management.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_BRANCH_CURRENT
#                   action-set		keyword			subset		identifier	description
mbfl_declare_action GIT_BRANCH_CURRENT	GIT_BRANCH_CURRENT_NAME	NONE		name		'Print the name of the current branch.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_BRANCH_LIST
#                   action-set		keyword			subset	identifier	description
mbfl_declare_action GIT_BRANCH_LIST	GIT_BRANCH_LIST_ALL	NONE	all		'List all the branches: local and remote tracking.'
mbfl_declare_action GIT_BRANCH_LIST	GIT_BRANCH_LIST_LOCAL	NONE	local		'List the local branches.'
mbfl_declare_action GIT_BRANCH_LIST	GIT_BRANCH_LIST_REMOTE_TRACKING NONE remote-tracking 'List the remote tracking branches.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_BRANCH
#                   action-set	keyword			subset			identifier	description
mbfl_declare_action GIT_BRANCH	GIT_BRANCH_CURRENT	GIT_BRANCH_CURRENT	current		'Current branch management.'
mbfl_declare_action GIT_BRANCH	GIT_BRANCH_LIST		GIT_BRANCH_LIST		list		'List the branches.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_REPOSITORY_PRINT
#                   action-set		 keyword                         subset identifier description
mbfl_declare_action GIT_REPOSITORY_PRINT GIT_REPOSITORY_PRINT_TOP_SRCDIR NONE   top-srcdir 'Print informations about the repositories.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT_REPOSITORY
#                   action-set     keyword              subset               identifier description
mbfl_declare_action GIT_REPOSITORY GIT_REPOSITORY_PRINT GIT_REPOSITORY_PRINT print      'Print informations about the repositories.'

## --------------------------------------------------------------------

mbfl_declare_action_set GIT
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action GIT		GIT_CONFIG	GIT_CONFIG	config		'Configuration management.'
mbfl_declare_action GIT		GIT_REPOSITORY	GIT_REPOSITORY	repository	'Repositories management.'
mbfl_declare_action GIT		GIT_BRANCH	GIT_BRANCH	branch		'Branches management.'

## --------------------------------------------------------------------

mbfl_declare_action_set HELP
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action HELP	HELP_USAGE	NONE		usage		'Print the help screen and exit.'
mbfl_declare_action HELP	HELP_PRINT_COMPLETIONS_SCRIPT NONE print-completions-script 'Print the completions script for this program.'

## --------------------------------------------------------------------

mbfl_declare_action_set MAIN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action MAIN	GIT		GIT		git		'GIT version control system.'
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


#### configuration

function script_before_parsing_options_GIT_CONFIG () {
    script_USAGE="usage: ${script_PROGNAME} config [action] [options]"
    script_DESCRIPTION='Configuration management.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_CONFIG_LOCAL () {
    script_USAGE="usage: ${script_PROGNAME} config local [action] [options]"
    script_DESCRIPTION='Repository configuration management.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG_LOCAL () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_CONFIG_LOCAL_GET () {
    script_USAGE="usage: ${script_PROGNAME} config local get [options] KEY [DEFAULT_VALUE]"
    script_DESCRIPTION='Get values from repository configuration.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG_LOCAL_GET () {
    vc_git_config_get_value 'local'
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_CONFIG_LOCAL_SET () {
    script_USAGE="usage: ${script_PROGNAME} config local set [options] KEY VALUE"
    script_DESCRIPTION='Set values into repository configuration.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG_LOCAL_SET () {
    vc_git_config_set_value 'local'
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_CONFIG_GLOBAL () {
    script_USAGE="usage: ${script_PROGNAME} config global [action] [options]"
    script_DESCRIPTION='Global configuration management.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG_GLOBAL () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_CONFIG_GLOBAL_GET () {
    script_USAGE="usage: ${script_PROGNAME} config global get [options] KEY [DEFAULT_VALUE]"
    script_DESCRIPTION='Get values from global configuration.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG_GLOBAL_GET () {
    vc_git_config_get_value 'global'
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_CONFIG_GLOBAL_SET () {
    script_USAGE="usage: ${script_PROGNAME} config global set [options] KEY VALUE"
    script_DESCRIPTION='Set values into global configuration.'
    script_EXAMPLES=
}
function script_action_GIT_CONFIG_GLOBAL_SET () {
    vc_git_config_set_value 'global'
}

### ------------------------------------------------------------------------

function vc_git_config_get_value () {
    if mbfl_wrong_num_args_range 1 2 $ARGC
    then
	mbfl_mandatory_parameter(DATABASE, 1, the database specification)
	mbfl_command_line_argument(KEY, 0)
	mbfl_command_line_argument(DEFAULT, 1)
	mbfl_local_assoc_array_varref(CFGOPT)
	mbfl_local_varref(VALUE)

	if ! mbfl_vc_git_config_option_define _(CFGOPT) "$KEY" "$DEFAULT"
	then exit_because_failure
	fi
	if ! vc_git_config_parse_database  _(CFGOPT) "$DATABASE"
	then exit_because_failure
	fi
	if ! mbfl_vc_git_config_option_value_var _(VALUE) _(CFGOPT)
	then exit_because_failure
	fi
	printf '%s' "$VALUE"
    else
	mbfl_main_print_usage_screen_brief
	exit_because_wrong_num_args
    fi
}
function vc_git_config_set_value () {
    if mbfl_wrong_num_args 2 $ARGC
    then
	mbfl_mandatory_parameter(DATABASE, 1, the database specification)
	mbfl_command_line_argument(KEY, 0)
	mbfl_command_line_argument(NEW_VALUE, 1)
	mbfl_local_assoc_array_varref(CFGOPT)
	mbfl_local_varref(VALUE)

	if ! mbfl_vc_git_config_option_define _(CFGOPT) "$KEY"
	then exit_because_failure
	fi
	if ! vc_git_config_parse_database _(CFGOPT) "$DATABASE"
	then exit_because_failure
	fi
	if ! mbfl_vc_git_config_option_value_set _(CFGOPT) "$NEW_VALUE"
	then exit_because_failure
	fi
    else
	mbfl_main_print_usage_screen_brief
	exit_because_wrong_num_args
    fi
}

# Validate  the command  line argument  DATABASE  and store  it in  CFGOPT  as value  for the  field
# "database".
#
function vc_git_config_parse_database () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to object of class mbfl_vc_git_config_option)
    mbfl_mandatory_parameter(DATABASE,		2, the database specification)

    case "$DATABASE" in
	'local')	: ;;
	'global')	: ;;
	*)
	    mbfl_message_error_printf 'internal error, invalid database specification: "%s"' "$DATABASE"
	    return_because_failure
	    ;;
    esac
    mbfl_vc_git_config_option_database_set _(CFGOPT) "$DATABASE"
}


#### repositories

function script_before_parsing_options_GIT_REPOSITORY () {
    script_USAGE="usage: ${script_PROGNAME} repository [action] [options]"
    script_DESCRIPTION='Repositories management.'
    script_EXAMPLES=
}
function script_action_GIT_REPOSITORY () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_REPOSITORY_PRINT () {
    script_USAGE="usage: ${script_PROGNAME} repository print [action] [options]"
    script_DESCRIPTION='Print informations about git repositories.'
    script_EXAMPLES=
}
function script_action_GIT_REPOSITORY_PRINT () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_REPOSITORY_PRINT_TOP_SRCDIR () {
    script_USAGE="usage: ${script_PROGNAME} repository print top-srcdir [options]"
    script_DESCRIPTION='Print the top srcdir pathname of the current git repository.'
    script_EXAMPLES=
}
function script_action_GIT_REPOSITORY_PRINT_TOP_SRCDIR () {
    if mbfl_wrong_num_args 0 $ARGC
    then mbfl_vc_git_repository_top_srcdir
    else exit_because_wrong_num_args
    fi
}


#### branches

function script_before_parsing_options_GIT_BRANCH () {
    script_USAGE="usage: ${script_PROGNAME} branch [action] [options]"
    script_DESCRIPTION='Branches management.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_BRANCH_CURRENT () {
    script_USAGE="usage: ${script_PROGNAME} branch current [action] [options]"
    script_DESCRIPTION='Current branch management.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH_CURRENT () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_BRANCH_CURRENT_NAME () {
    script_USAGE="usage: ${script_PROGNAME} branch current name [options]"
    script_DESCRIPTION='Print the name of the current branch.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH_CURRENT_NAME () {
    if mbfl_wrong_num_args 0 $ARGC
    then
	mbfl_local_varref(CURRENT_BRANCH_NAME)

	mbfl_vc_git_branch_current_name_var mbfl_datavar(CURRENT_BRANCH_NAME)
	printf '%s' "$CURRENT_BRANCH_NAME"
    else exit_because_wrong_num_args
    fi
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_BRANCH_LIST () {
    script_USAGE="usage: ${script_PROGNAME} branch list [action] [options]"
    script_DESCRIPTION='List branches.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH_LIST () {
    mbfl_main_print_usage_screen_brief
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_BRANCH_LIST_ALL () {
    script_USAGE="usage: ${script_PROGNAME} branch list all [options]"
    script_DESCRIPTION='List all the branches: local and remote tracking.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH_LIST_ALL () {
    if mbfl_wrong_num_args 0 $ARGC
    then
	mbfl_declare_index_array_varref(BRANCHES)

	mbfl_vc_git_branch_list_all_var _(BRANCHES)
	p_print_branches_from_array _(BRANCHES)
    else exit_because_wrong_num_args
    fi
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_BRANCH_LIST_LOCAL () {
    script_USAGE="usage: ${script_PROGNAME} branch list local [options]"
    script_DESCRIPTION='List the local branches.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH_LIST_LOCAL () {
    if mbfl_wrong_num_args 0 $ARGC
    then
	mbfl_declare_index_array_varref(BRANCHES)

	mbfl_vc_git_branch_list_local_var _(BRANCHES)
	p_print_branches_from_array _(BRANCHES)
    else exit_because_wrong_num_args
    fi
}

### ------------------------------------------------------------------------

function script_before_parsing_options_GIT_BRANCH_LIST_REMOTE_TRACKING () {
    script_USAGE="usage: ${script_PROGNAME} branch list remote-tracking [options]"
    script_DESCRIPTION='List the remote tracking branches.'
    script_EXAMPLES=
}
function script_action_GIT_BRANCH_LIST_REMOTE_TRACKING () {
    if mbfl_wrong_num_args 0 $ARGC
    then
	mbfl_declare_index_array_varref(BRANCHES)

	mbfl_vc_git_branch_list_local_var _(BRANCHES)
	p_print_branches_from_array _(BRANCHES)
    else exit_because_wrong_num_args
    fi
}

### ------------------------------------------------------------------------

function p_print_branches_from_array () {
    mbfl_mandatory_nameref_parameter(mbfl_BRANCHES, 1, reference to result array)
    declare -i mbfl_I mbfl_NUM=mbfl_slots_number(BRANCHES)

    for ((mbfl_I=0; mbfl_I < mbfl_NUM; ++mbfl_I))
    do printf '%s\n' mbfl_slot_qref(mbfl_BRANCHES, mbfl_I)
    done
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


#### external program interfaces

#MBFL_DEFINE_PROGRAM_EXECUTOR([[[touch]]],[[[touch]]])


#### let's go

mbfl_main

### end of file
# Local Variables:
# mode: shell-script
# End:
