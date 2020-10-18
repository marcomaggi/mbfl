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
