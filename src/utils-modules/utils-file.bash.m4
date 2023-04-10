#
# Part of: Marco's Bash Functions Utilities Library
# Contents: file system functions
# Date: Mon Nov 16, 2020
#
# Abstract
#
#
#
# Copyright (C) 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
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


#### preamble

mbfl_file_enable_owner_and_group
mbfl_file_enable_permissions


#### file system operations: tables of functions

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_declare_assoc_array(MBFLUTILS_FILE_FUNCTIONS)
    mbfl_slot_set(MBFLUTILS_FILE_FUNCTIONS, IS_TYPE, 'mbflutils_p_file_is_file')

    mbfl_declare_assoc_array(MBFLUTILS_DIRECTORY_FUNCTIONS)
    mbfl_slot_set(MBFLUTILS_DIRECTORY_FUNCTIONS, IS_TYPE, 'mbflutils_p_file_is_directory')
fi


#### file system operations: data structures declaration

function mbflutils_file_init_directory_struct () {
    mbfl_mandatory_nameref_parameter(STRUCT,1, file system struct array name)
    mbfl_mandatory_parameter(PATHNAME,      2, directory pathname)
    mbfl_mandatory_parameter(DESCRIPTION,   3, directory description)
    mbfl_optional_parameter(OWNER,          4)
    mbfl_optional_parameter(GROUP,          5)
    mbfl_optional_parameter(MODE,           6)

    if mbfl_string_is_empty "$PATHNAME"
    then
	mbfl_message_error_printf 'the given %b file system pathname is empty' "$DESCRIPTION"
	return_failure
    else
	mbfl_slot_set(STRUCT,PATHNAME,    "$PATHNAME")
	mbfl_slot_set(STRUCT,DESCRIPTION, "$DESCRIPTION")
	mbfl_slot_set(STRUCT,OWNER,       "$OWNER")
	mbfl_slot_set(STRUCT,GROUP,       "$GROUP")
	mbfl_slot_set(STRUCT,MODE,        "$MODE")
	mbfl_slot_set(STRUCT,TYPE,        'directory')
	mbfl_slot_set(STRUCT,FUNCTIONS,   'MBFLUTILS_DIRECTORY_FUNCTIONS')
    fi
}

function mbflutils_file_init_file_struct () {
    mbfl_mandatory_nameref_parameter(STRUCT,1, file system struct array name)
    mbfl_mandatory_parameter(PATHNAME,      2, file pathname)
    mbfl_mandatory_parameter(DESCRIPTION,   3, file description)
    mbfl_optional_parameter(OWNER,          4)
    mbfl_optional_parameter(GROUP,          5)
    mbfl_optional_parameter(MODE,           6)

    if mbfl_string_is_empty "$PATHNAME"
    then
	mbfl_message_error_printf 'the given %b file system pathname is empty' "$DESCRIPTION"
	return_failure
    else
	mbfl_slot_set(STRUCT,PATHNAME,    "$PATHNAME")
	mbfl_slot_set(STRUCT,DESCRIPTION, "$DESCRIPTION")
	mbfl_slot_set(STRUCT,OWNER,       "$OWNER")
	mbfl_slot_set(STRUCT,GROUP,       "$GROUP")
	mbfl_slot_set(STRUCT,MODE,        "$MODE")
	mbfl_slot_set(STRUCT,TYPE,        'file')
	mbfl_slot_set(STRUCT,FUNCTIONS,   'MBFLUTILS_FILE_FUNCTIONS')
    fi
}


#### file system operations: data structures initialisation from file system

function mbflutils_file_stat () {
    mbfl_mandatory_nameref_parameter(SELF, 1, file system struct array name)

    if ! {
	    # Access the table of functions.
	    local -n FUNCTIONS=mbfl_slot_ref(SELF,FUNCTIONS)
	    mbfl_slot_ref(FUNCTIONS,IS_TYPE) mbfl_datavar(SELF)
	}
    then
	# Let's be more specific about the error.
	if mbfl_string_is_empty "mbfl_slot_ref(SELF, PATHNAME)"
	then mbfl_message_error_printf						\
		 'the file system pathname given as %b is an empty string'	\
		 "mbfl_slot_ref(SELF,DESCRIPTION)"
	elif ! mbfl_file_exists "mbfl_slot_ref(SELF, PATHNAME)"
	then mbfl_message_error_printf						\
		 'the file system pathname given as %b does not exist: "%s"'	\
		 "mbfl_slot_ref(SELF,DESCRIPTION)" "mbfl_slot_ref(SELF,PATHNAME)"
	else mbfl_message_error_printf						\
		 'the file system pathname given as %b is not a %s: "%s"'	\
		 "mbfl_slot_ref(SELF,DESCRIPTION)"				\
		 "mbfl_slot_ref(SELF, TYPE)"					\
		 "mbfl_slot_ref(SELF,PATHNAME)"
	fi
	return_failure
    else
	# We modify the struct only if the values acquisitions are successful.
	mbfl_declare_varref(OWNER)
	mbfl_declare_varref(GROUP)
	mbfl_declare_varref(MODE)

	if ! mbfl_file_get_owner_var mbfl_datavar(OWNER) "mbfl_slot_ref(SELF, PATHNAME)"
	then
	    mbfl_message_error_printf					\
		'acquiring access file system owner of %b: "%s"'	\
		"mbfl_slot_ref(SELF, DESCRIPTION)"			\
		"mbfl_slot_ref(SELF, PATHNAME)"
	    return_failure
	elif ! mbfl_file_get_group_var mbfl_datavar(GROUP) "mbfl_slot_ref(SELF, PATHNAME)"
	then
	    mbfl_message_error_printf					\
		'acquiring file system group of %b: "%s"'		\
		"mbfl_slot_ref(SELF, DESCRIPTION)"			\
		"mbfl_slot_ref(SELF, PATHNAME)"
	    return_failure
	elif ! mbfl_file_get_permissions_var mbfl_datavar(MODE) "mbfl_slot_ref(SELF, PATHNAME)"
	then
	    mbfl_message_error_printf					\
		'acquiring file system access permissions of %b: "%s"'	\
		"mbfl_slot_ref(SELF, DESCRIPTION)"			\
		"mbfl_slot_ref(SELF, PATHNAME)"
	    return_failure
	else
	    mbfl_slot_set(SELF, OWNER, "$OWNER")
	    mbfl_slot_set(SELF, GROUP, "$GROUP")
	    mbfl_slot_set(SELF, MODE,  "$MODE")
	    return_success
	fi
    fi
}


