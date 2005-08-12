# at.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: interface to the 'at' service
# Date: Fri Aug 12, 2005
# 
# Abstract
# 
#	This example script shows how to use the 'at' interface.
# 
# Copyright (c) 2005 Marco Maggi
# 
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
# 
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
# 

#page
## ------------------------------------------------------------
## MBFL's related options and variables.
## ------------------------------------------------------------

script_PROGNAME=at.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2005'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION="Example script to test the 'at' interface."

source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ACTION_SCHEDULE no S schedule noarg 'schedules a command'
mbfl_declare_option ACTION_LIST no     L list     noarg 'lists scheduled commands'
mbfl_declare_option ACTION_DROP no     D drop     noarg 'drops a scheduled command'
mbfl_declare_option ACTION_CLEAN no    C clean    noarg 'cleans a queue'

mbfl_declare_option QUEUE z               q queue       witharg 'selects the queue'
mbfl_declare_option TIME 'now +1 minutes' t time        witharg 'selects time'
mbfl_declare_option COMMAND :             c command     witharg 'selects the command'
mbfl_declare_option IDENTIFIER ''         '' identifier witharg 'selects a job'

# Program declarations.
mbfl_at_enable

# Exit code declarations.
mbfl_main_declare_exit_code 3 wrong_queue_identifier

#page
## ------------------------------------------------------------
## Options update functions.
## ------------------------------------------------------------

function script_option_update_action_schedule () {
    mbfl_main_set_main script_action_schedule
}
function script_option_update_action_list () {
    mbfl_main_set_main script_action_list
}
function script_option_update_action_drop () {
    mbfl_main_set_main script_action_drop
}
function script_option_update_action_clean () {
    mbfl_main_set_main script_action_clean
}
function script_option_update_queue () {
    local Q=${script_option_QUEUE}

    if ! mbfl_at_select_queue "${Q}" ; then
        exit_because_wrong_queue_identifier
    fi
}


#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function script_before_parsing_options () {
    mbfl_main_set_main script_action_list
}
function script_action_schedule () {
    local Q=$(mbfl_at_print_queue)
    local TIME=${script_option_TIME}
    local ID

    mbfl_message_verbose "scheduling a job in queue '${Q}'\n"
    if ! ID=$(mbfl_at_schedule : "${TIME}") ; then
        exit_failure
    fi
    mbfl_message_verbose "scheded job identifier '${ID}'\n"    
    exit_success
}
function script_action_list () {
    local Q=$(mbfl_at_print_queue)
    local item

    mbfl_message_verbose "jobs in queue '${Q}': "
    {
        for item in $(mbfl_at_queue_print_identifiers) ; do
            printf '%d ' "${item}"
        done
        printf '\n'
    } >&2
}
function script_action_drop () {
    local ID=${script_option_IDENTIFIER}

    mbfl_message_verbose "dropping job '${ID}'\n"
    mbfl_at_drop "${ID}"
}
function script_action_clean () {
    local Q=$(mbfl_at_print_queue)

    mbfl_message_verbose "cleaning queue '${Q}'\n"
    mbfl_at_queue_clean
}

#page
## ------------------------------------------------------------
## Start.
## ------------------------------------------------------------

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
