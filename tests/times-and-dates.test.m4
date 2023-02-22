# times-and-dates.test --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the times and dates library
# Date: Nov  3, 2018
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=times-and-dates-
#
#	will select these tests.
#
# Copyright (c) 2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
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

mbfl_load_library("$MBFL_TESTS_LIBMBFL_CORE")
mbfl_load_library("$MBFL_TESTS_LIBMBFL_TEST")

mbfl_times_and_dates_enable


#### current time and date

function times-and-dates--current-1.1 () {
    mbfl_date_current_year
}

function times-and-dates--current-1.2 () {
    mbfl_date_current_month
}

function times-and-dates--current-1.3 () {
    mbfl_date_current_day
}

function times-and-dates--current-1.4 () {
    mbfl_date_current_hour
}

function times-and-dates--current-1.5 () {
    mbfl_date_current_minute
}

function times-and-dates--current-1.6 () {
    mbfl_date_current_second
}

function times-and-dates--current-1.7 () {
    mbfl_date_current_date
}

function times-and-dates--current-1.8 () {
    mbfl_date_current_time
}


#### special formats

function times-and-dates--current-2.1 () {
    mbfl_date_email_timestamp
}

function times-and-dates--current-2.2 () {
    mbfl_date_iso_timestamp
}


#### let's go

dotest times-and-dates-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
