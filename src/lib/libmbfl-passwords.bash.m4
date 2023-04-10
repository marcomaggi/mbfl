#! libmbfl-passwords.bash.m4 --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: utilities library file
#! Date: Nov 16, 2020
#!
#! Abstract
#!
#!	We use the ISO basic Latin alphabet:
#!
#!		<https://en.wikipedia.org/wiki/ISO_basic_Latin_alphabet>
#!
#! Copyright (c) 2020, 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then declare -r mbfl_LOADED_MBFLPASSWORDS='yes'
fi


#### macros

# $1 - function name stem
m4_define([[[MBFL_PASSWORDS_PRINTING_FUNCTION]]],[[[
function $1 () {
    mbfl_mandatory_parameter(NUM, 1, number of characters, -i)
    mbfl_declare_varref(RV)
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
    mbfl_declare_varref(RANDOM_INTEGER)
    local -i i INTEGER_LIMIT=mbfl_string_len($2)
    local RESULT
    if (($NUM >= 0))
    then
	for ((i=0; i < $NUM; ++i))
	do
	    mbfl_passwords_random_integer_var mbfl_datavar(RANDOM_INTEGER)
	    RESULT+=mbfl_string_idx($2, $(($RANDOM_INTEGER % $INTEGER_LIMIT)))
	done
	RV="$RESULT"
    else return_failure
    fi
}
]]])


#### random sources

function mbfl_passwords_random_integer_var () {
    mbfl_mandatory_nameref_parameter(RANDOM_INTEGER, 1, result variable)
    RANDOM_INTEGER=$RANDOM
    if ((0 == $RANDOM_INTEGER))
    then RANDOM_INTEGER=1
    fi
}


#### digits and symbols functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_digits]]],[[[MBFL_ASCII_RANGE_DIGITS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_digits]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_ascii_symbols]]],[[[MBFL_ASCII_RANGE_ASCII_SYMBOLS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_ascii_symbols]]])


#### lower case functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_vowels]]],[[[MBFL_ASCII_RANGE_LOWER_CASE_VOWELS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_vowels]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_consonants]]],[[[MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_consonants]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_alphabet]]],[[[MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_alphabet]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_alnum]]],[[[MBFL_ASCII_RANGE_LOWER_CASE_ALNUM]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_alnum]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_lower_case_base16]]],[[[MBFL_ASCII_RANGE_LOWER_CASE_BASE16]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_lower_case_base16]]])


#### upper case functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_vowels]]],[[[MBFL_ASCII_RANGE_UPPER_CASE_VOWELS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_vowels]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_consonants]]],[[[MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_consonants]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_alphabet]]],[[[MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_alphabet]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_alnum]]],[[[MBFL_ASCII_RANGE_UPPER_CASE_ALNUM]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_alnum]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_upper_case_base16]]],[[[MBFL_ASCII_RANGE_UPPER_CASE_BASE16]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_upper_case_base16]]])


#### mixed case functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_vowels]]],[[[MBFL_ASCII_RANGE_MIXED_CASE_VOWELS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_vowels]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_consonants]]],[[[MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_consonants]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_alphabet]]],[[[MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_alphabet]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_alnum]]],[[[MBFL_ASCII_RANGE_MIXED_CASE_ALNUM]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_alnum]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_mixed_case_base16]]],[[[MBFL_ASCII_RANGE_MIXED_CASE_BASE16]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_mixed_case_base16]]])


#### miscellaneous functions

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_base32]]],[[[MBFL_ASCII_RANGE_BASE32]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_base32]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_base64]]],[[[MBFL_ASCII_RANGE_BASE64]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_base64]]])

MBFL_PASSWORDS_VAR_FUNCTION([[[mbfl_passwords_printable_ascii_noblank]]],[[[MBFL_ASCII_RANGE_PRINTABLE_ASCII_NOBLANK]]])
MBFL_PASSWORDS_PRINTING_FUNCTION([[[mbfl_passwords_printable_ascii_noblank]]])

#!# end of file
# Local Variables:
# mode: sh
# End:
