# program.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: program functions
# Date: Thu May  1, 2003
#
# Abstract
#
#
# Copyright (c) 2003-2005, 2009, 2013-2014, 2017-2018, 2020 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
# your option) any later version.
#
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
#
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA.
#


#### simple finding of external programs

mbfl_declare_numeric_array(mbfl_split_PATH)

function mbfl_program_split_path () {
    if ((0 == mbfl_slots_number(mbfl_split_PATH)))
    then
	mbfl_local_numeric_array(SPLITFIELD)
	local -i SPLITCOUNT i

	mbfl_string_split "$PATH" :
	for ((i=0; i < SPLITCOUNT; ++i))
	do mbfl_split_PATH[$i]=mbfl_slot_ref(SPLITFIELD, $i)
	done
	return_success
    else return_failure
    fi
}

function mbfl_program_find_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PROGRAM,               2, program)

    # NOTE We do *not* want  to test for the executability of the program  here!  This is because we
    # also  want to  find  a  program that  is  executable  only by  some  other  user, for  example
    # "/sbin/ifconfig" is executable only by root (or it should be).

    if mbfl_file_is_absolute "$mbfl_PROGRAM"
    then
	if mbfl_file_is_file "$mbfl_PROGRAM"
	then
	    mbfl_RESULT_VARREF="$mbfl_PROGRAM"
	    return_success
	else return_because_program_not_found
	fi
    elif {
	mbfl_local_varref(DUMMY)
	mbfl_string_first_var mbfl_datavar(DUMMY) "$mbfl_PROGRAM" '/'
    }
    then
	# The $mbfl_PROGRAM is not an absolute pathname, but it is a relative pathname with at least
	# one slash in it.
	if mbfl_file_is_file "$mbfl_PROGRAM"
	then
	    mbfl_RESULT_VARREF="$mbfl_PROGRAM"
	    return_success
	else return_because_program_not_found
	fi
    else
	mbfl_program_split_path
	local mbfl_PATHNAME
	local -i mbfl_I mbfl_NUMBER_OF_COMPONENTS=mbfl_slots_number(mbfl_split_PATH)

	for ((mbfl_I=0; mbfl_I < mbfl_NUMBER_OF_COMPONENTS; ++mbfl_I))
	do
	    printf -v mbfl_PATHNAME '%s/%s' "mbfl_slot_ref(mbfl_split_PATH, $mbfl_I)" "$mbfl_PROGRAM"
	    if mbfl_file_is_file "$mbfl_PATHNAME"
	    then
		mbfl_RESULT_VARREF="$mbfl_PATHNAME"
		break
	    fi
	done
	if mbfl_string_is_not_empty "$mbfl_RESULT_VARREF"
	then return_success
	else return_because_program_not_found
	fi
    fi
}

function mbfl_program_find () {
    mbfl_mandatory_parameter(PROGRAM, 1, program)
    mbfl_local_varref(RESULT_VARNAME)
    if mbfl_program_find_var mbfl_datavar(RESULT_VARNAME) "$PROGRAM"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}


#### program finding functions

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then mbfl_declare_symbolic_array(mbfl_program_PATHNAMES)
fi

function mbfl_declare_program () {
    mbfl_mandatory_parameter(PROGRAM, 1, program)
    local PROGRAM_PATHNAME

    mbfl_program_find_var PROGRAM_PATHNAME "$PROGRAM"
    if mbfl_string_is_not_empty "$PROGRAM_PATHNAME"
    then mbfl_file_normalise_var PROGRAM_PATHNAME "$PROGRAM_PATHNAME"
    fi
    mbfl_program_PATHNAMES["$PROGRAM"]=$PROGRAM_PATHNAME
    return_success
}
function mbfl_program_validate_declared () {
    local -i RV=0
    local PROGRAM PROGRAM_PATHNAME

    for PROGRAM in "${!mbfl_program_PATHNAMES[@]}"
    do
	PROGRAM_PATHNAME=mbfl_slot_ref(mbfl_program_PATHNAMES, "$PROGRAM")
	# NOTE We do *not* want to test for  the executability of the program here!  This is because
	# we also  want to find a  program that is executable  only by some other  user, for example
	# "/sbin/ifconfig" is executable only by root (or it should be).
        if mbfl_file_is_file "$PROGRAM_PATHNAME"
        then mbfl_message_verbose_printf 'found "%s": "%s"\n' "$PROGRAM" "$PROGRAM_PATHNAME"
        else
            mbfl_message_verbose_printf '*** not found "%s", path: "%s"\n' "$PROGRAM" "$PROGRAM_PATHNAME"
            RV=1
        fi
    done
    return $RV
}
function mbfl_program_found_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PROGRAM,               2, program name)
    local -r mbfl_PROGRAM_PATHNAME=mbfl_slot_ref(mbfl_program_PATHNAMES, "$mbfl_PROGRAM")

    # NOTE We do *not* want  to test for the executability of the program  here!  This is because we
    # also  want to  find  a  program that  is  executable  only by  some  other  user, for  example
    # "/sbin/ifconfig" is executable only by root (or it should be).
    if mbfl_file_is_file "$mbfl_PROGRAM_PATHNAME"
    then
	mbfl_RESULT_VARREF=$mbfl_PROGRAM_PATHNAME
        return_success
    else
	mbfl_message_error_printf 'unable to find pathname for program file: "%s"' "$mbfl_PROGRAM"
	return_because_program_not_found
    fi
}
function mbfl_program_found () {
    mbfl_mandatory_parameter(PROGRAM, 1, program name)
    local RESULT_VARNAME EXIT_STATUS
    mbfl_program_found_var RESULT_VARNAME "$PROGRAM"
    EXIT_STATUS=$?
    if ((0 == EXIT_STATUS))
    then
	echo "$RESULT_VARNAME"
	return_success
    else return $EXIT_STATUS
    fi
}


#### program validation functions

function mbfl_program_main_validate_programs () {
    mbfl_program_validate_declared || exit_because_program_not_found
}


#### additional flags for the Bash built-in "exec"

declare mbfl_program_EXEC_FLAGS

function mbfl_program_set_exec_flags () {
    mbfl_program_EXEC_FLAGS="$*"
}
function mbfl_program_reset_exec_flags () {
    mbfl_program_EXEC_FLAGS=
}


#### redirection of stderr to stdout

declare mbfl_program_STDERR_TO_STDOUT=false

# NOTE This  function is  deprecated, but  still here  for backwards  compatibility.  We  should use
# "mbfl_program_set_stderr_to_stdout()".  (Marco Maggi; Nov 8, 2020)
#
function mbfl_program_redirect_stderr_to_stdout () {
    mbfl_program_STDERR_TO_STDOUT=true
}

function mbfl_program_set_stderr_to_stdout () {
    mbfl_program_STDERR_TO_STDOUT=true
}
function mbfl_program_reset_stderr_to_stdout () {
    mbfl_program_STDERR_TO_STDOUT=false
}


#### "sudo" requests

# This variable holds the  name of the user "sudo" should switch to.   When the value is ":nosudo:":
# "sudo" is not used.  Notice that ":nosudo:" is not a valid user name.
#
declare mbfl_program_SUDO_USER=':nosudo:'

# This variable holds additional flags to place on the commnd line of the next "sudo" invocation.
#
declare mbfl_program_SUDO_OPTIONS

# Cache the value resulting from running "whoami".
#
declare mbfl_program_EFFECTIVE_USER

# This is an undocumented variable; it is used only for testing.  Setting its value to 'true' causes
# "mbfl_p_program_exec()" to use sudo even when  the "$mbfl_program_SUDO_USER" is equal to the value
# printed by "whoami".
#
declare mbfl_program_FORCE_USE_SUDO=false

