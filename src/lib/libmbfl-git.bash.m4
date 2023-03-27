#! libmbfl-git.bash.m4 --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: interface to the external program "git"
#! Date: Mar  6, 2023
#!
#! Abstract
#!
#!	Very basic interface to the version control program GIT.
#!
#! Copyright (c) 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!


#### macros

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],$#,2,[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]],[[[MBFL_P_WRONG_NUM_ARGS($#,1 or 2)]]])]]])


#### global variables

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    # Global variable used to cache the result of "mbfl_vc_git_repository_top_srcdir_var()".
    #
    declare -g mbfl_vc_git_REPOSITORY_TOP_SRCDIR_CACHED_VALUE=
fi


#### library initialisation

function mbfl_vc_git_enable () {
    mbfl_declare_program git

    mbfl_p_vc_git_reset_repository_top_srcdir
    mbfl_hook_add _(mbfl_CHANGE_DIRECTORY_HOOK) mbfl_p_vc_git_reset_repository_top_srcdir
}


#### data structures: CONFIG_VALUE

function mbfl_vc_git_config_init_value_struct () {
    mbfl_mandatory_nameref_parameter(CONFIG_VALUE, 1, struct array)
    mbfl_mandatory_parameter(KEY,		2, key string)
    mbfl_optional_parameter(DEFAULT_VALUE,	3)

    mbfl_slot_set(CONFIG_VALUE,MBFL_STRUCT_TYPE,'MBFL_VC_GIT_CONFIG_VALUE')
    mbfl_slot_set(CONFIG_VALUE,DATABASE,	'unspecified')
    mbfl_slot_set(CONFIG_VALUE,KEY,		"$KEY")
    mbfl_slot_set(CONFIG_VALUE,DEFAULT_VALUE,	"$DEFAULT_VALUE")
    mbfl_slot_set(CONFIG_VALUE,TYPE,		'no-type')
    mbfl_slot_set(CONFIG_VALUE,TERMINATOR,	'newline')
}

function mbfl_vc_git_config_validate_value_struct () {
    mbfl_mandatory_nameref_parameter(CONFIG_VALUE, 1, reference to config value struct)
    mbfl_local_varref(FLAGS)
    # We execute  this in a subshell  so that the  call to "exit_because_failure" are  equivalent to
    # calls to "return_because_failure".
    (mbfl_vc_git_config_parse_config_value_flags mbfl_datavar(CONFIG_VALUE) mbfl_datavar(FLAGS))
}

function mbfl_vc_git_config_parse_config_value_flags () {
    mbfl_mandatory_nameref_parameter(CONFIG_VALUE,	1, reference to config value struct)
    mbfl_mandatory_nameref_parameter(FLAGS,		2, reference to flags variable)

    if ! mbfl_string_eq('MBFL_VC_GIT_CONFIG_VALUE', mbfl_slot_qref(CONFIG_VALUE,MBFL_STRUCT_TYPE))
    then
	mbfl_message_error_printf 'invalid data structure type, expected "MBFL_VC_GIT_CONFIG_VALUE": "%s"' \
				  mbfl_slot_qref(CONFIG_VALUE,MBFL_STRUCT_TYPE)
	exit_because_failure
    fi

    if ! mbfl_string_is_extended_identifier mbfl_slot_qref(CONFIG_VALUE,KEY)
    then
	mbfl_message_error_printf 'invalid field value "CONFIG_VALUE[KEY]": "%s"' mbfl_slot_qref(CONFIG_VALUE,KEY)
	exit_because_failure
    fi

    case mbfl_slot_qref(CONFIG_VALUE,DATABASE) in
	'local')	FLAGS+=' --local'	;;
	'global')	FLAGS+=' --global'	;;
	'system')	FLAGS+=' --system'	;;
	'worktree')	FLAGS+=' --worktree'	;;
        'unspecified')				;;
	*)
	    mbfl_message_error_printf 'invalid field value "CONFIG_VALUE[DATABASE]": "%s"' mbfl_slot_qref(CONFIG_VALUE,DATABASE)
	    exit_because_failure
    esac

    case mbfl_slot_qref(CONFIG_VALUE,TYPE) in
	'bool')		FLAGS+=' --type=bool'		;;
	'int')		FLAGS+=' --type=int'		;;
	'bool-or-int')	FLAGS+=' --type=bool-or-int'	;;
	'path')		FLAGS+=' --type=path'		;;
	'expiry-date')	FLAGS+=' --type=expiry-date'	;;
	'color')	FLAGS+=' --type=color'		;;
	'no-type')	FLAGS+=' --no-type'		;;
	*)
	    mbfl_message_error_printf 'invalid field value "CONFIG_VALUE[TYPE]": "%s"' mbfl_slot_qref(CONFIG_VALUE,TYPE)
	    exit_because_failure
    esac

    case mbfl_slot_qref(CONFIG_VALUE,TERMINATOR) in
	'null')		FLAGS+=' --null'	;;
	'newline')				;;
	*)
	    mbfl_message_error_printf 'invalid field value "CONFIG_VALUE[TERMINATOR]": "%s"' mbfl_slot_qref(CONFIG_VALUE,TERMINATOR)
	    exit_because_failure
    esac
}


#### configuration management

