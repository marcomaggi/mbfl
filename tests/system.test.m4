# system.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the system.sh functions
# Date: Mon Apr 11, 2005
#
# Abstract
#
#
# Copyright (c) 2005, 2013, 2018, 2020 Marco Maggi <mrc.mgg@gmail.com>
#
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 3, or (at your  option) any later
# version.
#
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
#
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
#

#PAGE
#### setup

source setup.sh

#page
#### searching entries in /etc/passwd: by name

function system-passwd-find-entry-by-name-var-1.1 () {
    mbfl_local_varref(IDX)
    mbfl_local_varref(NAME)

    mbfl_system_passwd_read
    if mbfl_system_passwd_find_entry_by_name_var mbfl_datavar(IDX) root
    then
	if mbfl_system_passwd_get_name_var mbfl_datavar(NAME) $IDX
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-passwd-find-entry-by-name-1.1 () {
    local IDX NAME
    mbfl_system_passwd_read
    if IDX=$(mbfl_system_passwd_find_entry_by_name root)
    then
	if NAME=$(mbfl_system_passwd_get_name $IDX)
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

#page
#### searching entries in /etc/passwd: by uid

function system-passwd-find-entry-by-uid-var-1.1 () {
    mbfl_local_varref(IDX)
    mbfl_local_varref(NAME)

    mbfl_system_passwd_read
    if mbfl_system_passwd_find_entry_by_uid_var mbfl_datavar(IDX) 0
    then
	if mbfl_system_passwd_get_name_var mbfl_datavar(NAME) $IDX
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-passwd-find-entry-by-uid-1.1 () {
    local IDX NAME
    mbfl_system_passwd_read
    if IDX=$(mbfl_system_passwd_find_entry_by_uid 0)
    then
	if NAME=$(mbfl_system_passwd_get_name $IDX)
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

#page
#### /etc/passwd: conversion between names and UIDs

function system-passwd-uid-to-name-var-1.1 () {
    mbfl_local_varref(USER_NAME)

    if mbfl_system_passwd_read
    then
	if mbfl_system_passwd_uid_to_name_var mbfl_datavar(USER_NAME) 0
	then dotest-equal 'root' "$USER_NAME"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-passwd-uid-to-name-1.1 () {
    if mbfl_system_passwd_read
    then mbfl_system_passwd_uid_to_name 0 | dotest-output 'root'
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-passwd-name-to-uid-var-1.1 () {
    mbfl_local_varref(USER_ID)

    if mbfl_system_passwd_read
    then
	if mbfl_system_passwd_name_to_uid_var mbfl_datavar(USER_ID) 'root'
	then dotest-equal 0 "$USER_ID"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-passwd-name-to-uid-1.1 () {
    if mbfl_system_passwd_read
    then mbfl_system_passwd_name_to_uid 'root' | dotest-output 0
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-passwd-name-to-numerical-uid-1.1 () {
    mbfl_system_user_name_to_numerical_id 'root' | dotest-output '0'
}

### ------------------------------------------------------------------------

function system-passwd-numerical-uid-to-name-1.1 () {
    mbfl_system_numerical_user_id_to_name 0 | dotest-output 'root'
}

#page
#### printing entries in /etc/passwd

function system-passwd-print-entries-raw-1.1 () {
    if mbfl_system_passwd_read
    then mbfl_system_passwd_print_entries >/dev/null
    fi
}

function system-passwd-print-entries-xml-2.1 () {
    if mbfl_system_passwd_read
    then mbfl_system_passwd_print_entries_as_xml >/dev/null
    fi
}

function system-passwd-print-entries-xml-3.1 () {
    if mbfl_system_passwd_read
    then mbfl_system_passwd_print_entries_as_json >/dev/null
    fi
}

#page
#### searching entries in /etc/group: by name

function system-group-find-entry-by-name-var-1.1 () {
    mbfl_local_varref(IDX)
    mbfl_local_varref(NAME)

    mbfl_system_group_read
    if mbfl_system_group_find_entry_by_name_var mbfl_datavar(IDX) root
    then
	if mbfl_system_group_get_name_var mbfl_datavar(NAME) $IDX
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-group-find-entry-by-name-1.1 () {
    local IDX NAME
    mbfl_system_group_read
    if IDX=$(mbfl_system_group_find_entry_by_name root)
    then
	if NAME=$(mbfl_system_group_get_name $IDX)
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

#page
#### searching entries in /etc/group: by gid

function system-group-find-entry-by-gid-var-1.1 () {
    mbfl_local_varref(IDX)
    mbfl_local_varref(NAME)

    mbfl_system_group_read
    if mbfl_system_group_find_entry_by_gid_var mbfl_datavar(IDX) 0
    then
	if mbfl_system_group_get_name_var mbfl_datavar(NAME) $IDX
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-group-find-entry-by-gid-1.1 () {
    local IDX NAME
    mbfl_system_group_read
    if IDX=$(mbfl_system_group_find_entry_by_gid 0)
    then
	if NAME=$(mbfl_system_group_get_name $IDX)
	then dotest-equal root "$NAME"
	else return 1
	fi
    else return 1
    fi
}

#page
#### printing entries in /etc/group

function system-group-print-entries-raw-1.1 () {
    if mbfl_system_group_read
    then mbfl_system_group_print_entries >/dev/null
    fi
}

function system-group-print-entries-xml-2.1 () {
    if mbfl_system_group_read
    then mbfl_system_group_print_entries_as_xml >/dev/null
    fi
}

function system-group-print-entries-xml-3.1 () {
    if mbfl_system_group_read
    then mbfl_system_group_print_entries_as_json >/dev/null
    fi
}

#page
#### retrieving users from /etc/group

function system-group-get-user-in-group-var-1.1 () {
    mbfl_local_varref(GROUP_IDX,,  -i)
    mbfl_local_varref(USER_COUNT,, -i)
    mbfl_local_varref(USER_NAME)
    local -i USER_IDX

    if mbfl_system_group_read
    then
	if mbfl_system_group_find_entry_by_name_var mbfl_datavar(GROUP_IDX) root
	then
	    mbfl_system_group_get_users_count_var mbfl_datavar(USER_COUNT) $GROUP_IDX
	    for ((USER_IDX=0; USER_IDX < USER_COUNT; ++USER_IDX))
	    do
		mbfl_system_group_get_user_name_var mbfl_datavar(USER_NAME) $GROUP_IDX $USER_IDX
		dotest-equal 'root' "$USER_NAME"
	    done
	else return 1
	fi
    else return 1
    fi
}

function system-group-get-user-in-group-1.1 () {
    local -i GROUP_IDX USER_COUNT USER_IDX
    local USER_NAME

    if mbfl_system_group_read
    then
	if GROUP_IDX=$(mbfl_system_group_find_entry_by_name root)
	then
	    USER_COUNT=$(mbfl_system_group_get_users_count $GROUP_IDX)
	    for ((USER_IDX=0; USER_IDX < USER_COUNT; ++USER_IDX))
	    do mbfl_system_group_get_user_name $GROUP_IDX $USER_IDX | dotest-output 'root'
	    done
	else return 1
	fi
    else return 1
    fi
}

#page
#### /etc/group: conversion between names and GIDs

function system-group-gid-to-name-var-1.1 () {
    mbfl_local_varref(GROUP_NAME)

    if mbfl_system_group_read
    then
	if mbfl_system_group_gid_to_name_var mbfl_datavar(GROUP_NAME) 0
	then dotest-equal 'root' "$GROUP_NAME"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-group-gid-to-name-1.1 () {
    if mbfl_system_group_read
    then mbfl_system_group_gid_to_name 0 | dotest-output 'root'
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-group-name-to-gid-var-1.1 () {
    mbfl_local_varref(GROUP_ID)

    if mbfl_system_group_read
    then
	if mbfl_system_group_name_to_gid_var mbfl_datavar(GROUP_ID) 'root'
	then dotest-equal 0 "$GROUP_ID"
	else return 1
	fi
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-group-name-to-gid-1.1 () {
    if mbfl_system_group_read
    then mbfl_system_group_name_to_gid 'root' | dotest-output 0
    else return 1
    fi
}

### ------------------------------------------------------------------------

function system-group-name-to-numerical-gid-1.1 () {
    mbfl_system_group_name_to_numerical_id 'root' | dotest-output '0'
}

### ------------------------------------------------------------------------

function system-group-numerical-gid-to-name-1.1 () {
    mbfl_system_numerical_group_id_to_name 0 | dotest-output 'root'
}

#page
#### file permissions functions

function system-symbolic-to-octal-1.1 () {
    mbfl_system_symbolic_to_octal_permissions 'rwx' | dotest-output '7'
}
function system-symbolic-to-octal-1.2 () {
    mbfl_system_symbolic_to_octal_permissions 'r-x' | dotest-output '5'
}
function system-symbolic-to-octal-1.3 () {
    mbfl_system_octal_to_symbolic_permissions '7' | dotest-output 'rwx'
}
function system-symbolic-to-octal-1.4 () {
    mbfl_system_octal_to_symbolic_permissions '5' | dotest-output 'r-x'
}

#page
#### end of tests

dotest system-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
