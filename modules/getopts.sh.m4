# getopts.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: command line parsing functions
# Date: Tue Apr 22, 2003
# 
# Abstract
# 
#       This is a collection of functions for the GNU BASH shell. Its
#       purpose is to provide a command line parsing facility.
# 
#         Support for encoded argument values is provided and requires
#       the "encode.sh" file to be included in the script.
#
# Copyright (c) 2003, 2004 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
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
# USA
# 

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then
    declare -i ARGC=0
    declare -a ARGV ARGV1

    for ((ARGC1=0; $# > 0; ++ARGC1)); do
        ARGV1[$ARGC1]="$1"
        shift
    done

    mbfl_getopts_INDEX=0
    declare -a mbfl_getopts_KEYWORDS
    declare -a mbfl_getopts_DEFAULTS
    declare -a mbfl_getopts_BRIEFS
    declare -a mbfl_getopts_LONGS
    declare -a mbfl_getopts_HASARGS
    declare -a mbfl_getopts_DESCRIPTION
fi

#page
## ------------------------------------------------------------
## Default options description.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then

mbfl_message_DEFAULT_OPTIONS="
\t-i
\t--interactive
\t\task before doing dangerous operations
\t-f
\t--force
\t\tdo not ask before dangerous operations
\t--encoded-args
\t\tdecode arguments following this option
\t\tfrom the hex format (example: 414243 -> ABC)
\t-v
\t--verbose
\t\tverbose execution
\t--silent
\t\tsilent execution
\t--verbose-program
\t\tverbose execution for external program (if supported)
\t--null
\t\tuse the null character as terminator
\t--debug
\t\tprint debug messages
\t--test
\t\ttests execution
\t--validate-programs
\t\tchecks the existence of all the required external programs
\t--version
\t\tprint version informations and exit
\t--version-only
\t\tprint version number and exit
\t--license
\t\tprint license informations and exit
\t-h
\t--help
\t--usage
\t\tprint usage informations and exit
"

fi

#page
function mbfl_declare_option () {
    local keyword="$1"
    local default="$2"
    local brief="$3"
    local long="$4"
    local hasarg="$5"
    local description="$6"
    local index=$(($mbfl_getopts_INDEX + 1))


    mbfl_p_declare_option_test_length $keyword keyword $index
    mbfl_getopts_KEYWORDS[$mbfl_getopts_INDEX]=`mbfl_string_toupper "$keyword"`
    mbfl_getopts_BRIEFS[$mbfl_getopts_INDEX]=$brief
    mbfl_getopts_LONGS[$mbfl_getopts_INDEX]=$long

    mbfl_p_declare_option_test_length $hasarg hasarg $index
    if test "$hasarg" != "witharg" -a "$hasarg" != "noarg" ; then
        mbfl_message_error \
  "wrong value '$hasarg' to hasarg field in option declaration number ${index}"
        exit 2
    fi
    mbfl_getopts_HASARG[$mbfl_getopts_INDEX]=$hasarg

    if test "$hasarg" = "noarg" ; then
        if test "$default" != "yes" -a "$default" != "no" ; then
            mbfl_message_error \
  "wrong value '$default' as default for option with no argument number ${index}"
        fi
    fi
    mbfl_getopts_DEFAULTS[$mbfl_getopts_INDEX]=$default

    mbfl_p_declare_option_test_length $description description $index
    mbfl_getopts_DESCRIPTION[$mbfl_getopts_INDEX]=$description

    mbfl_getopts_INDEX=$index

    # Creates the global option variable
    eval script_option_`mbfl_string_toupper $keyword`=\'"${default}"\'
}
function mbfl_p_declare_option_test_length () {
    local value="${1}"
    local value_name="${2}"
    local option_number=${3}

    test -z "$value" && {
        mbfl_message_error \
            "null ${value_name} in declared option number ${option_number}"
        exit 2
    }
}
#page
function mbfl_getopts_p_process_script_option () {
    mandatory_parameter(OPT, 1, option name)
    optional_parameter(OPTARG, 2)
    local i=0
    local value=
    local brief= long= hasarg= keyword= procedure= variable=


    for ((i=0; $i < $mbfl_getopts_INDEX; ++i)); do
        keyword="${mbfl_getopts_KEYWORDS[$i]}"
        brief="${mbfl_getopts_BRIEFS[$i]}"
        long="${mbfl_getopts_LONGS[$i]}"
        hasarg="${mbfl_getopts_HASARG[$i]}"
        if test \
            \( -n "$OPT" \) -a \( \( -n "$brief" -a "$brief" = "$OPT" \) -o \
                                \( -n "$long"  -a "$long"  = "$OPT" \) \)
        then
            if test "$hasarg" = "witharg"; then
                if mbfl_option_encoded_args; then
                    value=`mbfl_decode_hex "${OPTARG}"`
                else
                    value="$OPTARG"
                fi
            else
                value="yes"
            fi
            
            procedure=script_option_update_`mbfl_string_tolower $keyword`
            variable=script_option_`mbfl_string_toupper $keyword`
            eval $variable=\'"${value}"\'
            mbfl_invoke_script_function $procedure
            return 0
        fi
    done
    return 1
}
#PAGE
function mbfl_getopts_parse () {
    local p_OPT= p_OPTARG=
    local argument= i=0
    local found_end_of_options_delimiter=0


    for ((i=0; $i < $ARGC1; ++i)); do
        argument="${ARGV1[$i]}"
        if test "$found_end_of_options_delimiter" = 1 ; then
            ARGV[$ARGC]="${argument}"
            let ++ARGC
        elif test "${argument}" = '--' ; then
            found_end_of_options_delimiter=1
        elif mbfl_getopts_isbrief "${argument}" p_OPT || \
             mbfl_getopts_islong "${argument}" p_OPT
        then
            mbfl_getopts_p_process_predefined_option_no_arg "${p_OPT}"
        elif \
            mbfl_getopts_isbrief_with "${argument}" p_OPT p_OPTARG || \
            mbfl_getopts_islong_with  "${argument}" p_OPT p_OPTARG
        then
            mbfl_getopts_p_process_predefined_option_with_arg "${p_OPT}" "${p_OPTARG}"
        else
            ARGV[$ARGC]="${argument}"
            let ++ARGC
        fi
    done

    mbfl_getopts_p_decode_hex
    return 0
}
#PAGE
function mbfl_getopts_p_process_predefined_option_no_arg () {
    local OPT="${1:?}"
    local i=0


    case "${OPT}" in
	encoded-args)
            mbfl_set_option_encoded_args
	    ;;
	v|verbose)
            mbfl_set_option_verbose
	    ;;
	silent)
            mbfl_unset_option_verbose
	    ;;
	verbose-program)
            mbfl_set_option_verbose_program
	    ;;
	debug)
            mbfl_set_option_verbose
	    ;;
	test)
            mbfl_set_option_test
	    ;;
	null)
            mbfl_set_option_null
	    ;;
        f|force)
            mbfl_unset_option_interactive
	    ;;
        i|interactive)
            mbfl_set_option_interactive
	    ;;
        validate-programs)
            mbfl_program_validate_declared || mbfl_exit_program_not_found
            ;;
	version)
	    echo -e "${mbfl_message_VERSION}"
	    exit 0
	    ;;
	version-only)
	    echo -e "${script_VERSION}"
	    exit 0
	    ;;
	license)
            case "${script_LICENSE}" in
                GPL)
                    echo -e "${mbfl_message_LICENSE_GPL}"
                    ;;
                LGPL)
                    echo -e "${mbfl_message_LICENSE_LGPL}"
                    ;;
                BSD)
                    echo -e "${mbfl_message_LICENSE_BSD}"
                    ;;
                *)
                    mbfl_message_error "unknown license: \"${script_LICENSE}\""
                    exit 2
                    ;;
            esac
	    exit 0
	    ;;
	h|help|usage)
	    echo -e "${script_USAGE}\noptions:"
            mbfl_getopts_p_build_and_print_options_usage
            echo -e "${mbfl_message_DEFAULT_OPTIONS}"
	    exit 0
	    ;;
	*)
            mbfl_getopts_p_process_script_option "${OPT}" || {
                mbfl_message_error "unknown option: '${OPT}'"
                exit 2
            }
	    ;;
    esac
    return 0
}
#PAGE
function mbfl_getopts_p_process_predefined_option_with_arg () {
    local OPT="${1:?}"
    local OPTARG="${2:?}"


    mbfl_option_encoded_args && OPTARG=$(mbfl_decode_hex "${OPTARG}")

    # at present no options with argument are declared by MBFL

    case "${OPT}" in
	*)
	    mbfl_getopts_p_process_script_option "${OPT}" "${OPTARG}" || {
                mbfl_message_error "unknown option \"${OPT}\""
                exit 2
            }
	    ;;
    esac
    return 0
}
#page
function mbfl_getopts_p_build_and_print_options_usage () {
    local i=0
    local brief= long= description= long_hasarg= long_hasarg=


    for ((i=0; $i < $mbfl_getopts_INDEX; ++i)); do
        if test "${mbfl_getopts_HASARG[$i]}" = 1 ; then
            brief_hasarg="VALUE"
            long_hasarg="=VALUE"
        fi

        brief="${mbfl_getopts_BRIEFS[$i]}"
        test -n "$brief" && echo -e "\t-${brief}${brief_hasarg}"

        long="${mbfl_getopts_LONGS[$i]}"
        test -n "$long" && echo -e "\t--${long}${long_hasarg}"

        description="${mbfl_getopts_DESCRIPTION[$i]}"
        test -n && echo -e "\t\t$description"
    done
}
#PAGE
function mbfl_getopts_islong () {
    mandatory_parameter(ARGUMENT, 1, argument)
    optional_parameter(OPTION_VARIABLE_NAME, 2)
    local len="${#ARGUMENT}" i ch


    test $len -lt 3 -o "${ARGUMENT:0:2}" != "--"  && return 1
    for ((i=2; $i < $len; ++i)); do
        ch="${ARGUMENT:$i:1}"
        mbfl_p_getopts_not_char_in_long_option_name "$ch" && return 1
    done
    mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${ARGUMENT:2}"
    return 0
}
function mbfl_getopts_islong_with () {
    mandatory_parameter(ARGUMENT, 1, argument)
    optional_parameter(OPTION_VARIABLE_NAME, 2)
    optional_parameter(VALUE_VARIABLE_NAME, 3)
    local len="${#ARGUMENT}" equal_position


    # The min length of a long option with is 5 (example: --o=1).
    test $len -lt 5 && return 1
    equal_position=`mbfl_string_first "${ARGUMENT}" =`
    test -z "$equal_position" -o $(($equal_position + 1)) = $len && return 1

    mbfl_getopts_islong "${ARGUMENT:0:$equal_position}" || return 1
    mbfl_set_maybe "${OPTION_VARIABLE_NAME}" \
        "${ARGUMENT:2:$(($equal_position - 2))}"
    mbfl_set_maybe "${VALUE_VARIABLE_NAME}" \
        "${ARGUMENT:$(($equal_position + 1))}"
    return 0
}
function mbfl_p_getopts_not_char_in_long_option_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \) -a \
        \( "$1" \< 0 -o 9 \< "$1" \) -a \
        "$1" != _ -a "$1" != -
}
#PAGE
function mbfl_getopts_isbrief () {
    mandatory_parameter(COMMAND_LINE_ARGUMENT, 1, command line argument)
    optional_parameter(OPTION_VARIABLE_NAME, 2)
    local ch

    test "${#COMMAND_LINE_ARGUMENT}" = 2 -a \
        "${COMMAND_LINE_ARGUMENT:0:1}" = "-" || return 1

    mbfl_p_getopts_not_char_in_brief_option_name \
        "${COMMAND_LINE_ARGUMENT:1:1}" && return 1

    mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${COMMAND_LINE_ARGUMENT:1}"
    return 0
}
function mbfl_getopts_isbrief_with () {
    mandatory_parameter(COMMAND_LINE_ARGUMENT, 1, command line argument)
    optional_parameter(OPTION_VARIABLE_NAME, 2)
    optional_parameter(VALUE_VARIABLE_NAME, 3)

    test "${#COMMAND_LINE_ARGUMENT}" -gt 2 -a \
        "${COMMAND_LINE_ARGUMENT:0:1}" = "-" || return 1

    mbfl_p_getopts_not_char_in_brief_option_name \
        "${COMMAND_LINE_ARGUMENT:1:1}" && return 1

    mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${COMMAND_LINE_ARGUMENT:1:1}"
    local QUOTED_VALUE=`mbfl_string_quote "${COMMAND_LINE_ARGUMENT:2}"`
    mbfl_set_maybe "${VALUE_VARIABLE_NAME}" "${QUOTED_VALUE}"
    return 0
}
function mbfl_p_getopts_not_char_in_brief_option_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \) -a \
        \( "$1" \< 0 -o 9 \< "$1" \)
}
#PAGE
function mbfl_getopts_p_decode_hex () {
    local i=0

    mbfl_option_encoded_args && {
        for ((i=0; $i < $ARGC; ++i))
          do ARGV[$i]=`mbfl_decode_hex "${ARGV[$i]}"`
        done
    }
    return 0
}
#PAGE
function mbfl_wrong_num_args () {
    mandatory_parameter(required, 1, required number of args)
    mandatory_parameter(argc, 2, given number of args)

    test $required != $argc && {
        mbfl_message_error "number of arguments required: $required"
        return 1
    }
    return 0
}
#PAGE
function mbfl_argv_from_stdin () {
    local file=


    test $ARGC -eq 0 || {
        while mbfl_read_maybe_null file ; do
            ARGV[$ARGC]="${file}"
            let ++ARGC
        done
    }
    return 0
}
function mbfl_argv_all_files () {
    local i file


    for ((i=0; $i < $ARGC; ++i)) ; do
	file=`mbfl_file_normalise "${ARGV[$i]}"`
	if test ! -f "${file}" ; then
	    mbfl_message_error "unexistent file '${file}'"
	    return 1
	fi
	ARGV[$i]="${file}"
    done
    return 0
}
#page
function mbfl_getopts_p_test_option () {
    test "${!1}" = "yes" && return 0
    return 1
}

### end of file
# Local Variables:
# mode: sh
# End:
