# libmbflutils.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: utilities library file
# Date: Nov 16, 2020
#
# Abstract
#
#	This is the utilities library file of MBFL.  It can be sourced in shell scripts at the
#	beginning of evaluation.
#
# Copyright (c) 2020 Marco Maggi
# <mrc.mgg@gmail.com>
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

#page
#### file system operations: directory normalisation

function mbflutils_file_normalise_directory () {
    mbfl_mandatory_parameter(DIRECTORY_PATHNAME,    1, directory pathname)
    mbfl_mandatory_parameter(DIRECTORY_OWNER,       2, directory owner)
    mbfl_mandatory_parameter(DIRECTORY_GROUP,       3, directory group)
    mbfl_mandatory_parameter(DIRECTORY_MODE,        4, directory mode)
    # We use  the printf format directive  "%b" to print the  description, so we expand  some of the
    # backslash escape sequences.
    mbfl_mandatory_parameter(DIRECTORY_DESCRIPTION, 5, description)

    mbfl_message_verbose_printf 'normalising owner, group and access permissions of %b: "%s"\n' \
				"$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"

    mbflutils_file_p_normalise_directory_check			|| return $?
    mbflutils_file_p_normalise_directory_access_permissions	|| return $?
    mbflutils_file_p_normalise_directory_owner			|| return $?
    mbflutils_file_p_normalise_directory_group			|| return $?
}

# Check if we can act upon the directory.
#
function mbflutils_file_p_normalise_directory_check () {
    if ! mbfl_file_is_directory "$DIRECTORY_PATHNAME"
    then
	mbfl_message_error_printf 'non-existent %b: "%s"' "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
	return_because_failure
    fi
    if ! mbfl_file_directory_is_writable "$DIRECTORY_PATHNAME"
    then
	mbfl_message_error_printf 'non-writable %b: "%s"' "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
	return_because_failure
    fi
}

function mbflutils_file_p_normalise_directory_access_permissions () {
    local -r TEMPLATE='setting to "%s" the access permissions of the %b: "%s"'

    mbfl_message_verbose_printf "${TEMPLATE}\n" $DIRECTORY_MODE "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
    if ! mbfl_file_set_permissions $DIRECTORY_MODE "$DIRECTORY_PATHNAME"
    then
	mbfl_message_error_printf "$TEMPLATE" $DIRECTORY_MODE "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_directory_owner () {
    local -r TEMPLATE='setting to "%s" the owner of the %b: "%s"'

    mbfl_message_verbose_printf "${TEMPLATE}\n" "$DIRECTORY_OWNER" "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
    if ! mbfl_file_set_owner "$DIRECTORY_OWNER" "$DIRECTORY_PATHNAME"
    then
	mbfl_message_error_printf "$TEMPLATE" "$DIRECTORY_OWNER" "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_directory_group () {
    local -r TEMPLATE='setting to "%s" the group of the %b: "%s"'

    mbfl_message_verbose_printf "${TEMPLATE}\n" "$DIRECTORY_GROUP" "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
    if ! mbfl_file_set_group "$DIRECTORY_GROUP" "$DIRECTORY_PATHNAME"
    then
	mbfl_message_error_printf "$TEMPLATE" "$DIRECTORY_GROUP" "$DIRECTORY_DESCRIPTION" "$DIRECTORY_PATHNAME"
	exit_because_failure
    fi
}

#page
#### file system operations: file normalisation

function mbflutils_file_normalise_file () {
    mbfl_mandatory_parameter(FILE_PATHNAME,    1, file pathname)
    mbfl_mandatory_parameter(FILE_OWNER,       2, file owner)
    mbfl_mandatory_parameter(FILE_GROUP,       3, file group)
    mbfl_mandatory_parameter(FILE_MODE,        4, file mode)
    # We use  the printf format directive  "%b" to print the  description, so we expand  some of the
    # backslash escape sequences.
    mbfl_mandatory_parameter(FILE_DESCRIPTION, 5, description)

    mbfl_message_verbose_printf 'normalising owner, group and access permissions of %b: "%s"\n' \
				"$FILE_DESCRIPTION" "$FILE_PATHNAME"

    mbflutils_file_p_normalise_file_check			|| return $?
    mbflutils_file_p_normalise_file_access_permissions		|| return $?
    mbflutils_file_p_normalise_file_owner			|| return $?
    mbflutils_file_p_normalise_file_group			|| return $?
}

# Check if we can act upon the file.
#
function mbflutils_file_p_normalise_file_check () {
    if ! mbfl_file_is_file "$FILE_PATHNAME"
    then
	mbfl_message_error_printf 'non-existent %b: "%s"' "$FILE_DESCRIPTION" "$FILE_PATHNAME"
	return_because_failure
    fi
    if ! mbfl_file_directory_is_writable "$FILE_PATHNAME"
    then
	mbfl_message_error_printf 'non-writable %b: "%s"' "$FILE_DESCRIPTION" "$FILE_PATHNAME"
	return_because_failure
    fi
}

function mbflutils_file_p_normalise_file_access_permissions () {
    local -r TEMPLATE='setting to "%s" the access permissions of the %b: "%s"'

    mbfl_message_verbose_printf "${TEMPLATE}\n" $FILE_MODE "$FILE_DESCRIPTION" "$FILE_PATHNAME"
    if ! mbfl_file_set_permissions $FILE_MODE "$FILE_PATHNAME"
    then
	mbfl_message_error_printf "$TEMPLATE" $FILE_MODE "$FILE_DESCRIPTION" "$FILE_PATHNAME"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_file_owner () {
    local -r TEMPLATE='setting to "%s" the owner of the %b: "%s"'

    mbfl_message_verbose_printf "${TEMPLATE}\n" "$FILE_OWNER" "$FILE_DESCRIPTION" "$FILE_PATHNAME"
    if ! mbfl_file_set_owner "$FILE_OWNER" "$FILE_PATHNAME"
    then
	mbfl_message_error_printf "$TEMPLATE" "$FILE_OWNER" "$FILE_DESCRIPTION" "$FILE_PATHNAME"
	exit_because_failure
    fi
}

function mbflutils_file_p_normalise_file_group () {
    local -r TEMPLATE='setting to "%s" the group of the %b: "%s"'

    mbfl_message_verbose_printf "${TEMPLATE}\n" "$FILE_GROUP" "$FILE_DESCRIPTION" "$FILE_PATHNAME"
    if ! mbfl_file_set_group "$FILE_GROUP" "$FILE_PATHNAME"
    then
	mbfl_message_error_printf "$TEMPLATE" "$FILE_GROUP" "$FILE_DESCRIPTION" "$FILE_PATHNAME"
	exit_because_failure
    fi
}


### end of file
# Local Variables:
# mode: sh
# End:
