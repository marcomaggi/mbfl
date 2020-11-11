# fd.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the file descriptors module
# Date: Dec  9, 2018
#
# Abstract
#
#	To select the tests in this file:
#
#		$ TESTMATCH=fd- make all tests
#
# Copyright (c) 2018, 2020 Marco Maggi <mrc.mgg@gmail.com>
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

#page
#### setup

source setup.sh

#dotest-set-debug

mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit
mbfl_file_enable_remove

mbfl_declare_program mkfifo

#page
#### helpers

function program_mkfifo () {
    local PATHNAME=${1:?"missing pathname argument to '${FUNCNAME}'"}
    shift 1
    local MKFIFO
    mbfl_program_found_var MKFIFO mkfifo || exit_because_program_not_found

    "$MKFIFO" --mode=0600 "$@" "$PATHNAME"
}

#page
#### reading from a file

# Write to a test file, then read from it.
#
function fd-file-read-write-1.1 () {
    local TESTFILE INFD=3 OUFD=4 LINE
    TESTFILE=$(dotest-mkfile file)

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files

	mbfl_fd_open_output $OUFD "$TESTFILE"
	echo 1234 >&${OUFD}
	mbfl_fd_close $OUFD

	mbfl_fd_open_input  $INFD "$TESTFILE"
	read -u ${INFD} LINE
	mbfl_fd_close $INFD
    }
    mbfl_location_leave

    dotest-equal '1234' "$LINE"
}

# Write to  a test file,  then read from  it.  Use location  handlers to
# close the file descriptors.
#
function fd-file-read-write-1.2 () {
    local TESTFILE INFD=3 OUFD=4 LINE CLOSED_INFD=false CLOSED_OUFD=false
    TESTFILE=$(dotest-mkfile file)

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files

	mbfl_fd_open_output $OUFD "$TESTFILE"
	mbfl_location_handler "mbfl_fd_close ${OUFD}; CLOSED_OUFD=true; dotest-debug '${FUNCNAME}: closed ${OUFD}'"
	echo 1234 >&${OUFD}

	mbfl_fd_open_input  $INFD "$TESTFILE"
	mbfl_location_handler "mbfl_fd_close ${INFD}; CLOSED_INFD=true; dotest-debug '${FUNCNAME}: closed ${INFD}'"
	read -u ${INFD} LINE
    }
    mbfl_location_leave

    dotest-equal '1234' "$LINE" && $CLOSED_INFD && $CLOSED_OUFD
}

### ------------------------------------------------------------------------

# Write to  a test file,  then read from  it.  Use location  handlers to
# close the file descriptors.  Create the file while opening it.
#
function fd-file-read-write-2.1 () {
    local TESTFILE INFD=3 OUFD=4 LINE CLOSED_INFD=false CLOSED_OUFD=false
    TESTFILE=$(dotest-mkpathname file)

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files

	mbfl_fd_open_output $OUFD "$TESTFILE"
	mbfl_location_handler "mbfl_fd_close ${OUFD}; CLOSED_OUFD=true; dotest-debug '${FUNCNAME}: closed ${OUFD}'"
	echo 1234 >&${OUFD}

	mbfl_fd_open_input  $INFD "$TESTFILE"
	mbfl_location_handler "mbfl_fd_close ${INFD}; CLOSED_INFD=true; dotest-debug '${FUNCNAME}: closed ${INFD}'"
	read -u ${INFD} LINE
    }
    mbfl_location_leave

    dotest-equal '1234' "$LINE" && $CLOSED_INFD && $CLOSED_OUFD
}

#page
#### reading and writing using a FIFO

# Write to a test FIFO, then read from it.
#
function fd-fifo-read-write-1.1 () {
    local TESTFIFO=$(dotest-mkpathname fifo) INFD=3 OUFD=4 LINE

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	program_mkfifo "$TESTFIFO"

	mbfl_fd_open_input_output $INFD "$TESTFIFO"
	mbfl_fd_open_output       $OUFD "$TESTFIFO"

	echo 1234 >&${OUFD}
	read -u ${INFD} LINE

	mbfl_fd_close $INFD
	mbfl_fd_close $OUFD
    }
    mbfl_location_leave

    dotest-equal '1234' "$LINE"
}

# Write to a test FIFO, then read from it.  Use location handlers to
# close the file descriptors.
#
function fd-fifo-read-write-1.2 () {
    local TESTFIFO=$(dotest-mkpathname fifo) INFD=3 OUFD=4 LINE CLOSED_INFD=false CLOSED_OUFD=false

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	program_mkfifo "$TESTFIFO"

	mbfl_fd_open_input_output $INFD "$TESTFIFO"
	mbfl_location_handler "mbfl_fd_close ${INFD}; CLOSED_INFD=true; dotest-debug '${FUNCNAME}: closed ${INFD}'"

	mbfl_fd_open_output       $OUFD "$TESTFIFO"
	mbfl_location_handler "mbfl_fd_close ${OUFD}; CLOSED_OUFD=true; dotest-debug '${FUNCNAME}: closed ${OUFD}'"

	echo 1234 >&${OUFD}
	read -u ${INFD} LINE
    }
    mbfl_location_leave

    dotest-equal '1234' "$LINE"
}

