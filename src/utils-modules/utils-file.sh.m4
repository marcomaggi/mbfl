#
# Part of: Marco's Bash Functions Utilities Library
# Contents: file system functions
# Date: Mon Nov 16, 2020
#
# Abstract
#
#
#
# Copyright (C) 2020 Marco Maggi <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#


#### file system operations: directory normalisation

function mbflutils_file_init_directory_struct () {
    mbfl_mandatory_nameref_parameter(DIRECTORY_STRUCT,1, directory array name)
    mbfl_mandatory_parameter(DIRECTORY_PATHNAME,      2, directory pathname)
    mbfl_mandatory_parameter(DIRECTORY_OWNER,         3, directory owner)
    mbfl_mandatory_parameter(DIRECTORY_GROUP,         4, directory group)
    mbfl_mandatory_parameter(DIRECTORY_MODE,          5, directory mode)
    mbfl_mandatory_parameter(DIRECTORY_DESCRIPTION,   6, description)

    mbfl_slot_set(DIRECTORY_STRUCT,PATHNAME,	"$DIRECTORY_PATHNAME")
    mbfl_slot_set(DIRECTORY_STRUCT,OWNER,	"$DIRECTORY_OWNER")
    mbfl_slot_set(DIRECTORY_STRUCT,GROUP,	"$DIRECTORY_GROUP")
    mbfl_slot_set(DIRECTORY_STRUCT,MODE,	"$DIRECTORY_MODE")
    mbfl_slot_set(DIRECTORY_STRUCT,DESCRIPTION, "$DIRECTORY_DESCRIPTION")
}

function mbflutils_file_normalise_directory () {
    mbfl_mandatory_nameref_parameter(DIRECTORY_STRUCT, 1, directory array name)

    # We use  the printf format directive  "%b" to print the  description, so we expand  some of the
    # backslash escape sequences.
    mbfl_message_verbose_printf 'normalising owner, group and access permissions of %b: "%s"\n' \
				"mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"

    if mbflutils_file_p_normalise_directory_check
    then
	if mbflutils_file_p_normalise_directory_access_permissions
	then
	    if mbflutils_file_p_normalise_directory_owner
	    then mbflutils_file_p_normalise_directory_group
	    else return $?
	    fi
	else return $?
	fi
    else return $?
    fi
}

# Check if we can act upon the directory.
#
function mbflutils_file_p_normalise_directory_check () {
    if ! mbfl_file_is_directory "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    'non-existent %b: "%s"' \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
	return_because_failure
    fi
    if ! mbfl_directory_is_writable "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    'non-writable %b: "%s"' \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
	return_because_failure
    fi
}

function mbflutils_file_p_normalise_directory_access_permissions () {
    local -r TEMPLATE='setting to "%s" the access permissions of the %b: "%s"'

    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" mbfl_slot_ref(DIRECTORY_STRUCT,MODE) \
	"mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    if ! mbfl_file_set_permissions $DIRECTORY_MODE "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" mbfl_slot_ref(DIRECTORY_STRUCT,MODE) \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_directory_owner () {
    local -r TEMPLATE='setting to "%s" the owner of the %b: "%s"'

    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" \
	"mbfl_slot_ref(DIRECTORY_STRUCT,OWNER)" "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    if ! mbfl_file_set_owner "mbfl_slot_ref(DIRECTORY_STRUCT,OWNER)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf "$TEMPLATE" "mbfl_slot_ref(DIRECTORY_STRUCT,OWNER)" "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_directory_group () {
    local -r TEMPLATE='setting to "%s" the group of the %b: "%s"'

    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" "mbfl_slot_ref(DIRECTORY_STRUCT,GROUP)" \
	"mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    if ! mbfl_file_set_group "mbfl_slot_ref(DIRECTORY_STRUCT,GROUP)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" "mbfl_slot_ref(DIRECTORY_STRUCT,GROUP)" \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
	exit_because_failure
    fi
}


#### file system operations: file normalisation

function mbflutils_file_init_file_struct () {
    mbfl_mandatory_nameref_parameter(FILE_STRUCT,1, file array name)
    mbfl_mandatory_parameter(FILE_PATHNAME,      2, file pathname)
    mbfl_mandatory_parameter(FILE_OWNER,         3, file owner)
    mbfl_mandatory_parameter(FILE_GROUP,         4, file group)
    mbfl_mandatory_parameter(FILE_MODE,          5, file mode)
    mbfl_mandatory_parameter(FILE_DESCRIPTION,   6, description)

    mbfl_slot_set(FILE_STRUCT,PATHNAME,		"$FILE_PATHNAME")
    mbfl_slot_set(FILE_STRUCT,OWNER,		"$FILE_OWNER")
    mbfl_slot_set(FILE_STRUCT,GROUP,		"$FILE_GROUP")
    mbfl_slot_set(FILE_STRUCT,MODE,		"$FILE_MODE")
    mbfl_slot_set(FILE_STRUCT,DESCRIPTION,	"$FILE_DESCRIPTION")
}

function mbflutils_file_normalise_file () {
    mbfl_mandatory_nameref_parameter(FILE_STRUCT, 1, file array name)

    # We use  the printf format directive  "%b" to print the  description, so we expand  some of the
    # backslash escape sequences.
    mbfl_message_verbose_printf 'normalising owner, group and access permissions of %b: "%s"\n' \
				"mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"

    if mbflutils_file_p_normalise_file_check
    then
	if mbflutils_file_p_normalise_file_access_permissions
	then
	    if mbflutils_file_p_normalise_file_owner
	    then mbflutils_file_p_normalise_file_group
	    else return $?
	    fi
	else return $?
	fi
    else return $?
    fi
}

# Check if we can act upon the file.
#
function mbflutils_file_p_normalise_file_check () {
    if ! mbfl_file_is_file "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf 'non-existent %b: "%s"' \
				  "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
	return_because_failure
    fi
    if ! mbfl_file_is_writable "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf 'non-writable %b: "%s"' \
				  "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
	return_because_failure
    fi
}

function mbflutils_file_p_normalise_file_access_permissions () {
    local -r TEMPLATE='setting to "%s" the access permissions of the %b: "%s"'

    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" mbfl_slot_ref(FILE_STRUCT,MODE) \
	"mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    if ! mbfl_file_set_permissions $FILE_MODE "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" mbfl_slot_ref(FILE_STRUCT,MODE) \
	    "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_file_owner () {
    local -r TEMPLATE='setting to "%s" the owner of the %b: "%s"'

    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" "mbfl_slot_ref(FILE_STRUCT,OWNER)" \
	"mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    if ! mbfl_file_set_owner "mbfl_slot_ref(FILE_STRUCT,OWNER)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" "mbfl_slot_ref(FILE_STRUCT,OWNER)" \
	    "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_file_group () {
    local -r TEMPLATE='setting to "%s" the group of the %b: "%s"'

    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" "mbfl_slot_ref(FILE_STRUCT,GROUP)" \
	"mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    if ! mbfl_file_set_group "mbfl_slot_ref(FILE_STRUCT,GROUP)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" "mbfl_slot_ref(FILE_STRUCT,GROUP)" \
	    "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
	exit_because_failure
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
