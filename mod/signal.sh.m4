# libsignal.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: functions to deal with signals
# Date: Mon Jul  7, 2003
# 
# Abstract
# 
# 
# 
# Copyright (c) 2003 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
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
# USA
# 
# $Id: signal.sh.m4,v 1.1.1.7 2003/12/21 07:45:55 marco Exp $
#

m4_include(macros.m4)

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

# MBFL_SIGNAL_MAP --
#
# Array that maps signal identifiers to signal names, in a one-to-one
# relation.
#
#   The keys are signal identifiers, used also in "MBFL_SIGNAL_REGISTRY",
# the values are signal name strings (the ones returned by "trap -l").
# The keys are NOT related to the integer representing the signals
# (example: SIGKILL = 9), they are generated in sequence.
#
#   The purpose of this array is to find the integer number associated
# to a signal name.
#

declare -a MBFL_SIGNAL_MAP


# MBFL_SIGNAL_HANDLERS --
#
# Array that maps handler identifiers to handler scripts, in a one-to-one
# relation. The keys are handler identifiers, the values are the handler
# scripts.
#

declare -a MBFL_SIGNAL_HANDLERS


# MBFL_SIGNAL_REGISTRY --
#
# Array that maps signal identifiers to handler identifiers, in a
# one-to-many relation.
#
#   The indexes are signal identifiers, used also in "MBFL_SIGNAL_MAP",
# the values are lists of handler identifiers to be used as indexes
# in "MBFL_SIGNAL_HANDLERS".
#

declare -a MBFL_SIGNAL_REGISTRY


#PAGE
# mbfl_signal_map_signame_to_signum --
#
#       Maps a signal name to the corresponding signal number.
#
#  Arguments:
#
#       $1 -            the signal name (one of the strings
#                       returned by "trap -l")
#
#  Results:
#
#       Search the values in the "MBFL_SIGNAL_MAP" array for a
#       signal name equal to the selected one, prints to stdout
#       its key integer.
#
#         If the name is not found, add a new element to the
#       array associating the name to the next index value:
#       the maximum index incremented by one.
#
#         Returns with code zero.
#
#  Side effects:
#
#       None.
#

function mbfl_signal_map_signame_to_signum () {
    local SIGSPEC="${1:?}"
    declare -i signum=0


    while test -n "${MBFL_SIGNAL_MAP[${signum}]}"
    do
        if test "${MBFL_SIGNAL_MAP[${signum}]}" = "${SIGSPEC}"
        then break
        fi
        signum=${signum}+1
    done

    MBFL_SIGNAL_MAP[$signum]="${SIGSPEC}"
    echo ${signum}
    return 0
}

#PAGE
# mbfl_signal_register_handler --
#
#       Append a new handler to the "MBFL_SIGNAL_HANDLERS" array.
#
#  Arguments:
#
#       $1 -            the handler's script
#
#  Results:
#
#       Prints to stdout the handler identifier.
#       Returns with code zero.
#
#  Side effects:
#
#       None.
#

function mbfl_signal_register_handler () {
    local HANDLER="${1:?}"
    declare -i hannum


    hannum=$((${#MBFL_SIGNAL_HANDLERS[*]} + 1))
    MBFL_SIGNAL_HANDLERS[${hannum}]="${HANDLER}"
    return 0
}

#PAGE
# mbfl_signal_attach --
#
#       Registers a script to be evaluated whenever a signal is
#       received.
#
#  Arguments:
#
#       $1 -            the signal specification (one of the
#                       strings returned by "trap -l")
#       $2 -            the handler's script
#
#  Results:
#
#       Prints to the standard output the identifier of the
#       registered handler; this id may used to detach the handler
#       from the signal with "mbfl_signal_detach()".
#
#         Returns with code zero.
#
#  Side effects:
#
#       If detaching is wanted: after the invocation to this function,
#       "mbfl_signal_identifier()" should called and the value printed
#       to its standard output should be recorded: it's used to detach
#       the handler from the signal.
#

function mbfl_signal_attach () {
    local SIGSPEC="${1:?}"
    local HANDLER="${2:?}"
    declare -i signum=0 hannum=0


#     signum=$(mbfl_signal_map_signame_to_signum "${SIGSPEC}")
#     hannum=$(mbfl_signal_register_handler      "${HANDLER}")

    # Append  the handler  number  to the  list  of registered  handlers
    # associated to the signal number.

    MBFL_SIGNAL_REGISTRY[$signum]="${MBFL_SIGNAL_REGISTRY[$signum]} $hannum"

    trap "mbfl_signal_handler ${signum}" ${SIGSPEC}
    echo $hannum
    return 0
}

#PAGE
# mbfl_signal_detach --
#
#       Detaches a previously registered signal handler.
#
#  Arguments:
#
#       $1 -            the handler identifier that should have
#                       been recorded after the call to
#                       "mbfl_signal_attach()"
#
#  Results:
#
#       Returns with code zero if the handler is detached,
#       returns with code one if the handler is not found.
#
#  Side effects:
#
#       This operation is not perfect: for simplicity, the handler
#       is removed from the "MBFL_SIGNAL_HANDLER" array, but not
#       from the "MBFL_SIGNAL_REGISTRY" array. "mbfl_signal_handler()"
#       is coded in such a way that this causes no problems when
#       invoking the handler.
#
#         This causes resource leakage if one attaches and detaches
#       a lot of handlers.
#

function mbfl_signal_detach () {
    local hannum="${1:?}"


    if test -n "${MBFL_SIGNAL_HANDLERS[${hannum}]}"
    then
        MBFL_SIGNAL_HANDLERS[${hannum}]=
        return 0
    else
        mbfl_message_error "signal handler not found when detaching"
        return 1
    fi
}

#PAGE
# mbfl_signal_handler --
#
#       Callback invoked whenever a signal with handlers attached
#       is received by this shell.
#
#  Arguments:
#
#       $1 -            the signal identifier
#
#  Results:
#
#       Returns the empty string.
#
#  Side effects:
#
#       None.
#

function mbfl_signal_handler () {
    local signum="${1:?}"
    local HANDLER=
    declare -i signum=0 hannum=


    for hannum in ${MBFL_SIGNAL_REGISTRY[$signum]}
    do
        HANDLER="${MBFL_SIGNAL_HANDLERS[$hannum]}"
        if test -n "${HANDLER}"
        then eval ${HANDLER}
        fi
    done
    return 0
}

#PAGE
# mbfl_signal_inspect --
#
#       Inspects the table of signal handlers.
#
#  Arguments:
#
#       None.
#
#  Results:
#
#       Prints to stderr the registered handlers.
#       Returns with code zero.
#
#  Side effects:
#
#       None.
#

function mbfl_signal_inspect () {
    local SIGSPEC=
    local HANDLER=
    declare -i signum=0 hannum=


    mbfl_message_string "Inspecting signal table:\n"
    while test $signum -lt ${#MBFL_SIGNAL_MAP[*]}
    do
        SIGSPEC="${MBFL_SIGNAL_MAP[${signum}]}"
        if test -z "${SIGSPEC}"
        then break
        fi

        for handnum in ${MBFL_SIGNAL_REGISTRY[${signum}]}
        do
            HANDLER="${MBFL_SIGNAL_HANDLERS[${handnum}]}"
            if test -z "${HANDLER}"
            then break
            fi

            echo "Signal \"${SIGSPEC}\": ${HANDLER} "
        done

        signum=${signum}+1
    done

    mbfl_message_string "End inspection.\n"
    return 0
}


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# indent-tabs-mode: nil
# End:
