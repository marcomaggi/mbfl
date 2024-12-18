# string.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: string library
# Date: Fri Apr 18, 2003
#
# Abstract
#
#       This is a collection of string functions for the GNU BASH shell.
#
#       The functions make heavy usage of  special variable substitutions (like ${name:num:num}) so,
#       maybe, other Bourne shells will not work at all.
#
# Copyright (c) 2003-2005, 2009, 2013, 2014, 2018, 2020, 2023, 2024 Marco Maggi
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

MBFL_DEFINE_SPECIAL_MACROS


#### global variables

# Given an  exact integer, in base  10, representing the ASCII  code of a character:  the element at
# that index in this array is the character itself.
#
# NOTE Is it ugly  to do the conversion this way?   I do not care.  Ha!  Ha!   Ha! (Marco Maggi; Sep
# 12, 2024)
#
declare -ga MBFL_TABLE_ASCII_CODE_TO_STRING=($'\x00' $'\x01' $'\x02' $'\x03' $'\x04' $'\x05' $'\x06' $'\x07' $'\x08' $'\x09' $'\x0a' $'\x0b' $'\x0c' $'\x0d' $'\x0e' $'\x0f' $'\x10' $'\x11' $'\x12' $'\x13' $'\x14' $'\x15' $'\x16' $'\x17' $'\x18' $'\x19' $'\x1a' $'\x1b' $'\x1c' $'\x1d' $'\x1e' $'\x1f' $'\x20' $'\x21' $'\x22' $'\x23' $'\x24' $'\x25' $'\x26' $'\x27' $'\x28' $'\x29' $'\x2a' $'\x2b' $'\x2c' $'\x2d' $'\x2e' $'\x2f' $'\x30' $'\x31' $'\x32' $'\x33' $'\x34' $'\x35' $'\x36' $'\x37' $'\x38' $'\x39' $'\x3a' $'\x3b' $'\x3c' $'\x3d' $'\x3e' $'\x3f' $'\x40' $'\x41' $'\x42' $'\x43' $'\x44' $'\x45' $'\x46' $'\x47' $'\x48' $'\x49' $'\x4a' $'\x4b' $'\x4c' $'\x4d' $'\x4e' $'\x4f' $'\x50' $'\x51' $'\x52' $'\x53' $'\x54' $'\x55' $'\x56' $'\x57' $'\x58' $'\x59' $'\x5a' $'\x5b' $'\x5c' $'\x5d' $'\x5e' $'\x5f' $'\x60' $'\x61' $'\x62' $'\x63' $'\x64' $'\x65' $'\x66' $'\x67' $'\x68' $'\x69' $'\x6a' $'\x6b' $'\x6c' $'\x6d' $'\x6e' $'\x6f' $'\x70' $'\x71' $'\x72' $'\x73' $'\x74' $'\x75' $'\x76' $'\x77' $'\x78' $'\x79' $'\x7a' $'\x7b' $'\x7c' $'\x7d' $'\x7e' $'\x7f' $'\x80' $'\x81' $'\x82' $'\x83' $'\x84' $'\x85' $'\x86' $'\x87' $'\x88' $'\x89' $'\x8a' $'\x8b' $'\x8c' $'\x8d' $'\x8e' $'\x8f' $'\x90' $'\x91' $'\x92' $'\x93' $'\x94' $'\x95' $'\x96' $'\x97' $'\x98' $'\x99' $'\x9a' $'\x9b' $'\x9c' $'\x9d' $'\x9e' $'\x9f' $'\xa0' $'\xa1' $'\xa2' $'\xa3' $'\xa4' $'\xa5' $'\xa6' $'\xa7' $'\xa8' $'\xa9' $'\xaa' $'\xab' $'\xac' $'\xad' $'\xae' $'\xaf' $'\xb0' $'\xb1' $'\xb2' $'\xb3' $'\xb4' $'\xb5' $'\xb6' $'\xb7' $'\xb8' $'\xb9' $'\xba' $'\xbb' $'\xbc' $'\xbd' $'\xbe' $'\xbf' $'\xc0' $'\xc1' $'\xc2' $'\xc3' $'\xc4' $'\xc5' $'\xc6' $'\xc7' $'\xc8' $'\xc9' $'\xca' $'\xcb' $'\xcc' $'\xcd' $'\xce' $'\xcf' $'\xd0' $'\xd1' $'\xd2' $'\xd3' $'\xd4' $'\xd5' $'\xd6' $'\xd7' $'\xd8' $'\xd9' $'\xda' $'\xdb' $'\xdc' $'\xdd' $'\xde' $'\xdf' $'\xe0' $'\xe1' $'\xe2' $'\xe3' $'\xe4' $'\xe5' $'\xe6' $'\xe7' $'\xe8' $'\xe9' $'\xea' $'\xeb' $'\xec' $'\xed' $'\xee' $'\xef' $'\xf0' $'\xf1' $'\xf2' $'\xf3' $'\xf4' $'\xf5' $'\xf6' $'\xf7' $'\xf8' $'\xf9' $'\xfa' $'\xfb' $'\xfc' $'\xfd' $'\xfe' $'\xff')

declare -gA MBFL_TABLE_STRING_TO_ASCII_CODE=([$'\x01']=1 [$'\x02']=2 [$'\x03']=3 [$'\x04']=4 [$'\x05']=5 [$'\x06']=6 [$'\x07']=7 [$'\x08']=8 [$'\x09']=9 [$'\x0a']=10 [$'\x0b']=11 [$'\x0c']=12 [$'\x0d']=13 [$'\x0e']=14 [$'\x0f']=15 [$'\x10']=16 [$'\x11']=17 [$'\x12']=18 [$'\x13']=19 [$'\x14']=20 [$'\x15']=21 [$'\x16']=22 [$'\x17']=23 [$'\x18']=24 [$'\x19']=25 [$'\x1a']=26 [$'\x1b']=27 [$'\x1c']=28 [$'\x1d']=29 [$'\x1e']=30 [$'\x1f']=31 [$'\x20']=32 [$'\x21']=33 [$'\x22']=34 [$'\x23']=35 [$'\x24']=36 [$'\x25']=37 [$'\x26']=38 [$'\x27']=39 [$'\x28']=40 [$'\x29']=41 [$'\x2a']=42 [$'\x2b']=43 [$'\x2c']=44 [$'\x2d']=45 [$'\x2e']=46 [$'\x2f']=47 [$'\x30']=48 [$'\x31']=49 [$'\x32']=50 [$'\x33']=51 [$'\x34']=52 [$'\x35']=53 [$'\x36']=54 [$'\x37']=55 [$'\x38']=56 [$'\x39']=57 [$'\x3a']=58 [$'\x3b']=59 [$'\x3c']=60 [$'\x3d']=61 [$'\x3e']=62 [$'\x3f']=63 [$'\x40']=64 [$'\x41']=65 [$'\x42']=66 [$'\x43']=67 [$'\x44']=68 [$'\x45']=69 [$'\x46']=70 [$'\x47']=71 [$'\x48']=72 [$'\x49']=73 [$'\x4a']=74 [$'\x4b']=75 [$'\x4c']=76 [$'\x4d']=77 [$'\x4e']=78 [$'\x4f']=79 [$'\x50']=80 [$'\x51']=81 [$'\x52']=82 [$'\x53']=83 [$'\x54']=84 [$'\x55']=85 [$'\x56']=86 [$'\x57']=87 [$'\x58']=88 [$'\x59']=89 [$'\x5a']=90 [$'\x5b']=91 [$'\x5c']=92 [$'\x5d']=93 [$'\x5e']=94 [$'\x5f']=95 [$'\x60']=96 [$'\x61']=97 [$'\x62']=98 [$'\x63']=99 [$'\x64']=100 [$'\x65']=101 [$'\x66']=102 [$'\x67']=103 [$'\x68']=104 [$'\x69']=105 [$'\x6a']=106 [$'\x6b']=107 [$'\x6c']=108 [$'\x6d']=109 [$'\x6e']=110 [$'\x6f']=111 [$'\x70']=112 [$'\x71']=113 [$'\x72']=114 [$'\x73']=115 [$'\x74']=116 [$'\x75']=117 [$'\x76']=118 [$'\x77']=119 [$'\x78']=120 [$'\x79']=121 [$'\x7a']=122 [$'\x7b']=123 [$'\x7c']=124 [$'\x7d']=125 [$'\x7e']=126 [$'\x7f']=127 [$'\x80']=128 [$'\x81']=129 [$'\x82']=130 [$'\x83']=131 [$'\x84']=132 [$'\x85']=133 [$'\x86']=134 [$'\x87']=135 [$'\x88']=136 [$'\x89']=137 [$'\x8a']=138 [$'\x8b']=139 [$'\x8c']=140 [$'\x8d']=141 [$'\x8e']=142 [$'\x8f']=143 [$'\x90']=144 [$'\x91']=145 [$'\x92']=146 [$'\x93']=147 [$'\x94']=148 [$'\x95']=149 [$'\x96']=150 [$'\x97']=151 [$'\x98']=152 [$'\x99']=153 [$'\x9a']=154 [$'\x9b']=155 [$'\x9c']=156 [$'\x9d']=157 [$'\x9e']=158 [$'\x9f']=159 [$'\xa0']=160 [$'\xa1']=161 [$'\xa2']=162 [$'\xa3']=163 [$'\xa4']=164 [$'\xa5']=165 [$'\xa6']=166 [$'\xa7']=167 [$'\xa8']=168 [$'\xa9']=169 [$'\xaa']=170 [$'\xab']=171 [$'\xac']=172 [$'\xad']=173 [$'\xae']=174 [$'\xaf']=175 [$'\xb0']=176 [$'\xb1']=177 [$'\xb2']=178 [$'\xb3']=179 [$'\xb4']=180 [$'\xb5']=181 [$'\xb6']=182 [$'\xb7']=183 [$'\xb8']=184 [$'\xb9']=185 [$'\xba']=186 [$'\xbb']=187 [$'\xbc']=188 [$'\xbd']=189 [$'\xbe']=190 [$'\xbf']=191 [$'\xc0']=192 [$'\xc1']=193 [$'\xc2']=194 [$'\xc3']=195 [$'\xc4']=196 [$'\xc5']=197 [$'\xc6']=198 [$'\xc7']=199 [$'\xc8']=200 [$'\xc9']=201 [$'\xca']=202 [$'\xcb']=203 [$'\xcc']=204 [$'\xcd']=205 [$'\xce']=206 [$'\xcf']=207 [$'\xd0']=208 [$'\xd1']=209 [$'\xd2']=210 [$'\xd3']=211 [$'\xd4']=212 [$'\xd5']=213 [$'\xd6']=214 [$'\xd7']=215 [$'\xd8']=216 [$'\xd9']=217 [$'\xda']=218 [$'\xdb']=219 [$'\xdc']=220 [$'\xdd']=221 [$'\xde']=222 [$'\xdf']=223 [$'\xe0']=224 [$'\xe1']=225 [$'\xe2']=226 [$'\xe3']=227 [$'\xe4']=228 [$'\xe5']=229 [$'\xe6']=230 [$'\xe7']=231 [$'\xe8']=232 [$'\xe9']=233 [$'\xea']=234 [$'\xeb']=235 [$'\xec']=236 [$'\xed']=237 [$'\xee']=238 [$'\xef']=239 [$'\xf0']=240 [$'\xf1']=241 [$'\xf2']=242 [$'\xf3']=243 [$'\xf4']=244 [$'\xf5']=245 [$'\xf6']=246 [$'\xf7']=247 [$'\xf8']=248 [$'\xf9']=249 [$'\xfa']=250 [$'\xfb']=251 [$'\xfc']=252 [$'\xfd']=253 [$'\xfe']=254 [$'\xff']=255)

function mbfl_string_from_ascii_code_var () {
    mbfl_check_mandatory_parameters_number(2,2)
    mbfl_mandatory_nameref_parameter(STRING,	1, result string)
    mbfl_mandatory_parameter(ASCII_CODE,	2, ASCII code)

    if mbfl_string_is_exact_integer_number WW(ASCII_CODE) && (( 0 <= ASCII_CODE && ASCII_CODE <= 255 ))
    then STRING=WW(MBFL_TABLE_ASCII_CODE_TO_STRING,RR(ASCII_CODE))
    else
	mbfl_default_object_declare(CND)
	declare MSG

	printf -v 'invalid string as ASCII code: %s' WW(ASCII_CODE)
	mbfl_logic_error_condition_make UU(CND) WW(FUNCNAME) WW(MSG)
	mbfl_exception_raise UU(CND)
    fi
}
function mbfl_string_to_ascii_code_var () {
    mbfl_check_mandatory_parameters_number(1,3)
    mbfl_mandatory_nameref_parameter(ASCII_CODE,	1, ASCII code result)
    mbfl_optional_parameter(STRING,			2)
    mbfl_optional_parameter(INDEX,			3, 0)

    if mbfl_string_empty(STRING)
    then ASCII_CODE=0
    else ASCII_CODE=WW(MBFL_TABLE_STRING_TO_ASCII_CODE,mbfl_string_idx(STRING,RR(INDEX)))
    fi
}


#### global variables, known character ranges

# These should be  all the symbols in the ASCII  table in the range [0, 127],  with the exception of
# blanks.  Notice the value is the concatenation of the strings:
#
#    '.,:;{[()]}_=<>~+-*/%&$!?"^|#@'
#    "'"
#    '`'
#
declare -r MBFL_ASCII_RANGE_ASCII_SYMBOLS=[[['.,:;{[()]}_=<>~+-*/%&$!?"^|#@'"'"'`']]]

declare -r MBFL_ASCII_RANGE_DIGITS='0123456789'

declare -r MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET='abcdefghijklmnopqrstuvwxyz'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_VOWELS='aeiouy'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS='bcdfghjklmnpqrstvwxz'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_ALNUM='abcdefghijklmnopqrstuvwxyz0123456789'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_BASE16='abcdef0123456789'

declare -r MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_VOWELS='AEIOUY'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS='BCDFGHJKLMNPQRSTVWXZ'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_ALNUM='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_BASE16='ABCDEF0123456789'

declare -r MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_VOWELS="${MBFL_ASCII_RANGE_LOWER_CASE_VOWELS}${MBFL_ASCII_RANGE_UPPER_CASE_VOWELS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS="${MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS}${MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_ALNUM="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_BASE16='abcdefABCDEF0123456789'

# According to RFC 4648, without padding character, as described in:
#
#  <https://datatracker.ietf.org/doc/html/rfc4648>
#
declare -r MBFL_ASCII_RANGE_BASE32="${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}234567"

# According to RFC 4648, without padding character, as described in:
#
#  <https://datatracker.ietf.org/doc/html/rfc4648>
#
declare -r MBFL_ASCII_RANGE_BASE64="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}+/"

# We need to quote the symbols to avoit a further round of evaluation!!!
#
declare -r MBFL_ASCII_RANGE_PRINTABLE_ASCII_NOBLANK="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}${MBFL_ASCII_RANGE_ASCII_SYMBOLS}"


#### quoted characters

function mbfl_string_is_quoted_char () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_integer_parameter(POS, 2, position)
    local -i COUNT
    let --POS
    for ((COUNT=0; POS >= 0; --POS))
    do
	if test "mbfl_string_idx(STRING, ${POS})" = \\
        then let ++COUNT
        else break
	fi
    done
    let ${COUNT}%2
}
function mbfl_string_is_equal_unquoted_char () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_integer_parameter(POS, 2, position)
    mbfl_mandatory_parameter(CHAR, 3, known char)
    if test "mbfl_string_idx(STRING, ${POS})" != "$CHAR"
    then mbfl_string_is_quoted_char "$STRING" "$POS"
    fi
}

function mbfl_string_quote_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_optional_parameter(mbfl_STRING, 2)
    local -i mbfl_I
    local mbfl_ch
    mbfl_RESULT_VARREF=
    for ((mbfl_I=0; mbfl_I < mbfl_string_len(mbfl_STRING); ++mbfl_I))
    do
        mbfl_ch=mbfl_string_idx(mbfl_STRING, $mbfl_I)
        if test "$mbfl_ch" = \\
	then mbfl_ch=\\\\
	fi
        mbfl_RESULT_VARREF+=$mbfl_ch
    done
}
function mbfl_string_quote () {
    mbfl_optional_parameter(STRING, 1)
    local RESULT_VARNAME
    if mbfl_string_quote_var RESULT_VARNAME "$STRING"
    then printf '%s\n' "$RESULT_VARNAME"
    else return 1
    fi
}


#### inspecting a string

function mbfl_string_length () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    echo mbfl_string_len(STRING)
}
function mbfl_string_length_equal_to () {
    mbfl_mandatory_integer_parameter(LENGTH, 1, length of string)
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 2)
    test mbfl_string_len(STRING) -eq $LENGTH
}
function mbfl_string_is_empty () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    test -z "$STRING"
}
function mbfl_string_is_not_empty () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    test -n "$STRING"
}

function mbfl_string_first_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_CHAR, 3, char)
    mbfl_optional_parameter(mbfl_BEGIN, 4, 0)
    local -i mbfl_I
    for ((mbfl_I=mbfl_BEGIN; mbfl_I < mbfl_string_len(mbfl_STRING); ++mbfl_I))
    do
	if test "mbfl_string_idx(mbfl_STRING, $mbfl_I)" = "$mbfl_CHAR"
	then
            mbfl_RESULT_VARREF=$mbfl_I
	    # Found!  Return with exit status 0.
            return 0
        fi
    done
    # Not found!  Return with exit status 1.
    return 1
}
function mbfl_string_first () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(CHAR, 2, char)
    mbfl_optional_parameter(BEGIN, 3)
    mbfl_declare_varref(RESULT_VARNAME)
    # Be  careful  to  return  the  same exit  status  of  the  call  to
    # "mbfl_string_first_var".
    if mbfl_string_first_var UU(RESULT_VARNAME) "$STRING" "$CHAR" "$BEGIN"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_last_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_CHAR, 3, char)
    mbfl_optional_parameter(mbfl_BEGIN, 4)
    local -i mbfl_I
    for ((mbfl_I=${mbfl_BEGIN:-((mbfl_string_len(mbfl_STRING)-1))}; mbfl_I >= 0; --mbfl_I))
    do
	if test "mbfl_string_idx(mbfl_STRING, $mbfl_I)" = "$mbfl_CHAR"
	then
	    # Found!  Return with exit status 0.
            mbfl_RESULT_VARREF=$mbfl_I
	    return 0
        fi
    done
    # Not found!  Return with exit status 1.
    return 1
}
function mbfl_string_last () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(CHAR, 2, char)
    mbfl_optional_parameter(BEGIN, 3)
    mbfl_declare_varref(RESULT_VARNAME)
    # Be  careful  to  return  the  same exit  status  of  the  call  to
    # "mbfl_string_last_var".
    if mbfl_string_last_var UU(RESULT_VARNAME) "$STRING" "$CHAR" "$BEGIN"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_index_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_INDEX, 3, index)
    mbfl_RESULT_VARREF=mbfl_string_idx(mbfl_STRING, ${mbfl_INDEX})
}
function mbfl_string_index () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(INDEX, 2, index)
    printf "mbfl_string_idx(STRING, $INDEX)\n"
}

function mbfl_string_range_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_BEGIN, 3, begin)
    mbfl_optional_parameter(mbfl_END, 4)
    if test -z "$mbfl_END" -o "$mbfl_END" = 'end' -o "$mbfl_END" = 'END'
    then mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN}
    else mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN:$mbfl_END}
    fi
}
function mbfl_string_range () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(BEGIN, 2, begin)
    mbfl_optional_parameter(END, 3)
    mbfl_declare_varref(RESULT_VARNAME)
    if mbfl_string_range_var UU(RESULT_VARNAME) "$STRING" "$BEGIN" "$END"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_is_true () {
    mbfl_mandatory_parameter(STRING, 1, the string argument)
    test 'true' = "$STRING"
}
function mbfl_string_is_false () {
    mbfl_mandatory_parameter(STRING, 1, the string argument)
    test 'false' = "$STRING"
}

function mbfl_string_has_prefix () {
    mbfl_optional_parameter(mbfl_PREFIX, 1)
    mbfl_optional_parameter(mbfl_STRING, 2)
    declare -i mbfl_PREFIX_LEN=mbfl_string_len(mbfl_PREFIX)
    declare mbfl_STRING_PREFIX=${mbfl_STRING:0:$mbfl_PREFIX_LEN}

    #echo $FUNCNAME mbfl_PREFIX=\"$mbfl_PREFIX\" mbfl_STRING=\"$mbfl_STRING\" mbfl_STRING_PREFIX=\"$mbfl_STRING_PREFIX\" >&2
    mbfl_string_eq("$mbfl_PREFIX", "$mbfl_STRING_PREFIX")
}
function mbfl_string_has_suffix () {
    mbfl_optional_parameter(mbfl_STRING, 1)
    mbfl_optional_parameter(mbfl_SUFFIX, 2)
    declare -i mbfl_STRING_LEN=mbfl_string_len(mbfl_STRING)
    declare -i mbfl_SUFFIX_LEN=mbfl_string_len(mbfl_SUFFIX)
    declare -i mbfl_STRING_BEGIN=$(($mbfl_STRING_LEN - $mbfl_SUFFIX_LEN))
    declare mbfl_STRING_SUFFIX=${mbfl_STRING:$mbfl_STRING_BEGIN}

    #echo $FUNCNAME mbfl_STRING_LEN=\"$mbfl_STRING_LEN\" mbfl_SUFFIX_LEN=\"$mbfl_SUFFIX_LEN\" mbfl_STRING_BEGIN=\"$mbfl_STRING_BEGIN\" >&2
    #echo $FUNCNAME mbfl_STRING_SUFFIX=\"$mbfl_STRING_SUFFIX\" mbfl_SUFFIX=\"$mbfl_SUFFIX\" >&2
    mbfl_string_eq("$mbfl_STRING_SUFFIX", "$mbfl_SUFFIX")
}
function mbfl_string_has_prefix_and_suffix () {
    mbfl_optional_parameter(mbfl_PREFIX, 1)
    mbfl_optional_parameter(mbfl_STRING, 2)
    mbfl_optional_parameter(mbfl_SUFFIX, 3)

    #echo $FUNCNAME mbfl_PREFIX=\"$mbfl_PREFIX\" mbfl_STRING=\"$mbfl_STRING\" mbfl_SUFFIX=\"$mbfl_SUFFIX\" >&2

    declare -i mbfl_STRING_LEN=mbfl_string_len(mbfl_STRING)
    declare -i mbfl_PREFIX_LEN=mbfl_string_len(mbfl_PREFIX)
    declare -i mbfl_SUFFIX_LEN=mbfl_string_len(mbfl_SUFFIX)

    declare mbfl_STRING_PREFIX=${mbfl_STRING:0:$mbfl_PREFIX_LEN}

    declare -i mbfl_STRING_BEGIN=$(($mbfl_STRING_LEN - $mbfl_SUFFIX_LEN))
    declare mbfl_STRING_SUFFIX=${mbfl_STRING:$mbfl_STRING_BEGIN}

    #echo $FUNCNAME mbfl_STRING_PREFIX=\"$mbfl_STRING_PREFIX\" mbfl_STRING_SUFFIX=\"$mbfl_STRING_SUFFIX\" >&2
    mbfl_string_eq("$mbfl_PREFIX", "$mbfl_STRING_PREFIX") && mbfl_string_eq("$mbfl_STRING_SUFFIX", "$mbfl_SUFFIX")
}


#### splitting

function mbfl_string_chars () {
    mbfl_mandatory_parameter(STRING, 1, string)
    local -i i j
    local ch
    for ((i=0, j=0; i < mbfl_string_len(STRING); ++i, ++j))
    do
        ch=mbfl_string_idx(STRING, $i)
        if test "$ch" != $'\\'
        then SPLITFIELD[$j]=$ch
        else
            let ++i
            if test $i != mbfl_string_len(STRING)
            then SPLITFIELD[$j]=${ch}mbfl_string_idx(STRING, $i)
            else SPLITFIELD[$j]=$ch
            fi
        fi
    done
    SPLITCOUNT=$j
    return 0
}
function mbfl_string_split () {
    mbfl_mandatory_parameter(STRING,    1, string)
    mbfl_mandatory_parameter(SEPARATOR, 2, separator)
    local -i i j k=0 first=0
    SPLITFIELD=()
    SPLITCOUNT=0
    for ((i=0; i < mbfl_string_len(STRING); ++i))
    do
        if (( (i + mbfl_string_len(SEPARATOR)) > mbfl_string_len(STRING)))
	then break
	elif mbfl_string_equal_substring "$STRING" $i "$SEPARATOR"
	then
	    # Here $i is the index of the first char in the separator.
	    SPLITFIELD[$k]=${STRING:$first:$((i - first))}
	    let ++k
	    let i+=mbfl_string_len(SEPARATOR)-1
	    # Place  the "first"  marker to  the beginning  of the  next
	    # substring; "i" will  be incremented by "for",  that is why
	    # we do "+1" here.
	    let first=i+1
        fi
    done
    SPLITFIELD[$k]=${STRING:$first}
    let ++k
    SPLITCOUNT=$k
    return 0
}
function mbfl_string_split_blanks () {
    mbfl_mandatory_parameter(STRING, 1, string)
    local ACCUM CH
    local -i i

    SPLITFIELD=()
    SPLITCOUNT=0
    for ((i=0; i < mbfl_string_len(STRING); ++i))
    do
	CH=mbfl_string_idx(STRING, $i)
	if test ' ' = "$CH" -o $'\t' = "$CH"
	then
	    # Store the field.
	    SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
	    ACCUM=
	    # Consume all the adjacent blanks, if any.
	    for ((i=$i; i < mbfl_string_len(STRING); ++i))
	    do
		CH=mbfl_string_idx(STRING, $((i+1)))
		if test ' ' != "$CH" -a $'\t' != "$CH"
		then break
		fi
	    done
	else ACCUM+=$CH
	fi
    done
    if mbfl_string_is_not_empty "$ACCUM"
    then SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
    fi
    SPLITCOUNT=${#SPLITFIELD[@]}
    return 0
}


#### comparison

function mbfl_string_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '=' "$STR2"
}
function mbfl_string_not_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '!=' "$STR2"
}

function mbfl_string_is_yes () {
    mbfl_optional_parameter(STR, 1)
    test "$STR" = 'yes'
}
function mbfl_string_is_no () {
    mbfl_optional_parameter(STR, 1)
    test "$STR" = 'no'
}

### ------------------------------------------------------------------------

function mbfl_string_less () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '<' "$STR2"
}

function mbfl_string_greater () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '>' "$STR2"
}

function mbfl_string_less_or_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '<' "$STR2" -o "$STR1" '=' "$STR2"
}

function mbfl_string_greater_or_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '>' "$STR2" -o "$STR1" '=' "$STR2"
}

function mbfl_string_compare () {
    mbfl_optional_parameter(mbfl_STR1, 1)
    mbfl_optional_parameter(mbfl_STR2, 2)

    if   mbfl_string_eq("$mbfl_STR1", "$mbfl_STR2")
    then return 0
    elif mbfl_string_le("$mbfl_STR1", "$mbfl_STR2")
    then return 1
    else return 2
    fi
}

function mbfl_string_equal_substring () {
    mbfl_mandatory_parameter(STRING,   1, string)
    mbfl_mandatory_parameter(POSITION, 2, position)
    mbfl_mandatory_parameter(PATTERN,  3, pattern)
    local i
    if (( (POSITION + mbfl_string_len(PATTERN)) > mbfl_string_len(STRING) ))
    then return 1
    fi
    for ((i=0; i < "mbfl_string_len(PATTERN)"; ++i))
    do
	if test "mbfl_string_idx(PATTERN, $i)" != "mbfl_string_idx(STRING, $(($POSITION+$i)))"
	then return 1
	fi
    done
    return 0
}


#### character predicates

function mbfl_string_is_alpha_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    ! test \( "$CHAR" \< A -o Z \< "$CHAR" \) -a \( "$CHAR" \< a -o z \< "$CHAR" \)
}
function mbfl_string_is_digit_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    ! test "$CHAR" \< 0 -o 9 \< "$CHAR"
}
function mbfl_string_is_alnum_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alpha_char "$CHAR" || mbfl_string_is_digit_char "$CHAR"
}
function mbfl_string_is_name_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_'
}
function mbfl_string_is_identifier_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-'
}
function mbfl_string_is_extended_identifier_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-' -o "$CHAR" = '.'
}
function mbfl_string_is_noblank_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    test \( "$CHAR" != " " \) -a \
	\( "$CHAR" != $'\n' \) -a \( "$CHAR" != $'\r' \) -a \
	\( "$CHAR" != $'\t' \) -a \( "$CHAR" != $'\f' \)
}


#### character predicates from character ranges and similar

m4_define([[[MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE]]],[[[
function $1 () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_declare_varref(RV)
    mbfl_string_first_var UU(RV) "$[[[]]]$2[[[]]]" "$CHAR"
}
]]])

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_ascii_symbol_char,	      MBFL_ASCII_RANGE_ASCII_SYMBOLS)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_vowel_char,	      MBFL_ASCII_RANGE_LOWER_CASE_VOWELS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_consonant_char,    MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_alphabet_char,     MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_alnum_char,	      MBFL_ASCII_RANGE_LOWER_CASE_ALNUM)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_base16_char,	      MBFL_ASCII_RANGE_LOWER_CASE_BASE16)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_vowel_char,	      MBFL_ASCII_RANGE_UPPER_CASE_VOWELS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_consonant_char,    MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_alphabet_char,     MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_alnum_char,	      MBFL_ASCII_RANGE_UPPER_CASE_ALNUM)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_base16_char,	      MBFL_ASCII_RANGE_UPPER_CASE_BASE16)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_vowel_char,	      MBFL_ASCII_RANGE_MIXED_CASE_VOWELS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_consonant_char,    MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_alphabet_char,     MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_alnum_char,	      MBFL_ASCII_RANGE_MIXED_CASE_ALNUM)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_base16_char,	      MBFL_ASCII_RANGE_MIXED_CASE_BASE16)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_base32_char,		      MBFL_ASCII_RANGE_BASE32)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_base64_char,		      MBFL_ASCII_RANGE_BASE64)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_printable_ascii_noblank_char, MBFL_ASCII_RANGE_PRINTABLE_ASCII_NOBLANK)


#### string predicates

function mbfl_p_string_is () {
    mbfl_mandatory_parameter(CHAR_PRED_FUNC, 1, char predicate func)
    # Accept $2  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    declare STRING=$2
    declare -i i
    if ((0 < mbfl_string_len(STRING)))
    then
	for ((i=0; i < mbfl_string_len(STRING); ++i))
	do
	    if ! $CHAR_PRED_FUNC "mbfl_string_idx(STRING, $i)"
	    then return 1
	    fi
	done
	return 0
    else return 1
    fi
}
function mbfl_string_is_alpha			() { mbfl_p_string_is mbfl_string_is_alpha_char   "$@"; }
function mbfl_string_is_digit			() { mbfl_p_string_is mbfl_string_is_digit_char   "$@"; }
function mbfl_string_is_alnum			() { mbfl_p_string_is mbfl_string_is_alnum_char   "$@"; }
function mbfl_string_is_noblank			() { mbfl_p_string_is mbfl_string_is_noblank_char "$@"; }

function mbfl_string_is_ascii_symbol		() { mbfl_p_string_is mbfl_string_is_ascii_symbol_char "$@"; }
function mbfl_string_is_lower_case_vowel	() { mbfl_p_string_is mbfl_string_is_lower_case_vowel_char "$@"; }
function mbfl_string_is_lower_case_consonant	() { mbfl_p_string_is mbfl_string_is_lower_case_consonant_char "$@"; }
function mbfl_string_is_lower_case_alphabet	() { mbfl_p_string_is mbfl_string_is_lower_case_alphabet_char "$@"; }
function mbfl_string_is_lower_case_alnum	() { mbfl_p_string_is mbfl_string_is_lower_case_alnum_char "$@"; }
function mbfl_string_is_lower_case_base16	() { mbfl_p_string_is mbfl_string_is_lower_case_base16_char "$@"; }

function mbfl_string_is_upper_case_vowel	() { mbfl_p_string_is mbfl_string_is_upper_case_vowel_char "$@"; }
function mbfl_string_is_upper_case_consonant	() { mbfl_p_string_is mbfl_string_is_upper_case_consonant_char "$@"; }
function mbfl_string_is_upper_case_alphabet	() { mbfl_p_string_is mbfl_string_is_upper_case_alphabet_char "$@"; }
function mbfl_string_is_upper_case_alnum	() { mbfl_p_string_is mbfl_string_is_upper_case_alnum_char "$@"; }
function mbfl_string_is_upper_case_base16	() { mbfl_p_string_is mbfl_string_is_upper_case_base16_char "$@"; }

function mbfl_string_is_mixed_case_vowel	() { mbfl_p_string_is mbfl_string_is_mixed_case_vowel_char "$@"; }
function mbfl_string_is_mixed_case_consonant	() { mbfl_p_string_is mbfl_string_is_mixed_case_consonant_char "$@"; }
function mbfl_string_is_mixed_case_alphabet	() { mbfl_p_string_is mbfl_string_is_mixed_case_alphabet_char "$@"; }
function mbfl_string_is_mixed_case_alnum	() { mbfl_p_string_is mbfl_string_is_mixed_case_alnum_char "$@"; }
function mbfl_string_is_mixed_case_base16	() { mbfl_p_string_is mbfl_string_is_mixed_case_base16_char "$@"; }

function mbfl_string_is_base32			() { mbfl_p_string_is mbfl_string_is_base32_char "$@"; }
function mbfl_string_is_base64			() { mbfl_p_string_is mbfl_string_is_base64_char "$@"; }
function mbfl_string_is_printable_ascii_noblank	() { mbfl_p_string_is mbfl_string_is_printable_ascii_noblank_char "$@"; }

function mbfl_string_is_name () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    declare STRING=$1
    mbfl_string_is_not_empty "$STRING" && \
	mbfl_p_string_is mbfl_string_is_name_char "$STRING" && \
	{ ! mbfl_string_is_digit "mbfl_string_idx(STRING, 0)"; }
}
function mbfl_string_is_identifier () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    mbfl_optional_parameter(STRING, 1)
    mbfl_string_is_not_empty "$STRING"					\
	&&   mbfl_p_string_is mbfl_string_is_identifier_char "$STRING"	\
	&& ! mbfl_string_is_digit "mbfl_string_idx(STRING, 0)"		\
	&& mbfl_string_not_equal "mbfl_string_idx(STRING, 0)" '-'
}
function mbfl_string_is_extended_identifier () {
    # Accept $1 even if it is empty; for this reason we do not use MBFL_MANDATORY_PARAMETER.
    declare STRING=$1
    mbfl_string_is_not_empty "$STRING" \
	&&   mbfl_p_string_is mbfl_string_is_extended_identifier_char "$STRING"		\
	&& ! mbfl_string_is_digit "mbfl_string_idx(STRING, 0)"				\
	&& mbfl_string_not_equal "mbfl_string_idx(STRING, 0)" '-'
}
function mbfl_string_is_username () {
    mbfl_optional_parameter(STRING,1)
    declare -r REX='^(([a-zA-Z0-9_\.\-]+)|(\+[0-9]+))$'

    if mbfl_string_equal $'\n' "mbfl_string_last_char(STRING)"
    then return_failure
    elif [[ "$STRING" =~ $REX ]]
    then return_success
    else return_failure
    fi
}
function mbfl_string_is_groupname () {
    mbfl_optional_parameter(STRING,1)
    mbfl_string_is_username "$STRING"
}
function mbfl_string_is_network_port () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(STRING, 1)

    if mbfl_string_is_not_empty "$STRING" && mbfl_string_is_digit "$STRING" && ((0 <= STRING && STRING <= 1024))
    then return 0
    else return 1
    fi
}
function mbfl_string_is_network_hostname () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(STRING, 1)
    # This regular expression comes from:
    #
    #   https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    #
    # answer by Sakari A. Maaranen, last visited Nov 23, 2018.
    declare -r REX="^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$"

    if ((mbfl_string_len(STRING) <= 255)) && [[ $STRING =~ $REX ]]
    then return 0
    fi
    return 1
}

function mbfl_string_is_network_ip_address () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(STRING, 1)
    # This regular expression comes from:
    #
    #   https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    #
    # answer by Jorge Ferreira, last visited Nov 23, 2018.
    #
    declare -r REX="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

    if ((mbfl_string_len(STRING) <= 255)) && [[ $STRING =~ $REX ]]
    then return 0
    fi
    return 1
}

function mbfl_string_is_email_address () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(ADDRESS, 1)
    declare -r REX='^[a-zA-Z0-9_.\-]+(@[a-zA-Z0-9_.\-]+)?$'

    if [[ $ADDRESS =~ $REX ]]
    then return 0
    else return 1
    fi
}

### ------------------------------------------------------------------------

function mbfl_string_is_exact_integer_number () {
    mbfl_optional_parameter(STRING,1)
    declare -r REX='^[+-]?[0-9]+$'

    if mbfl_string_equal $'\n' "mbfl_string_last_char(STRING)"
    then return_failure
    elif [[ "$STRING" =~ $REX ]]
    then return_success
    else return_failure
    fi
}
function mbfl_string_is_floating_point_number () {
    mbfl_optional_parameter(STRING,1)
    declare -r REX='^[+-]?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))([eE][+-]?[0-9]+)?$'
    declare -r REXA='^\-?0[xX][0-9a-fA-F](\.[0-9a-fA-F]+)?[pP][+-]?[0-9a-fA-F]+$'

    if mbfl_string_equal $'\n' "mbfl_string_last_char(STRING)"
    then return_failure
    elif [[ "$STRING" =~ $REX ]]
    then return_success
    elif [[ "$STRING" =~ $REXA ]]
    then return_success
    else
	declare ITEM

	for ITEM in \
	    'inf' '+inf' '-inf' 'inf.0' '+inf.0' '-inf.0' \
		  'infinity' '+infinity' '-infinity' 'Infinity' '+Infinity' '-Infinity' \
		  'nan' '+nan' '-nan' 'nan.0' '+nan.0' '-nan.0' \
		  'NaN' '+NaN' '-NaN' 'NaN.0' '+NaN.0' '-NaN.0'
	do
	    if mbfl_string_equal "$ITEM" "$STRING"
	    then return_success
	    fi
	done
	return_failure
    fi
}
function mbfl_string_is_complex_floating_point_number () {
    mbfl_optional_parameter(STRING,1)
    declare -r REX='^\(([^\)]+)\)\+i\*\(([^\)]+)\)$'

    if mbfl_string_equal $'\n' "mbfl_string_last_char(STRING)"
    then return_failure
    elif [[ "$STRING" =~ $REX ]]
    then
	# Calling "mbfl_string_is_floating_point_number()"  will reset the matching  array, so let's
	# save the groups.
	declare REP=${BASH_REMATCH[1]} IMP=${BASH_REMATCH[2]}
	#mbfl_array_dump BASH_REMATCH BASH_REMATCH
	mbfl_string_is_floating_point_number "$REP" && mbfl_string_is_floating_point_number "$IMP"
    elif test 'i' = "mbfl_string_last_char(STRING)"
    then
	# FIXME In  future I will implement  the format '1.2+3.4i' but  right now I am  too lazy and
	# busy with other stuff.  (Marco Maggi; Sep 30, 2024)
	return_failure
    else mbfl_string_is_floating_point_number "$STRING"
    fi
}


#### case conversion

function mbfl_string_toupper () {
    echo "${1^^}"
}
function mbfl_string_tolower () {
    echo "${1,,}"
}

function mbfl_string_toupper_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_RESULT_VARREF="${2^^}"
}
function mbfl_string_tolower_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_RESULT_VARREF="${2,,}"
}


#### stripping from strings

function mbfl_string_strip_carriage_return_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_NAMEREF, 1, result variable name)
    mbfl_optional_parameter(mbfl_LINE, 2)

    if mbfl_string_is_not_empty "$mbfl_LINE"
    then
	mbfl_declare_varref(CH)

	mbfl_string_index_var UU(CH) "$mbfl_LINE" $((mbfl_string_len(mbfl_LINE) - 1))
	if mbfl_string_equal "$CH" $'\r'
	then mbfl_RESULT_NAMEREF=${mbfl_LINE:0:((mbfl_string_len(mbfl_LINE) - 1))}
	else mbfl_RESULT_NAMEREF=$mbfl_LINE
	fi
    fi
}

function mbfl_string_strip_prefix_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,	1, the result variable)
    mbfl_optional_parameter(mbfl_PREFIX,	2)
    mbfl_optional_parameter(mbfl_STRING,	3)

    declare -i mbfl_PREFIX_LEN=mbfl_string_len(mbfl_PREFIX)
    declare mbfl_STRING_PREFIX=${mbfl_STRING:0:$mbfl_PREFIX_LEN}

    if mbfl_string_eq("$mbfl_PREFIX", "$mbfl_STRING_PREFIX")
    then
	mbfl_RV=${mbfl_STRING:$mbfl_PREFIX_LEN}
	return_because_success
    else
	mbfl_RV="$mbfl_STRING"
	return_because_failure
    fi
}
function mbfl_string_strip_suffix_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,	1, the result variable)
    mbfl_optional_parameter(mbfl_STRING,	2)
    mbfl_optional_parameter(mbfl_SUFFIX,	3)

    #echo $FUNCNAME mbfl_STRING=\"$mbfl_STRING\" mbfl_SUFFIX=\"$mbfl_SUFFIX\" >&2

    declare -i mbfl_STRING_LEN=mbfl_string_len(mbfl_STRING)
    declare -i mbfl_SUFFIX_LEN=mbfl_string_len(mbfl_SUFFIX)

    declare -i mbfl_STRING_BEGIN=$(($mbfl_STRING_LEN - $mbfl_SUFFIX_LEN))
    declare mbfl_STRING_SUFFIX=${mbfl_STRING:$mbfl_STRING_BEGIN}

    #echo $FUNCNAME mbfl_STRING_LEN=\"$mbfl_STRING_LEN\" mbfl_SUFFIX_LEN=\"$mbfl_SUFFIX_LEN\" mbfl_STRING_BEGIN=\"$mbfl_STRING_BEGIN\" >&2
    #echo $FUNCNAME mbfl_STRING_SUFFIX=\"$mbfl_STRING_SUFFIX\" >&2
    if mbfl_string_eq("$mbfl_STRING_SUFFIX", "$mbfl_SUFFIX")
    then
	mbfl_RV=${mbfl_STRING:0:$mbfl_STRING_BEGIN}
	return_because_success
    else
	mbfl_RV="$mbfl_STRING"
	return_because_failure
    fi
}
function mbfl_string_strip_prefix_and_suffix_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,	1, the result variable)
    mbfl_optional_parameter(mbfl_PREFIX,	2)
    mbfl_optional_parameter(mbfl_STRING,	3)
    mbfl_optional_parameter(mbfl_SUFFIX,	4)
    mbfl_declare_varref(mbfl_TMP_STRING)
    declare -i X1 x2

    mbfl_string_strip_prefix_var UU(mbfl_TMP_STRING) "$mbfl_PREFIX" "$mbfl_STRING"
    X1=$?
    mbfl_string_strip_suffix_var UU(mbfl_RV)         "$mbfl_TMP_STRING" "$mbfl_SUFFIX"
    X2=$?

    if   ((0 == X1 && 0 == X2)) ;# both strip
    then return 0
    elif ((1 == X1 && 1 == X2)) ;# no strip
    then return 1
    elif ((0 == X1 && 1 == X2)) ;# prefix strip
    then return 2
    elif ((1 == X1 && 0 == X2)) ;# suffix strip
    then return 3
    else return 4 ;# internal error!!! should not be here!
    fi
}


#### values normalisation

function mbfl_string_normalise_boolean_var () {
    mbfl_mandatory_nameref_parameter(mbfl_NORMAL_RV,	1, result variable)
    mbfl_mandatory_parameter(mbfl_VAL,			2, possible boolean value)

    case "$mbfl_VAL" in
	'true'|'false')	mbfl_NORMAL_RV=$mbfl_VAL	;;
	'yes'|'1')	mbfl_NORMAL_RV='true'		;;
	'no'|'0')	mbfl_NORMAL_RV='false'		;;
	*)
	    return_failure
	    ;;
    esac
    return_success
}


#### miscellaneous

function mbfl_string_replace () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(PATTERN, 2, pattern)
    mbfl_optional_parameter(SUBST, 3)
    printf '%s\n' "${STRING//$PATTERN/$SUBST}"
}
function mbfl_string_replace_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_PATTERN, 3, pattern)
    mbfl_optional_parameter(mbfl_SUBST, 4)
    mbfl_RESULT_VARREF=${mbfl_STRING//${mbfl_PATTERN}/${mbfl_SUBST}}
}

function mbfl_string_skip () {
    mbfl_mandatory_parameter(mbfl_STRING, 1, string)
    mbfl_mandatory_nameref_parameter(mbfl_POSNAME, 2, position)
    mbfl_mandatory_parameter(mbfl_CHAR, 3, char)
    while test "mbfl_string_idx(mbfl_STRING, $mbfl_POSNAME)" = "$mbfl_CHAR"
    do let ++mbfl_POSNAME
    done
}

function mbfl_sprintf () {
    mbfl_mandatory_parameter(VARNAME, 1, variable name)
    mbfl_mandatory_parameter(FORMAT,  2, format)
    local OUTPUT=
    shift 2
    printf -v OUTPUT "$FORMAT" "$@"
    eval "$VARNAME"=\'"$OUTPUT"\'
}

### end of file
# Local Variables:
# mode: sh
# End:
