# ... .sh --
# 
# Part of: ...
# Contents: ...
# Date: ...
# 
# Abstract
# 
# 
# 
# Copyright (c) 2004 Marco Maggi
# 
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
# 
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
# 
# $Id: template.sh.m4,v 1.1.1.29 2004/02/05 08:04:21 marco Exp $
#

set -e
#set -x

m4_changequote([[, ]])

#PAGE
## ------------------------------------------------------------
## Service variables.
## ------------------------------------------------------------

script_PROGNAME="..."
script_AUTHOR="Marco Maggi"
script_COPYRIGHT="2004"

Revision=
script_VERSION="$Revision: 1.1.1.29 $Revision"
script_REVISION="${script_VERSION:2}"
script_ORG_PWD="${PWD}"

message_VERSION="${script_PROGNAME} version${script_VERSION}
Written by ${script_AUTHOR}.

Copyright (C) ${script_COPYRIGHT} by ${script_AUTHOR}.
This is free software;  see the source for  copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
"

message_USAGE="usage: ${script_PROGNAME} [options] ...
A script template.
options:
\t   --one=ARG           an action
\t   --two=ARG           an action
\t   --three=ARG         an action
\n
\t   --interactive       ask before doing dangerous operations
\t   --force             do not ask before dangerous operations
\t   --encoded-args      decode arguments following this option
\t                       from the hex format (example: 414243 -> ABC)
\t-v --verbose           verbose execution
\t-s --silent            silent execution
\t   --null              read arguments from stdin using the null
\t                       character as terminator
\t-d --debug             print debug messages
\t-T --test              tests execution
\t   --version           print version informations and exit
\t   --license           print license informations and exit
\t-h --help --usage      print usage informations and exit
"

message_LICENSE="${script_PROGNAME} version$Revision: 1.1.1.29 $Revision
Written by ${script_AUTHOR}.

Copyright (C) ${script_COPYRIGHT} by ${script_AUTHOR}.

This file  is free software you  can redistribute it  and/or modify it
under the terms of the GNU  General Public License as published by the
Free Software  Foundation; either version  2, or (at your  option) any
later version.

This  file is  distributed in  the hope  that it  will be  useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.

You  should have received  a copy  of the  GNU General  Public License
along with this file; see the file COPYING.  If not, write to the Free
Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
02111-1307, USA.
"

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

option_VERBOSE="no"
option_DEBUG="no"
option_TEST="no"

option_INTERACTIVE="yes"
option_ENCODED_ARGS="no"
option_TMPDIR="${TMPDIR:-/tmp}"

option_ACTION=

option_ONE=
option_TWO=
option_THREE=


#PAGE
# main --
#
#	Main script function.
#
#  Arguments:
#
#	None.
#
#  Results:
#
#	Exits with code zero if no errors; exits with code 1 if an
#	error performing the request occurs; exits with code 2 if
#	an error in the invocation is detected.
#

function main () {

    # Parses command line options.

    mbfl_message_set_progname "${script_PROGNAME}"
    mbfl_getopts_parse

    if test "${option_ENCODED_ARGS}" = "yes"
    then mbfl_getopts_decode_hex
    fi

    mbfl_message_set_verbosity "${option_VERBOSE}"
    mbfl_message_set_debugging "${option_DEBUG}"


    # Prints execution messages.

    if test "${option_VERBOSE}" = "yes"
    then echo -e "${message_VERSION}" >&2
    fi
    if test "${option_TEST}" = "yes"
    then mbfl_message_string "test execution\n"
    fi


    # Selects the action to perform.

    case "${option_ACTION}" in
	one)
	    mbfl_argv_from_stdin
	    mbfl_wrong_num_args 0 0
	    echo "argument: ${option_ONE}"
	;;
	two)
	    echo "argument: ${option_TWO}"
	;;
	three)
	    echo "argument: ${option_three}"
	;;
	four)
	    echo "action four"
	;;

	*)
	    mbfl_message_error "select an action, please (--action)"
	    exit 2
	;;
    esac

    exit 0
}
#PAGE
# mbfl_getopts_option --
#
#	Callback function required by "mbfl_getopts_parse()". It's
#	invoked whenever an option without argument is found on the
#	command line.
#
#  Arguments:
#
#	$1 -		the option without the leading dash(es)
#
#  Results:
#
#	Recognises the option and updates the value of the
#	appropriated "option_*" global variable. If the option is
#	recognised: returns with code zero, else prints an error
#	message and exits with code two.
#

function mbfl_getopts_option () {
    local OPT="${1:?}"

    case "${OPT}" in
	four)
	    option_ACTION="four"
	    ;;

	encoded-args)
	    option_ENCODED_ARGS="yes"
	    ;;
	v|verbose)
	    option_VERBOSE="yes"
	    ;;
	s|silent)
	    option_VERBOSE="no"
	    ;;
	d|debug)
	    option_DEBUG="yes"
	    ;;
	T|test)
	    option_TEST="yes"
	    mbfl_program_TEST="yes"
	    ;;
	null)
	    mbfl_option_NULL="yes"
	    ;;
        force)
	    option_INTERACTIVE="no"
	    ;;
        interactive)
	    option_INTERACTIVE="yes"
	    ;;
	version)
	    echo -e "${message_VERSION}"
	    exit 0
	    ;;
	version-only)
	    echo -e "${script_REVISION}"
	    exit 0
	    ;;
	license)
	    echo -e "${message_LICENSE}"
	    exit 0
	    ;;
	h|help|usage)
	    echo -e "${message_USAGE}"
	    exit 0
	    ;;
	*)
	    mbfl_message_error "unknown option \"${OPT}\""
	    exit 2
	    ;;
    esac
    return 0
}
#PAGE
# mbfl_getopts_option_with --
#
#	Callback function required by "mbfl_getopts_parse()". It's
#	invoked whenever an option with argument is found on the
#	command line.
#
#  Arguments:
#
#	$1 -		the option without the leading dash(es)
#	$2 -		the option argument
#
#  Results:
#
#	Recognises the option and updates the value of the
#	appropriated "option_*" global variable. If the option is
#	recognised: returns with code zero, else prints an error
#	message and exits with code two.
#

function mbfl_getopts_option_with () {
    local OPT="${1:?}"
    local OPTARG="${2:?}"

    case "$OPT" in
	1|one)
	    option_ACTION=one
	    option_ONE=$(script_option_decode "${OPTARG}")
	    ;;
	2|two)
	    option_ACTION=two
	    option_TWO=$(script_option_decode "${OPTARG}")
	    ;;
	3|three)
	    option_ACTION=three
	    option_THREE=$(script_option_decode "${OPTARG}")
	    ;;
	*)
	    mbfl_message_error "unknown option \"${OPT}\""
	    exit 2
	    ;;
    esac
    return 0
}
#PAGE
# script_option_decode --
#
#	Decodes a single argument, but only if the global script
#	option "option_ENCODED_ARGS" is "yes".
#
#  Arguments:
#
#	$1 -		the argument to decode
#
#  Results:
#
#	Echoes to stdout the decoded argument. Returns with code
#	zero.
#

function script_option_decode () {
    local ARG="${1:?}"

    if test "${option_ENCODED_ARGS}" = "yes"
    then mbfl_decode_hex "${ARG}"
    else echo -n "${ARG}"
    fi

    return 0
}
#PAGE
## ------------------------------------------------------------
## Libraries.
## ------------------------------------------------------------

m4_include(libMBFL.sh)

#PAGE
## ------------------------------------------------------------
## Main script.
## ------------------------------------------------------------

main


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# End:
