# libmbflutils.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: utilities library file
# Date: Nov 16, 2020
#
# Abstract
#
#	We use the ISO basic Latin alphabet:
#
#		<https://en.wikipedia.org/wiki/ISO_basic_Latin_alphabet>
#
# Copyright (c) 2020 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then declare -r mbfl_LOADED_MBFLPASSWORDS='yes'
fi


#### macros

# $1 - function name stem
m4_define([[[MBFL_PASSWORDS_PRINTING_FUNCTION]]],[[[
function $1 () {
    mbfl_mandatory_parameter(NUM, 1, number of characters, -i)
    mbfl_local_varref(RV)
    if $1[[[]]]_var mbfl_datavar(RV) $NUM
    then printf '%s' "$RV"
    else return_failure
    fi
}
]]])

# $1 - function name stem
# $2 - global variable name
m4_define([[[MBFL_PASSWORDS_VAR_FUNCTION]]],[[[
function $1[[[]]]_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    mbfl_mandatory_parameter(NUM, 2, number of characters, -i)
    mbfl_local_varref(RANDOM_INTEGER)
    local -i i INTEGER_LIMIT=${#$2[@]}
    local RESULT
    if (($NUM >= 0))
    then
	for ((i=0; i < $NUM; ++i))
	do
	    mbfl_passwords_random_integer_var mbfl_datavar(RANDOM_INTEGER)
	    RESULT+=${$2[$(($RANDOM_INTEGER % $INTEGER_LIMIT))]}
	done
	RV="$RESULT"
    else return_failure
    fi
}
]]])


#### global variables

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then

# These should be  all the symbols in the ASCII  table in the range [0, 127],  with the exception of
# blanks.
#
declare -ra MBFL_PASSWORDS_ASCII_SYMBOLS=(
    '.' ',' ':' ';'
    '{' '[' '(' ')' ']' '}'
    '_'
    '=' '<' '>' '~'
    '+' '-' '*' '/' '%'
    '&' '$' '!' '?'
    '"' "'" '`' '^'
    '|' '#' '@'
)

declare -ra MBFL_PASSWORDS_DIGITS=(0 1 2 3 4 5 6 7 8 9)

declare -ra MBFL_PASSWORDS_LOWER_CASE_ALPHABET=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
declare -ra MBFL_PASSWORDS_LOWER_CASE_VOWELS=(a e i o u y)
declare -ra MBFL_PASSWORDS_LOWER_CASE_CONSONANTS=(b c d f g h j k l m n p q r s t v w x z)
declare -ra MBFL_PASSWORDS_LOWER_CASE_ALNUM=(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)
declare -ra MBFL_PASSWORDS_LOWER_CASE_BASE16=(a b c d e f ${MBFL_PASSWORDS_DIGITS[@]})

declare -ra MBFL_PASSWORDS_UPPER_CASE_ALPHABET=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
declare -ra MBFL_PASSWORDS_UPPER_CASE_VOWELS=(A E I O U Y)
declare -ra MBFL_PASSWORDS_UPPER_CASE_CONSONANTS=(B C D F G H J K L M N P Q R S T V W X Z)
declare -ra MBFL_PASSWORDS_UPPER_CASE_ALNUM=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9)
declare -ra MBFL_PASSWORDS_UPPER_CASE_BASE16=(A B C D E F ${MBFL_PASSWORDS_DIGITS[@]})

declare -ra MBFL_PASSWORDS_MIXED_CASE_ALPHABET=(
    ${MBFL_PASSWORDS_LOWER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]}
)
declare -ra MBFL_PASSWORDS_MIXED_CASE_VOWELS=(
    ${MBFL_PASSWORDS_LOWER_CASE_VOWELS[@]}
    ${MBFL_PASSWORDS_UPPER_CASE_VOWELS[@]}
)
declare -ra MBFL_PASSWORDS_MIXED_CASE_CONSONANTS=(
    ${MBFL_PASSWORDS_LOWER_CASE_CONSONANTS[@]}
    ${MBFL_PASSWORDS_UPPER_CASE_CONSONANTS[@]}
)
declare -ra MBFL_PASSWORDS_MIXED_CASE_ALNUM=(
    ${MBFL_PASSWORDS_LOWER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_DIGITS[@]}
)

# According to RFC 4648, without padding character, as described in:
#
#  <https://datatracker.ietf.org/doc/html/rfc4648>
#
declare -ra MBFL_PASSWORDS_BASE64=(
    ${MBFL_PASSWORDS_LOWER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_DIGITS[@]}
    '+' '/'
)

# According to RFC 4648, without padding character, as described in:
#
#  <https://datatracker.ietf.org/doc/html/rfc4648>
#
declare -ra MBFL_PASSWORDS_BASE32=(
    ${MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]}
    2 3 4 5 6 7
)

# We need to quote the symbols to avoit a further round of evaluation!!!
#
declare -ra MBFL_PASSWORDS_ASCII=(
    ${MBFL_PASSWORDS_LOWER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]}
    ${MBFL_PASSWORDS_DIGITS[@]}
    "${MBFL_PASSWORDS_ASCII_SYMBOLS[@]}"
)

fi


#### random sources

function mbfl_passwords_random_integer_var () {
    mbfl_mandatory_nameref_parameter(RANDOM_INTEGER, 1, result variable)
    RANDOM_INTEGER=$RANDOM
}


#### digits and symbols functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_digits]]],[[[MBFL_PASSWORDS_DIGITS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_digits]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_ascii_symbols]]],[[[MBFL_PASSWORDS_ASCII_SYMBOLS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_ascii_symbols]]])


#### lower case functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_vowels]]],[[[MBFL_PASSWORDS_LOWER_CASE_VOWELS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_vowels]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_consonants]]],[[[MBFL_PASSWORDS_LOWER_CASE_CONSONANTS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_consonants]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_alphabet]]],[[[MBFL_PASSWORDS_LOWER_CASE_ALPHABET]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_alphabet]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_alnum]]],[[[MBFL_PASSWORDS_LOWER_CASE_ALNUM]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_alnum]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_base16]]],[[[MBFL_PASSWORDS_LOWER_CASE_BASE16]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_base16]]])


#### upper case functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_vowels]]],[[[MBFL_PASSWORDS_UPPER_CASE_VOWELS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_vowels]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_consonants]]],[[[MBFL_PASSWORDS_UPPER_CASE_CONSONANTS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_consonants]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_alphabet]]],[[[MBFL_PASSWORDS_UPPER_CASE_ALPHABET]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_alphabet]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_alnum]]],[[[MBFL_PASSWORDS_UPPER_CASE_ALNUM]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_alnum]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_base16]]],[[[MBFL_PASSWORDS_UPPER_CASE_BASE16]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_base16]]])


#### mixed case functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_vowels]]],[[[MBFL_PASSWORDS_MIXED_CASE_VOWELS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_vowels]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_consonants]]],[[[MBFL_PASSWORDS_MIXED_CASE_CONSONANTS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_consonants]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_alphabet]]],[[[MBFL_PASSWORDS_MIXED_CASE_ALPHABET]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_alphabet]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_alnum]]],[[[MBFL_PASSWORDS_MIXED_CASE_ALNUM]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_alnum]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_base16]]],[[[MBFL_PASSWORDS_MIXED_CASE_BASE16]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_base16]]])


#### miscellaneous functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_base32]]],[[[MBFL_PASSWORDS_BASE32]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_base32]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_base64]]],[[[MBFL_PASSWORDS_BASE64]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_base64]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_ascii]]],[[[MBFL_PASSWORDS_ASCII]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_ascii]]])


#### my passwords

# This looks nice but  it is unsafe because predictable.  The tool  "pwgen" generates passwords that
# are "easy" to pronounce; to do it we have  too choose the right sequence of consonants and vowels;
# I  think it  comes down  to avoiding  certain consonants  sequences.  I  will have  to investigate
# further in the future.  (Marco Maggi; Nov 16, 2022)
#
function mbfl_passwords_mine_var () {
    mbfl_mandatory_nameref_parameter(PWD, 1, result variable)
    mbfl_local_varref(BLOCK)

    mbfl_passwords_lower_case_consonants_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_lower_case_vowels_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_lower_case_consonants_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_lower_case_vowels_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    PWD+=.
    mbfl_passwords_upper_case_consonants_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_upper_case_vowels_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_upper_case_consonants_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_upper_case_vowels_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    PWD+=.
    mbfl_passwords_digits_var			mbfl_datavar(BLOCK) 4; PWD+="$BLOCK"
    PWD+=.
    mbfl_passwords_lower_case_consonants_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_lower_case_vowels_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_lower_case_consonants_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
    mbfl_passwords_lower_case_vowels_var	mbfl_datavar(BLOCK) 1; PWD+="$BLOCK"
}

function mbfl_passwords_mine () {
    mbfl_local_varref(RV)
    mbfl_passwords_mine_var mbfl_datavar(RV)
    printf '%s' "$RV"
}

### end of file
