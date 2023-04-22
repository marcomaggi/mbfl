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


#### simple FIFO operations

# This single process opens a FIFO for both reading and writing.
#
function fifo-simple-1.1 () {
    declare -r THE_FIFO="$(dotest-mkpathname the-fifo)"

    mbfl_location_enter
    {
	mbfl_location_handler 'dotest-clean-files'
	mbfl_location_handler 'mbfl_fd_close 5'

	mbfl_exec_mkfifo "$THE_FIFO"
	mbfl_fd_open_input_output 5 "$THE_FIFO"

	printf 'ciao\n' >&5
	read -u 5
	dotest-equal 'ciao' "$REPLY"
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
