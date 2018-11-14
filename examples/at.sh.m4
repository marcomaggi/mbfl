# Part of: Marco's BASH Functions Library
# Contents: interface to the 'at' service
# Date: Fri Aug 12, 2005
#
# Abstract
#
#	This example script shows how to use the 'at' interface.
#
# Copyright (c) 2005, 2009, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# The author hereby grants  permission to use, copy, modify, distribute,
# and  license this  software  and its  documentation  for any  purpose,
# provided that  existing copyright notices  are retained in  all copies
# and that  this notice  is included verbatim in any  distributions.  No
# written agreement, license, or royalty  fee is required for any of the
# authorized uses.  Modifications to this software may be copyrighted by
# their authors and need not  follow the licensing terms described here,
# provided that the new terms are clearly indicated on the first page of
# each file where they apply.
#
# IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
# FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
# ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
# DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
# POSSIBILITY OF SUCH DAMAGE.
#
# THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
# INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
# MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
# NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
# AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

#page
#### MBFL's related options and variables

script_PROGNAME=at.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2005, 2009, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL3
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION="Example script to test the 'at' interface."
script_EXAMPLES="Examples:
\n
\tat.sh --schedule --time='now +1 hour' --queue=A \\
\t   --command='command.sh --option'
\tat.sh --list-jobs --queue=A
\tat.sh --drop --identifier=1234
"

mbfl_library_loader

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ACTION_SCHEDULE    no  S   schedule        noarg   'schedules a command'
mbfl_declare_option ACTION_LIST        yes L   list            noarg   'lists scheduled job identifiers'
mbfl_declare_option ACTION_LIST_JOBS   no  J   list-jobs       noarg   'lists scheduled jobs'
mbfl_declare_option ACTION_LIST_QUEUES no  Q   list-queues     noarg   'lists queues with scheduled jobs'
mbfl_declare_option ACTION_DROP        no  D   drop            noarg   'drops a scheduled command'
mbfl_declare_option ACTION_CLEAN       no  C   clean           noarg   'cleans a queue'

mbfl_declare_option QUEUE       z                q  queue      witharg 'selects the queue'
mbfl_declare_option TIME        'now +1 minutes' t  time       witharg 'selects time'
mbfl_declare_option COMMAND     :                c  command    witharg 'selects the command'
mbfl_declare_option IDENTIFIER  ''               '' identifier witharg 'selects a job'

# Program declarations.
mbfl_at_enable

# Exit code declarations.
mbfl_main_declare_exit_code 3 wrong_queue_identifier
mbfl_main_declare_exit_code 4 wrong_command_line_arguments

#page
#### options update functions

function script_option_update_queue () {
    if ! mbfl_at_select_queue "$script_option_QUEUE"
    then exit_because_wrong_queue_identifier
    fi
}

#page
#### main functions

function script_before_parsing_options () {
    mbfl_at_select_queue ${script_option_QUEUE}
}
function script_action_schedule () {
    local Q=$(mbfl_at_print_queue)
    local TIME=${script_option_TIME}
    local ID
    mbfl_message_verbose_printf 'scheduling a job in queue "%s"\n' "$Q"
    if ID=$(mbfl_at_schedule "$script_option_COMMAND" "$TIME")
    then exit_failure
    else
	mbfl_message_verbose_printf 'scheded job identifier "%s"\n' "$ID"
	exit_success
    fi
}
function script_action_list () {
    local Q=$(mbfl_at_print_queue) item
    mbfl_message_verbose_printf 'jobs in queue "%s": ' "$Q"
    for item in $(mbfl_at_queue_print_identifiers)
    do printf '%d ' "$item"
    done
    printf '\n'
}
function script_action_list_jobs () {
    mbfl_at_queue_print_jobs
}
function script_action_list_queues () {
    local item
    mbfl_message_verbose 'queues with pending jobs: '
    for item in $(mbfl_at_queue_print_queues)
    do printf '%c ' "$item"
    done
    printf '\n'
}
function script_action_drop () {
    local ID=${script_option_IDENTIFIER}
    if test -n "${ID}"
    then
        mbfl_message_verbose_printf 'dropping job "%s"\n' "$ID"
        mbfl_at_drop "$ID"
    else
        mbfl_message_error 'no job selected'
        exit_because_wrong_command_line_arguments
    fi
}
function script_action_clean () {
    local Q=$(mbfl_at_print_queue)
    mbfl_message_verbose_printf 'cleaning queue "${Q}"\n' "$Q"
    mbfl_at_queue_clean
}

#page
#### let's go

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
