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
# Copyright (c) 2003-2005, 2009, 2013, 2014, 2018 Marco Maggi
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

#PAGE
#### global variables

if test "$mbfl_INTERACTIVE" = 'yes'
then
    declare -i mbfl_getopts_INDEX=0
    declare -a mbfl_getopts_KEYWORDS
    declare -a mbfl_getopts_DEFAULTS
    declare -a mbfl_getopts_BRIEFS
    declare -a mbfl_getopts_LONGS
    declare -a mbfl_getopts_HASARG
    declare -a mbfl_getopts_DESCRIPTION
fi

#page
#### default options description

if test "$mbfl_INTERACTIVE" != yes
then

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
\t--show-programs
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
\t-h --help --usage
\t\tprint usage informations and exit
\t-H --brief-help --brief-usage
\t\tprint usage informations and the list of script specific
\t\toptions, then exit
"

fi

#page
function mbfl_declare_option () {
    mbfl_mandatory_parameter(keyword, 1, option declaration keyword)
    local default=$2
    local brief=$3
    local long=$4
    mbfl_mandatory_parameter(hasarg, 5, option declaration hasarg selection)
    mbfl_mandatory_parameter(description, 6, option declaration decription)
    local tolower_keyword toupper_keyword
    local -ri index=$((1 + mbfl_getopts_INDEX))

    mbfl_p_declare_option_test_length "$keyword" 'keyword' $index

    mbfl_string_toupper_var toupper_keyword $keyword
    mbfl_string_tolower_var tolower_keyword $keyword

    mbfl_getopts_KEYWORDS[$mbfl_getopts_INDEX]=$toupper_keyword
    mbfl_getopts_BRIEFS[$mbfl_getopts_INDEX]=$brief
    mbfl_getopts_LONGS[$mbfl_getopts_INDEX]=$long

    mbfl_p_declare_option_test_length "$hasarg" 'hasarg' $index
    if { mbfl_string_not_equal "$hasarg" 'witharg' && mbfl_string_not_equal "$hasarg" 'noarg'; }
    then
        mbfl_message_error_printf 'wrong value "%s" to hasarg field in option declaration number %d' "$hasarg" $index
        exit_because_invalid_option_declaration
    fi
    mbfl_getopts_HASARG[$mbfl_getopts_INDEX]=$hasarg

    if { mbfl_string_equal "$hasarg" 'noarg' && \
	     mbfl_string_not_equal "$default" 'yes' && \
	     mbfl_string_not_equal "$default" 'no'; }
    then
        mbfl_message_error_printf 'wrong value "%s" as default for option with no argument number %d' "$default" $index
        exit_because_invalid_option_declaration
    fi
    mbfl_getopts_DEFAULTS[$mbfl_getopts_INDEX]=$default

    mbfl_p_declare_option_test_length "$description" 'description' $index
    mbfl_getopts_DESCRIPTION[$mbfl_getopts_INDEX]=$description

    mbfl_getopts_INDEX=$index

    # Create the global option variable
    eval script_option_${toupper_keyword}=\'"$default"\'

    # Process action option.
    if mbfl_string_equal ${keyword:0:7} 'ACTION_'
    then
        if mbfl_string_equal "$hasarg" 'noarg'
        then
            if mbfl_string_equal "$default" 'yes'
            then mbfl_main_set_main script_${tolower_keyword}
            fi
        else
            mbfl_message_error_printf 'action option must be with no argument "%s"' $keyword
            return 1
        fi
    fi
    return 0
}
function mbfl_p_declare_option_test_length () {
    local value=$1
    mbfl_mandatory_parameter(value_name, 2, value name)
    mbfl_mandatory_integer_parameter(option_number, 3, ciao number)

    if mbfl_string_is_empty "$value"
    then
        mbfl_message_error_printf 'null "%s" in declared option number %d' "$value_name" $option_number
        exit_because_invalid_option_declaration
    fi
}

#page
function mbfl_getopts_parse () {
    local p_OPT= p_OPTARG= argument=
    local -i i

    for ((i=ARG1ST; i < ARGC1; ++i))
    do
        argument=${ARGV1[$i]}

	if mbfl_string_equal "$argument" '--'
        then
	    # Found  end-of-options  delimiter.   Everything else  is  a
	    # non-option argument.
	    for ((i=$i; i < ARGC1; ++i))
	    do
		ARGV[$ARGC]=${argument}
		let ++ARGC
	    done
	    break
	elif mbfl_string_equal '--' "${argument:0:2}"
	then
	    if mbfl_getopts_islong  "$argument" p_OPT
	    then
		if ! mbfl_getopts_p_process_predefined_option_no_arg "$p_OPT"
		then return 1
		fi
	    elif mbfl_getopts_islong_with "$argument" p_OPT p_OPTARG
	    then
		if ! mbfl_getopts_p_process_predefined_option_with_arg "$p_OPT" "$p_OPTARG"
		then return 1
		fi
	    else
		# Invalid command line argument starting with "--".
		mbfl_message_error_printf 'invalid command line argument: "%s"' "$argument"
		return 1
	    fi
	elif mbfl_string_equal '-' "${argument:0:1}"
	then
            if mbfl_getopts_isbrief "$argument" p_OPT
            then
		if ! mbfl_getopts_p_process_predefined_option_no_arg "$p_OPT"
		then return 1
		fi
            elif mbfl_getopts_isbrief_with "$argument" p_OPT p_OPTARG
            then
		if ! mbfl_getopts_p_process_predefined_option_with_arg "$p_OPT" "$p_OPTARG"
		then return 1
		fi
	    else
		# Invalid command line argument starting with "-".
		mbfl_message_error_printf 'invalid command line argument: "%s"' "$argument"
		return 1
	    fi
	else
	    # If it is not an option: it is a non-option argument.
	    ARGV[$ARGC]=${argument}
	    let ++ARGC
        fi
    done

    if mbfl_option_encoded_args
    then
        for ((i=0; i < ARGC; ++i))
        do ARGV[$i]=$(mbfl_decode_hex "${ARGV[$i]}")
        done
    fi
    return 0
}

#page
function mbfl_getopts_p_process_script_option () {
    mbfl_mandatory_parameter(OPT, 1, option name)
    mbfl_optional_parameter(OPTARG, 2)
    local i=0 value brief long hasarg keyword tolower_keyword update_procedure state_variable

    for ((i=0; i < mbfl_getopts_INDEX; ++i))
    do
        keyword=${mbfl_getopts_KEYWORDS[$i]}
        brief=${mbfl_getopts_BRIEFS[$i]}
        long=${mbfl_getopts_LONGS[$i]}
        hasarg=${mbfl_getopts_HASARG[$i]}
        if test \( -n "$OPT" \) -a \
		\( \( -n "$brief" -a "$brief" = "$OPT" \) -o \( -n "$long" -a "$long" = "$OPT" \) \)
	then
            if mbfl_string_equal "$hasarg" "witharg"
            then
		if mbfl_string_is_empty "$OPTARG"
		then
                    mbfl_message_error "expected non-empty argument for option: \"$OPT\""
                    return 1
		fi
		if mbfl_option_encoded_args
		then value=$(mbfl_decode_hex "$OPTARG")
		else value=$OPTARG
		fi
            else value=yes
            fi
            mbfl_string_tolower_var tolower_keyword ${keyword}
            if mbfl_string_equal ${keyword:0:7} ACTION_
	    then mbfl_main_set_main script_${tolower_keyword}
	    fi
            update_procedure=script_option_update_${tolower_keyword}
            state_variable=script_option_${keyword}
            eval ${state_variable}=\'"$value"\'
            mbfl_invoke_script_function ${update_procedure}
            return 0
        fi
    done
    mbfl_message_error_printf 'unknown option "%s"' "$OPT"
    return 1
}
#PAGE
function mbfl_getopts_p_process_predefined_option_no_arg () {
    mbfl_mandatory_parameter(OPT, 1, option name)
    local i=0

    case $OPT in
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
	show-program|show-programs)
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
            mbfl_main_set_private_main mbfl_main_list_exit_codes
            ;;
	version)
            mbfl_main_set_private_main mbfl_main_print_version_number
	    ;;
	version-only)
            mbfl_main_set_private_main mbfl_main_print_version_number_only
	    ;;
	license)
            mbfl_main_set_private_main mbfl_main_print_license
	    ;;
	h|help|usage)
            mbfl_main_set_private_main mbfl_main_print_usage_screen_long
	    ;;
	H|brief-help|brief-usage)
            mbfl_main_set_private_main mbfl_main_print_usage_screen_brief
	    ;;
        print-options)
            mbfl_main_set_private_main mbfl_getopts_print_long_switches
            ;;
	*)
            mbfl_getopts_p_process_script_option "$OPT"
            return $?
	    ;;
    esac
    return 0
}
#PAGE
function mbfl_getopts_p_process_predefined_option_with_arg () {
    mbfl_mandatory_parameter(OPT, 1, option name)
    mbfl_mandatory_parameter(OPTARG, 2, option argument)

    if mbfl_string_is_empty "$OPTARG"
    then
        mbfl_message_error_printf 'empty value given to option "%s" requiring argument' "$OPT"
        exit_because_invalid_option_argument
    fi
    if mbfl_option_encoded_args
    then OPTARG=$(mbfl_decode_hex "$OPTARG")
    fi
    case $OPT in
        tmpdir)
            mbfl_option_TMPDIR=${OPTARG}
            ;;
        print-exit-code)
            mbfl_main_print_exit_code "$OPTARG"
            exit 0
            ;;
        print-exit-code-names|print-exit-code-name)
            mbfl_main_print_exit_code_names "$OPTARG"
            exit 0
            ;;
	*)
	    mbfl_getopts_p_process_script_option "$OPT" "$OPTARG"
            return $?
            ;;
    esac
    return 0
}
#page
function mbfl_getopts_print_usage_screen () {
    mbfl_mandatory_parameter(BRIEF_OR_LONG,1,brief or long selection)
    local i=0 item brief long description long_hasarg long_hasarg default

    printf 'Options:\n'
    if ((0 == mbfl_getopts_INDEX))
    then printf '\tNo script-specific options.\n'
    else
        for ((i=0; i < mbfl_getopts_INDEX; ++i))
        do
            if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
            then
                brief_hasarg='VALUE'
                long_hasarg='=VALUE'
            else
                brief_hasarg=
                long_hasarg=
            fi

            printf '\t'

            brief=${mbfl_getopts_BRIEFS[$i]}
            if test -n "$brief"
	    then printf -- '-%s%s ' "$brief" "$brief_hasarg"
	    fi

            long=${mbfl_getopts_LONGS[$i]}
            if test -n "$long"
	    then printf -- '--%s%s' "$long" "$long_hasarg"
	    fi

            printf '\n'

            description=${mbfl_getopts_DESCRIPTION[$i]}
            if mbfl_string_is_empty "$description"
	    then description='undocumented option'
	    fi

            printf '\t\t%s\n' "$description"

            if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
            then
                item=${mbfl_getopts_DEFAULTS[$i]}
                if mbfl_string_is_not_empty "$item"
                then printf -v default "'%s'" "$item"
                else default='empty'
                fi
                printf '\t\t(default: %s)\n' "$default"
            else
                if test ${mbfl_getopts_KEYWORDS[$i]:0:7} = ACTION_
		then
                    if test "${mbfl_getopts_DEFAULTS[$i]}" = 'yes'
                    then printf '\t\t(default action)\n'
                    fi
		fi
            fi
        done
    fi
    printf '\n'

    # Do  it  as  first  argument  of "printf"  to  expand  the  escaped
    # characters.
    if test $BRIEF_OR_LONG = long
    then
	printf 'Common options:\n'
	printf "$mbfl_message_DEFAULT_OPTIONS"
	printf '\n'
    fi
}
#page
function mbfl_getopts_islong () {
    mbfl_mandatory_parameter(ARGUMENT, 1, argument)
    mbfl_optional_parameter(OPTION_VARIABLE_NAME, 2)
    local -r REX='^--([a-zA-Z0-9_\-]+)$'

    if [[ $ARGUMENT =~ $REX ]]
    then
	mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
	return 0
    else return 1
    fi
}
function mbfl_getopts_islong_with () {
    mbfl_mandatory_parameter(ARGUMENT, 1, argument)
    mbfl_optional_parameter(OPTION_VARIABLE_NAME, 2)
    mbfl_optional_parameter(VALUE_VARIABLE_NAME, 3)
    local -r REX='^--([a-zA-Z0-9_\-]+)=(.+)$'

    if [[ $ARGUMENT =~ $REX ]]
    then
	mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
	mbfl_set_maybe "$VALUE_VARIABLE_NAME"  "${BASH_REMATCH[2]}"
	return 0
    else return 1
    fi
}

#page
function mbfl_getopts_isbrief () {
    mbfl_mandatory_parameter(ARGUMENT, 1, argument)
    mbfl_optional_parameter(OPTION_VARIABLE_NAME, 2)
    local -r REX='^-([a-zA-Z0-9])$'

    if [[ $ARGUMENT =~ $REX ]]
    then
	mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
	return 0
    else return 1
    fi
}
function mbfl_getopts_isbrief_with () {
    mbfl_mandatory_parameter(ARGUMENT, 1, argument)
    mbfl_optional_parameter(OPTION_VARIABLE_NAME, 2)
    mbfl_optional_parameter(VALUE_VARIABLE_NAME, 3)
    local -r REX='^-([a-zA-Z0-9])(.+)$'

    if [[ $ARGUMENT =~ $REX ]]
    then
	mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
	mbfl_set_maybe "$VALUE_VARIABLE_NAME"  $(mbfl_string_quote "${BASH_REMATCH[2]}")
	return 0
    else return 1
    fi
}

#PAGE
function mbfl_wrong_num_args () {
    mbfl_mandatory_integer_parameter(required, 1, required number of args)
    mbfl_mandatory_integer_parameter(argc, 2, given number of args)

    if ((required == argc))
    then return 0
    else
        mbfl_message_error "number of arguments required: $required"
        return 1
    fi
}
function mbfl_wrong_num_args_range () {
    mbfl_mandatory_integer_parameter(min_required, 1, minimum required number of args)
    mbfl_mandatory_integer_parameter(max_required, 2, maximum required number of args)
    mbfl_mandatory_integer_parameter(argc, 3, given number of args)

    if test $min_required -gt $argc -o $max_required -lt $argc
    then
        mbfl_message_error "number of required arguments between $min_required and $max_required but given $argc"
        return 1
    else return 0
    fi
}
function mbfl_argv_from_stdin () {
    local item=

    if ((0 == ARGC))
    then return 0
    else
        while mbfl_read_maybe_null item
        do
            ARGV[${ARGC}]=${item}
            let ++ARGC
        done
    fi
}
function mbfl_argv_all_files () {
    local i item

    for ((i=0; i < ARGC; ++i))
    do
	mbfl_file_normalise_var item "${ARGV[$i]}"
	if mbfl_file_is_file "$item"
	then ARGV[$i]=${item}
	else
	    mbfl_message_error_printf 'unexistent file "%s"' "$item"
	    return 1
        fi
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
        if (( (i+1) < ${#mbfl_getopts_LONGS[@]}))
	then echo -n ' '
	fi
    done
    echo
    return 0
}
# function mbfl_getopts_print_action_arguments () {
#     local i=0 argument

#     for ((i=0; $i < ${mbfl_getopts_actargs_INDEX}; ++i))
#     do
#         argument=${mbfl_getopts_actargs_STRINGS[$i]}
#         if test -n "$argument"
#         then echo -n "$argument"
#         else continue
#         fi
#         test $(($i+1)) -lt ${mbfl_getopts_actargs_INDEX} && echo -n ' '
#     done
#     echo
#     return 0
# }

### end of file
# Local Variables:
# mode: sh
# End:
