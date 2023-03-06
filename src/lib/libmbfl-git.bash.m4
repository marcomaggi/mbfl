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


#### library initialisation

function mbfl_vc_git_enable () {
    mbfl_declare_program git
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


#### branches management

function mbfl_vc_git_branch_current_name () {
    mbfl_vc_git_program rev-parse --abbrev-ref HEAD
}
function mbfl_vc_git_branch_current_name_var () {
    mbfl_mandatory_nameref_parameter(BRANCH_NAME, 1, reference to branch name output variable)
    BRANCH_NAME=$(mbfl_vc_git_branch_current_name)
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
