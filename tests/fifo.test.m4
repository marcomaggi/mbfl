# fifo.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for named pipes
# Date: Apr 22, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=fifo-
#
#	that will select these tests.
#
# Copyright (c) 2023 Marco Maggi
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

mbfl_file_enable_remove
mbfl_process_enable
mbfl_atexit_enable


#### predicates

function fifo-predicate-1.1 () {
    declare -r THE_FIFO="$(dotest-mkpathname the-fifo)"

    mbfl_location_enter
    {
	mbfl_location_handler 'dotest-clean-files'
	mbfl_location_handler 'mbfl_fd_close 5'

	mbfl_exec_mkfifo --mode=0600 -- "$THE_FIFO"

	mbfl_file_is_fifo "$THE_FIFO"
    }
    mbfl_location_leave
}
function fifo-predicate-2.1 () {
    declare -r THE_FIFO="$(dotest-mkpathname the-fifo)"

    mbfl_location_enter
    {
	mbfl_location_handler 'dotest-clean-files'
	mbfl_location_handler 'mbfl_fd_close 5'

	mbfl_exec_mkfifo --mode=0600 -- "$THE_FIFO"

	mbfl_file_is_named_pipe "$THE_FIFO"
    }
    mbfl_location_leave
}


#### simple FIFO operations

# This single process opens a FIFO for both reading and writing.
#
function fifo-simple-1.1 () {
    declare -r THE_FIFO="$(dotest-mkpathname the-fifo)"

    mbfl_location_enter
    {
	mbfl_location_handler 'dotest-clean-files'
	mbfl_location_handler 'mbfl_fd_close 5'

	mbfl_exec_mkfifo --mode=0600 -- "$THE_FIFO"
	mbfl_fd_open_input_output 5 "$THE_FIFO"

	printf 'ciao\n' >&5
	read -u 5
	dotest-equal 'ciao' "$REPLY"
    }
    mbfl_location_leave
}


#### chatting with a child process

# Run a child process  sending to it the pathnames of FIFOs  through exported environment variables.
# The child takes care of opening the FIFOs by itself.
#
function fifo-child-process-1.1 () {
    declare -r FIFOTEST_SCRIPT="$testsdir"/fifotest.sh
    declare -i FIFOTEST_SCRIPT_PID
    declare -r FIFOTEST_PARENT_TO_CHILD="$(dotest-mkpathname fifotest-parent-to-child)"
    declare -r FIFOTEST_CHILD_TO_PARENT="$(dotest-mkpathname fifotest-child-to-parent)"

    # Make the FIFOs pathnames available to the child process.
    #
    export FIFOTEST_PARENT_TO_CHILD
    export FIFOTEST_CHILD_TO_PARENT

    #dotest-set-debug
    #mbfl_set_option_test
    #mbfl_set_option_show_program

    mbfl_location_enter
    {
	mbfl_location_handler 'dotest-clean-files'

	dotest-debug 'creating parent-to-child FIFO'
	if ! mbfl_exec_mkfifo --mode=0600 -- "$FIFOTEST_PARENT_TO_CHILD"
	then
	    mbfl_location_leave
	    return_failure
	fi

	dotest-debug 'creating child-to-parent FIFO'
	if ! mbfl_exec_mkfifo --mode=0600 -- "$FIFOTEST_CHILD_TO_PARENT"
	then
	    mbfl_location_leave
	    return_failure
	fi

	dotest-debug 'opening parent-to-child FIFO with fd 4'
	if mbfl_fd_open_input_output 4 "$FIFOTEST_PARENT_TO_CHILD"
	then mbfl_location_handler 'mbfl_fd_close 4'
	else
	    dotest-debug 'error opening parent-to-child FIFO with fd 4'
	    mbfl_location_leave
	    return_failure
	fi

	# Open the parent's  input FIFO as read-write,  otherwise "exec" will block  waiting for the
	# first character.
	#
	dotest-debug 'opening child-to-parent FIFO with fd 5'
	if mbfl_fd_open_input_output 5 "$FIFOTEST_CHILD_TO_PARENT"
	then mbfl_location_handler 'mbfl_fd_close 5'
	else
	    dotest-debug 'error opening child-to-parent FIFO with fd 5'
	    mbfl_location_leave
	    return_failure
	fi

	# Execute the child process.
	#
	dotest-debug 'running the child process'
	if mbfl_program_execbg 0 1 "$mbfl_PROGRAM_BASH" "$FIFOTEST_SCRIPT"
	then
	    FIFOTEST_SCRIPT_PID=$mbfl_program_BGPID
	    mbfl_location_handler "mbfl_process_wait $FIFOTEST_SCRIPT_PID"
	else
	    mbfl_location_leave
	    return_failure
	fi

	dotest-debug 'chatting with the child process'
	printf 'ciao child\n' >&4
	read -u 5
	dotest-debug 'read string from child:' "$REPLY"
	dotest-equal 'ciao parent' "$REPLY"
    }
    mbfl_location_leave
}