function mbfl_vc_git_config_get_value () {
    mbfl_mandatory_nameref_parameter(CONFIG_VALUE, 1, reference to config value struct)
    mbfl_local_varref(FLAGS)

    mbfl_vc_git_config_parse_config_value_flags mbfl_datavar(CONFIG_VALUE) mbfl_datavar(FLAGS)
    # NOTE The option "--default" and the other options must come BEFORE the option "--get"!!!
    mbfl_vc_git_program config $FLAGS							\
			--default	mbfl_slot_qref(CONFIG_VALUE,DEFAULT_VALUE)	\
			--get		mbfl_slot_qref(CONFIG_VALUE,KEY)
}
function mbfl_vc_git_config_get_value_var () {
    mbfl_mandatory_nameref_parameter(VALUE,		1, reference to result variable)
    mbfl_mandatory_nameref_parameter(CONFIG_VALUE,	2, reference to config value struct)
    VALUE=$(mbfl_vc_git_config_get_value mbfl_datavar(CONFIG_VALUE))
}
function mbfl_vc_git_config_set_value () {
    mbfl_mandatory_nameref_parameter(CONFIG_VALUE,	1, reference to config value struct)
    mbfl_mandatory_parameter(NEW_VALUE,			2, new value string)
    mbfl_local_varref(FLAGS)

    mbfl_vc_git_config_parse_config_value_flags mbfl_datavar(CONFIG_VALUE) mbfl_datavar(FLAGS)
    mbfl_vc_git_program config $FLAGS --add mbfl_slot_qref(CONFIG_VALUE,KEY) "$NEW_VALUE"
}


#### git repositories

function mbfl_p_vc_git_reset_repository_top_srcdir () {
    mbfl_vc_git_REPOSITORY_TOP_SRCDIR_CACHED_VALUE=''
}

function mbfl_vc_git_repository_top_srcdir_var () {
    mbfl_mandatory_nameref_parameter(TOP_SRCDIR, 1, result variable)
    declare TOP_DIR

    if mbfl_string_is_not_empty "$mbfl_vc_git_REPOSITORY_TOP_SRCDIR_CACHED_VALUE"
    then
	# Use the cached value.
	TOP_SRCDIR=$mbfl_vc_git_REPOSITORY_TOP_SRCDIR_CACHED_VALUE
	return_success
    else
	TOP_DIR=$(while test ! -d ./.git -a "$(pwd)" != /; do cd .. ; done; pwd)
	if mbfl_string_eq('/', "$TOP_DIR")
	then return_because_failure
	else
	    # Store the result in the result variable.
	    TOP_SRCDIR=$TOP_DIR
	    # Cache the result.
	    mbfl_vc_git_REPOSITORY_TOP_SRCDIR_CACHED_VALUE=$TOP_DIR
	    return_success
	fi
    fi
}
function mbfl_vc_git_repository_top_srcdir () {
    mbfl_declare_varref(TOP_SRCDIR)

    if mbfl_vc_git_repository_top_srcdir_var _(TOP_SRCDIR)
    then
	# Do not append a newline.
	printf '%s' "$TOP_SRCDIR"
	return_success
    else return_failure
    fi
}


#### branches management

function mbfl_vc_git_branch_current_name () {
    mbfl_vc_git_program rev-parse --abbrev-ref HEAD 2>/dev/null

    # Alternatively:
    #
    # mbfl_vc_git_program symbolic-ref --short HEAD 2>/dev/null
}
function mbfl_vc_git_branch_current_name_var () {
    mbfl_mandatory_nameref_parameter(BRANCH_NAME, 1, reference to branch name output variable)
    BRANCH_NAME=$(mbfl_vc_git_branch_current_name)
}

### ------------------------------------------------------------------------

function mbfl_vc_git_branch_list_all_var () {
    mbfl_mandatory_nameref_parameter(mbfl_BRANCHES, 1, reference to result array)

    mbfl_p_vc_git_branch_list_var _(mbfl_BRANCHES) '--all'
}
function mbfl_vc_git_branch_list_local_var () {
    mbfl_mandatory_nameref_parameter(mbfl_BRANCHES, 1, reference to result array)

    mbfl_p_vc_git_branch_list_var _(mbfl_BRANCHES)
}
function mbfl_vc_git_branch_list_remote_tracking_var () {
    mbfl_mandatory_nameref_parameter(mbfl_BRANCHES, 1, reference to result array)

    mbfl_p_vc_git_branch_list_var _(mbfl_BRANCHES) '--remotes'
}

function mbfl_p_vc_git_branch_list_var () {
    mbfl_mandatory_nameref_parameter(mbfl_BRANCHES,	1, reference to result array)
    mbfl_optional_parameter(mbfl_GIT_FLAGS,		2)
    declare mbfl_BRANCH_NAME
    declare -i mbfl_I=0

    mbfl_location_enter
    {
	mbfl_location_handler_restore_lastpipe
	# This causes the last process in the pipe to  be executed in this shell rather than a subshell.
	# This way we can mutate variables in this shell.
	shopt -s lastpipe
	mbfl_vc_git_program branch $mbfl_GIT_FLAGS | while read mbfl_BRANCH_NAME
	do
	    mbfl_string_strip_prefix_var mbfl_BRANCH_NAME '* ' "$mbfl_BRANCH_NAME"
	    mbfl_string_strip_prefix_var mbfl_BRANCH_NAME '  ' "$mbfl_BRANCH_NAME"
	    mbfl_slot_set(mbfl_BRANCHES,mbfl_I,"$mbfl_BRANCH_NAME")
	    let ++mbfl_I
	done
	#mbfl_array_dump _(mbfl_BRANCHES) mbfl_BRANCHES
    }
    mbfl_location_leave
}


#### commits management

function mbfl_vc_git_commit_all () {
    mbfl_vc_git_program commit -a
}
function mbfl_vc_git_commit_staged () {
    mbfl_vc_git_program commit
}


#### program interface

function mbfl_vc_git_program () {
    mbfl_local_varref(GIT_COMMAND)

    mbfl_program_found_var mbfl_datavar(GIT_COMMAND) git || exit $?
    mbfl_program_exec "$GIT_COMMAND" "$@"
}

#!# end of file
# Local Variables:
# mode: sh
# End:
