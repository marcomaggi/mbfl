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

ARGC=0
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

#page
## ------------------------------------------------------------
## Default options description.
## ------------------------------------------------------------

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
    mbfl_getopts_KEYWORDS[$mbfl_getopts_INDEX]=`mbfl_string_toupper $keyword`
    mbfl_getopts_BRIEFS[$mbfl_getopts_INDEX]=$brief
    mbfl_getopts_LONGS[$mbfl_getopts_INDEX]=$long

    mbfl_p_declare_option_test_length $hasarg hasarg $index
    test "$hasarg" != "witharg" -a "$hasarg" != "noarg" && {
        mbfl_message_error \
            "wrong value '$hasarg' to hasarg field in option declaration number ${index}"
        exit 2
    }
    mbfl_getopts_HASARG[$mbfl_getopts_INDEX]=$hasarg

    test "$hasarg" = "noarg" && {
        test "$default" != "yes" -a "$default" != "no" && {
            mbfl_message_error \
                "wrong value '$default' as default for option with no argument number ${index}"
        }
    }
    mbfl_getopts_DEFAULTS[$mbfl_getopts_INDEX]=$default

    mbfl_p_declare_option_test_length $description description $index
    mbfl_getopts_DESCRIPTION[$mbfl_getopts_INDEX]=$description

    mbfl_getopts_INDEX=$index
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
    local OPT="${1:?${FUNCNAME} error: missing option name}"
    local OPTARG="$2"
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
            eval $variable='${value}'
            mbfl_invoke_script_function $procedure
        fi
    done
    return 0
}
#PAGE
function mbfl_getopts_parse () {
    local OPT= OPTARG=
    local arg= i=0
    local found_end_of_options_delimiter=0


    for ((i=0; $i < $ARGC1; ++i)); do
        arg="${ARGV1[$i]}"
        if test "$found_end_of_options_delimiter" = 1 ; then
            ARGV[$ARGC]="${arg}"
            let ++ARGC
        elif test "${arg}" = "--" ; then
            found_end_of_options_delimiter=1
        elif mbfl_getopts_isbrief "${arg}" OPT || \
             mbfl_getopts_islong "${arg}" OPT
        then mbfl_getopts_p_process_predefined_option_no_arg "${OPT}"
        elif \
            mbfl_getopts_isbrief_with "${arg}" OPT OPTARG || \
            mbfl_getopts_islong_with  "${arg}" OPT OPTARG
        then mbfl_getopts_p_process_predefined_option_with_arg "${OPT}" "${OPTARG}"
        else
            ARGV[$ARGC]="${arg}"
            ARGC=$(($ARGC + 1))
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
	    mbfl_option_ENCODED_ARGS="yes"
	    ;;
	v|verbose)
	    mbfl_option_VERBOSE="yes"
	    mbfl_message_VERBOSE="yes"
	    ;;
	silent)
	    mbfl_option_VERBOSE="no"
	    mbfl_message_VERBOSE="no"
	    ;;
	debug)
	    mbfl_option_DEBUG="yes"
	    mbfl_message_DEBUG="yes"
	    ;;
	test)
	    mbfl_program_TEST="yes"
	    ;;
	null)
	    mbfl_option_NULL="yes"
	    ;;
        f|force)
	    mbfl_option_INTERACTIVE="no"
	    ;;
        i|interactive)
	    mbfl_option_INTERACTIVE="yes"
	    ;;
        validate-programs)
            mbfl_program_validate_declared
            exit $?
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
                mbfl_message_error "unknown option: \"${OPT}\""
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
        test "${mbfl_getopts_HASARG[$i]}" = 1 && {
            brief_hasarg="VALUE"
            long_hasarg="=VALUE"
        }

        brief="${mbfl_getopts_BRIEFS[$i]}"
        test -n "$brief" && echo -e "\t-${brief}${brief_hasarg}"

        long="${mbfl_getopts_LONGS[$i]}"
        test -n "$long" && echo -e "\t--${long}${long_hasarg}"

        description="${mbfl_getopts_DESCRIPTION[$i]}"
        test -n && echo -e "\t\t$description"
        i=$(($i + 1))
    done
}
#PAGE
# mbfl_getopts_islong --
#
#       Verifies if a string is a long option without argument.
#
#  Arguments:
#
#       $1 -    the string to validate
#       $2 -    optional name of a variable that's set to
#               the option name, without the leading dashes
#
#  Results:
#
#       Returns with code zero if the string is a long option
#       without argument, else returns with code one.
#
#         An option must be of the form "--option", only characters
#       in the ranges "A-Z", "a-z", "0-9" and the characters "-" and
#       "_" are allowed in the option name.  
#

function mbfl_getopts_islong () {
    local arg="${1:?missing argument to mbfl_getopts_islong()}"
    local optvar="${2}"

    local len="${#arg}"

    if test $len -lt 3
    then return 1
    fi

    if test "${arg:0:1}" = "-" -a "${arg:1:1}" = "-"
    then
        local i=2
        local ch=

        while test $i -lt $len
        do
            ch="${arg:$i:1}"
            if test \
                \( "$ch" \< A -o Z \< "$ch" \) -a \
                \( "$ch" \< a -o z \< "$ch" \) -a \
                \( "$ch" \< 0 -o 9 \< "$ch" \) -a \
                "$ch" != _ -a "$ch" != -
            then return 1
            fi
            i=$(($i + 1))
        done

        if test -n "${optvar}"
        then eval ${optvar}="${arg:2}"
        fi
        return 0
    fi
    return 1
}
#PAGE
# mbfl_getopts_islong_with --
#
#       Verifies if a string is a long option with argument.
#
#  Arguments:
#
#       $1 -    the string to validate
#       $2 -    optional name of a variable that's set to
#               the option name, without the leading dashes
#       $3 -    optional name of a variable that's set to
#               the option value
#
#  Results:
#
#       Returns with code zero if the string is a long option
#       with argument, else returns with code one.
#
#         An option must be of the form "--option", only characters
#       in the ranges "A-Z", "a-z", "0-9" and the characters "-" and
#       "_" are allowed in the option name.  
#
#         If the argument is not an option with value, the variable
#       names are ignored.
#

function mbfl_getopts_islong_with () {
    local arg="${1:?missing argument to mbfl_getopts_islong_with()}"
    local optvar="${2}"
    local valvar="${3}"

    local len="${#arg}" str=


    # The min length of a long option with is 5 (example: --o=1).
    if test $len -lt 5 -o "${arg:0:1}" != "-" -o "${arg:1:1}" != "-"
        then return 1
    fi

    local j=0
    while test $j -lt $len
      do
      ch="${arg:$j:1}"
      if test "$ch" = "="
          then
          if test $(($j + 1)) = $len
              then return 1
          fi
          if mbfl_getopts_islong "${arg:0:$j}"
              then
              if test -n "${optvar}"
                  then eval ${optvar}="${arg:2:$(($j - 2))}"
              fi
              if test -n "${valvar}"
                  then
                  str=$(mbfl_getopts_quote_string "${arg:$(($j + 1))}")
                  eval "${valvar}=\"${str}\""
              fi
              return 0
          else return 1
          fi
      fi
      j=$(($j + 1))
    done
    return 1
}
#PAGE
# mbfl_getopts_isbrief --
#
#       Verifies if a string is a brief option without argument.
#
#  Arguments:
#
#       $1 -    the string to validate
#       $2 -    optional name of a variable that's set to
#               the option name, without the leading dash
#
#  Results:
#
#       Returns with code zero if the argument is a brief option
#       without argument, else returns with code one.
#
#         A brief option must be of the form "-a", only characters
#       in the ranges "A-Z", "a-z", "0-9" are allowed as option
#       letters.
#

function mbfl_getopts_isbrief () {
    local arg="${1:?missing argument to mbfl_getopts_isbrief()}"
    local optvar="${2}"

    local ch="${arg:1:1}"

    if test "${#arg}" = 2 -a "${arg:0:1}" = "-"
    then
        if test \( "$ch" \< A -o Z \< "$ch" \) -a \
                \( "$ch" \< a -o z \< "$ch" \) -a \
                \( "$ch" \< 0 -o 9 \< "$ch" \)
        then return 1
        else
            if test -n "${optvar}"
            then eval ${optvar}="${arg:1}"
            fi
            return 0
        fi
    else return 1
    fi
}
#PAGE
# mbfl_getopts_isbrief_with --
#
#       Verifies if a string is a brief option without argument.
#
#  Arguments:
#
#       $1 -    the string to validate
#       $2 -    optional name of a variable that's set to
#               the option name, without the leading dashes
#       $3 -    optional name of a variable that's set to
#               the option value
#
#  Results:
#
#       Returns with code zero if the argument is a brief option
#       without argument, else returns with code one.
#
#         A brief option must be of the form "-a", only characters
#       in the ranges "A-Z", "a-z", "0-9" are allowed as option
#       letters.
#

function mbfl_getopts_isbrief_with () {
    local arg="${1:?missing argument to mbfl_getopts_isbrief_with()}"
    local optvar="${2}"
    local valvar="${3}"

    local ch="${arg:1:1}" str=

    if test "${#arg}" -gt 2 -a "${arg:0:1}" = "-" -a "${arg:1:1}" != "-"
    then
        if test \( "$ch" \< A -a z \< "$ch" \) -a \
                \( "$ch" \< 0 -a 9 \< "$ch" \)
        then return 1
        else
            if test -n "${optvar}"
            then eval ${optvar}="${arg:1:1}"
            fi
            if test -n "${valvar}"
            then
                str=$(mbfl_getopts_quote_string "${arg:2}")
                eval "${valvar}=\"${str}\""
            fi
            return 0
        fi
    else return 1
    fi
}
#PAGE
function mbfl_getopts_p_decode_hex () {
    local i=0


    if test "${mbfl_option_ENCODED_ARGS}" = "yes"; then
        while test $i -lt $ARGC
          do
          ARGV[$i]=$(mbfl_decode_hex "${ARGV[$i]}")
          i=$(($i + 1))
        done
    fi
    return 0
}
#PAGE
# mbfl_wrong_num_args --
#
#       Validates the number of arguments.
#
#  Arguments:
#
#       $1 -            the required number of arguments
#       $2 -            the given number of arguments
#
#  Results:
#
#       If the number of arguments is different from the
#       required one: prints an error message and returns with
#       code one; else returns with code zero.
#
#  Side effects:
#
#       None.
#

function mbfl_wrong_num_args () {
    local required="${1:?missing required number of args in mbfl_wrong_num_args()}"
    local argc="${2:?missing given number of args in mbfl_wrong_num_args()}"

    if test $required = $argc
    then
        return 0
    else
        mbfl_message_error "$required argument(s) required"
        return 1
    fi
}

#PAGE
# mbfl_getopts_quote_string --
#
#       Quotes a string.
#
#  Arguments:
#
#       $1 -            the string to quote
#
#  Results:
#
#       Echoes the quoted string to stdout. Returns with code zero.
#
#  Side effects:
#
#       None.
#

function mbfl_getopts_quote_string () {
    local STR="${1:?missing string to mbfl_getopts_quote_string()}"
    local OUT=
    local len="${#STR}" i=0 ch=
    

    while test $i -lt $len
    do
        ch="${STR:$i:1}"
        if test "$ch" = \\
        then ch=\\\\
        fi
        OUT="${OUT}$ch"
        i=$(($i + 1))
    done

    echo "$OUT"
    return 0
}
#PAGE
# mbfl_argv_from_stdin --
#
#	If no command line arguments: fill "ARGV" with lines from stdin.
#
#  Arguments:
#
#	None.
#
#  Results:
#
#	Returns with code zero.
#

function mbfl_argv_from_stdin () {
    local file=


    if test $ARGC -eq 0
    then
	if test "${mbfl_option_NULL}" = "yes"; then
	    while read -d $'\x00' file
	      do
	      ARGV[$ARGC]="${file}"
	      ARGC=$(($ARGC + 1))
	    done
	else
	    while read file
	      do
	      ARGV[$ARGC]="${file}"
	      ARGC=$(($ARGC + 1))
	    done
	fi
    fi

    return 0
}
#PAGE
function mbfl_argv_all_files () {
    local i=0
    local file=


    while test $i -lt $ARGC
    do
	file="${ARGV[$i]}"
	file=$(mbfl_file_normalise "${file}")
	if test ! -f "${file}"
	then
	    mbfl_message_error "unexistent file \"${file}\""
	    return 1
	fi
	ARGV[$i]="${file}"
	i=$(($i + 1))
    done

    return 0
}
#page
function mbfl_getopts_p_test_option () {
    test "${!1}" = "yes" && return 0
    return 1
}
function mbfl_option_encoded_args () {
    mbfl_getopts_p_test_option mbfl_option_ENCODED_ARGS
}
function mbfl_option_verbose () {
    mbfl_getopts_p_test_option mbfl_option_VERBOSE
}
function mbfl_option_test () {
    mbfl_getopts_p_test_option mbfl_option_TEST
}
function mbfl_option_null () {
    mbfl_getopts_p_test_option mbfl_option_NULL
}
function mbfl_option_debug () {
    mbfl_getopts_p_test_option mbfl_option_DEBUGGING
}
function mbfl_option_interactive () {
    mbfl_getopts_p_test_option mbfl_option_INTERACTIVE
}

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# indent-tabs-mode: nil
# End:
