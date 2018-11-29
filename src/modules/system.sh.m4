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
#### module initialisation

# This exists, but does nothing, for backwards compatibility.
#
function mbfl_system_enable_programs () {
    :
}

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
	#             username          passwd            uid      gid      gecos dir                shell
	local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([0-9]+):(.*):([a-zA-Z0-9_/\-]+):([a-zA-Z0-9_/\-]+)'
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
		else
		    :
		fi
	    done </etc/passwd
	}
	then
	    if ((0 < mbfl_system_PASSWD_COUNT))
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
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(mbfl_INDEX, 2, passwd entry index)
    mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:$1]}
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
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_THE_NAME, 2, user name)
    local -i mbfl_I

    for ((mbfl_I=0; mbfl_I < mbfl_system_PASSWD_COUNT; ++mbfl_I))
    do
	if mbfl_string_equal "$mbfl_THE_NAME" "${mbfl_system_PASSWD_ENTRIES[${mbfl_I}:name]}"
	then
	    mbfl_RESULT_VARREF=$mbfl_I
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
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_THE_UID, 2, user id)
    local -i mbfl_I

    for ((mbfl_I=0; mbfl_I < mbfl_system_PASSWD_COUNT; ++mbfl_I))
    do
	if mbfl_string_equal "$mbfl_THE_UID" "${mbfl_system_PASSWD_ENTRIES[${mbfl_I}:uid]}"
	then
	    mbfl_RESULT_VARREF=$mbfl_I
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

function mbfl_system_passwd_uid_to_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(mbfl_THE_UID,       2, user id)
    local -i mbfl_USER_INDEX
    if mbfl_system_passwd_find_entry_by_uid_var mbfl_USER_INDEX $mbfl_THE_UID
    then mbfl_system_passwd_get_name_var mbfl_RESULT_VARREF $mbfl_USER_INDEX
    else return 1
    fi
}
function mbfl_system_passwd_uid_to_name () {
    mbfl_mandatory_integer_parameter(THE_UID, 1, user id)
    local -i USER_INDEX
    if mbfl_system_passwd_find_entry_by_uid_var USER_INDEX $THE_UID
    then mbfl_system_passwd_get_name $USER_INDEX
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_system_passwd_name_to_uid_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_THE_NAME,              2, user name)
    local -i mbfl_USER_INDEX
    if mbfl_system_passwd_find_entry_by_name_var mbfl_USER_INDEX "$mbfl_THE_NAME"
    then mbfl_system_passwd_get_uid_var mbfl_RESULT_VARREF $mbfl_USER_INDEX
    else return 1
    fi
}

function mbfl_system_passwd_name_to_uid () {
    mbfl_mandatory_parameter(THE_NAME, 1, user name)
    local -i USER_INDEX
    if mbfl_system_passwd_find_entry_by_name_var USER_INDEX "$THE_NAME"
    then mbfl_system_passwd_get_uid $USER_INDEX
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_system_numerical_user_id_to_name () {
    mbfl_mandatory_integer_parameter(THE_UID, 1, user id)
    if mbfl_system_passwd_read
    then mbfl_system_passwd_uid_to_name "$THE_UID"
    fi
}
function mbfl_system_user_name_to_numerical_id () {
    mbfl_mandatory_parameter(THE_NAME, 1, user name)
    if mbfl_system_passwd_read
    then mbfl_system_passwd_name_to_uid "$THE_NAME"
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

		    # Let's parse the "users" field.
		    if mbfl_string_is_not_empty "${mbfl_system_GROUP_ENTRIES[${mbfl_system_GROUP_COUNT}:users]}"
		    then
			{
			    local SPLITFIELD
			    local -i SPLITCOUNT i
			    mbfl_string_split "${mbfl_system_GROUP_ENTRIES[${mbfl_system_GROUP_COUNT}:users]}" ','
			    mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users:count"]=$SPLITCOUNT
			    for ((i=0; i < SPLITCOUNT; ++i))
			    do mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users:${i}"]=${SPLITFIELD[$i]}
			    done
			}
		    fi

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
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(mbfl_GROUP_INDEX, 2, group entry index)
    mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:$1]}
}
function mbfl_system_group_get_$1 () {
    mbfl_mandatory_integer_parameter(GROUP_INDEX, 1, group entry index)
    echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:$1]}"
}
]]])
MBFL_GROUP_DECLARE_GETTER(name)
MBFL_GROUP_DECLARE_GETTER(passwd)
MBFL_GROUP_DECLARE_GETTER(gid)
MBFL_GROUP_DECLARE_GETTER(users)

### ------------------------------------------------------------------------

function mbfl_system_group_get_users_count_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(mbfl_GROUP_INDEX, 2, group entry index)
    mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users:count]}
}
function mbfl_system_group_get_users_count () {
    mbfl_mandatory_integer_parameter(GROUP_INDEX, 1, group entry index)
    echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users:count]}"
}

### ------------------------------------------------------------------------

function mbfl_system_group_get_user_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(mbfl_GROUP_INDEX,   2, group entry index)
    mbfl_mandatory_integer_parameter(mbfl_USER_INDEX,    3, user index)
    mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users:${mbfl_USER_INDEX}]}
}
function mbfl_system_group_get_user_name () {
    mbfl_mandatory_integer_parameter(GROUP_INDEX, 1, group entry index)
    mbfl_mandatory_integer_parameter(USER_INDEX,  2, user index)
    echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users:${USER_INDEX}]}"
}

#page
#### searching group entries

function mbfl_system_group_find_entry_by_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_THE_NAME, 2, group name)
    local -i mbfl_I

    for ((mbfl_I=0; mbfl_I < mbfl_system_GROUP_COUNT; ++mbfl_I))
    do
	if mbfl_string_equal "$mbfl_THE_NAME" "${mbfl_system_GROUP_ENTRIES[${mbfl_I}:name]}"
	then
	    mbfl_RESULT_VARREF=$mbfl_I
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
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_THE_GID, 2, group id)
    local -i mbfl_I

    for ((mbfl_I=0; mbfl_I < mbfl_system_GROUP_COUNT; ++mbfl_I))
    do
	if mbfl_string_equal "$mbfl_THE_GID" "${mbfl_system_GROUP_ENTRIES[${mbfl_I}:gid]}"
	then
	    mbfl_RESULT_VARREF=$mbfl_I
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
#### group id conversion

function mbfl_system_group_gid_to_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_integer_parameter(mbfl_THE_GID,       2, group id)
    local -i mbfl_GROUP_INDEX
    if mbfl_system_group_find_entry_by_gid_var mbfl_GROUP_INDEX $mbfl_THE_GID
    then mbfl_system_group_get_name_var mbfl_RESULT_VARREF $mbfl_GROUP_INDEX
    else return 1
    fi
}
function mbfl_system_group_gid_to_name () {
    mbfl_mandatory_integer_parameter(THE_GID, 1, group id)
    local -i GROUP_INDEX
    if mbfl_system_group_find_entry_by_gid_var GROUP_INDEX $THE_GID
    then mbfl_system_group_get_name $GROUP_INDEX
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_system_group_name_to_gid_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_THE_NAME,              2, group name)
    local -i GROUP_INDEX
    if mbfl_system_group_find_entry_by_name_var GROUP_INDEX "$mbfl_THE_NAME"
    then mbfl_system_group_get_gid_var mbfl_RESULT_VARREF $GROUP_INDEX
    else return 1
    fi
}

function mbfl_system_group_name_to_gid () {
    mbfl_mandatory_parameter(THE_NAME, 1, group name)
    local -i GROUP_INDEX
    if mbfl_system_group_find_entry_by_name_var GROUP_INDEX "$THE_NAME"
    then mbfl_system_group_get_gid $GROUP_INDEX
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_system_numerical_group_id_to_name () {
    mbfl_mandatory_integer_parameter(THE_GID, 1, group id)
    if mbfl_system_group_read
    then mbfl_system_group_gid_to_name "$THE_GID"
    fi
}
function mbfl_system_group_name_to_numerical_id () {
    mbfl_mandatory_parameter(THE_NAME, 1, group name)
    if mbfl_system_group_read
    then mbfl_system_group_name_to_gid "$THE_NAME"
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
