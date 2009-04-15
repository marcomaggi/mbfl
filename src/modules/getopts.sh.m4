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
# Copyright (c) 2003-2005, 2009 Marco Maggi <marcomaggi@gna.org>
#
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

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'
then
    declare -i ARGC=0
    declare -a ARGV ARGV1

    for ((ARGC1=0; $# > 0; ++ARGC1))
    do
        ARGV1[$ARGC1]="$1"
        shift
    done

    declare -r ARGC1 ARGV1

    declare -i mbfl_getopts_INDEX=0
    declare -a mbfl_getopts_KEYWORDS
    declare -a mbfl_getopts_DEFAULTS
    declare -a mbfl_getopts_BRIEFS
    declare -a mbfl_getopts_LONGS
    declare -a mbfl_getopts_HASARG
    declare -a mbfl_getopts_DESCRIPTION

    declare -i mbfl_getopts_actargs_INDEX=0
    declare -a mbfl_getopts_actargs_KEYWORDS
    declare -a mbfl_getopts_actargs_STRINGS
    declare -a mbfl_getopts_actargs_SKIPOPTS
    declare -a mbfl_getopts_actargs_DESCRIPTION
fi

#page
## ------------------------------------------------------------
## Default options description.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes' ; then

mbfl_message_DEFAULT_OPTIONS="
\t--tmpdir=DIR
\t\tselect a directory for temporary files
\t-i --interactive
\t\task before doing dangerous operations
\t-f --force
\t\tdo not ask before dangerous operations
\t--encoded-args
\t\tdecode arguments following this option
\t\tfrom the hex format (example: 414243 -> ABC)
\t-v --verbose
\t\tverbose execution
\t--silent
\t\tsilent execution
\t--verbose-program
\t\tverbose execution for external program (if supported)
\t--show-program
\t\tprint the command line of executed external programs
\t--null
\t\tuse the null character as terminator
\t--debug
\t\tprint debug messages
\t--test
\t\ttests execution
\t--validate-programs
\t\tchecks the existence of all the required external programs
\t--list-exit-codes
\t\tprints a list of exit codes and names
\t--print-exit-code=NAME
\t\tprints the exit code associated to a name
\t--print-exit-code-names=CODE
\t\tprints the names associated to an exit code
\t--version
\t\tprint version informations and exit
\t--version-only
\t\tprint version number and exit
\t--license
\t\tprint license informations and exit
\t--print-options
\t\tprint a list of long option switches
\t--print-action-arguments
\t\tprint a list of action arguments
\t-h --help --usage
\t\tprint usage informations and exit
\t-H --brief-help --brief-usage
\t\tprint usage informations and the list of script specific
\t\toptions, then exit
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
    mbfl_getopts_KEYWORDS[$mbfl_getopts_INDEX]=$(mbfl_string_toupper "$keyword")
    mbfl_getopts_BRIEFS[$mbfl_getopts_INDEX]=$brief
    mbfl_getopts_LONGS[$mbfl_getopts_INDEX]=$long

    mbfl_p_declare_option_test_length $hasarg hasarg $index
    test "$hasarg" != witharg -a "$hasarg" != noarg && {
        mbfl_message_error \
            "wrong value '$hasarg' to hasarg field in option declaration number ${index}"
        exit 2
    }
    mbfl_getopts_HASARG[$mbfl_getopts_INDEX]=$hasarg

    test "$hasarg" = noarg -a "$default" != yes -a "$default" != no && {
        mbfl_message_error \
            "wrong value '$default' as default for option with no argument number ${index}"
        exit 2
    }
    mbfl_getopts_DEFAULTS[$mbfl_getopts_INDEX]=$default

    mbfl_p_declare_option_test_length $description description $index
    mbfl_getopts_DESCRIPTION[$mbfl_getopts_INDEX]=$description

    mbfl_getopts_INDEX=$index

    # Create the global option variable
    eval script_option_$(mbfl_string_toupper ${keyword})=\'"${default}"\'

    # Process action option.
    test ${keyword:0:7} = 'ACTION_' && {
        if test "${hasarg}" = 'noarg'
        then test "${default}" = 'yes' && \
            mbfl_main_set_main script_$(mbfl_string_tolower ${keyword})
        else mbfl_message_error "action option must be with no argument '${keyword}'"
        fi
    }
}
function mbfl_p_declare_option_test_length () {
    local value="${1}"
    local value_name="${2}"
    local option_number=${3}

    test -z "$value" && {
        mbfl_message_error "null ${value_name} in declared option number ${option_number}"
        exit 2
    }
}

#page
function mbfl_declare_action_argument () {
    mandatory_parameter(keyword,1,keyword)
    mandatory_parameter(argument,2,identifier)
    mandatory_parameter(selected,3,selection)
    mandatory_parameter(skipopts,4,skip options)
    mandatory_parameter(description,5,description)
    local index=$(($mbfl_getopts_actargs_INDEX + 1))

# Validation of arguments is commented out for speed problems

#     test -z "${keyword}" && {
#         mbfl_message_error "null keyword in declared action argument number ${index}"
#         exit 2
#     }
    mbfl_getopts_actargs_KEYWORDS[$mbfl_getopts_actargs_INDEX]="$keyword"

#     mbfl_getopts_is_action_argument "${argument}" || {
#         mbfl_message_error "wrong value '$argument' as keyword for action argument number ${index}"
#         exit 2
#     }
    mbfl_getopts_actargs_STRINGS[$mbfl_getopts_actargs_INDEX]="$argument"

#     test "$selected" != "yes" -a "$selected" != "no" && {
#         mbfl_message_error \
#             "wrong value '$selected' as selection for action argument number ${index}"
#         exit 2
#     }

#     test "$skipopts" != "yes" -a "$skipopts" != "no" && {
#         mbfl_message_error \
#             "wrong value '$skipopts' as skip options flag for action argument number ${index}"
#         exit 2
#     }
    mbfl_getopts_actargs_SKIPOPTS[$mbfl_getopts_actargs_INDEX]="$skipopts"

#     test -z "$description" && {
#         mbfl_message_error "null description in declared action argument number ${index}"
#         exit 2
#     }
    mbfl_getopts_actargs_DESCRIPTION[$mbfl_getopts_actargs_INDEX]=$description

    mbfl_getopts_actargs_INDEX=$index

    test "${selected}" = 'yes' && mbfl_main_set_main script_action_${keyword}
    return 0
}
#page
function mbfl_getopts_parse () {
    local p_OPT= p_OPTARG= argument= i=0 j=0
    local found_end_of_options_delimiter=0

    test -n "${ARGV1[0]}" && mbfl_getopts_is_action_argument "${ARGV1[0]}" && {
        for ((j=0; $j < $mbfl_getopts_actargs_INDEX; ++j))
        do
            test "${ARGV1[0]}" = "${mbfl_getopts_actargs_STRINGS[$j]}" && {
                mbfl_main_set_main script_action_"${mbfl_getopts_actargs_KEYWORDS[$j]}"
                i=1
                if test "${mbfl_getopts_actargs_SKIPOPTS[$j]}" = yes
                then
                    ARGC=$((${ARGC1}-1))
                    for ((i=$i; $i < $ARGC1; ++i))
                    do ARGV[$i]=${ARGV1[$i]}
                    done
                    return 0
                else break
                fi
            }
        done
    }

    for ((i=$i; $i < $ARGC1; ++i)); do
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
            test $i = 0 && found_possible_action_argument=1
            ARGV[$ARGC]="${argument}"
            let ++ARGC
        fi
    done

    mbfl_option_encoded_args && {
        for ((i=0; $i < $ARGC; ++i))
        do ARGV[$i]=$(mbfl_decode_hex "${ARGV[$i]}")
        done
    }
    declare -r ARGC ARGV
    return 0
}
#page
function mbfl_getopts_p_process_script_option () {
    mandatory_parameter(OPT, 1, option name)
    optional_parameter(OPTARG, 2)
    local i=0 value brief long hasarg keyword tolower_keyword update_procedure state_variable

    for ((i=0; $i < $mbfl_getopts_INDEX; ++i))
    do
        keyword="${mbfl_getopts_KEYWORDS[$i]}"
        brief="${mbfl_getopts_BRIEFS[$i]}"
        long="${mbfl_getopts_LONGS[$i]}"
        hasarg="${mbfl_getopts_HASARG[$i]}"
        test \( -n "$OPT" \) -a \( \( -n "$brief" -a "$brief" = "$OPT" \) -o \
            \( -n "$long"  -a "$long"  = "$OPT" \) \) && {
          if test "$hasarg" = "witharg"
          then
              if mbfl_option_encoded_args
              then value=$(mbfl_decode_hex "${OPTARG}")
              else value="$OPTARG"
              fi
          else value="yes"
          fi

          tolower_keyword=$(mbfl_string_tolower ${keyword})
          test ${keyword:0:7} = ACTION_ && \
              mbfl_main_set_main script_${tolower_keyword}
          update_procedure=script_option_update_${tolower_keyword}
          state_variable=script_option_${keyword}
          eval ${state_variable}=\'"${value}"\'
          mbfl_invoke_script_function ${update_procedure}
          return 0
        }
    done
    return 1
}
#PAGE
function mbfl_getopts_p_process_predefined_option_no_arg () {
    local OPT="${1:?}" i=0

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
	show-program)
            mbfl_set_option_show_program
	    ;;
	debug)
            mbfl_set_option_debug
            mbfl_set_option_verbose
            mbfl_set_option_show_program
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
            mbfl_main_set_private_main mbfl_program_main_validate_programs
            ;;
        list-exit-codes)
            mbfl_main_list_exit_codes
	    exit 0
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
                GPL|GPL2)
                    echo -e "${mbfl_message_LICENSE_GPL}"
                    ;;
                GPL3)
                    echo -e "${mbfl_message_LICENSE_GPL3}"
                    ;;
                LGPL|LGPL2)
                    echo -e "${mbfl_message_LICENSE_LGPL}"
                    ;;
                LGPL3)
                    echo -e "${mbfl_message_LICENSE_LGPL3}"
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
            mbfl_getopts_print_usage_screen long
	    exit 0
	    ;;
	H|brief-help|brief-usage)
            mbfl_getopts_print_usage_screen brief
	    exit 0
	    ;;
        print-options)
            mbfl_getopts_print_long_switches
            exit 0
            ;;
        print-action-arguments)
            mbfl_getopts_print_action_arguments
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
    local OPT="${1:?}" OPTARG="${2:?}"

    mbfl_option_encoded_args && OPTARG=$(mbfl_decode_hex "${OPTARG}")
    case "${OPT}" in
        tmpdir)
            mbfl_option_TMPDIR="${OPTARG}"
            ;;
        print-exit-code)
            mbfl_main_print_exit_code "${OPTARG}"
            exit 0
        ;;
        print-exit-code-names|print-exit-code-name)
            mbfl_main_print_exit_code_names "${OPTARG}"
            exit 0
        ;;
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
function mbfl_getopts_print_usage_screen () {
    mandatory_parameter(BRIEF_OR_LONG,1,brief or long selection)
    local i=0 item brief long description long_hasarg long_hasarg default

    printf '%s\n' "${script_USAGE}"
    test -n "${script_DESCRIPTION}" && printf "${script_DESCRIPTION}\n"

    test $mbfl_getopts_actargs_INDEX != 0 && {
        printf 'actions:\n'
        for ((i=0; $i < $mbfl_getopts_actargs_INDEX; ++i))
        do printf '\t%s %s [options] [-- [other-args]]\n\t\t%s\n\n' \
            "${script_PROGNAME}" "${mbfl_getopts_actargs_STRINGS[$i]}" \
            "${mbfl_getopts_actargs_DESCRIPTION[$i]}"
        done
    }
    test $mbfl_getopts_INDEX != 0 -o ${BRIEF_OR_LONG} = long && printf 'options:\n'
    test $mbfl_getopts_INDEX != 0 && {
        for ((i=0; $i < $mbfl_getopts_INDEX; ++i))
        do
            if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
            then
                brief_hasarg="VALUE"
                long_hasarg="=VALUE"
            else
                brief_hasarg=
                long_hasarg=
            fi

            printf '\t'

            brief="${mbfl_getopts_BRIEFS[$i]}"
            test -n "$brief" && printf -- '-%s%s ' "${brief}" "${brief_hasarg}"

            long="${mbfl_getopts_LONGS[$i]}"
            test -n "$long" && printf -- '--%s%s' "${long}" "${long_hasarg}"

            printf '\n'

            description="${mbfl_getopts_DESCRIPTION[$i]}"
            test -z "${description}" && description='undocumented option'

            printf '\t\t%s\n' "${description}"

            if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
            then
                item="${mbfl_getopts_DEFAULTS[$i]}"
                if test -n "${item}"
                then default=$(printf "'%s'" "${item}")
                else default='empty'
                fi
                printf '\t\t(default: %s)\n' "${default}"
            else
                test ${mbfl_getopts_KEYWORDS[$i]:0:7} = ACTION_ && {
                    if test "${mbfl_getopts_DEFAULTS[$i]}" = 'yes'
                    then printf '\t\t(default action)\n'
                    fi
                }
            fi
        done
    }

    # Do  it as  first argument  of "printf"  to  expand the
    # escaped characters.
    test ${BRIEF_OR_LONG} = long && printf "${mbfl_message_DEFAULT_OPTIONS}"
    test -n "${script_EXAMPLES}" && printf "${script_EXAMPLES}\n"
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
    equal_position=$(mbfl_string_first "${ARGUMENT}" =)
    test -z "$equal_position" -o $(($equal_position + 1)) = $len && return 1

    mbfl_getopts_islong "${ARGUMENT:0:$equal_position}" || return 1
    mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${ARGUMENT:2:$(($equal_position - 2))}"
    mbfl_set_maybe "${VALUE_VARIABLE_NAME}"  "${ARGUMENT:$(($equal_position + 1))}"
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
    local QUOTED_VALUE=$(mbfl_string_quote "${COMMAND_LINE_ARGUMENT:2}")
    mbfl_set_maybe "${VALUE_VARIABLE_NAME}" "${QUOTED_VALUE}"
    return 0
}
function mbfl_p_getopts_not_char_in_brief_option_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \) -a \
        \( "$1" \< 0 -o 9 \< "$1" \)
}
#page
function mbfl_getopts_is_action_argument () {
    mandatory_parameter(ARGUMENT, 1, command line argument)
    local len="${#ARGUMENT}" i ch

    ch="${ARGUMENT:0:1}"
    mbfl_p_getopts_not_first_char_in_action_argument_name "$ch" && return 1
    for ((i=1; $i < $len; ++i))
    do
        ch="${ARGUMENT:$i:1}"
        mbfl_p_getopts_not_char_in_action_argument_name "$ch" && return 1
    done

    return 0
}
function mbfl_p_getopts_not_first_char_in_action_argument_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \)
}
function mbfl_p_getopts_not_char_in_action_argument_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \) -a \
        \( "$1" \< 0 -o 9 \< "$1" \) -a \
        \( "$1" != '-' \)
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
function mbfl_wrong_num_args_range () {
    mandatory_parameter(min_required, 1, minimum required number of args)
    mandatory_parameter(max_required, 2, maximum required number of args)
    mandatory_parameter(argc, 3, given number of args)

    test $min_required -gt $argc -o $max_required -lt $argc && {
        mbfl_message_error \
            "number of required arguments between $min_required and $max_required but given $argc"
        return 1
    }
    return 0
}
function mbfl_argv_from_stdin () {
    local item=

    test $ARGC -ne 0 && {
        while mbfl_read_maybe_null item
        do
            ARGV[${ARGC}]=${item}
            let ++ARGC
        done
    }
    return 0
}
function mbfl_argv_all_files () {
    local i item

    for ((i=0; $i < $ARGC; ++i))
    do
	item=$(mbfl_file_normalise "${ARGV[$i]}")
	test -f "${item}" || {
	    mbfl_message_error "unexistent file '${item}'"
	    return 1
        }
	ARGV[$i]=${item}
    done
    return 0
}

#page
function mbfl_getopts_p_test_option () {
    test "${!1}" = yes
}
function mbfl_getopts_print_long_switches () {
    local i=0

    for ((i=0; $i < ${#mbfl_getopts_LONGS[@]}; ++i))
    do
        if test -n "${mbfl_getopts_LONGS[$i]}"
        then printf -- '--%s' "${mbfl_getopts_LONGS[$i]}"
        else continue
        fi
        test $(($i+1)) -lt ${#mbfl_getopts_LONGS[@]} && echo -n ' '
    done
    echo
    return 0
}
function mbfl_getopts_print_action_arguments () {
    local i=0 argument

    for ((i=0; $i < ${mbfl_getopts_actargs_INDEX}; ++i))
    do
        argument="${mbfl_getopts_actargs_STRINGS[$i]}"
        if test -n "${argument}"
        then echo -n "${argument}"
        else continue
        fi
        test $(($i+1)) -lt ${mbfl_getopts_actargs_INDEX} && echo -n ' '
    done
    echo
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
