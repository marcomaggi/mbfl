# main.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: main script module
# Date: Mon May 17, 2004
#
# Abstract
#
#
#
# Copyright   (c)    2004-2005,   2009,    2013,   2018    Marco   Maggi
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
#### generic variables

if test "$mbfl_INTERACTIVE" != yes
then
    declare mbfl_option_TMPDIR=${TMPDIR:-/tmp/${USER}}
    declare -r mbfl_ORG_PWD=$PWD

    declare -i ARGC=0 ARGC1=0 ARG1ST=0
    declare -a ARGV ARGV1

    for ((ARGC1=0; $# > 0; ++ARGC1))
    do
        ARGV1[$ARGC1]=$1
        shift
    done

    # The name of the main function  to be called when no special action
    # is requested.  This  value can be customised by both  the MBFL and
    # the user script by calling the function "mbfl_main_set_main()".
    #
    declare mbfl_main_SCRIPT_FUNCTION=main

    # The name of  the main function to be called  whtn a special action
    # is requested, for example: printing the required external programs
    # then exit.   This value  is for  internal use only  and it  can be
    # changed      by     MBFL      by     calling      the     function
    # "mbfl_main_set_private_main()".
    #
    # When  this variable  is  not set  to the  empty  string: it  takes
    # precedence over the value selected by "mbfl_main_SCRIPT_FUNCTION".
    #
    declare mbfl_main_PRIVATE_SCRIPT_FUNCTION=

    # The name of the function to be called right before parsing command
    # line options.  This  value can be customised by both  the MBFL and
    # the      user     script      by     calling      the     function
    # "mbfl_main_set_before_parsing_options()".
    #
    declare mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS=script_before_parsing_options

    # The name of the function to  be called right after parsing command
    # line options.  This  value can be customised by both  the MBFL and
    # the      user     script      by     calling      the     function
    # "mbfl_main_set_before_parsing_options()".
    #
    declare mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS=script_after_parsing_options
fi

function mbfl_main_set_main () {
    mbfl_mandatory_parameter(FUNC,1,main function name)
    mbfl_main_SCRIPT_FUNCTION=${FUNC}
}
function mbfl_main_set_private_main () {
    mbfl_mandatory_parameter(FUNC,1,main function name)
    mbfl_main_PRIVATE_SCRIPT_FUNCTION=${FUNC}
}
function mbfl_main_set_before_parsing_options () {
    mbfl_mandatory_parameter(FUNC,1,main function name)
    mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS=${FUNC}
}
function mbfl_main_set_after_parsing_options () {
    mbfl_mandatory_parameter(FUNC,1,main function name)
    mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS=${FUNC}
}
#page
#### exit codes management

if test "$mbfl_INTERACTIVE" != yes
then
    declare -a mbfl_main_EXIT_CODES mbfl_main_EXIT_NAMES
    mbfl_main_EXIT_CODES[0]=0
    mbfl_main_EXIT_NAMES[0]=success

    mbfl_main_EXIT_CODES[1]=1
    mbfl_main_EXIT_NAMES[1]=failure

    mbfl_main_EXIT_CODES[2]=100
    mbfl_main_EXIT_NAMES[2]=error_loading_library

    mbfl_main_EXIT_CODES[3]=99
    mbfl_main_EXIT_NAMES[3]=program_not_found

    mbfl_main_EXIT_CODES[4]=98
    mbfl_main_EXIT_NAMES[4]=wrong_num_args

    mbfl_main_EXIT_CODES[5]=97
    mbfl_main_EXIT_NAMES[5]=invalid_action_set

    mbfl_main_EXIT_CODES[6]=96
    mbfl_main_EXIT_NAMES[6]=invalid_action_declaration

    mbfl_main_EXIT_CODES[7]=95
    mbfl_main_EXIT_NAMES[7]=invalid_action_argument

    mbfl_main_EXIT_CODES[8]=94
    mbfl_main_EXIT_NAMES[8]=missing_action_function

    mbfl_main_EXIT_CODES[9]=93
    mbfl_main_EXIT_NAMES[9]=invalid_option_declaration

    mbfl_main_EXIT_CODES[10]=92
    mbfl_main_EXIT_NAMES[10]=invalid_option_argument

    mbfl_main_EXIT_CODES[11]=91
    mbfl_main_EXIT_NAMES[11]=invalid_function_name

    mbfl_main_EXIT_CODES[12]=90
    mbfl_main_EXIT_NAMES[12]=invalid_sudo_username

    mbfl_main_EXIT_CODES[13]=89
    mbfl_main_EXIT_NAMES[13]=no_location

    declare mbfl_main_EXITING=false
    declare -i mbfl_main_pending_EXIT_CODE=0
fi

function mbfl_main_is_exiting () {
    $mbfl_main_EXITING
}
function mbfl_exit () {
    mbfl_optional_parameter(CODE, 1, 0)

    mbfl_main_pending_EXIT_CODE=$CODE
    mbfl_main_EXITING=true
    exit $CODE
}

function exit_success () {
    exit_because_success
}
function exit_failure () {
    exit_because_failure
}
alias return_success='return 0'
alias return_failure='return 1'
function mbfl_main_declare_exit_code () {
    mbfl_mandatory_parameter(CODE, 1, exit code)
    mbfl_mandatory_parameter(DESCRIPTION, 2, exit code name)
    local -i i=${#mbfl_main_EXIT_CODES[@]}
    mbfl_main_EXIT_NAMES[$i]=$DESCRIPTION
    mbfl_main_EXIT_CODES[$i]=$CODE
}
function mbfl_main_create_exit_functions () {
    local -i i
    local name
    for ((i=0; i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
    do
        name=exit_because_${mbfl_main_EXIT_NAMES[${i}]}
        eval function "$name" "()" "{ mbfl_exit ${mbfl_main_EXIT_CODES[${i}]}; }"
	name=return_because_${mbfl_main_EXIT_NAMES[${i}]}
	alias $name="return ${mbfl_main_EXIT_CODES[${i}]}"
    done
}
function mbfl_main_list_exit_codes () {
    local -i i
    for ((i=0; i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
    do printf '%d %s\n' ${mbfl_main_EXIT_CODES[${i}]} ${mbfl_main_EXIT_NAMES[${i}]}
    done
}
function mbfl_main_print_exit_code () {
    mbfl_mandatory_parameter(NAME, 1, exit code name)
    local -i i
    for ((i=0; i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
    do
	if test "${mbfl_main_EXIT_NAMES[${i}]}" = "$NAME"
	then printf '%d\n' ${mbfl_main_EXIT_CODES[${i}]}
	fi
    done
}
function mbfl_main_print_exit_code_names () {
    mbfl_mandatory_parameter(CODE, 1, exit code)
    local -i i
    for ((i=0; i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
    do
	if test "${mbfl_main_EXIT_CODES[${i}]}" = "$CODE"
	then printf '%s\n' ${mbfl_main_EXIT_NAMES[${i}]}
	fi
    done
}

#PAGE
#### license message variables

if test "$mbfl_INTERACTIVE" != 'yes'
then

declare -r mbfl_message_LICENSE_GPL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This file  is free software you  can redistribute it  and/or modify it
under the terms of the GNU  General Public License as published by the
Free Software  Foundation; either version  2, or (at your  option) any
later version.\n
This  file is  distributed in  the hope  that it  will be  useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.\n
You  should have received  a copy  of the  GNU General  Public License
along with this file; see the file COPYING.  If not, write to the Free
Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
02111-1307, USA.
"

declare -r mbfl_message_LICENSE_GPL3="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This file  is free software you  can redistribute it  and/or modify it
under the terms of the GNU  General Public License as published by the
Free Software  Foundation; either version  3, or (at your  option) any
later version.\n
This  file is  distributed in  the hope  that it  will be  useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.\n
You  should have received  a copy  of the  GNU General  Public License
along with this file; see the file COPYING.  If not, write to the Free
Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
02111-1307, USA.
"

declare -r mbfl_message_LICENSE_LGPL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; you  can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software  Foundation; either version  2.1 of the License,  or (at
your option) any later version.\n
This library  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
Lesser General Public License for more details.\n
You  should have  received a  copy of  the GNU  Lesser  General Public
License along  with this library; if  not, write to  the Free Software
Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
USA.
"

declare -r mbfl_message_LICENSE_LGPL3="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; you  can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software  Foundation; either version  3.0 of the License,  or (at
your option) any later version.\n
This library  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
Lesser General Public License for more details.\n
You  should have  received a  copy of  the GNU  Lesser  General Public
License along  with this library; if  not, write to  the Free Software
Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
USA.
"

declare -r mbfl_message_LICENSE_BSD="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
The author  hereby grant permission to use,  copy, modify, distribute,
and  license this  software  and its  documentation  for any  purpose,
provided that  existing copyright notices  are retained in  all copies
and that  this notice  is included verbatim  in any  distributions. No
written agreement, license, or royalty  fee is required for any of the
authorized uses.  Modifications to this software may be copyrighted by
their authors and need not  follow the licensing terms described here,
provided that the new terms are clearly indicated on the first page of
each file where they apply.\n
IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
POSSIBILITY OF SUCH DAMAGE.\n
THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN \"AS  IS\" BASIS,
AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
"

declare -r mbfl_message_LICENSE_LIBERAL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
The author  hereby grants permission  to use, copy,  modify, distribute,
and  license  this  software  and its  documentation  for  any  purpose,
provided that existing copyright notices  are retained in all copies and
that this notice is included  verbatim in any distributions.  No written
agreement, license, or royalty fee is required for any of the authorized
uses.   Modifications  to this  software  may  be copyrighted  by  their
authors and need not follow the licensing terms described here, provided
that the new terms are clearly indicated  on the first page of each file
where they apply.\n
IN NO EVENT SHALL THE AUTHOR OR  DISTRIBUTORS BE LIABLE TO ANY PARTY FOR
DIRECT, INDIRECT, SPECIAL, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE  USE OF THIS SOFTWARE, ITS DOCUMENTATION,  OR ANY DERIVATIVES
THEREOF, EVEN IF THE AUTHOR HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.\n
THE  AUTHOR  AND  DISTRIBUTORS  SPECIFICALLY  DISCLAIM  ANY  WARRANTIES,
INCLUDING,   BUT   NOT   LIMITED   TO,   THE   IMPLIED   WARRANTIES   OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
THIS  SOFTWARE IS  PROVIDED ON  AN  \"AS IS\"  BASIS, AND  THE AUTHOR  AND
DISTRIBUTORS  HAVE  NO  OBLIGATION   TO  PROVIDE  MAINTENANCE,  SUPPORT,
UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
"

fi

#PAGE
#### version message variables

if test "$mbfl_INTERACTIVE" != 'yes'
then

declare -r mbfl_message_VERSION="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; see the  source or use the '--license' option for
copying conditions.  There is NO warranty; not  even for MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.
"

fi

#page
#### printing stuff

function mbfl_main_print_version_number () {
    echo -e "$mbfl_message_VERSION"
    exit_success
}
function mbfl_main_print_version_number_only () {
    echo -e "$script_VERSION"
    exit_success
}
function mbfl_main_print_license () {
    case $script_LICENSE in
        GPL|GPL2)
            echo -e "$mbfl_message_LICENSE_GPL"
            ;;
        GPL3)
            echo -e "$mbfl_message_LICENSE_GPL3"
            ;;
        LGPL|LGPL2)
            echo -e "$mbfl_message_LICENSE_LGPL"
            ;;
        LGPL3)
            echo -e "$mbfl_message_LICENSE_LGPL3"
            ;;
        BSD)
            echo -e "$mbfl_message_LICENSE_BSD"
            ;;
        liberal)
            echo -e "$mbfl_message_LICENSE_LIBERAL"
            ;;
        *)
            mbfl_message_error_printf 'unknown license: "%s"' "$script_LICENSE"
            exit_failure
            ;;
    esac
    exit_success
}
function mbfl_main_print_usage_screen_long () {
    if mbfl_string_is_not_empty "$script_USAGE"
    then printf '%s\n' "$script_USAGE"
    else printf 'usafe: %s [arguments]\n' "$script_PROGNAME"
    fi
    if mbfl_string_is_not_empty "$script_DESCRIPTION"
    then
	# Use the variable  as first argument to "printf"  to expand the
	# escaped characters.
	printf "${script_DESCRIPTION}\n\n"
    fi
    mbfl_actions_print_usage_screen
    mbfl_getopts_print_usage_screen long
    if mbfl_string_is_not_empty "$script_EXAMPLES"
    then
	# Use the variable  as first argument to "printf"  to expand the
	# escaped characters.
	printf "${script_EXAMPLES}\n"
    fi
    exit_success
}
function mbfl_main_print_usage_screen_brief () {
    if mbfl_string_is_not_empty "$script_USAGE"
    then printf '%s\n' "$script_USAGE"
    else printf 'usafe: %s [arguments]\n' "$script_PROGNAME"
    fi
    if mbfl_string_is_not_empty "$script_DESCRIPTION"
    then
	# Use the variable  as first argument to "printf"  to expand the
	# escaped characters.
	printf "${script_DESCRIPTION}\n\n"
    fi
    mbfl_actions_print_usage_screen
    mbfl_getopts_print_usage_screen brief
    if mbfl_string_is_not_empty "$script_EXAMPLES"
    then
	# Use the variable  as first argument to "printf"  to expand the
	# escaped characters.
	printf "${script_EXAMPLES}\n"
    fi
    exit_success
}
#PAGE
#### main function

# This is  the main function  of the MBFL:  it must be  invoked (without
# aruments) as the last command in the script.
#
function mbfl_main () {
    local exit_code=0 action_func item code
    mbfl_message_set_progname "$script_PROGNAME"
    mbfl_main_create_exit_functions
    if mbfl_actions_set_exists MAIN
    then
	if ! mbfl_actions_dispatch MAIN
	then exit_failure
	fi
    fi
    if ! mbfl_invoke_script_function $mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS
    then exit_because_invalid_function_name
    fi
    if ! mbfl_getopts_parse
    then exit_because_invalid_option_argument
    fi
    if ! mbfl_invoke_script_function $mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS
    then exit_because_invalid_function_name
    fi
    if mbfl_string_is_not_empty "$mbfl_main_PRIVATE_SCRIPT_FUNCTION"
    then mbfl_invoke_existent_script_function $mbfl_main_PRIVATE_SCRIPT_FUNCTION
    else mbfl_invoke_existent_script_function $mbfl_main_SCRIPT_FUNCTION
    fi
    exit $?
}
# Called with a  function name argument: if such  function exists invoke
# it, else return with success.
#
function mbfl_invoke_script_function () {
    mbfl_mandatory_parameter(FUNC, 1, function name)
    if mbfl_string_equal 'function' "$(type -t $FUNC)"
    then $FUNC
    else return 0
    fi
}
# Called with a  function name argument: if such  function exists invoke
# it, else print an error message and exit.
#
function mbfl_invoke_existent_script_function () {
    mbfl_mandatory_parameter(FUNC, 1, function name)
    if mbfl_string_equal 'function' "$(type -t $FUNC)"
    then $FUNC
    else
	mbfl_message_error_printf 'internal error: request to call non-existent function \"%s\"' "$FUNC"
	exit_because_invalid_function_name
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
