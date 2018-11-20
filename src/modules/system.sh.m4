# system.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: system interface functions
# Date: Mon Apr 11, 2005
#
# Abstract
#
#
#
# Copyright    (c)    2005,    2009,     2013,    2018    Marco    Maggi
# <marco.maggi-ipsu@poste.it>
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
#### reading entries from /etc/passwd

declare -A mbfl_system_PASSWD_ENTRIES
declare -i mbfl_system_PASSWD_COUNT=0

function mbfl_system_passwd_reset () {
    # Reset the array to empty.
    mbfl_system_PASSWD_ENTRIES=()
    mbfl_system_PASSWD_COUNT=0
}

function mbfl_system_passwd_read () {
    if ((0 == mbfl_system_PASSWD_COUNT))
    then
	local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([0-9]+):([a-zA-Z0-9_/\-]*):([a-zA-Z0-9_/\-]+):([a-zA-Z0-9_/\-]+)'
	local LINE

	if {
	    while IFS= read LINE
	    do
		if [[ $LINE =~ $REX ]]
		then
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:name"]=${BASH_REMATCH[1]}
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:passwd"]=${BASH_REMATCH[2]}
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:uid"]=${BASH_REMATCH[3]}
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:gid"]=${BASH_REMATCH[4]}
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:gecos"]=${BASH_REMATC[5]}
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:dir"]=${BASH_REMATCH[6]}
		    mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:shell"]=${BASH_REMATCH[7]}
		    let ++mbfl_system_PASSWD_COUNT
		fi
	    done </etc/passwd
	}
	then
	    if ((0 < mbfl_system_GROUP_COUNT))
	    then return 0
	    else return 1
	    fi
	else return 1
	fi
    else return 0
    fi
}

#page
#### printing entries from /etc/passwd

function mbfl_system_passwd_print_entries () {
    local -i i

    for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
    do
	printf "name='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
	printf "passwd='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
	printf "uid=%d "	"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
	printf "gid=%d "	"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
	printf "gecos='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
	printf "dir='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
	printf "shell='%s'\n"	"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
    done
}

function mbfl_system_passwd_print_entries_as_xml () {
    local -i i

    for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
    do
	printf '<entry '
	printf "name='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
	printf "passwd='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
	printf "uid='%d' "	"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
	printf "gid='%d' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
	printf "gecos='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
	printf "dir='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
	printf "shell='%s'"	"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
	printf '/>\n'
    done
}

function mbfl_system_passwd_print_entries_as_json () {
    local -i i

    for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
    do
	printf '"entry": { '
	printf '"name": "%s", '		"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
	printf '"passwd": "%s", '	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
	printf '"uid": %d, '		"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
	printf '"gid": %d, '		"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
	printf '"gecos": "%s", '	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
	printf '"dir": "%s", '		"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
	printf '"shell": "%s"'		"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
	printf ' }\n'
    done
}

#page
#### passwd internal array getters

m4_define([[[MBFL_PASSWD_DECLARE_GETTER]]],[[[
function mbfl_system_passwd_get_$1_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(INDEX, 2, passwd entry index)
    RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${INDEX}:$1]}
}
function mbfl_system_passwd_get_$1 () {
    mbfl_mandatory_integer_parameter(INDEX, 1, passwd entry index)
    echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:$1]}"
}
]]])
MBFL_PASSWD_DECLARE_GETTER(name)
MBFL_PASSWD_DECLARE_GETTER(passwd)
MBFL_PASSWD_DECLARE_GETTER(uid)
MBFL_PASSWD_DECLARE_GETTER(gid)
MBFL_PASSWD_DECLARE_GETTER(gecos)
MBFL_PASSWD_DECLARE_GETTER(dir)
MBFL_PASSWD_DECLARE_GETTER(shell)

#page
#### searching passwd entries

function mbfl_system_passwd_find_entry_by_name_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(THE_NAME, 2, user name)
    local -i i

    for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
    do
	if mbfl_string_equal "$THE_NAME" "${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
	then
	    RESULT_VARREF=$i
	    return 0
	fi
    done
    return 1
}

function mbfl_system_passwd_find_entry_by_name () {
    mbfl_mandatory_parameter(THE_NAME, 1, user name)
    local RESULT_VARNAME
    if mbfl_system_passwd_find_entry_by_name_var RESULT_VARNAME "$THE_NAME"
    then echo "$RESULT_VARNAME"
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_system_passwd_find_entry_by_uid_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(THE_UID, 2, user id)
    local -i i

    for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
    do
	if mbfl_string_equal "$THE_UID" "${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
	then
	    RESULT_VARREF=$i
	    return 0
	fi
    done
    return 1
}

function mbfl_system_passwd_find_entry_by_uid () {
    mbfl_mandatory_parameter(THE_UID, 1, user id)
    local RESULT_VARNAME
    if mbfl_system_passwd_find_entry_by_uid_var RESULT_VARNAME "$THE_UID"
    then echo "$RESULT_VARNAME"
    else return 1
    fi
}

#page
#### user id conversion

function mbfl_system_enable_programs () {
    :
}
function mbfl_system_numerical_user_id_to_name () {
    mbfl_mandatory_integer_parameter(THE_UID, 1, numerical user id)
    local IDX
    mbfl_system_passwd_read
    if mbfl_system_passwd_find_entry_by_uid_var IDX $THE_UID
    then mbfl_system_passwd_get_name $IDX
    else return 1
    fi
}
function mbfl_system_user_name_to_numerical_id () {
    mbfl_mandatory_parameter(THE_NAME, 1, user name)
    local IDX
    mbfl_system_passwd_read
    if mbfl_system_passwd_find_entry_by_name_var IDX "$THE_NAME"
    then mbfl_system_passwd_get_uid $IDX
    else return 1
    fi
}

#page
#### reading entries from /etc/group

declare -A mbfl_system_GROUP_ENTRIES
declare -i mbfl_system_GROUP_COUNT=0

function mbfl_system_group_reset () {
    # Reset the array to empty.
    mbfl_system_GROUP_ENTRIES=()
    mbfl_system_GROUP_COUNT=0
}

function mbfl_system_group_read () {
    if ((0 == mbfl_system_GROUP_COUNT))
    then
	#             groupname         password          gid      userlist
	local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([a-zA-Z0-9_/,\-]*)'
	local LINE

	if {
	    while IFS= read LINE
	    do
		if [[ $LINE =~ $REX ]]
		then
		    mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:name"]=${BASH_REMATCH[1]}
		    mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:passwd"]=${BASH_REMATCH[2]}
		    mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:gid"]=${BASH_REMATCH[3]}
		    mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users"]=${BASH_REMATCH[4]}
		    let ++mbfl_system_GROUP_COUNT
		fi
	    done </etc/group
	}
	then
	    if ((0 < mbfl_system_GROUP_COUNT))
	    then return 0
	    else return 1
	    fi
	else return 1
	fi
    else return 0
    fi
}

#page
#### printing entries from /etc/group

function mbfl_system_group_print_entries () {
    local -i i

    for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
    do
	printf "name='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
	printf "passwd='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
	printf "gid=%d "	"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
	printf "users='%s'\n"	"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
    done
}

function mbfl_system_group_print_entries_as_xml () {
    local -i i

    for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
    do
	printf '<entry '
	printf "name='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
	printf "passwd='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
	printf "gid='%d' "	"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
	printf "users='%s'"	"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
	printf '/>\n'
    done
}

function mbfl_system_group_print_entries_as_json () {
    local -i i

    for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
    do
	printf '"entry": { '
	printf '"name": "%s", '		"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
	printf '"passwd": "%s", '	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
	printf '"gid": %d, '		"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
	printf '"users": "%s"'		"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
	printf ' }\n'
    done
}

#page
#### group internal array getters

m4_define([[[MBFL_GROUP_DECLARE_GETTER]]],[[[
function mbfl_system_group_get_$1_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(INDEX, 2, group entry index)
    RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${INDEX}:$1]}
}
function mbfl_system_group_get_$1 () {
    mbfl_mandatory_integer_parameter(INDEX, 1, group entry index)
    echo "${mbfl_system_GROUP_ENTRIES[${INDEX}:$1]}"
}
]]])
MBFL_GROUP_DECLARE_GETTER(name)
MBFL_GROUP_DECLARE_GETTER(passwd)
MBFL_GROUP_DECLARE_GETTER(gid)
MBFL_GROUP_DECLARE_GETTER(users)

#page
#### searching group entries

function mbfl_system_group_find_entry_by_name_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(THE_NAME, 2, group name)
    local -i i

    for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
    do
	if mbfl_string_equal "$THE_NAME" "${mbfl_system_GROUP_ENTRIES[${i}:name]}"
	then
	    RESULT_VARREF=$i
	    return 0
	fi
    done
    return 1
}

function mbfl_system_group_find_entry_by_name () {
    mbfl_mandatory_parameter(THE_NAME, 1, group name)
    local RESULT_VARNAME
    if mbfl_system_group_find_entry_by_name_var RESULT_VARNAME "$THE_NAME"
    then echo "$RESULT_VARNAME"
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_system_group_find_entry_by_gid_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(THE_GID, 2, group id)
    local -i i

    for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
    do
	if mbfl_string_equal "$THE_GID" "${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
	then
	    RESULT_VARREF=$i
	    return 0
	fi
    done
    return 1
}

function mbfl_system_group_find_entry_by_gid () {
    mbfl_mandatory_parameter(THE_GID, 1, group id)
    local RESULT_VARNAME
    if mbfl_system_group_find_entry_by_gid_var RESULT_VARNAME "$THE_GID"
    then echo "$RESULT_VARNAME"
    else return 1
    fi
}

#page
#### file permissions

declare -a mbfl_symbolic_permissions
mbfl_symbolic_permissions[0]='---'
mbfl_symbolic_permissions[1]='--x'
mbfl_symbolic_permissions[2]='-w-'
mbfl_symbolic_permissions[3]='-wx'
mbfl_symbolic_permissions[4]='r--'
mbfl_symbolic_permissions[5]='r-x'
mbfl_symbolic_permissions[6]='rw-'
mbfl_symbolic_permissions[7]='rwx'

function mbfl_system_symbolic_to_octal_permissions () {
    mbfl_mandatory_parameter(MODE, 1, symbolic permissions)
    local -i i
    for ((i=0; i < 8; ++i))
    do
	if mbfl_string_equal "${mbfl_symbolic_permissions[$i]}" "$MODE"
	then
            printf "%s\n" $i
            return 0
        fi
    done
    return 1
}
function mbfl_system_octal_to_symbolic_permissions () {
    mbfl_mandatory_parameter(MODE, 1, symbolic permissions)
    printf '%s\n' "${mbfl_symbolic_permissions[${MODE}]}"
}

### end of file
# Local Variables:
# mode: sh
# End:
