# mbflutils-files.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-utils' file module
# Date: Dec  2, 2020
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=mbflutils-file-
#
#	that will select these tests.
#
# Copyright (c) 2020 Marco Maggi
# <mrc.mgg@gmail.com>
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


#### setup

mbfl_load_library("$MBFL_TESTS_LIBMBFL")
mbfl_load_library("$MBFL_TESTS_LIBMBFLUTILS")
mbfl_load_library("$MBFL_TESTS_LIBMBFLTEST")

mbfl_file_enable_permissions
mbfl_system_enable_programs


#### file name functions: acquiring file/directory attributes

# Stat a file: the file exists.
#
function mbflutils-file-stat-1.1 () {
    mbfl_local_assoc_array_varref(THE_STRU)
    local -i RV=0

    #dotest-set-debug
    #mbfl_set_option_debug

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	local tmpdir=$(dotest-echo-tmpdir)
	local -r THE_PATHNAME=$(dotest-mkfile file.ext)
	local -r EXPECTED_USERNAME=$(mbfl_system_effective_user_id --name)
	local -r EXPECTED_GROUPNAME=$(mbfl_system_effective_group_id --name)
	local -r EXPECTED_MODE='0640'

	if mbfl_file_set_permissions u+rw-x,g+r-wx,o-rwx,a-st "$THE_PATHNAME"
	then
	    if mbflutils_file_init_file_struct mbfl_datavar(THE_STRU) "$THE_PATHNAME" "test file for '${FUNCNAME}'"
	    then
		if mbflutils_file_stat mbfl_datavar(THE_STRU)
		then
		    dotest-equal "$THE_PATHNAME"		"mbfl_slot_ref(THE_STRU,PATHNAME)"    'file pathname' && \
			dotest-equal "$EXPECTED_USERNAME"	"mbfl_slot_ref(THE_STRU,OWNER)"	      'file owner'    && \
			dotest-equal "$EXPECTED_GROUPNAME"	"mbfl_slot_ref(THE_STRU,GROUP)"	      'file group'    && \
			dotest-equal "$EXPECTED_MODE"		"mbfl_slot_ref(THE_STRU,MODE)"	      'file mode'
		    RV=$?
		else RV=$?
		fi
	    else RV=$?
	    fi
	else
	    mbfl_message_error_printf 'error setting permissions for temporary test file: "%s"' "$THE_PATHNAME"
	    RV=1
	fi
    }
    mbfl_location_leave
    return $RV
}

### ------------------------------------------------------------------------

# Stat a directory: the directory exists.
#
function mbflutils-file-stat-2.1 () {
    mbfl_local_assoc_array_varref(THE_STRU)
    local -i RV=0

    dotest-set-debug
    #mbfl_set_option_debug

    mbfl_location_enter
    {
	mbfl_location_handler dotest-clean-files
	local tmpdir=$(dotest-echo-tmpdir)
	local -r THE_PATHNAME=$(dotest-mkdir file.ext)
	local -r EXPECTED_USERNAME=$(mbfl_system_effective_user_id --name)
	local -r EXPECTED_GROUPNAME=$(mbfl_system_effective_group_id --name)
	local -r EXPECTED_MODE='0640'

	if mbfl_file_set_permissions u+rw-x,g+r-wx,o-rwx,a-st "$THE_PATHNAME"
	then
	    if mbflutils_file_init_directory_struct mbfl_datavar(THE_STRU) "$THE_PATHNAME" "test file for '${FUNCNAME}'"
	    then
		if mbflutils_file_stat mbfl_datavar(THE_STRU)
		then
		    dotest-equal "$THE_PATHNAME"		"mbfl_slot_ref(THE_STRU,PATHNAME)"    'file pathname' && \
			dotest-equal "$EXPECTED_USERNAME"	"mbfl_slot_ref(THE_STRU,OWNER)"	      'file owner'    && \
			dotest-equal "$EXPECTED_GROUPNAME"	"mbfl_slot_ref(THE_STRU,GROUP)"	      'file group'    && \
			dotest-equal "$EXPECTED_MODE"		"mbfl_slot_ref(THE_STRU,MODE)"	      'file mode'
		    RV=$?
		else RV=$?
		fi
	    else RV=$?
	    fi
	else
	    mbfl_message_error_printf 'error setting permissions for temporary test file: "%s"' "$THE_PATHNAME"
	    RV=1
	fi
    }
    mbfl_location_leave
    return $RV
}


#### let's go

dotest mbflutils-file-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
