# times-and-dates.sh --
#
# Part of: Marco's BASH functions library
# Contents: times and dates module
# Date: Nov  3, 2018
#
# Abstract
#
#       This is  a collection of times  and dates functions for  the GNU
#       BASH shell.
#
# Copyright (c) 2018, 2020, 2024 Marco Maggi <mrc.mgg@gmail.com>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
# your option) any later version.
#
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
#
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA.
#


#### module initialisation

function mbfl_times_and_dates_enable () {
    :
}

MBFL_DEFINE_QQ_MACRO()
MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS()

function mbfl_exec_date () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_DATE"
    then mbfl_program_exec "$mbfl_PROGRAM_DATE" "$@"
    else
	mbfl_message_error_printf 'program "date" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_DATE"
	return_because_program_not_found
    fi
}
function mbfl_exec_date_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    shift
    RV=$(mbfl_exec_date "$@")
}

function mbfl_exec_date_format () {
    mbfl_mandatory_parameter(FORMAT, 1, date format)
    shift
    mbfl_exec_date "$FORMAT" "$@"
}
function mbfl_exec_date_format_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    shift
    RV=$(mbfl_exec_date_format "$@")
}


#### current time and date

function mbfl_date_current_year () {
    mbfl_exec_date_format '+%Y'
}

function mbfl_date_current_month () {
    mbfl_exec_date_format '+%m'
}

function mbfl_date_current_day () {
    mbfl_exec_date_format '+%d'
}

function mbfl_date_current_hour () {
    mbfl_exec_date_format '+%H'
}

function mbfl_date_current_minute () {
    mbfl_exec_date_format '+%M'
}

function mbfl_date_current_second () {
    mbfl_exec_date_format '+%S'
}

function mbfl_date_current_date () {
    mbfl_exec_date_format '+%F'
}

function mbfl_date_current_time () {
    mbfl_exec_date_format '+%T'
}


#### special formats

function mbfl_date_email_timestamp () {
    mbfl_exec_date --rfc-2822
}

function mbfl_date_iso_timestamp () {
    mbfl_exec_date --iso-8601=ns
}


#### Epoch conversion

function mbfl_date_to_epoch_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    mbfl_mandatory_parameter(TIMESTAMP, 2, timestamp in ISO 8601 format)

    mbfl_exec_date_var _(RV) --date=QQ(TIMESTAMP) '+%s'
}
function mbfl_date_from_epoch_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    mbfl_mandatory_parameter(EPOCH_SECONDS, 2, number of seconds from the Epoch)
    declare FMT

    printf -v FMT '@%s' QQ(EPOCH_SECONDS)
    mbfl_exec_date_var _(RV) --date=QQ(FMT) '+%Y-%m-%dT%H:%M:%S%z'
}

### end of file
# Local Variables:
# mode: sh
# End:
