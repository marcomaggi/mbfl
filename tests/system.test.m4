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

mbfl_load_library("$MBFL_TESTS_LIBMBFL")
mbfl_load_library("$MBFL_TESTS_LIBMBFLTEST")

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
#### tests for "whoami" from GNU Coreutils

function system-users-whoami-1.0 () {
    mbfl_local_varref(USERNAME)
    local RV1 RV2

    mbfl_system_whoami_var mbfl_datavar(USERNAME)
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'whoami exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the username is: %s' "$USERNAME"
}

function system-users-whoami-1.1 () {
    local USERNAME
    local RV1 RV2

    USERNAME=$(mbfl_system_whoami)
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'whoami exit status' && \
	dotest-equal 0 $RV2 'not empty result'&& \
	dotest-printf 'the username is: %s' "$USERNAME"
}

#page
#### tests for "id" from GNU Coreutils

function system-users-id-1.0 () {
    mbfl_local_varref(OUTPUT)
    local RV1 RV2

    mbfl_system_id_var mbfl_datavar(OUTPUT)
    RV1=$?
    mbfl_string_is_not_empty "$OUTPUT"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the output is: %s' "$OUTPUT"
}

function system-users-id-1.1 () {
    local USERNAME
    local RV1 RV2

    USERNAME=$(mbfl_system_id '--user')
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the username is: %s' "$USERNAME"
}

### ------------------------------------------------------------------------

function system-users-id-2.0.1 () {
    mbfl_local_varref(USERID)
    local RV1 RV2

    mbfl_system_effective_user_id_var mbfl_datavar(USERID)
    RV1=$?
    mbfl_string_is_not_empty "$USERID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective user id is: %s' "$USERID"
}
function system-users-id-2.0.2 () {
    local USERID
    local RV1 RV2

    USERID=$(mbfl_system_effective_user_id)
    RV1=$?
    mbfl_string_is_not_empty "$USERID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective user id is: %s' "$USERID"
}

### ------------------------------------------------------------------------

function system-users-id-2.1.1 () {
    mbfl_local_varref(GROUPID)
    local RV1 RV2

    mbfl_system_effective_group_id_var mbfl_datavar(GROUPID)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective group id is: %s' "$GROUPID"
}
function system-users-id-2.1.2 () {
    local GROUPID
    local RV1 RV2

    GROUPID=$(mbfl_system_effective_group_id)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective group id is: %s' "$GROUPID"
}

### ------------------------------------------------------------------------

function system-users-id-2.2.1 () {
    mbfl_local_varref(USERNAME)
    local RV1 RV2

    mbfl_system_effective_user_name_var mbfl_datavar(USERNAME)
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective user name is: %s' "$USERNAME"
}
function system-users-id-2.2.2 () {
    local USERNAME
    local RV1 RV2

    USERNAME=$(mbfl_system_effective_user_name)
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective user name is: %s' "$USERNAME"
}

### ------------------------------------------------------------------------

function system-users-id-2.3.1 () {
    mbfl_local_varref(GROUPNAME)
    local RV1 RV2

    mbfl_system_effective_group_name_var mbfl_datavar(GROUPNAME)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective group name is: %s' "$GROUPNAME"
}
function system-users-id-2.3.2 () {
    local GROUPNAME
    local RV1 RV2

    GROUPNAME=$(mbfl_system_effective_group_name)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the effective group name is: %s' "$GROUPNAME"
}

### ------------------------------------------------------------------------

function system-users-id-2.4.1 () {
    mbfl_local_varref(USERID)
    local RV1 RV2

    mbfl_system_real_user_id_var mbfl_datavar(USERID)
    RV1=$?
    mbfl_string_is_not_empty "$USERID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real user id is: %s' "$USERID"
}
function system-users-id-2.4.2 () {
    local USERID
    local RV1 RV2

    USERID=$(mbfl_system_real_user_id)
    RV1=$?
    mbfl_string_is_not_empty "$USERID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real user id is: %s' "$USERID"
}

### ------------------------------------------------------------------------

function system-users-id-2.5.1 () {
    mbfl_local_varref(GROUPID)
    local RV1 RV2

    mbfl_system_real_group_id_var mbfl_datavar(GROUPID)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real group id is: %s' "$GROUPID"
}
function system-users-id-2.5.2 () {
    local GROUPID
    local RV1 RV2

    GROUPID=$(mbfl_system_real_group_id)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPID"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real group id is: %s' "$GROUPID"
}

### ------------------------------------------------------------------------

function system-users-id-2.6.1 () {
    mbfl_local_varref(USERNAME)
    local RV1 RV2

    mbfl_system_real_user_name_var mbfl_datavar(USERNAME)
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real user name is: %s' "$USERNAME"
}
function system-users-id-2.6.2 () {
    local USERNAME
    local RV1 RV2

    USERNAME=$(mbfl_system_real_user_name)
    RV1=$?
    mbfl_string_is_not_empty "$USERNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real user name is: %s' "$USERNAME"
}

### ------------------------------------------------------------------------

function system-users-id-2.7.1 () {
    mbfl_local_varref(GROUPNAME)
    local RV1 RV2

    mbfl_system_real_group_name_var mbfl_datavar(GROUPNAME)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real group name is: %s' "$GROUPNAME"
}
function system-users-id-2.7.2 () {
    local GROUPNAME
    local RV1 RV2

    GROUPNAME=$(mbfl_system_real_group_name)
    RV1=$?
    mbfl_string_is_not_empty "$GROUPNAME"
    RV2=$?

    dotest-equal 0 $RV1 'id exit status' && \
	dotest-equal 0 $RV2 'not empty result' && \
	dotest-printf 'the real group name is: %s' "$GROUPNAME"
}

#page
#### end of tests

dotest system-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
