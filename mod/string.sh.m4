# string.sh --
# 
# Part of: Marco's BASH functions library
# Contents: string library
# Date: Fri Apr 18, 2003
# 
# Abstract
# 
#       This is a collection of string functions for the GNU BASH shell.
#
#       The functions made heavy usage of special variable substitutions
#       (like ${name:num:num}) so, maybe, other Bourne shells will not
#       made them work at all.
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
# $Id: string.sh.m4,v 1.1.1.10 2003/12/21 07:46:05 marco Exp $

m4_include(macros.m4)

#PAGE
# mbfl_string_chars --
#
#       Splits a string into characters.
#
#  Arguments:
#
#       $1 -    the source string
#
#  Results:
#
#       Echoes to stdout the characters one per line.
#
#  Side effects:
#
#       The correct way to use the fields is:
#
#               mbfl_string_chars $string $sep | while read ch
#               do
#                  ... $ch ...
#               done
#

function mbfl_string_chars () {
    local string="${1:?}"
    local i=0

    while test $i -lt "${#string}"
    do
        echo ${string:$i:1}
        i=$(($i + 1))
    done
}


#PAGE
# mbfl_string_first --
#
#       Searches characters in a string.
#
#  Arguments:
#
#       $1 -    the target string
#       $2 -    the character to look for
#       $3 -    optional, the index of the character in the
#               target string from which the search begins;
#               defaults to zero
#
#  Results:
#
#       Echoes to stdout an integer representing the index of the
#       first occurrence of "$2" in "$1". If the character is not
#       found: nothing is sent to stdout.
#
#  Side effects:
#
#       None.
#

function mbfl_string_first () {
    local string="${1:?}"
    local char="${2:?}"
    local begin="${3:-0}"

    local i=$begin

    while test "$i" -lt "${#string}"
    do
        if test "${string:$i:1}" = "$char"
        then
            echo $i
            return 0
        fi
        i=$(($i+1))
    done
    return 0
}

#PAGE
# mbfl_string_index --
#
#       Selects a character from a string.
#
#  Arguments:
#
#       $1 -    the source string
#       $2 -    the index of the selected character
#
#  Results:
#
#       Echoes to stdout the selected character. If the index is
#       out of range: the empty string is echoed to stdout.
#
#  Side effects:
#
#       None.
#

function mbfl_string_index () {
    local string="${1:?}"
    local index="${2:?}"
    echo "${string:$index:1}"
}

#PAGE
# mbfl_string_is --
#
#       Tests a string agains a character class. Supported classes
#       are:
#
#       alpha -         characters in the range A-Z and a-Z;
#       digit -         characters in the range 0-9;
#       alnum -         character of the classes "alpha" and "digit";
#       noblank -       all the characters excluding " \n\t\r".
#       name -          a string of characters numbers and underscores,
#                       with the first character not being a number
#
#  Arguments:
#
#       $1 -    the class name
#       $2 -    the source string, a null string is of no class
#
#  Results:
#
#       Returns with code 0 if the string is of the selected class,
#       else returns with code 1.
#
#  Side effects:
#
#       None.
#

function mbfl_string_is () {
    local class="${1:?null class to mbfl_string_is}"
    local string="${2}"

    local ch=
    local flag=0

    test "${#string}" -eq 0 && return 1

    case "$class" in
        alpha)
            {
                local i=0
                while test $i -lt "${#string}"
                do
                    ch="${string:$i:1}"
                    if test \
                        \( "$ch" \< A -o Z \< "$ch" \) -a \
                        \( "$ch" \< a -o z \< "$ch" \)
                    then return 1
                    fi
                    i=$(($i + 1))
                done
            } || flag=1
        ;;
        alnum)
            {
                local i=0
                while test $i -lt "${#string}"
                do
                    ch="${string:$i:1}"
                    if test \
                        \( "$ch" \< A -o Z \< "$ch" \) -a \
                        \( "$ch" \< a -o z \< "$ch" \) -a \
                        \( "$ch" \< 0 -o 9 \< "$ch" \)
                    then return 1
                    fi
                    i=$(($i + 1))
                done
            } || flag=1
        ;;
        digit)
            {
                local i=0
                while test $i -lt "${#string}"
                do
                    ch="${string:$i:1}"
                    if test \( "$ch" \< 0 -o 9 \< "$ch" \)
                    then return 1
                    fi
                    i=$(($i + 1))
                done
            } || flag=1
        ;;
        noblank)
            local i=0
            local len="${#string}"

            while test $i -lt $len
            do
                ch="${string:$i:1}"
                if test "$ch" = " "   -o "$ch" = $'\n' -o \
                        "$ch" = $'\r' -o "$ch" = $'\t' -o \
                        "$ch" = $'\f'
                then return 1
                fi
                i=$(($i + 1))
            done
            return 0
        ;;
        name)
            local i=1
            local len="${#string}"
            local ch=

            if test $len -eq 0
            then return 1
            else
                ch="${string:0:1}"
                if test \( "$ch" != _ \) -a \
                        \( "$ch" \< A -o Z \< "$ch" \) -a \
                        \( "$ch" \< a -o z \< "$ch" \)
                then return 1
                fi

                while test $i -lt $len
                do
                    ch="${string:$i:1}"
                    if test \( "$ch" != _ \) -a \
                            \( "$ch" \< A -o Z \< "$ch" \) -a \
                            \( "$ch" \< a -o z \< "$ch" \) -a \
                            \( "$ch" \< 0 -o 9 \< "$ch" \)
                    then return 1
                    fi
                    i=$(($i + 1))
                done
            fi
            return 0
        ;;
    esac

    return $flag
}

#PAGE
# mbfl_string_last --
#
#       Searches characters in a string starting from the end.
#
#  Arguments:
#
#       $1 -    the target string
#       $2 -    the character to look for
#       $3 -    optional, the index of the character in the
#               target string from which the search begins;
#               defaults to zero
#
#  Results:
#
#       Echoes to stdout an integer representing the index of the
#       last occurrence of "$2" in "$1". If the character is not
#       found: nothing is sent to stdout.
#
#  Side effects:
#
#       None.
#

function mbfl_string_last () {
    local string="${1:?}"
    local char="${2:?}"
    local begin="${3:-${#string}}"

    local i=$begin

    while test "$i" -gt -1
    do
        if test "${string:$i:1}" = "$char"
        then
            echo $i
            return 0
        fi
        i=$(($i - 1))
    done
    return 0
}


#PAGE
# mbfl_string_range --
#
#       Extracts a range of characters from a string.
#
#  Arguments:
#
#       $1 -    the source string
#       $2 -    the index of the first character in the range
#       $3 -    optional, the index of the character next to the
#               last in the range, this character is not extracted;
#               defaults to the last character in the string; if
#               equal to "end": the end of the range is the end of
#               the string
#
#  Results:
#
#       Echoes to stdout the selected range of characters.
#
#  Side effects:
#
#       None.
#

function mbfl_string_range () {
    local string="${1:?}"
    local begin="${2:?}"
    local end="${3}"

    if test -z "$end" -o "$end" = "end"
    then echo "${string:$begin}"
    else echo "${string:$begin:$end}"
    fi
}


#PAGE
# mbfl_string_split --
#
#       Splits a string into fields. This is done replacing each
#       character from a selected set with a newline. If the
#       source string contains newlines the splitting
#       operation can lead to unexpected results.
#
#  Arguments:
#
#       $1 -    the source string
#       $2 -    the string made up of characters to be used
#               as field separators
#
#  Results:
#
#       Echoes to stdout the fields one per line.
#
#  Side effects:
#
#       The correct way to use the fields is:
#
#               mbfl_string_split $string $sep | while read field
#               do
#                  ... $field ...
#               done
#

function mbfl_string_split () {
    local string="${1:?}"
    local chars="${2:?}"

    local i=0
    local j=0
    local sep=

    while test $i -lt "${#chars}"
    do
        sep="${chars:$i:1}"
        j=0
        while test $j -lt "${#string}"
        do
            string="${string//${sep}/\\n}"
            j=$(($j + 1))
        done
        i=$(($i + 1))
    done
    echo -e "$string"
    return 0
}


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE"
# indent-tabs-mode: nil
# End:
