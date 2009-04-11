# signaltest.sh --

SIGSPEC=SIGUSR1

source "${MBFL_LIBRARY:=libmbfl.sh}"

function main () {
    flag=0

#    mbfl_set_option_debug
    mbfl_message_debug "running: pid $$"

    mbfl_signal_attach SIGUSR1 handler_one
    mbfl_signal_attach SIGUSR1 handler_two

    mbfl_signal_attach SIGUSR2 handler_three
    mbfl_signal_attach SIGUSR2 handler_four

    mbfl_message_debug "waiting"
    debug-wait 40
    mbfl_message_debug "exiting"
    trap quitting EXIT
    exit 0
}

function debug-wait () {
    local i
    for ((i=0; $i < $(($1 * 1000)); ++i)); do :; done    
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
    sync
}
function quitting () {
    local msg="exiting with no interruption"

    if test $flag != 0 ; then
	msg="exiting after interruption ($SIGSPEC, $flag handlers)"
    fi
    output_and_debug "$msg"
}

main

### end of file