# Run a child process  sending to it the pathnames of FIFOs  through exported environment variables.
# The child takes care of opening the FIFOs by itself.
#
function fifo-child-process-1.2 () {
    declare -r FIFOTEST_SCRIPT="$testsdir"/fifotest.sh
    declare -i FIFOTEST_SCRIPT_PID
    declare -r FIFOTEST_PARENT_TO_CHILD="$(dotest-mkpathname fifotest-parent-to-child)"
    declare -r FIFOTEST_CHILD_TO_PARENT="$(dotest-mkpathname fifotest-child-to-parent)"

    # Make the FIFOs pathnames available to the child process.
    #
    export FIFOTEST_PARENT_TO_CHILD
    export FIFOTEST_CHILD_TO_PARENT

    #dotest-set-debug
    #mbfl_set_option_test
    #mbfl_set_option_show_program

    mbfl_location_enter
    {
	mbfl_location_handler 'dotest-clean-files'

	dotest-debug 'creating parent-to-child FIFO'
	if ! mbfl_exec_mkfifo --mode=0600 -- "$FIFOTEST_PARENT_TO_CHILD"
	then
	    mbfl_location_leave
	    return_failure
	fi

	dotest-debug 'creating child-to-parent FIFO'
	if ! mbfl_exec_mkfifo --mode=0600 -- "$FIFOTEST_CHILD_TO_PARENT"
	then
	    mbfl_location_leave
	    return_failure
	fi

	dotest-debug 'opening parent-to-child FIFO with fd 4'
	if mbfl_fd_open_input_output 4 "$FIFOTEST_PARENT_TO_CHILD"
	then mbfl_location_handler 'mbfl_fd_close 4'
	else
	    dotest-debug 'error opening parent-to-child FIFO with fd 4'
	    mbfl_location_leave
	    return_failure
	fi

	# Open the parent's  input FIFO as read-write,  otherwise "exec" will block  waiting for the
	# first character.
	#
	dotest-debug 'opening child-to-parent FIFO with fd 5'
	if mbfl_fd_open_input_output 5 "$FIFOTEST_CHILD_TO_PARENT"
	then mbfl_location_handler 'mbfl_fd_close 5'
	else
	    dotest-debug 'error opening child-to-parent FIFO with fd 5'
	    mbfl_location_leave
	    return_failure
	fi

	# Execute the child process.
	#
	dotest-debug 'running the child process'
	if mbfl_program_exec "$mbfl_PROGRAM_BASH" "$FIFOTEST_SCRIPT" channels <"$FIFOTEST_PARENT_TO_CHILD" >"$FIFOTEST_CHILD_TO_PARENT" &
	then FIFOTEST_SCRIPT_PID=$mbfl_program_BGPID
	else
	    mbfl_location_leave
	    return_failure
	fi

	# We have connected  both the ends of  both the FIFOs, so  we can remove them  from the file
	# system: the FIFOs will continue to exist until the file descriptors are closed.
	#
	dotest-debug 'removing FIFOs'
	mbfl_file_remove "$FIFOTEST_PARENT_TO_CHILD"
	mbfl_file_remove "$FIFOTEST_CHILD_TO_PARENT"

	dotest-debug 'chatting with the child process'
	printf 'ciao child\n' >&4
	read -u 5
	dotest-debug 'read string from child:' "$REPLY"
	dotest-equal 'ciao parent' "$REPLY"
    }
    mbfl_location_leave
}


#### let's go

dotest fifo-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
