# program.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: program functions
# Date: Thu May  1, 2003
#
# Abstract
#
#
# Copyright (c) 2003-2005, 2009 Marco Maggi <marcomaggi@gna.org>
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
## ------------------------------------------------------------
## Obsolete program finding functions.
## ------------------------------------------------------------

function mbfl_program_check () {
    local item= path=
    for item in "$@"
    do
        path=$(mbfl_program_find "$item")
        mbfl_file_is_executable "$path" || {
            mbfl_message_error "cannot find executable '$item'"
            return 1
        }
    done
    return 0
}
function mbfl_program_find () {
    mandatory_parameter(PROGRAM, 1, program)
    local item
    for item in $(type -ap "$PROGRAM")
    do mbfl_file_is_executable "$item" && {
            printf "%s\n" "$item"
            return 0
        }
    done
    return 0
}

#page
## ------------------------------------------------------------
## Program execution functions.
## ------------------------------------------------------------

declare mbfl_program_SUDO_USER=nosudo
declare mbfl_program_STDERR_TO_STDOUT=no
declare mbfl_program_BASH=$BASH
declare mbfl_program_BGPID

function mbfl_program_enable_sudo () {
    mbfl_declare_program sudo
    mbfl_declare_program whoami
}
function mbfl_program_declare_sudo_user () {
    mandatory_parameter(PERSONA, 1, sudo user name)
    mbfl_program_SUDO_USER=${PERSONA}
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
function mbfl_program_redirect_stderr_to_stdout () {
    mbfl_program_STDERR_TO_STDOUT=yes
}
# This function and the following 'mbfl_program_execbg' have
# to be kept equal, with the exception of the stuff required
# to execute the program in background!!!
function mbfl_program_exec () {
    local PERSONA=$mbfl_program_SUDO_USER USE_SUDO=no SUDO WHOAMI
    local STDERR_TO_STDOUT=no
    mbfl_program_SUDO_USER=nosudo
    test "$PERSONA" = nosudo || {
        SUDO=$(mbfl_program_found sudo)     || exit $?
        WHOAMI=$(mbfl_program_found whoami) || exit $?
        USE_SUDO=yes
    }
    STDERR_TO_STDOUT=${mbfl_program_STDERR_TO_STDOUT}
    mbfl_program_STDERR_TO_STDOUT=no
    { mbfl_option_test || mbfl_option_show_program; } && {
        if test "$USE_SUDO" = yes -a "$PERSONA" != "$USER"
        then echo "$SUDO" -u "$PERSONA" "$@" >&2
        else echo "$@" >&2
        fi
    }
    mbfl_option_test || {
        if test "$USE_SUDO" = yes
        then
            # Putting  this test  inside  here avoids  using
            # "whoami" when "sudo" is not required.
            test "$PERSONA" = $("$WHOAMI") || {
                if test "$STDERR_TO_STDOUT" = yes
                then "$SUDO" -u "$PERSONA" "$@" 2>&1
                else "$SUDO" -u "$PERSONA" "$@"
                fi
            }
        else
            if test "$STDERR_TO_STDOUT" = yes
            then "$@" 2>&1
            else "$@"
            fi
        fi
    }
}
function mbfl_program_execbg () {
    mandatory_parameter(INCHAN, 1, input channel)
    mandatory_parameter(OUCHAN, 2, output channel)
    shift 2
    local PERSONA=$mbfl_program_SUDO_USER USE_SUDO=no SUDO WHOAMI
    local STDERR_TO_STDOUT=no
    mbfl_program_SUDO_USER=nosudo
    test "$PERSONA" = nosudo || {
        SUDO=$(mbfl_program_found sudo)     || exit $?
        WHOAMI=$(mbfl_program_found whoami) || exit $?
        USE_SUDO=yes
    }
    STDERR_TO_STDOUT=${mbfl_program_STDERR_TO_STDOUT}
    mbfl_program_STDERR_TO_STDOUT='no'
    { mbfl_option_test || mbfl_option_show_program; } && {
        if test "$USE_SUDO" = yes -a "$PERSONA" != "$USER"
        then echo "$SUDO" -u "$PERSONA" "$@" >&2
        else echo "$@" >&2
        fi
    }
    mbfl_option_test || {
        if test "$USE_SUDO" = yes
        then
            # Putting  this test  inside  here avoids  using
            # "whoami" when "sudo" is not required.
            test "$PERSONA" = $("$WHOAMI") || {
                if test "$STDERR_TO_STDOUT" = yes
                then "$SUDO" -u "$PERSONA" "$@" <$INCHAN 2>&1 >$OUCHAN &
                else "$SUDO" -u "$PERSONA" "$@" <$INCHAN >$OUCHAN &
                fi
                mbfl_program_BGPID=$!
            }
        else
            if test "$STDERR_TO_STDOUT" = yes
            then "$@" <$INCHAN 2>&1 >$OUCHAN &
            else "$@" <$INCHAN >$OUCHAN &
            fi
            mbfl_program_BGPID=$!
        fi
    }
}
function mbfl_program_bash_command () {
    mandatory_parameter(COMMAND, 1, command)
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
    mandatory_parameter(PROGRAM, 1, program)
    local pathname
    local next_free_index=${#mbfl_program_NAMES[@]}

    mbfl_program_NAMES[${next_free_index}]="$PROGRAM"
    PROGRAM=$(mbfl_program_find "$PROGRAM")
    test -n "$PROGRAM" && \
        PROGRAM=$(mbfl_file_normalise "$PROGRAM")
    mbfl_program_PATHS[${next_free_index}]="$PROGRAM"
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
    mandatory_parameter(PROGRAM, 1, program name)
    local number_of_programs=${#mbfl_program_NAMES[@]} i=
    test "$PROGRAM" = : || {
        for ((i=0; $i < ${number_of_programs}; ++i))
        do
            test "${mbfl_program_NAMES[$i]}" = "$PROGRAM" && {
                echo "${mbfl_program_PATHS[$i]}"
                return 0
            }
        done
    }
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
