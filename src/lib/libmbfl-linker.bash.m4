#!# libmbfl-linker.bash.m4 --
#!#
#!# Part of: Marco's BASH Functions Library
#!# Contents: linker library
#!# Date: Jun 11, 2023
#!#
#!# Abstract
#!#
#!#	This library must be  standalone: it must not require any of the  functions in the core MBFL
#!#	libraries or any other libraries.
#!#
#!# Copyright (c) 2023 Marco Maggi
#!# <mrc.mgg@gmail.com>
#!#
#!# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#!# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#!# License, or (at your option) any later version.
#!#
#!# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#!# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#!# Lesser General Public License for more details.
#!#
#!# You should have received a copy of the  GNU Lesser General Public License along with this library;
#!# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#!# 02111-1307 USA.
#!#


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS
MBFL_DEFINE_QQ_MACRO


#### library initialisation

function mbfl_module_init_linker () {
    declare -gar MBFL_LINKER_DEFAULT_LIBRARY_PATH=('/usr/local/share/mbfl' '/usr/share/mbfl' '/share/mbfl')
    declare -ga  MBFL_LINKER_LIBRARY_PATH=()
    mbfl_declare_index_array(SPLITFIELD)
    declare -i SPLITCOUNT mbfl_I

    if mbfl_string_not_empty(MBFL_LIBRARY_PATH)
    then
	mbfl_linker_split_search_path QQ(MBFL_LIBRARY_PATH) ':'
	for ((mbfl_I=0; mbfl_I < SPLITCOUNT; ++mbfl_I))
	do mbfl_slot_set(MBFL_LINKER_LIBRARY_PATH, $mbfl_I, mbfl_slot_qref(SPLITFIELD, $mbfl_I))
	done
    fi
}


#### finding libraries

declare -gA MBFL_LINKER_FOUND_LIBRARIES=()
declare -gA MBFL_LINKER_LOADED_LIBRARIES=()

function mbfl_linker_find_library_by_stem () {
    mbfl_mandatory_parameter(mbfl_STEM, 1, MBFL library stem)

    if   test -n mbfl_slot_qref(MBFL_LINKER_LOADED_LIBRARIES,"$mbfl_STEM")
    then
	# The library has already been found and loaded.
	return 1
    elif test -n mbfl_slot_qref(MBFL_LINKER_FOUND_LIBRARIES, "$mbfl_STEM")
    then
	# The library has already been found but not loaded.
	return 0
    else
	declare mbfl_FOUND_LIBRARY_PATHNAME=
	if mbfl_linker_search_by_stem_var mbfl_FOUND_LIBRARY_PATHNAME "$mbfl_STEM"
	then
	    mbfl_slot_set(MBFL_LINKER_FOUND_LIBRARIES,"$mbfl_STEM","$mbfl_FOUND_LIBRARY_PATHNAME")
	    # The library has been found but not loaded.
	    return 0
	else
	    # Exit with "library not found" status.
	    printf 'libmbfl-linker: required MBFL library not found in search path: "%s"\n' QQ(mbfl_STEM)
	    exit_because_error_loading_library
	fi
    fi
}

# This function will be redefined by "libmbfl-core.bash".
#
function exit_because_error_loading_library () { exit 100; }


#### searching for libraries

function mbfl_linker_search_by_stem_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,	1, result variable)
    mbfl_mandatory_parameter(mbfl_STEM,		2, MBFL library stem)

    if   mbfl_linker_search_by_stem_in_search_path_var _(mbfl_RV) QQ(mbfl_STEM) MBFL_LINKER_LIBRARY_PATH
    then return 0
    elif mbfl_linker_search_by_stem_in_search_path_var _(mbfl_RV) QQ(mbfl_STEM) MBFL_LINKER_DEFAULT_LIBRARY_PATH
    then return 0
    else return 1
    fi
}

function mbfl_linker_search_by_stem_in_search_path_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_parameter(mbfl_STEM,			2, MBFL library stem)
    mbfl_mandatory_nameref_parameter(mbfl_SEARCH_PATH,	3, MBFL library search path index array)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_SEARCH_PATH)
    declare mbfl_LIBRARY_PATHNAME

    #mbfl_array_dump _(mbfl_SEARCH_PATH) mbfl_SEARCH_PATH

    for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do
	printf -v mbfl_LIBRARY_PATHNAME '%s/libmbfl-%s.bash' _(mbfl_SEARCH_PATH, $mbfl_I) QQ(mbfl_STEM)
	# Make the pathname absolute.
	if mbfl_string_neq('/', mbfl_string_idx(mbfl_LIBRARY_PATHNAME,0))
	then printf -v mbfl_LIBRARY_PATHNAME '%s/%s' QQ(PWD) QQ(mbfl_LIBRARY_PATHNAME)
	fi

	#echo $FUNCNAME searching QQ(mbfl_LIBRARY_PATHNAME)  >&2
	if test -f QQ(mbfl_LIBRARY_PATHNAME)
	then
	    if test -r QQ(mbfl_LIBRARY_PATHNAME)
	    then
		mbfl_RV=QQ(mbfl_LIBRARY_PATHNAME)
		return 0
	    else
		printf 'libmbfl-libraries.bash: library file not readable: "%s"\n' QQ(mbfl_LIBRARY_PATHNAME) >&2
	    fi
	fi
    done
    return 1
}


#### helper functions

function mbfl_linker_split_search_path () {
    mbfl_mandatory_parameter(STRING,    1, string)
    mbfl_mandatory_parameter(SEPARATOR, 2, separator)
    declare -i i j k=0 first=0
    SPLITFIELD=()
    SPLITCOUNT=0
    for ((i=0; i < mbfl_string_len(STRING); ++i))
    do
        if (( (i + mbfl_string_len(SEPARATOR)) > mbfl_string_len(STRING)))
	then break
	elif mbfl_linker_string_equal_substring "$STRING" $i "$SEPARATOR"
	then
	    # Here $i is the index of the first char in the separator.
	    SPLITFIELD[$k]=${STRING:$first:$((i - first))}
	    let ++k
	    let i+=mbfl_string_len(SEPARATOR)-1
	    # Place  the "first"  marker to  the beginning  of the  next
	    # substring; "i" will  be incremented by "for",  that is why
	    # we do "+1" here.
	    let first=i+1
        fi
    done
    SPLITFIELD[$k]=${STRING:$first}
    let ++k
    SPLITCOUNT=$k
    return 0
}
function mbfl_linker_string_equal_substring () {
    mbfl_mandatory_parameter(STRING,   1, string)
    mbfl_mandatory_parameter(POSITION, 2, position)
    mbfl_mandatory_parameter(PATTERN,  3, pattern)
    local i
    if (( (POSITION + mbfl_string_len(PATTERN)) > mbfl_string_len(STRING) ))
    then return 1
    fi
    for ((i=0; i < mbfl_string_len(PATTERN); ++i))
    do
	if test "mbfl_string_idx(PATTERN, $i)" != "mbfl_string_idx(STRING, $(($POSITION+$i)))"
	then return 1
	fi
    done
    return 0
}


#### done

mbfl_module_init_linker

#!# end of file
# Local Variables:
# mode: shell-script
# End:
