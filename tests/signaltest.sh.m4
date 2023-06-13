# signaltest.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: test script for signal handling
# Date: Mon Jul  7, 2003
#
# Abstract
#
#
#
# Copyright (c) 2003, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#


#### MBFL's related options and variables

script_REQUIRED_MBFL_VERSION=v3.0.0-devel.8
script_PROGNAME=signaltest.sh
script_VERSION=2.0
script_COPYRIGHT_YEARS='2003, 2018, 2023'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options]"
script_DESCRIPTION='Test scripts for signal handling.'
script_EXAMPLES=


#### load library

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### global variables

declare SIGSPEC='none'


#### functions

function main () {
    local -i flag=0

    mbfl_signal_enable
    mbfl_process_enable

    trap quitting EXIT

    #mbfl_set_option_debug

    mbfl_message_debug_printf 'running child process with PID "%d"' $mbfl_PID

    mbfl_signal_attach SIGUSR1 handler_one
    mbfl_signal_attach SIGUSR1 handler_two

    mbfl_signal_attach SIGUSR2 handler_three
    mbfl_signal_attach SIGUSR2 handler_four

    if false
    then
	mbfl_declare_varref(SIGUSR1_HOOK)
	mbfl_signal_hook_var _(SIGUSR1_HOOK) 'SIGUSR1'
	mbfl_array_dump $SIGUSR1_HOOK SIGUSR1_HOOK

	mbfl_declare_varref(SIGUSR2_HOOK)
	mbfl_signal_hook_var _(SIGUSR2_HOOK) 'SIGUSR2'
	mbfl_array_dump $SIGUSR2_HOOK SIGUSR2_HOOK
    fi

    if ! {
	    write-to-parent-process		'ready'		&&
		read-from-parent-process	'ready'		&&
		wait-for-signal					&&
		write-to-parent-process		'got signal'	&&
		read-from-parent-process	'quit'		&&
		write-to-parent-process		'quit'
	}
    then return_failure
    fi

    # mbfl_message_debug_printf "waiting for a signal %d" $flag
    # # while (( 0 == flag ))
    # # do :
    # # done
    # mbfl_process_sleep 1s
    # mbfl_message_debug "waiting for the parent to tell us that we are done"

    #mbfl_message_debug "suspend, wait for SIGCONT"
    #mbfl_process_sleep 1s
    #mbfl_process_suspend

    exit_because_success
}

function read-from-parent-process () {
    mbfl_mandatory_parameter(EXPECTED_REPLY, 1, expected parent reply string)

    mbfl_message_debug_printf 'waiting message from parent'
    if read -t 4
    then
	if mbfl_string_eq("$REPLY", "$EXPECTED_REPLY")
	then
	    mbfl_message_debug_printf 'the parent said: "%s"' "$REPLY"
	    return_success
	else
	    mbfl_message_debug_printf 'unexpected parent reply: "%s"' "$REPLY"
	    return_failure
	fi
    else
	if (( 128 < $? ))
	then mbfl_message_debug_printf 'the parent did not reply before timeout'
	else mbfl_message_debug_printf 'some error reading from the parent'
	fi
	return_failure
    fi
}
function write-to-parent-process () {
    mbfl_mandatory_parameter(MESSAGE, 1, message string)

    mbfl_message_debug_printf 'sending message to parent'
    if printf '%s\n' "$MESSAGE"
    then
	mbfl_message_debug_printf 'child to parent: "%s"' "$MESSAGE"
	return_success
    else
	mbfl_message_debug_printf 'error writing to parent: "%s"' "$MESSAGE"
	return_failure
    fi
}
function wait-for-signal () {
    while (( 0 == flag ))
    do :
    done
}
function handler_one () {
    SIGSPEC=SIGUSR1
    mbfl_message_debug "interrupted by signal (handler one)"
    let ++flag
}
function handler_two () {
    SIGSPEC=SIGUSR1
    mbfl_message_debug "interrupted by signal (handler two)"
    let ++flag
}
function handler_three () {
    SIGSPEC=SIGUSR2
    mbfl_message_debug "interrupted by signal (${FUNCNAME})"
    let ++flag
}
function handler_four () {
    SIGSPEC=SIGUSR2
    mbfl_message_debug "interrupted by signal (${FUNCNAME})"
    let ++flag
}
function output_and_debug () {
    echo "$1"
    mbfl_message_debug "$1"
}
function quitting () {
    declare EXIT_MESSAGE="exiting with no interruption"

    if ((0 != flag))
    then EXIT_MESSAGE="exiting after interruption ($SIGSPEC, $flag handlers)"
    fi
    output_and_debug "$EXIT_MESSAGE"
}

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
