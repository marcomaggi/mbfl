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
# Copyright (c) 2003 Marco Maggi
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
# $Id: getopts.sh.m4,v 1.1.1.24 2004/02/05 08:08:45 marco Exp $
#

m4_include(macros.m4)

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

ARGC=0
ARGC1=0
declare -a ARGV ARGV1

while test $# -gt 0
do
    ARGV1[$ARGC1]="$1"
    ARGC1=$(($ARGC1 + 1))
    shift
done

#PAGE
# mbfl_getopts_parse --
#
#       Parses a set of command line options. The options are handed
#       to user defined functions.
#
#  Arguments:
#
#       The array ARGV1 and the variable ARGC1 are supposed to hold the
#       command line arguments and the number of command line arguments.
#
#  Results:
#
#       When an option without argument is found: "mbfl_getopts_option()"
#       is called with the option name, without dashes, as first argument;
#       when an option with argument is found: "mbfl_getopts_option_with()"
#       is called with the option name, without dashes, as first
#       argument and the option value as second argument.
#
#         Non-option arguments are left in the global array "ARGV", the
#       global variable "ARGC" holds the number of elements in "ARGV".
#
#  Side effects:
#
#       None.
#

function mbfl_getopts_parse () {
    local OPT= OPTARG=
    local arg= end=0 i=0


    while test $i -lt $ARGC1
    do
        arg="${ARGV1[$i]}"
        if test "$end" = 1
        then
            ARGV[$ARGC]="${arg}"
            ARGC=$(($ARGC + 1))
        elif test "${arg}" = "--"
        then end=1
        elif mbfl_getopts_isbrief "${arg}" OPT || \
             mbfl_getopts_islong "${arg}" OPT
        then mbfl_getopts_option "${OPT}"
        elif \
            mbfl_getopts_isbrief_with "${arg}" OPT OPTARG || \
            mbfl_getopts_islong_with  "${arg}" OPT OPTARG
        then mbfl_getopts_option_with "${OPT}" "${OPTARG}"
        else
            ARGV[$ARGC]="${arg}"
            ARGC=$(($ARGC + 1))
        fi
        i=$(($i + 1))
    done

    return 0
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
#  Side effects:
#
#       None.
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
#  Side effects:
#
#       None.
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
#  Side effects:
#
#       None.
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
#  Side effects:
#
#       None.
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
# mbfl_getopts_decode_hex --
#
#       Decodes non-option arguments. Requires "mbfl_decode_hex()".
#       In hex-coding, each byte in the argument is replaced by
#       its representation in hex number.
#
#  Arguments:
#
#       None.
#
#  Results:
#
#       Decodes hex-coded arguments in the "ARGV" array. This
#       can be invoked if the command line arguments have been
#       encoded 
#
#  Side effects:
#
#       None.
#

function mbfl_getopts_decode_hex () {
    local i=0

    while test $i -lt $ARGC
    do
        ARGV[$i]=$(mbfl_decode_hex "${ARGV[$i]}")
        i=$(($i + 1))
    done
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
# mbfl_argv_all_files --
#
#	Checks that all the arguments in ARGV are file names of
#	existent file.
#
#  Arguments:
#
#	None.
#
#  Results:
#
#	Returns with code zero if no errors, else prints an error
#	message and returns with code 1.
#

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


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# indent-tabs-mode: nil
# End:
