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
    mbfl_default_class_declare(mbfl_vc_git_config_option)

    mbfl_default_class_define _(mbfl_vc_git_config_option) _(mbfl_default_object) 'mbfl_vc_git_config_option' \
			      database key default_value type terminator

    # Rename the constructor  and mutator functions of the class  "mbfl_vc_git_config_option", so that they
    # can be reimplemented with functions validating the new field value.  The field "default_value"
    # needs no validation.
    #
    # I do not like this, but with the current class implementation that's the way it is.  Maybe, in
    # some future, it will be possible to specify  the identifiers of a field's accessor and mutator
    # at class defintion time.  (Marco Maggi; Mar 29, 2023)
    #
    {
	declare mbfl_FIELD_NAME mbfl_SRC_FUNCNAME mbfl_DST_FUNCNAME

	mbfl_function_rename 'mbfl_vc_git_config_option_define' 'mbfl_p_vc_git_config_option_define'
	for mbfl_FIELD_NAME in database key type terminator
	do
	    printf -v mbfl_SRC_FUNCNAME 'mbfl_vc_git_config_option_%s_set'   "$mbfl_FIELD_NAME"
	    printf -v mbfl_DST_FUNCNAME 'mbfl_p_vc_git_config_option_%s_set' "$mbfl_FIELD_NAME"
	    mbfl_function_rename "$mbfl_SRC_FUNCNAME" "$mbfl_DST_FUNCNAME"
	done
    }

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


#### configuration management: the class "mbfl_vc_git_config_option"

function mbfl_vc_git_config_option_define () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to uninitialised object of type mbfl_vc_git_config_option)
    mbfl_mandatory_parameter(KEY,		2, key string)
    mbfl_optional_parameter(DEFAULT_VALUE,	3)

    if ! mbfl_string_is_git_config_option_key "$KEY"
    then
	mbfl_message_error_printf 'in call to %s expected identifier as key got: "%s"' $FUNCNAME "$KEY"
	return_because_failure
    fi

    #                                            database      key    default_value    type      terminator
    mbfl_p_vc_git_config_option_define _(CFGOPT) 'unspecified' "$KEY" "$DEFAULT_VALUE" 'no-type' 'newline'
}

### ------------------------------------------------------------------------

function mbfl_vc_git_config_option_database_set () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to object of class mbfl_vc_git_config_option)
    mbfl_mandatory_parameter(NEW_VALUE,		2, new field value)

    case "$NEW_VALUE" in
	'local')	: ;;
	'global')	: ;;
	'system')	: ;;
	'worktree')	: ;;
        'unspecified')	: ;;
	*)
	    mbfl_message_error_printf 'invalid value for field "database" in object of class "mbfl_vc_git_config_option": "%s"' \
				      "$NEW_VALUE"
	    exit_because_failure
    esac
    mbfl_p_vc_git_config_option_database_set _(CFGOPT) "$NEW_VALUE"
}
function mbfl_vc_git_config_option_key_set () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to object of class mbfl_vc_git_config_option)
    mbfl_mandatory_parameter(NEW_VALUE,		2, new field value)

    if ! mbfl_string_is_git_config_option_key "$NEW_VALUE"
    then
	mbfl_message_error_printf 'in call to %s expected identifier as key got: "%s"' $FUNCNAME "$NEW_VALUE"
	return_because_failure
    fi

    mbfl_p_vc_git_config_option_key_set _(CFGOPT) "$NEW_VALUE"
}
function mbfl_vc_git_config_option_type_set () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to object of class mbfl_vc_git_config_option)
    mbfl_mandatory_parameter(NEW_VALUE,		2, new field value)

    case "$NEW_VALUE" in
	'bool')		: ;;
	'int')		: ;;
	'bool-or-int')	: ;;
	'path')		: ;;
	'expiry-date')	: ;;
	'color')	: ;;
	'no-type')	: ;;
	*)
	    mbfl_message_error_printf 'invalid value for field "type" of class "mbfl_vc_git_config_option": "%s"' "$NEW_VALUE"
	    exit_because_failure
    esac
    mbfl_p_vc_git_config_option_type_set _(CFGOPT) "$NEW_VALUE"
}
function mbfl_vc_git_config_option_terminator_set () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to object of class mbfl_vc_git_config_option)
    mbfl_mandatory_parameter(NEW_VALUE,		2, new field value)

    case "$NEW_VALUE" in
	'null')		: ;;
	'newline')	: ;;
	*)
	    mbfl_message_error_printf 'invalid value for field "terminator" of class "mbfl_vc_git_config_option": "%s"' "$NEW_VALUE"
	    exit_because_failure
    esac
    mbfl_p_vc_git_config_option_terminator_set _(CFGOPT) "$NEW_VALUE"
}

### ------------------------------------------------------------------------

function mbfl_vc_git_config_option_value_var () {
    mbfl_mandatory_nameref_parameter(VALUE,	1, reference to result variable)
    mbfl_mandatory_nameref_parameter(CFGOPT,	2, reference to object of class mbfl_vc_git_config_option)
    mbfl_declare_varref(KEY)
    mbfl_declare_varref(DEFAULT_VALUE)
    mbfl_declare_varref(FLAGS)

    mbfl_vc_git_config_option_key_var           _(KEY)           _(CFGOPT)
    mbfl_vc_git_config_option_default_value_var _(DEFAULT_VALUE) _(CFGOPT)
    mbfl_vc_git_config_option_flags_var         _(FLAGS)         _(CFGOPT)

    # NOTE The option "--default" and the other options must come BEFORE the option "--get"!!!
    VALUE=$(mbfl_vc_git_program config $FLAGS				\
				--default	"$DEFAULT_VALUE"	\
				--get		"$KEY")
}
function mbfl_vc_git_config_option_value_set () {
    mbfl_mandatory_nameref_parameter(CFGOPT,	1, reference to config value struct)
    mbfl_mandatory_parameter(NEW_VALUE,		2, new value string)
    mbfl_declare_varref(KEY)
    mbfl_declare_varref(FLAGS)

    mbfl_vc_git_config_option_key_var   _(KEY)   _(CFGOPT)
    mbfl_vc_git_config_option_flags_var _(FLAGS) _(CFGOPT)
    mbfl_vc_git_program config $FLAGS --add "$KEY" "$NEW_VALUE"
}

# Whenever we execute "git config --get" or "git config  --add" we need to put on the command line a
# set of  flags to  configure the  operation.  The  function "mbfl_vc_git_config_option_flags_var()"
# inspects the state of CFGOPT and stores in the result variable FLAGS an appropriate list of flags.
#
function mbfl_vc_git_config_option_flags_var () {
    mbfl_mandatory_nameref_parameter(FLAGS,	1, reference to output variable)
    mbfl_mandatory_nameref_parameter(CFGOPT,	2, reference to config value struct)

    if ! mbfl_vc_git_config_option_is_a _(CFGOPT)
    then
	mbfl_message_error_printf 'in call to %s expected object of class mbfl_vc_git_config_option got datavar: "%s"' \
				  $FUNCNAME _(CFGOPT)
	return_because_failure
    fi

    {
	mbfl_declare_varref(DATABASE)

	mbfl_vc_git_config_option_database_var _(DATABASE) _(CFGOPT)
	case "$DATABASE" in
	    'local')		FLAGS+=' --local'	;;
	    'global')		FLAGS+=' --global'	;;
	    'system')		FLAGS+=' --system'	;;
	    'worktree')		FLAGS+=' --worktree'	;;
            'unspecified')				;;
	    *)
		mbfl_message_error_printf 'in call to %s invalid database value: "%s"' $FUNCNAME "$DATABASE"
		return_because_failure
		;;
	esac
    }

    {
	mbfl_declare_varref(TYPE)

	mbfl_vc_git_config_option_type_var _(TYPE) _(CFGOPT)
	case "$TYPE" in
	    'bool')		FLAGS+=' --type=bool'		;;
	    'int')		FLAGS+=' --type=int'		;;
	    'bool-or-int')	FLAGS+=' --type=bool-or-int'	;;
	    'path')		FLAGS+=' --type=path'		;;
	    'expiry-date')	FLAGS+=' --type=expiry-date'	;;
	    'color')		FLAGS+=' --type=color'		;;
	    'no-type')		FLAGS+=' --no-type'		;;
	    *)
		mbfl_message_error_printf 'in call to %s invalid type value: "%s"' $FUNCNAME "$TYPE"
		return_because_failure
		;;
	esac
    }

    {
	mbfl_declare_varref(TERMINATOR)

	mbfl_vc_git_config_option_terminator_var _(TERMINATOR) _(CFGOPT)
	case "$TERMINATOR" in
	    'null')		FLAGS+=' --null'	;;
	    'newline')					;;
	    *)
		mbfl_message_error_printf 'in call to %s invalid terminator value: "%s"' $FUNCNAME "$TERMINATOR"
		return_because_failure
		;;
	esac
    }
}

function mbfl_string_is_git_config_option_key () {
    mbfl_optional_parameter(STRING, 1)
    declare -r REX='^[a-zA-Z_][a-zA-Z0-9_\.\-]+$'

    if mbfl_string_is_empty "$STRING"
    then return_failure
    elif [[ "$STRING" =~ $REX ]]
    then return_success
    else return_failure
    fi
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
    mbfl_declare_varref(GIT_COMMAND)

    mbfl_program_found_var _(GIT_COMMAND) git || exit $?
    mbfl_program_exec "$GIT_COMMAND" "$@"
}

#!# end of file
# Local Variables:
# mode: sh
# End:
