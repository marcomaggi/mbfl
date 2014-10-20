# program.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: program functions
# Date: Thu May  1, 2003
#
# Abstract
#
#
# Copyright (c) 2003-2005, 2009, 2013, 2014 Marco Maggi <marcomaggi@gna.org>
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

#page
#### simple finding of external programs

function mbfl_program_find () {
    mbfl_mandatory_parameter(PROGRAM, 1, program)
    local item
    type -ap "$PROGRAM" | while read item
    do
	if mbfl_file_is_executable "$item"
	then
            printf "%s\n" "$item"
            return 0
	fi
    done
    return 0
}

#page
## ------------------------------------------------------------
## Program execution functions.
## ------------------------------------------------------------

declare mbfl_program_SUDO_USER=nosudo
declare mbfl_program_SUDO_OPTIONS
declare -r mbfl_program_SUDO=__PATHNAME_SUDO__
declare -r mbfl_program_WHOAMI=__PATHNAME_WHOAMI__
declare mbfl_program_STDERR_TO_STDOUT=no
declare mbfl_program_BASH=$BASH
declare mbfl_program_BGPID

function mbfl_program_enable_sudo () {
    local SUDO=__PATHNAME_SUDO__
    if ! test -x "$SUDO"
    then mbfl_message_warning_printf 'executable sudo not found: "%s"\n' "$SUDO"
    fi
    local WHOAMI=__PATHNAME_WHOAMI__
    if ! test -x "$WHOAMI"
    then mbfl_message_warning_printf 'executable whoami not found: "%s"\n' "$WHOAMI"
    fi
}
function mbfl_program_declare_sudo_user () {
    mbfl_mandatory_parameter(PERSONA, 1, sudo user name)
    if mbfl_string_is_username "$PERSONA"
    then mbfl_program_SUDO_USER=$PERSONA
    else
	mbfl_message_error_printf 'attempt to select invalid "sudo" user: "%s"' "$PERSONA"
	exit_because_invalid_username
    fi
}
function mbfl_program_reset_sudo_user () {
    mbfl_program_SUDO_USER=nosudo
}
function mbfl_program_sudo_user () {
    printf '%s\n' "$mbfl_program_SUDO_USER"
}
function mbfl_program_requested_sudo () {
    test "$mbfl_program_SUDO_USER" != nosudo
}
function mbfl_program_declare_sudo_options () {
    mbfl_program_SUDO_OPTIONS="$*"
}
function mbfl_program_reset_sudo_options () {
    mbfl_program_SUDO_OPTIONS=
}

## --------------------------------------------------------------------

function mbfl_program_redirect_stderr_to_stdout () {
    mbfl_program_STDERR_TO_STDOUT=yes
}

### --------------------------------------------------------------------

# The    functions   'mbfl_program_exec',    'mbfl_program_execbg'   and
# 'mbfl_program_replace' have  to be kept  equal, with the  exception of
# the stuff required to execute the program as needed!!!
function mbfl_program_exec () {
    mbfl_p_program_exec /dev/stdin /dev/stdout no-replace no-background "$@"
}
function mbfl_program_execbg () {
    mbfl_mandatory_parameter(INCHAN, 1, input channel)
    mbfl_mandatory_parameter(OUCHAN, 2, output channel)
    shift 2
    mbfl_p_program_exec "$INCHAN" "$OUCHAN" no-replace background "$@"
}
function mbfl_program_replace () {
    mbfl_p_program_exec /dev/stdin /dev/stdout replace no-background "$@"
}
function mbfl_p_program_exec () {
    mbfl_mandatory_parameter(INCHAN,     1, input channel)
    mbfl_mandatory_parameter(OUCHAN,     2, output channel)
    mbfl_mandatory_parameter(REPLACE,    3, replace argument)
    mbfl_mandatory_parameter(BACKGROUND, 4, background argument)
    shift 4
    local PERSONA=$mbfl_program_SUDO_USER
    local USE_SUDO=no
    local SUDO=__PATHNAME_SUDO__
    local WHOAMI=__PATHNAME_WHOAMI__
    local USERNAME
    local SUDO_OPTIONS=$mbfl_program_SUDO_OPTIONS
    local STDERR_TO_STDOUT=$mbfl_program_STDERR_TO_STDOUT

    # Reset request for sudo.
    mbfl_program_SUDO_USER=nosudo
    mbfl_program_SUDO_OPTIONS=

    # Reset stderr to stdout redirection
    mbfl_program_STDERR_TO_STDOUT=no

    # Set the variable USE_SUDO to 'yes' if  we must use sudo to run the
    # program, otherwise leave it set to 'no'.
    if ! test "$PERSONA" = nosudo
    then
        if ! test -x "$SUDO"
	then
	    mbfl_message_error_printf 'executable sudo not found: "%s"\n' "$SUDO"
	    exit_because_program_not_found
	fi
        if ! test -x "$WHOAMI"
	then
	    mbfl_message_error_printf 'executable whoami not found: "%s"\n' "$WHOAMI"
	    exit_because_program_not_found
	fi
	if ! USERNAME=$("$WHOAMI")
	then
	    mbfl_message_error 'unable to determine current user name'
	    exit_because_failure
	fi
	if test "$PERSONA" != "$USERNAME"
	then USE_SUDO=yes
	fi
    fi

    # Print to stderr the comman line that will be executed.
    { mbfl_option_test || mbfl_option_show_program; } && {
        if test "$USE_SUDO" = yes
        then echo "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" >&2
        else echo "$@" >&2
        fi
    }

    # If this run is not dry: actually run the program.
    mbfl_option_test || {
	local EXEC
	if test "$REPLACE" = replace
	then EXEC=exec
	fi
        if test yes = "$USE_SUDO"
        then
	    if test "$BACKGROUND" = background
	    then
		if test "$STDERR_TO_STDOUT" = yes
		then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <$INCHAN 2>&1 >$OUCHAN
		else $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <$INCHAN      >$OUCHAN
		fi
		mbfl_program_BGPID=$!
	    else
		if test "$STDERR_TO_STDOUT" = yes
		then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <$INCHAN 2>&1 >$OUCHAN &
		else $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <$INCHAN      >$OUCHAN &
		fi
	    fi
        else
	    if test "$BACKGROUND" = background
	    then
		if test "$STDERR_TO_STDOUT" = yes
		then $EXEC "$@" <$INCHAN 2>&1 >$OUCHAN &
		else $EXEC "$@" <$INCHAN      >$OUCHAN &
		fi
		mbfl_program_BGPID=$!
	    else
		if test "$STDERR_TO_STDOUT" = yes
		then $EXEC "$@" <$INCHAN 2>&1 >$OUCHAN
		else $EXEC "$@" <$INCHAN      >$OUCHAN
		fi
	    fi
        fi
    }
}

## --------------------------------------------------------------------

function mbfl_program_bash_command () {
    mbfl_mandatory_parameter(COMMAND, 1, command)
    mbfl_program_exec "$mbfl_program_BASH" -c "$COMMAND"
}
function mbfl_program_bash () {
    mbfl_program_exec "$mbfl_program_BASH" "$@"
}

#page
## ------------------------------------------------------------
## Program finding functions.
## ------------------------------------------------------------

test "$mbfl_INTERACTIVE" = yes || \
    declare -a mbfl_program_NAMES mbfl_program_PATHS

function mbfl_declare_program () {
    mbfl_mandatory_parameter(PROGRAM, 1, program)
    local PATHNAME
    local next_free_index=${#mbfl_program_NAMES[@]}

    mbfl_program_NAMES[${next_free_index}]="$PROGRAM"
    PATHNAME=$(mbfl_program_find "$PROGRAM")
    test -n "$PATHNAME" && \
        PROGRAM=$(mbfl_file_normalise "$PATHNAME")
    mbfl_program_PATHS[${next_free_index}]="$PATHNAME"
    return 0
}
function mbfl_program_validate_declared () {
    local -i i retval=0 number_of_programs=${#mbfl_program_NAMES[@]}
    local name path
    for ((i=0; $i < $number_of_programs; ++i))
    do
        name="${mbfl_program_NAMES[$i]}"
        path="${mbfl_program_PATHS[$i]}"
        if test -n "$path" -a -x "$path"
        then mbfl_message_verbose "found '$name': '$path'\n"
        else
            mbfl_message_verbose "*** not found '$name', path: '$path'\n"
            retval=1
        fi
    done
    return $retval
}
function mbfl_program_found () {
    mbfl_mandatory_parameter(PROGRAM, 1, program name)
    local number_of_programs=${#mbfl_program_NAMES[@]} i=
    if test "$PROGRAM" != :
    then
        for ((i=0; $i < ${number_of_programs}; ++i))
        do
            if test "${mbfl_program_NAMES[$i]}" = "$PROGRAM"
	    then
		local PATHNAME="${mbfl_program_PATHS[$i]}"
		if test -n "$PATHNAME" -a -x "$PATHNAME"
		then
		    echo "$PATHNAME"
                    return 0
		else
		    mbfl_message_error_printf "executable not found '$PROGRAM'"
		    exit_because_program_not_found
		fi
            fi
        done
    fi
    mbfl_message_error "executable not found '$PROGRAM'"
    exit_because_program_not_found
}

#page
## ------------------------------------------------------------
## Program validation functions.
## ------------------------------------------------------------

function mbfl_program_main_validate_programs () {
    mbfl_program_validate_declared || exit_because_program_not_found
}


### end of file
# Local Variables:
# mode: sh
# End:
