#! fifotest.sh.m4 --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: test script for named pipes
#! Date: Apr 23, 2023
#!
#! Abstract
#!
#!
#!
#! Copyright (c) 2023 Marco Maggi <mrc.mgg@gmail.com>
#!
#! The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
#! and its documentation  for any purpose, provided  that existing copyright notices  are retained in
#! all copies and that this notice is  included verbatim in any distributions.  No written agreement,
#! license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
#! software may  be copyrighted by their  authors and need  not follow the licensing  terms described
#! here, provided that the new terms are clearly indicated  on the first page of each file where they
#! apply.
#!
#! IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
#! INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
#! OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
#! DAMAGE.
#!
#! THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
#! THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
#! THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
#! OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#!


#### MBFL's related options and variables

script_REQUIRED_MBFL_VERSION=v3.0.0-devel.8
script_PROGNAME=fifotest.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2023'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options]"
script_DESCRIPTION='Test scripts for named pipes.'
script_EXAMPLES=


#### load library

mbfl_load_library("$MBFL_LIBMBFL_CORE")

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### functions

function main () {
    mbfl_signal_enable
    mbfl_process_enable

    #mbfl_set_option_debug
    mbfl_message_debug_printf 'start'

    if (( 0 == ARGC ))
    then
	# We, the child, communicate  with our parent through explicitly open  FIFOs.  We expect the
	# name of the FIFOs to be in these variables.
	#
	declare -r FIFO_PARENT_TO_CHILD=$FIFO_PARENT_TO_CHILD
	declare -r FIFO_CHILD_TO_PARENT=$FIFO_CHILD_TO_PARENT

	declare -ri FD_PARENT_TO_CHILD=4
	declare -ri FD_CHILD_TO_PARENT=5

	mbfl_location_enter
	{
	    mbfl_message_debug_printf 'opening parent-to-child FIFO with fd %s: "%s"' $FD_PARENT_TO_CHILD "$FIFO_PARENT_TO_CHILD"
	    if mbfl_fd_open_input_output $FD_PARENT_TO_CHILD "$FIFO_PARENT_TO_CHILD"
	    then mbfl_location_handler "mbfl_fd_close $FD_PARENT_TO_CHILD"
	    else
		mbfl_location_leave
		return_failure
	    fi

	    mbfl_message_debug_printf 'opening child-to-parent FIFO with fd %s: "%s"' $FD_CHILD_TO_PARENT "$FIFO_CHILD_TO_PARENT"
	    if mbfl_fd_open_input_output $FD_CHILD_TO_PARENT "$FIFO_CHILD_TO_PARENT"
	    then mbfl_location_handler "mbfl_fd_close $FD_CHILD_TO_PARENT"
	    else
		mbfl_location_leave
		return_failure
	    fi

	    mbfl_message_debug_printf 'chatting with the parent'
	    read -u $FD_PARENT_TO_CHILD
	    printf 'ciao parent\n' >&$FD_CHILD_TO_PARENT

	    mbfl_message_debug_printf 'exiting'
	}
	mbfl_location_leave
    elif (( 1 == ARGC )) && mbfl_string_equal 'channels' _(ARGV, 0)
    then
	# We, the child, communicate with our parent  through stdin and stdout: the parent took care
	# of redirecting the standard channels to FIFOs.
	#
	mbfl_message_debug_printf 'chatting with the parent through stdin and stdout'
	read
	mbfl_message_debug_printf 'read from parent: "%s"' "$REPLY"
	printf 'ciao parent\n'

	mbfl_message_debug_printf 'exiting'
    else exit_failure
    fi
}

mbfl_main

#!# end of file
# Local Variables:
# mode: sh
# End:
