# variables.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the variable manipulation functions
# Date: Wed Apr 23, 2003
#
# Abstract
#
#	To select the tests in this file:
#
#		$ make all test file=variables
#
# Copyright (c) 2004, 2005, 2013, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation; either version 3 of the License, or (at your
# option) any later version.
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

#PAGE
#### setup

source setup.sh

#page
#### array variables

function variable-find-in-array-1.1 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)

    mbfl_variable_find_in_array abc mbfl_FIELDS | dotest-output 0
}
function variable-find-in-array-1.2 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)

    mbfl_variable_find_in_array def mbfl_FIELDS | dotest-output 1
}
function variable-find-in-array-1.3 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)

    mbfl_variable_find_in_array lmn mbfl_FIELDS | dotest-output 3
}
function variable-find-in-array-1.4 () {
    declare -a mbfl_FIELDS=("abc 123" def ghi lmn)

    mbfl_variable_find_in_array gasp mbfl_FIELDS | dotest-output
}

function variable-find-in-array-2.1 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)
    mbfl_variable_element_is_in_array abc
}

### ------------------------------------------------------------------------

function variable-element-is-in-array-1.1 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)
    mbfl_variable_element_is_in_array lmn
}
function variable-element-is-in-array-1.2 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)
    ! mbfl_variable_element_is_in_array gasp
}

#page
#### colon variables

function variable-colon-variable-to-array-1.1 () {
    local v=a:b:c:d:e
    local -a mbfl_FIELDS

    mbfl_variable_colon_variable_to_array v
    dotest-equal 5 "${#mbfl_FIELDS[*]}" && \
	dotest-equal a "${mbfl_FIELDS[0]}" && \
	dotest-equal b "${mbfl_FIELDS[1]}" && \
	dotest-equal c "${mbfl_FIELDS[2]}" && \
	dotest-equal d "${mbfl_FIELDS[3]}" && \
	dotest-equal e "${mbfl_FIELDS[4]}"
}
function variable-colon-variable-to-array-1.2 () {
    local v
    local -a mbfl_FIELDS=(a b c d e)

    mbfl_variable_array_to_colon_variable v
    dotest-equal a:b:c:d:e $v
}
### ------------------------------------------------------------------------

function variable-colon-variable-to-array-2.1 () {
    local v=a:b:c:b:d:e:e

    mbfl_variable_colon_variable_drop_duplicate v
    dotest-equal a:b:c:d:e $v
}

#page
#### variables allocation

function variable-alloc-1.1 () {
    local NAME
    mbfl_variable_alloc NAME
    local -n NAMEREF=$NAME

    NAMEREF=123
    dotest-equal 123 ${!NAME}
}

#page
#### let's go

dotest variable-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
