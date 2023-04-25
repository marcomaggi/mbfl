# signal.test --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the signal library
# Date: Mon Jul  7, 2003
#
# Abstract
#
#
# Copyright (c) 2003, 2004, 2005, 2013, 2018, 2020, 2023 Marco Maggi
# <mrc.mgg@gmail.com>
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


#### setup

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_TEST")

mbfl_signal_enable
mbfl_process_enable

script_PROGNAME='signal.test'


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### signal names and numbers

function signal-pred-1.1 () {
    mbfl_string_is_signame 'SIGKILL'
}
function signal-pred-1.2 () {
    ! mbfl_string_is_signame 'ciao'
}
function signal-pred-1.3 () {
    mbfl_string_is_signame 'SIGUSR1'
}
function signal-pred-2.1 () {
    mbfl_string_is_signum 0
}
function signal-pred-1.2 () {
    ! mbfl_string_is_signum 999
}

### ------------------------------------------------------------------------

function signal-mapping-1.1 () {
    mbfl_declare_integer_varref(SIGNUM)

    mbfl_signal_map_signame_to_signum_var _(SIGNUM) 'SIGKILL'
    dotest-equal 9 $SIGNUM 'SIGKILL number'
}
function signal-mapping-2.1 () {
    declare SIGNUM=$(mbfl_signal_map_signame_to_signum 'SIGKILL')

    dotest-equal 9 $SIGNUM 'SIGKILL number'
}
function signal-mapping-3.1 () {
    mbfl_declare_varref(SIGNAME)

    mbfl_signal_map_signum_to_signame_var _(SIGNAME) 9
    dotest-equal 'SIGKILL' "$SIGNAME" 'SIGKILL name'
}
function signal-mapping-4.1 () {
    declare SIGNAME=$(mbfl_signal_map_signum_to_signame 9)

    dotest-equal 'SIGKILL' "$SIGNAME" 'SIGKILL name'
}


#### signal handler registry

function signal-remove-all-handlers-1.1 () {
    declare FLAG1=false FLAG2=false FLAG3=false FLAG4=false

    mbfl_location_enter
    {
	mbfl_location_handler mbfl_signal_remove_all_handlers

	mbfl_signal_attach 'SIGUSR1' 'true'
	mbfl_signal_attach 'SIGUSR1' 'false'
	mbfl_signal_attach 'SIGUSR2' 'true'
	mbfl_signal_attach 'SIGUSR2' 'false'

	mbfl_signal_has_handlers 'SIGUSR1' && FLAG1=true
	mbfl_signal_has_handlers 'SIGUSR2' && FLAG2=true
    }
    mbfl_location_leave

    { ! mbfl_signal_has_handlers 'SIGUSR1'; } && FLAG3=true
    { ! mbfl_signal_has_handlers 'SIGUSR2'; } && FLAG4=true

    dotest-equal	true	$FLAG1 'FLAG1' &&
	dotest-equal	true	$FLAG2 'FLAG2' &&
	dotest-equal	true	$FLAG3 'FLAG3' &&
	dotest-equal	true	$FLAG4 'FLAG4'
}
function signal-remove-handler-1.1 () {
    declare FLAG1=false FLAG2=false FLAG3=false FLAG4=false

    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_signal_remove_handler SIGUSR1'

	mbfl_signal_attach 'SIGUSR1' 'true'
	mbfl_signal_attach 'SIGUSR1' 'false'
	mbfl_signal_attach 'SIGUSR2' 'true'
	mbfl_signal_attach 'SIGUSR2' 'false'

	mbfl_signal_has_handlers 'SIGUSR1' && FLAG1=true
	mbfl_signal_has_handlers 'SIGUSR2' && FLAG2=true
    }
    mbfl_location_leave

    { ! mbfl_signal_has_handlers 'SIGUSR1'; } && FLAG3=true
    {   mbfl_signal_has_handlers 'SIGUSR2'; } && FLAG4=true

    dotest-equal	true	$FLAG1 'FLAG1' &&
	dotest-equal	true	$FLAG2 'FLAG2' &&
	dotest-equal	true	$FLAG3 'FLAG3' &&
	dotest-equal	true	$FLAG4 'FLAG4'
}


#### signal delivery simulation

function signal-delivery-simulation-1.1 () {
    declare -g SIGNAL_DELIVERY_SIMULATION_1_1=false
    mbfl_declare_integer_varref(SIGNUM)

    mbfl_location_enter
    {
	mbfl_location_handler mbfl_signal_remove_all_handlers
	mbfl_location_handler 'unset -v SIGNAL_DELIVERY_SIMULATION_1_1'

	#mbfl_set_option_debug

	mbfl_signal_attach 'SIGUSR1' 'SIGNAL_DELIVERY_SIMULATION_1_1=true'
	mbfl_signal_invoke_handlers 'SIGUSR1'
	dotest-equal true "$SIGNAL_DELIVERY_SIMULATION_1_1"
    }
    mbfl_location_leave
}


#### sending signals to a subprocess
#
# The only way to test  actual signal delivery is to run a subprocess and send  signals to it; it is
# possible to send  signal to this process,  but, with the API  Bash exposes, it is  not possible to
# force signal  delivery; so we cannot  finish a testing function  being sure that the  sent signals
# arrived.  (Marco Maggi; Apr 22, 2023)
#

function signal-sending-1.1 () {
    run-subprocess-send-signal "SIGUSR1"
}
function signal-sending-1.2 () {
    run-subprocess-send-signal "SIGUSR2"
}
function run-subprocess-send-signal () {
    mbfl_mandatory_parameter(SIGNAME, 1, signal name)
    declare -r SIGNALTEST_SCRIPT="$testsdir"/signaltest.sh
    declare SIGNALTEST_FLAGS

    #mbfl_set_option_debug

    if dotest-option-debug
    then SIGNALTEST_FLAGS+=' --debug'
    fi

    mbfl_location_enter
    {
	mbfl_message_debug_printf "executing test script"
	if coproc "$mbfl_PROGRAM_BASH" "$SIGNALTEST_SCRIPT" $SIGNALTEST_FLAGS
	then
	    mbfl_message_debug_printf "test script pid: $COPROC_PID"
	    mbfl_location_handler "mbfl_fd_close _(COPROC,0)"
	    mbfl_location_handler "mbfl_fd_close _(COPROC,1)"
	    mbfl_process_disown $COPROC_PID
	else
	    mbfl_location_leave
	    return_failure
	fi

	if ! {
		read-from-child-process		'ready'		&&
		    write-to-child-process	'ready'		&&
		    mbfl_signal_send $SIGNAME $COPROC_PID	&&
		    read-from-child-process	'got signal'	&&
		    write-to-child-process	'quit'		&&
		    read-from-child-process	'quit'		&&
		    read-from-child-process	"exiting after interruption ($SIGNAME, 2 handlers)"
	    }
	then
	    mbfl_location_leave
	    return_failure
	fi

	# mbfl_message_debug_printf 'telling the child to go'
	# printf 'go\n' >_(COPROC, 1)

	# mbfl_message_debug_printf "sending ${SIGNAME} signal to pid '$COPROC_PID'"
	# mbfl_signal_send $SIGNAME $COPROC_PID
	#mbfl_process_sleep 1s
	#mbfl_message_debug_printf "sending SIGCONT signal to pid '$COPROC_PID' to wake it up"
	#mbfl_signal_send 'SIGCONT' $COPROC_PID

	# mbfl_message_debug_printf 'telling the child we are done'
	# printf 'done\n' >_(COPROC, 1)

	# mbfl_process_sleep 1s
	# mbfl_message_debug_printf 'reading child last reply'
	# if ! read-from-child-process 'quit'
	# then
	#     mbfl_location_leave
	#     return_failure
	# fi

	mbfl_message_debug_printf "waiting for pid '$COPROC_PID'"
	mbfl_process_wait $COPROC_PID
	mbfl_message_debug_printf "received finalisation of pid '$COPROC_PID'"
	dotest-equal "exiting after interruption ($SIGNAME, 2 handlers)" "$REPLY"
    }
    mbfl_location_leave
    dotest-clean-files
}
function read-from-child-process () {
    mbfl_mandatory_parameter(EXPECTED_REPLY, 1, expected child reply string)

    if read -t 4 -u _(COPROC, 0)
    then
	if mbfl_string_eq("$REPLY", "$EXPECTED_REPLY")
	then
	    mbfl_message_debug_printf 'the child said: "%s"' "$REPLY"
	    return_success
	else
	    mbfl_message_debug_printf 'unexpected child reply: "%s"' "$REPLY"
	    return_failure
	fi
    else
	if (( 128 < $? ))
	then mbfl_message_debug_printf 'the child did not reply before timeout'
	else mbfl_message_debug_printf 'some error reading from the child'
	fi
	return_failure
    fi
}
function write-to-child-process () {
    mbfl_mandatory_parameter(MESSAGE, 1, message string)

    mbfl_message_debug_printf 'sending message to child'
    if printf '%s\n' "$MESSAGE" >&_(COPROC, 1)
    then
	mbfl_message_debug_printf 'parent to child: "%s"' "$MESSAGE"
	return_success
    else
	mbfl_message_debug_printf 'error writing to child: "%s"' "$MESSAGE"
	return_failure
    fi
}


#### let's go

dotest signal-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