# Use a location handler to remove the FIFO.
#
function fd-fifo-read-write-1.3 () {
    local TESTFIFO=$(dotest-mkpathname fifo) INFD=3 OUFD=4 LINE CLOSED_INFD=false CLOSED_OUFD=false

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	program_mkfifo "$TESTFIFO"
	mbfl_location_handler "mbfl_file_remove '${TESTFIFO}'; dotest-debug '${FUNCNAME}: removing FIFO'"

	mbfl_fd_open_input_output $INFD "$TESTFIFO"
	mbfl_location_handler "mbfl_fd_close ${INFD}; CLOSED_INFD=true; dotest-debug '${FUNCNAME}: closed ${INFD}'"

	mbfl_fd_open_output       $OUFD "$TESTFIFO"
	mbfl_location_handler "mbfl_fd_close ${OUFD}; CLOSED_OUFD=true; dotest-debug '${FUNCNAME}: closed ${OUFD}'"

	echo 1234 >&${OUFD}
	read -u ${INFD} LINE
    }
    mbfl_location_leave

    dotest-equal '1234' "$LINE"
}

#page
#### duplicating file descriptors

# Write to a test FIFO, then read from it.  Use location handlers to
# close the file descriptors.  Use duplicated file descriptors.
#
function fd-dup-fifo-read-write-1.1 () {
    local TESTFIFO=$(dotest-mkpathname fifo)
    local INFD=3 OUFD=4 DUP_INFD=5 DUP_OUFD=6
    local LINE1 LINE2 LINE3

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	program_mkfifo "$TESTFIFO"

	mbfl_fd_open_input_output $INFD "$TESTFIFO"
	mbfl_location_handler "mbfl_fd_close ${INFD}; CLOSED_INFD=true; dotest-debug '${FUNCNAME}: closed ${INFD}'"

	mbfl_fd_open_output       $OUFD "$TESTFIFO"
	mbfl_location_handler "mbfl_fd_close ${OUFD}; CLOSED_OUFD=true; dotest-debug '${FUNCNAME}: closed ${OUFD}'"

	echo 1234 >&${OUFD}
	read -u ${INFD} LINE1

	mbfl_location_enter
	{
	    mbfl_fd_dup_input  $INFD $DUP_INFD
	    mbfl_location_handler "mbfl_fd_close ${DUP_INFD}; dotest-debug '${FUNCNAME}: closed ${DUP_INFD}'"

	    mbfl_fd_dup_output $OUFD $DUP_OUFD
	    mbfl_location_handler "mbfl_fd_close ${DUP_OUFD}; dotest-debug '${FUNCNAME}: closed ${DUP_OUFD}'"

	    echo 5678 >&${DUP_OUFD}
	    read -u ${DUP_INFD} LINE2
	}
	mbfl_location_leave

	echo 90 >&${OUFD}
	read -u ${INFD} LINE3
    }
    mbfl_location_leave

    dotest-debug LINE1="$LINE1"
    dotest-debug LINE2="$LINE2"
    dotest-debug LINE3="$LINE3"
    dotest-equal '1234' "$LINE1" && dotest-equal '5678' "$LINE2" && dotest-equal '90' "$LINE3"
}

#page
#### moving file descriptors

# Write to a test FIFO, then read from it.  Use location handlers to
# close the file descriptors.  Use duplicated file descriptors.
#
function fd-move-fifo-read-write-1.1 () {
    local TESTFIFO=$(dotest-mkpathname fifo)
    local INFD=3 OUFD=4 DUP_INFD=5 DUP_OUFD=6
    local LINE

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	program_mkfifo "$TESTFIFO"

	mbfl_fd_open_input_output $INFD "$TESTFIFO"
	mbfl_fd_open_output       $OUFD "$TESTFIFO"

	mbfl_fd_move $INFD $DUP_INFD
	mbfl_location_handler "mbfl_fd_close ${DUP_INFD}; dotest-debug '${FUNCNAME}: closed ${DUP_INFD}'"

	mbfl_fd_move $OUFD $DUP_OUFD
	mbfl_location_handler "mbfl_fd_close ${DUP_OUFD}; dotest-debug '${FUNCNAME}: closed ${DUP_OUFD}'"

	echo 1234 >&${DUP_OUFD}
	read -u ${DUP_INFD} LINE
    }
    mbfl_location_leave

    dotest-debug LINE="$LINE"
    dotest-equal '1234' "$LINE"
}

### ------------------------------------------------------------------------

function fd-move-file-read-write-1.1 () {
    local TESTFIFO=$(dotest-mkpathname file)
    local INFD=3 OUFD=4 DUP_INFD=5 DUP_OUFD=6
    local LINE

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files

	mbfl_fd_open_input_output $INFD "$TESTFIFO"
	mbfl_fd_open_output       $OUFD "$TESTFIFO"

	mbfl_fd_move $INFD $DUP_INFD
	mbfl_location_handler "mbfl_fd_close ${DUP_INFD}; dotest-debug '${FUNCNAME}: closed ${DUP_INFD}'"

	mbfl_fd_move $OUFD $DUP_OUFD
	mbfl_location_handler "mbfl_fd_close ${DUP_OUFD}; dotest-debug '${FUNCNAME}: closed ${DUP_OUFD}'"

	echo 1234 >&${DUP_OUFD}
	read -u ${DUP_INFD} LINE
    }
    mbfl_location_leave

    dotest-debug LINE="$LINE"
    dotest-equal '1234' "$LINE"
}

#page
#### let's go

dotest fd-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