#### file system operations: file and directory installation

function mbflutils_file_install_directory () {
    mbfl_mandatory_nameref_parameter(DIRECTORY_STRUCT, 1, directory array name)
    shift 1
    local INSTALL_FLAGS
    local -r TEMPLATE='installing directory %b: "%s"'

    # We use  the printf format directive  "%b" to print the  description, so we expand  some of the
    # backslash escape sequences.
    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"

    if ! mbfl_string_is_username "mbfl_slot_ref(DIRECTORY_STRUCT,OWNER)"
    then
	mbfl_message_error_printf \
	    'invalid owner for %b: "%s"' \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,OWNER)"
	return_failure
    fi
    if ! mbfl_string_is_username "mbfl_slot_ref(DIRECTORY_STRUCT,GROUP)"
    then
	mbfl_message_error_printf \
	    'invalid group for %b: "%s"' \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,GROUP)"
	return_failure
    fi
    if mbfl_string_is_empty "mbfl_slot_ref(DIRECTORY_STRUCT,MODE)"
    then
	mbfl_message_error_printf \
	    'invalid access permissions mode for %b: "%s"' \
	    "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,MODE)"
	return_failure
    fi

    if mbfl_option_verbose_program
    then INSTALL_FLAGS+=' --verbose'
    fi
    if ! mbfl_program_exec "$mbfl_PROGRAM_INSTALL" \
	 --owner="mbfl_slot_ref(DIRECTORY_STRUCT,OWNER)"	\
	 --group="mbfl_slot_ref(DIRECTORY_STRUCT,GROUP)"	\
	 --mode="mbfl_slot_ref(DIRECTORY_STRUCT,MODE)"	\
	 "$INSTALL_FLAGS" "$@" --directory '--' "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" "mbfl_slot_ref(DIRECTORY_STRUCT,DESCRIPTION)" "mbfl_slot_ref(DIRECTORY_STRUCT,PATHNAME)"
	return_because_failure
    fi
}

function mbflutils_file_install_file () {
    mbfl_mandatory_nameref_parameter(FILE_STRUCT,             1, file array name)
    mbfl_mandatory_nameref_parameter(TARGET_DIRECTORY_STRUCT, 2, target directory array name)
    shift 1
    local INSTALL_FLAGS
    local -r TEMPLATE='installing file %b: "%s"'

    # We use  the printf format directive  "%b" to print the  description, so we expand  some of the
    # backslash escape sequences.
    mbfl_message_verbose_printf \
	"${TEMPLATE}\n" "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"

    if ! mbfl_string_is_username "mbfl_slot_ref(FILE_STRUCT,OWNER)"
    then
	mbfl_message_error_printf \
	    'invalid owner for %b: "%s"' \
	    "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,OWNER)"
	return_failure
    fi
    if ! mbfl_string_is_username "mbfl_slot_ref(FILE_STRUCT,GROUP)"
    then
	mbfl_message_error_printf \
	    'invalid group for %b: "%s"' \
	    "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,GROUP)"
	return_failure
    fi
    if mbfl_string_is_empty "mbfl_slot_ref(FILE_STRUCT,MODE)"
    then
	mbfl_message_error_printf \
	    'invalid access permissions mode for %b: "%s"' \
	    "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,MODE)"
	return_failure
    fi

    if mbfl_option_verbose_program
    then INSTALL_FLAGS+=' --verbose'
    fi
    if ! mbfl_program_exec "$mbfl_PROGRAM_INSTALL"				\
	 --owner="mbfl_slot_ref(FILE_STRUCT,OWNER)"				\
	 --group="mbfl_slot_ref(FILE_STRUCT,GROUP)"				\
	 --mode="mbfl_slot_ref(FILE_STRUCT,MODE)"				\
	 "$INSTALL_FLAGS" "$@"							\
	 --target-directory "mbfl_slot_ref(TARGET_DIRECTORY_STRUCT,PATHNAME)"	\
	 '--' "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
    then
	mbfl_message_error_printf \
	    "$TEMPLATE" "mbfl_slot_ref(FILE_STRUCT,DESCRIPTION)" "mbfl_slot_ref(FILE_STRUCT,PATHNAME)"
	return_because_failure
    fi
}


#### file system operations: directory normalisation

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


#### file system operations: type-specific function

function mbflutils_p_file_is_file () {
    mbfl_mandatory_nameref_parameter(SELF, 1, file system struct array name)
    mbfl_file_is_file "mbfl_slot_ref(SELF, PATHNAME)"
}
function mbflutils_p_file_is_directory () {
    mbfl_mandatory_nameref_parameter(SELF, 1, file system struct array name)
    mbfl_file_is_directory "mbfl_slot_ref(SELF, PATHNAME)"
}

### end of file
# Local Variables:
# mode: sh
# End:
