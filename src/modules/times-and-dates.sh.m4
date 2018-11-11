#! /bin/bash
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
# Copyright (c) 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
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

#page
#### module initialisation

function mbfl_times_and_dates_enable () {
    mbfl_declare_program date
}

function mbfl_exec_date () {
    local DATE
    mbfl_program_found_var DATE date || exit $?
    mbfl_program_exec "$DATE" "$@"
}

function mbfl_exec_date_format () {
    mbfl_mandatory_parameter(FORMAT, 1, date format)
    shift
    mbfl_exec_date "$FORMAT" "$@"
}

#page
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

#page
#### special formats

function mbfl_date_email_timestamp () {
    mbfl_exec_date --rfc-2822
}

function mbfl_date_iso_timestamp () {
    mbfl_exec_date --iso-8601=ns
}

### end of file
# Local Variables:
# mode: sh
# End:
