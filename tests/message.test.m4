y# message.test --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the message library
# Date: Mon Sep 13, 2004
#
# Abstract
#
#
# Copyright (c) 2004, 2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
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


## ------------------------------------------------------------
## Setup.
## ------------------------------------------------------------

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_TEST")



function message-1.1 () {
    mbfl_message_string "abcde\n" 2>&1 | dotest-output abcde
}



function message-2.1 () {
    mbfl_message_verbose abcde\n 2>&1 | dotest-output
}

function message-2.2 () {
    {
	mbfl_set_option_verbose
	mbfl_message_verbose "abcde\n"
	mbfl_unset_option_verbose
    } 2>&1 | dotest-output "<unknown>: abcde"
}



function message-3.1 () {
    {
	mbfl_set_option_debug
	mbfl_message_debug abcde
	mbfl_unset_option_debug
    }  2>&1 | dotest-output "<unknown>: debug: abcde"
}



function message-4.1 () {
    mbfl_message_warning abcde 2>&1 | dotest-output "<unknown>: warning: abcde"
}

function message-5.1 () {
    mbfl_message_error abcde 2>&1 | dotest-output "<unknown>: error: abcde"
}


#### let's go

dotest message-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