function mbfl_program_enable_sudo () {
    if ! mbfl_file_is_executable "$mbfl_PROGRAM_SUDO"
    then mbfl_message_warning_printf 'executable sudo not found: "%s"\n' "$mbfl_PROGRAM_SUDO"
    fi
    if ! mbfl_file_is_executable "$mbfl_PROGRAM_WHOAMI"
    then mbfl_message_warning_printf 'executable whoami not found: "%s"\n' "$mbfl_PROGRAM_WHOAMI"
    fi
}
function mbfl_program_declare_sudo_user () {
    mbfl_mandatory_parameter(PERSONA, 1, sudo user name)
    local EFFECTIVE_USER_NAME

    if ! mbfl_string_is_username "$PERSONA"
    then
	mbfl_message_error_printf 'attempt to select invalid "sudo" user: "%s"' "$PERSONA"
	exit_because_invalid_sudo_username
    fi

    if ! mbfl_file_is_executable "$mbfl_PROGRAM_SUDO"
    then
	mbfl_message_error_printf 'executable sudo not found: "%s"' "$mbfl_PROGRAM_SUDO"
	exit_because_program_not_found
    fi
    if ! mbfl_file_is_executable "$mbfl_PROGRAM_WHOAMI"
    then
	mbfl_message_error_printf 'executable whoami not found: "%s"' "$mbfl_PROGRAM_WHOAMI"
	exit_because_program_not_found
    fi
    if mbfl_string_is_empty "$mbfl_program_EFFECTIVE_USER"
    then
	# NOTE   Do    not   use    "mbfl_system_whoami()"   here,    because   that    function   calls
	# "mbfl_program_exec()".  Instead just execute the program directly!!!
	if mbfl_program_EFFECTIVE_USER=$("$mbfl_PROGRAM_WHOAMI")
	then EFFECTIVE_USER_NAME=$mbfl_program_EFFECTIVE_USER
	else
	    mbfl_message_error 'unable to determine current effective user name'
	    exit_because_failure
	fi
    else EFFECTIVE_USER_NAME=$mbfl_program_EFFECTIVE_USER
    fi
    if mbfl_string_not_equal "$PERSONA" "$EFFECTIVE_USER_NAME" || mbfl_string_is_true "$mbfl_program_FORCE_USE_SUDO"
    then
	mbfl_program_SUDO_USER=$PERSONA
	mbfl_program_FORCE_USE_SUDO=false
	mbfl_message_debug_printf '%s: the next program execution will use "sudo" with user: "%s"' "$FUNCNAME" "$mbfl_program_SUDO_USER"
	return_success
    else
	mbfl_message_debug_printf '%s: skipped "sudo" request for user: "%s"' "$FUNCNAME" "$PERSONA"
	mbfl_program_reset_sudo_user
	mbfl_program_FORCE_USE_SUDO=false
	return_because_failure
    fi
}
function mbfl_program_reset_sudo_user () {
    mbfl_message_debug_printf '%s: reset sudo user request' "$FUNCNAME"
    mbfl_program_SUDO_USER=':nosudo:'
}
function mbfl_program_sudo_user () {
    printf '%s\n' "$mbfl_program_SUDO_USER"
}
function mbfl_program_requested_sudo () {
    test "$mbfl_program_SUDO_USER" != ':nosudo:'
}
function mbfl_program_declare_sudo_options () {
    mbfl_program_SUDO_OPTIONS="$*"
}
function mbfl_program_set_sudo_options () {
    mbfl_program_SUDO_OPTIONS="$*"
}
function mbfl_program_reset_sudo_options () {
    mbfl_program_SUDO_OPTIONS=
}


#### public API for program execution

# When we use one of the "mbfl_program_execbg()" functions:  the PID of the process in background is
# stored in this variable.
#
declare mbfl_program_BGPID

# The  functions 'mbfl_program_exec',  'mbfl_program_execbg' and  'mbfl_program_replace' have  to be
# kept equal, with the exception of the stuff required to execute the program as needed!!!
#
function mbfl_program_exec () {
    # We use  0 and 1 because  /dev/stdin, /dev/stdout, /dev/fd/0,  /dev/fd/1 do not exist  when the
    # script is run from a cron job.
    local -ir INCHAN=0 OUCHAN=1 ERCHAN=2
    local -r REPLACE=false BACKGROUND=false
    mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_exec2 () {
    mbfl_mandatory_parameter(INCHAN, 1, numeric input channel)
    mbfl_mandatory_parameter(OUCHAN, 2, numeric output channel)
    mbfl_mandatory_parameter(ERCHAN, 3, numeric error channel)
    shift 3
    local -r REPLACE=false BACKGROUND=false
    mbfl_program_reset_stderr_to_stdout
    mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_execbg () {
    mbfl_mandatory_parameter(INCHAN, 1, numeric input channel)
    mbfl_mandatory_parameter(OUCHAN, 2, numeric output channel)
    local -ir ERCHAN=2
    shift 2
    local -r REPLACE=false BACKGROUND=true
    mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_execbg2 () {
    mbfl_mandatory_parameter(INCHAN, 1, numeric input channel)
    mbfl_mandatory_parameter(OUCHAN, 2, numeric output channel)
    mbfl_mandatory_parameter(ERCHAN, 3, numeric error channel)
    shift 3
    local -r REPLACE=false BACKGROUND=true
    mbfl_program_reset_stderr_to_stdout
    mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_replace () {
    # We  use  0  and  1  because  /dev/stdin,  /dev/stdout,  /dev/fd/0,
    # /dev/fd/1 do not exist when the script is run from a cron job.
    local -ir INCHAN=0 OUCHAN=1 ERCHAN=2
    local -r REPLACE=true BACKGROUND=false
    mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_replace2 () {
    mbfl_mandatory_parameter(INCHAN, 1, numeric input channel)
    mbfl_mandatory_parameter(OUCHAN, 2, numeric output channel)
    mbfl_mandatory_parameter(ERCHAN, 3, numeric error channel)
    shift 3
    local -r REPLACE=true BACKGROUND=false
    mbfl_program_reset_stderr_to_stdout
    mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}


#### program execution mechanism functions

function mbfl_p_program_exec () {
    mbfl_mandatory_parameter(INCHAN,    1, input channel)
    mbfl_mandatory_parameter(OUCHAN,    2, output channel)
    mbfl_mandatory_parameter(ERCHAN,    3, error channel)
    mbfl_mandatory_parameter(REPLACE,	4, replace argument)
    mbfl_mandatory_parameter(BACKGROUND,5, background argument)
    shift 5

    # Set the variable USE_SUDO to 'true' if we must use sudo to run the program, otherwise leave it
    # set to 'false'.
    local USE_SUDO=false
    if mbfl_program_requested_sudo
    then USE_SUDO=true
    fi

    # if true
    # then
    # 	if mbfl_string_is_true "$USE_SUDO"
    # 	then mbfl_message_debug_printf '%s: the next program execution will use sudo (PERSONA=%s)'     "$FUNCNAME" "$mbfl_program_SUDO_USER"
    # 	else mbfl_message_debug_printf '%s: the next program execution will not use sudo (PERSONA=%s)' "$FUNCNAME" "$mbfl_program_SUDO_USER"
    # 	fi
    # fi

    # Acquire the values then reset the request for sudo.
    local -r SUDO="$mbfl_PROGRAM_SUDO"
    local -r PERSONA=$mbfl_program_SUDO_USER
    local -r SUDO_OPTIONS=$mbfl_program_SUDO_OPTIONS
    mbfl_program_reset_sudo_user
    mbfl_program_reset_sudo_options

    # Acquire the value the reset the request for stderr-to-stdout redirection.
    local -r STDERR_TO_STDOUT=$mbfl_program_STDERR_TO_STDOUT
    mbfl_program_reset_stderr_to_stdout

    # Print to stderr the command line that will be executed.
    if { mbfl_option_test || mbfl_option_show_program; }
    then mbfl_p_program_log_1 "$@"
    fi

    # If this run is not dry: actually run the program.
    #
    # NOTE This is a hellish nested tree of "if" statements, I know!  I really, really, really tried
    # to  write it  in different  ways; and  I failed.   With the  other solutions  (for example:  a
    # sequence of nested function calls) there is always some problem with one or more among:
    #
    # * Correctly detecting program execution errors.
    #
    # * Correctly detecting input/output channel opening errors.
    #
    # * Correctly registering the PID of the process run in background.
    #
    # So I wrote  it this way.  Fortunately I do  not have to look at this  code very often.  (Marco
    # Maggi; Nov 24, 2018)
    #
    if ! mbfl_option_test
    then
	# NOTE We might be tempted to use "command" as value of "EXEC" when we are not replacing the
	# current process.  We must  avoid it, because "command" causes an  additional process to be
	# spawned and this botches the value of "mbfl_program_BGPID" we want to collect when running
	# the process in background.
	if $REPLACE
	then
	    local EXEC=exec
	    local EXEC_FLAGS=$mbfl_program_EXEC_FLAGS
	    mbfl_program_reset_exec_flags
	else
	    local EXEC=
	    local EXEC_FLAGS=
	    mbfl_program_reset_exec_flags
	fi

	if $STDERR_TO_STDOUT
	then
	    # Stderr-to-stdout.
	    if mbfl_string_is_digit "$OUCHAN"
	    then
		# Stderr-to-stdout, digit ouchan.
		if mbfl_string_is_digit "$INCHAN"
		then
		    # Stderr-to-stdout, digit ouchan, digit inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stdout, digit ouchan, digit inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stdout, digit ouchan, digit inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
			fi
		    fi
		else
		    # Stderr-to-stdout, digit ouchan, string inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stdout, digit ouchan, string inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stdout, digit ouchan, string inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
			fi
		    fi
		fi
	    else
		# Stderr-to-stdout, string ouchan.
		if mbfl_string_is_digit "$INCHAN"
		then
		    # Stderr-to-stdout, string ouchan, digit inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stdout, string ouchan, digit inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stdout, string ouchan, digit inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
			fi
		    fi
		else
		    # Stderr-to-stdout, string ouchan, string inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stdout, string ouchan, string inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stdout, string ouchan, string inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
			fi
		    fi
		fi
	    fi
	else
	    # Stderr-to-stderr.
	    if mbfl_string_is_digit "$OUCHAN"
	    then
		# Stderr-to-stderr, digit ouchan.
		if mbfl_string_is_digit "$INCHAN"
		then
		    # Stderr-to-stderr, digit ouchan, digit inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stderr, digit ouchan, digit inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stderr, digit ouchan, digit inchan, foreground.
			#echo INCHAN=$INCHAN OUCHAN=$OUCHAN ERCHAN=$ERCHAN >&2
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
			fi
		    fi
		else
		    # Stderr-to-stderr, digit ouchan, string inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stderr, digit ouchan, string inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stderr, digit ouchan, string inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
			fi
		    fi
		fi
	    else
		# Stderr-to-stderr, string ouchan.
		if mbfl_string_is_digit "$INCHAN"
		then
		    # Stderr-to-stderr, string ouchan, digit inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stderr, string ouchan, digit inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stderr, string ouchan, digit inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
			fi
		    fi
		else
		    # Stderr-to-stderr, string ouchan, string inchan.
		    if $BACKGROUND
		    then
			# Stderr-to-stderr, string ouchan, string inchan, background.
			local -i EXIT_CODE
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
			fi
			EXIT_CODE=$?
			mbfl_program_BGPID=$!
			mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
			return $EXIT_CODE
		    else
			# Stderr-to-stderr, string ouchan, string inchan, foreground.
			if $USE_SUDO
			then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
			else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
			fi
		    fi
		fi
	    fi
	fi
    fi
}

### --------------------------------------------------------------------

function mbfl_p_program_log_1 () {
    {
	mbfl_p_program_log_2 "$@"
	if $BACKGROUND
	then echo ' &'
	else echo
	fi
    } >&2
}
function mbfl_p_program_log_2 () {
    mbfl_p_program_log_3 "$@"
    if $STDERR_TO_STDOUT
    then echo -n " 2>&$OUCHAN"
    else echo -n " 2>&$ERCHAN"
    fi
}
function mbfl_p_program_log_3 () {
    mbfl_p_program_log_4 "$@"
    if mbfl_string_is_digit "$OUCHAN"
    then echo -n " >&$OUCHAN"
    else echo -n " >'$OUCHAN'"
    fi
}
function mbfl_p_program_log_4 () {
    mbfl_p_program_log_5 "$@"
    if mbfl_string_is_digit "$INCHAN"
    then echo -n " <&$INCHAN"
    else echo -n " <'$INCHAN'"
    fi
}
function mbfl_p_program_log_5 () {
    local EXEC EXEC_FLAGS PROG=$1
    shift 1

    if $REPLACE
    then
	EXEC=exec
	EXEC_FLAGS=$mbfl_program_EXEC_FLAGS
    else EXEC=command
    fi

    if $USE_SUDO
    then echo -n $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$PROG"
    else echo -n $EXEC $EXEC_FLAGS "$PROG"
    fi

    {
	mbfl_local_varref(QUOTED_ARG)
	local arg
	for arg in "$@"
	do
	    mbfl_string_quote_var mbfl_datavar(QUOTED_ARG) "$arg"
	    printf " '%s'" "$QUOTED_ARG"
	done
    }
}


#### executing bash commands

function mbfl_program_bash () {
    mbfl_program_exec "$mbfl_PROGRAM_BASH" "$@"
}
function mbfl_program_bash_command () {
    mbfl_mandatory_parameter(COMMAND, 1, command)
    shift
    mbfl_program_bash "$@" -c "$COMMAND"
}

### end of file
# Local Variables:
# mode: sh
# End:
