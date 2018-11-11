# signal.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: functions to deal with signals
# Date: Mon Jul  7, 2003
#
# Abstract
#
#
#
# Copyright (c) 2003-2005, 2009, 2013, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
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

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

test "$mbfl_INTERACTIVE" = yes || {
    declare -a mbfl_signal_HANDLERS
    i=0
    { while kill -l $i ; do let ++i; done; } &>/dev/null
    declare -i mbfl_signal_MAX_SIGNUM=$i
}

#PAGE
function mbfl_signal_map_signame_to_signum () {
    mbfl_mandatory_parameter(SIGSPEC, 1, signal name)
    local i name
    for ((i=0; $i < $mbfl_signal_MAX_SIGNUM; ++i))
    do
        test "SIG$(kill -l $i)" = "$SIGSPEC" && {
            echo $i
            return 0
        }
    done
    return 1
}
function mbfl_signal_attach () {
    mbfl_mandatory_parameter(SIGSPEC, 1, signal name)
    mbfl_mandatory_parameter(HANDLER, 2, function name)
    local signum
    signum=$(mbfl_signal_map_signame_to_signum "$SIGSPEC") || return 1
    if test -z ${mbfl_signal_HANDLERS[$signum]}
    then mbfl_signal_HANDLERS[$signum]=$HANDLER
    else mbfl_signal_HANDLERS[$signum]=${mbfl_signal_HANDLERS[$signum]}:$HANDLER
    fi
    mbfl_message_debug "attached '$HANDLER' to signal $SIGSPEC"
    trap -- "mbfl_signal_invoke_handlers $signum" $signum
}
function mbfl_signal_invoke_handlers () {
    mbfl_mandatory_parameter(SIGNUM, 1, signal number)
    local handler ORGIFS=$IFS
    mbfl_message_debug "received signal 'SIG$(kill -l $SIGNUM)'"
    IFS=:
    for handler in ${mbfl_signal_HANDLERS[$SIGNUM]}
    do
        IFS=$ORGIFS
        mbfl_message_debug "registered handler: $handler"
        test -n "$handler" && eval $handler
    done
    IFS=$ORGIFS
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
