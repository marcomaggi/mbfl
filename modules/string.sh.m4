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
function mbfl_string_chars () {
    mandatory_parameter(STRING, 1, string)
    local i j ch

    for ((i=0, j=0; $i < "${#STRING}"; ++i, ++j)) ; do
        ch=
        test "${STRING:$i:1}" = \\ && {
            test $i != "${#STRING}" && ch=\\
            let ++i
        }
        SPLITFIELD[$j]="${ch}${STRING:$i:1}"
        ch=
    done
    SPLITCOUNT=$j
    return 0
}
#page
function mbfl_string_equal_substring () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(POSITION, 2, position)
    mandatory_parameter(PATTERN, 3, pattern)
    local i

    test $(($POSITION+${#PATTERN})) -gt ${#STRING} && return 1
    for ((i=0; $i < "${#PATTERN}"; ++i)) ; do
        test "${PATTERN:$i:1}" != "${STRING:$(($POSITION+$i)):1}" && \
            return 1
    done
    return 0
}
function mbfl_string_split () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(SEPARATOR, 2, separator)
    local i j k=0 first=0


    for ((i=0; $i < "${#STRING}"; ++i)) ; do
        test $(($i+${#SEPARATOR})) -gt ${#STRING} && break
        mbfl_string_equal_substring "${STRING}" $i "${SEPARATOR}" && {
            # here $i is the index of the first char in the separator
            SPLITFIELD[$k]="${STRING:$first:$(($i-$first))}"
            let ++k
            i=$(($i+${#SEPARATOR}-1))
	    # place the "first" marker to the beginning of the
	    # next substring; "i" will be incremented by "for",
	    # that is why we do "+1" here
            first=$(($i+1))
        }
    done
    SPLITFIELD[$k]="${STRING:$first}"
    let ++k
    SPLITCOUNT=$k
    return 0
}
#page
function mbfl_string_first () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(CHAR, 2, char)
    optional_parameter(BEGIN, 3, 0)
    local i

    for ((i=$BEGIN; $i < ${#STRING}; ++i)) ; do
        test "${STRING:$i:1}" = "$CHAR" && {
            echo $i
            return 0
        }
    done
    return 0
}
function mbfl_string_last () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(CHAR, 2, char)
    local i="${3:-${#STRING}}"

    for ((; $i >= 0; --i)) ; do
        test "${STRING:$i:1}" = "$CHAR" && {
            echo $i
            return 0
        }
    done
    return 0
}
function mbfl_string_index () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(INDEX, 2, index)
    echo "${STRING:$INDEX:1}"
}
#PAGE
function mbfl-string-is-alpha-char () {
    ! test \( "$1" \< A -o Z \< "$1" \) -a \( "$1" \< a -o z \< "$1" \)
}
function mbfl-string-is-digit-char () {
    ! test "$1" \< 0 -o 9 \< "$1"
}
function mbfl-string-is-alnum-char () {
    mbfl-string-is-alpha-char "$1" || mbfl-string-is-digit-char "$1"
}
function mbfl-string-is-name-char () {
    mbfl-string-is-alnum-char "$1" || test "$1" = _
}
function mbfl-string-is-noblank-char () {
    test \( "$1" != " " \) -a \
	\( "$1" != $'\n' \) -a \( "$1" != $'\r' \) -a \
	\( "$1" != $'\t' \) -a \( "$1" != $'\f' \)
}
for class in alpha digit alnum noblank ; do
    alias "mbfl-string-is-${class}"="mbfl-p-string-is $class"
done    
function mbfl-p-string-is () {
    mandatory_parameter(CLASS, 1, class)
    mandatory_parameter(STRING, 2, string)
    local i

    test "${#STRING}" = 0 && return 1
    for ((i=0; $i < ${#STRING}; ++i));  do
	"mbfl-string-is-${CLASS}-char" "${STRING:$i:1}" || return 1
    done
    return 0
}
function mbfl-string-is-name () {
    mandatory_parameter(STRING, 1, string)
    mbfl-p-string-is name "${STRING}" && ! mbfl-string-is-digit "${STRING:0:1}"
}
#PAGE
function mbfl_string_range () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(BEGIN, 2, begin)
    optional_parameter(END, 3)

    if test -z "$END" -o "$END" = "end" -o "$END" = "END"
    then echo "${STRING:$BEGIN}"
    else echo "${STRING:$BEGIN:$END}"
    fi
}
function mbfl_string_replace () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(PATTERN, 2, pattern)
    optional_parameter(SUBST, 3)

    echo "${STRING//$PATTERN/$SUBST}"
}
function mbfl_string_skip () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(POSNAME, 2, position)
    mandatory_parameter(CHAR, 3, char)
    local position=${!POSNAME}

    while test "${STRING:$position:1}" = "$CHAR" ; do let ++position ; done
    eval $POSNAME=$position
}
#page
function mbfl_string_toupper () {
    mbfl_p_string_uplo toupper "${1}"
}
function mbfl_string_tolower () {
    mbfl_p_string_uplo tolower "${1}"
}
function mbfl_p_string_uplo () {
    mandatory_parameter(MODE, 1, mode)
    optional_parameter(STRING, 2)
    local ch lower upper flag=0


    test "${#STRING}" = 0 && return 0

    for ch in \
        a A b B c C d D e E f F g G h H i I j J k K l L m M \
        n N o O p P q Q r R s S t T u U v V w W x X y Y z Z ; do
      if test $flag = 0; then
          lower=$ch
          flag=1
      else
          upper=$ch
          if test "${MODE}" = toupper ; then
              STRING="${STRING//$lower/$upper}"
          else
              STRING="${STRING//$upper/$lower}"
          fi
          flag=0
      fi
    done
    echo "${STRING}"
    return 0
}
#page
function mbfl_sprintf () {
    local VARNAME="${1:?missing variable name parameter in ${FUNCNAME}}"
    local FORMAT="${2:?missing format parameter in ${FUNCNAME}}"
    local OUTPUT=
    shift 2
    
    OUTPUT=`printf "${FORMAT}" "$@"`
    eval "${VARNAME}"=\'"${OUTPUT}"\'
}
#page
function mbfl_string_is_equal_unquoted_char () {
    local STRING="${1:?missing string parameter to ${FUNCNAME}}"
    local pos="${2:?missing position parameter to ${FUNCNAME}}"
    local char="${3:?missing known char parameter to ${FUNCNAME}}"

    test "${STRING:$pos:1}" = "$char" || mbfl_string_is_quoted_char "$STRING" $pos
}
function mbfl_string_is_quoted_char () {
    local STRING="${1:?missing string parameter to ${FUNCNAME}}"
    local i="${2:?missing position parameter to ${FUNCNAME}}"
    local count

    let --i
    for ((count=0; $i >= 0; --i))
      do
      if test "${STRING:$i:1}" = \\
          then let ++count
          else break
      fi
    done
    let ${count}%2
}
function mbfl_string_quote () {
    mandatory_parameter(STRING, 1, string)
    local QUOTED_STRING i quote ch
    

    for ((i=0; $i < "${#STRING}"; ++i)) ; do
        ch="${STRING:$i:1}"
        test "$ch" = \\ && ch=\\\\
        QUOTED_STRING="${QUOTED_STRING}$ch"
    done
    echo "${QUOTED_STRING}"
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
