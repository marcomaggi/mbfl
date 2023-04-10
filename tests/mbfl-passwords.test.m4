# mbfl-passwords.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-passwords library
# Date: Feb 19, 2023
#
# Abstract
#
#	This file must be executed with one among:
#
#		$ make all test TESTMATCH=mbfl-passwords-
#		$ make all check TESTS=tests/mbfl-passwords.test ; less tests/mbfl-passwords.log
#
#	that will select these tests.
#
# Copyright (c) 2023 Marco Maggi
# <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#


#### setup

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_PASSWORDS")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### macros

# $1 - test function name
# $2 - password generating function
# $3 - password length
# $4 - validating function
#
m4_define([[[MBFL_DEFINE_TEST_PRINTING_FUNCTION]]],[[[
function $1 () {
    local PASSWD=$($2 $3)
    dotest-printf 'generated password: "%s"\n' "$PASSWD" >&2
    dotest-equal $3 mbfl_string_len(PASSWD) && $4 "$PASSWD"
}
]]])

# $1 - test function name
# $2 - password generating function
# $3 - password length
# $4 - validating function
#
m4_define([[[MBFL_DEFINE_TEST_VAR_FUNCTION]]],[[[
function $1 () {
    mbfl_declare_varref(PASSWD)
    $2 mbfl_datavar(PASSWD) $3
    dotest-printf 'generated password: "%s"\n' "$PASSWD" >&2
    dotest-equal $3 mbfl_string_len(PASSWD) && $4 "$PASSWD"
}
]]])

# $1 - test stem
# $2 - function to test
# $3 - validation function
#
m4_define([[[MBFL_DEFINE_TESTS_GROUP]]],[[[
MBFL_DEFINE_TEST_PRINTING_FUNCTION(mbfl-passwords-[[[]]]$1[[[]]]-1.1, $2,  1, $3)
MBFL_DEFINE_TEST_PRINTING_FUNCTION(mbfl-passwords-[[[]]]$1[[[]]]-1.2, $2, 75, $3)

MBFL_DEFINE_TEST_VAR_FUNCTION(mbfl-passwords-[[[]]]$1[[[]]]-2.1, $2[[[]]]_var,  1, $3)
MBFL_DEFINE_TEST_VAR_FUNCTION(mbfl-passwords-[[[]]]$1[[[]]]-2.2, $2[[[]]]_var, 75, $3)
]]])


#### test groups

MBFL_DEFINE_TESTS_GROUP(digits,			mbfl_passwords_digits,			mbfl_string_is_digit)
MBFL_DEFINE_TESTS_GROUP(ascii-symbols,		mbfl_passwords_ascii_symbols,		mbfl_string_is_ascii_symbol)

MBFL_DEFINE_TESTS_GROUP(lower-case-vowels,	mbfl_passwords_lower_case_vowels,	mbfl_string_is_lower_case_vowel)
MBFL_DEFINE_TESTS_GROUP(lower-case-consonants,	mbfl_passwords_lower_case_consonants,	mbfl_string_is_lower_case_consonant)
MBFL_DEFINE_TESTS_GROUP(lower-case-alphabet,	mbfl_passwords_lower_case_alphabet,	mbfl_string_is_lower_case_alphabet)
MBFL_DEFINE_TESTS_GROUP(lower-case-alnum,	mbfl_passwords_lower_case_alnum,	mbfl_string_is_lower_case_alnum)
MBFL_DEFINE_TESTS_GROUP(lower-case-base16,	mbfl_passwords_lower_case_base16,	mbfl_string_is_lower_case_base16)

MBFL_DEFINE_TESTS_GROUP(upper-case-vowels,	mbfl_passwords_upper_case_vowels,	mbfl_string_is_upper_case_vowel)
MBFL_DEFINE_TESTS_GROUP(upper-case-consonants,	mbfl_passwords_upper_case_consonants,	mbfl_string_is_upper_case_consonant)
MBFL_DEFINE_TESTS_GROUP(upper-case-alphabet,	mbfl_passwords_upper_case_alphabet,	mbfl_string_is_upper_case_alphabet)
MBFL_DEFINE_TESTS_GROUP(upper-case-alnum,	mbfl_passwords_upper_case_alnum,	mbfl_string_is_upper_case_alnum)
MBFL_DEFINE_TESTS_GROUP(upper-case-base16,	mbfl_passwords_upper_case_base16,	mbfl_string_is_upper_case_base16)

MBFL_DEFINE_TESTS_GROUP(mixed-case-vowels,	mbfl_passwords_mixed_case_vowels,	mbfl_string_is_mixed_case_vowel)
MBFL_DEFINE_TESTS_GROUP(mixed-case-consonants,	mbfl_passwords_mixed_case_consonants,	mbfl_string_is_mixed_case_consonant)
MBFL_DEFINE_TESTS_GROUP(mixed-case-alphabet,	mbfl_passwords_mixed_case_alphabet,	mbfl_string_is_mixed_case_alphabet)
MBFL_DEFINE_TESTS_GROUP(mixed-case-alnum,	mbfl_passwords_mixed_case_alnum,	mbfl_string_is_mixed_case_alnum)
MBFL_DEFINE_TESTS_GROUP(mixed-case-base16,	mbfl_passwords_mixed_case_base16,	mbfl_string_is_mixed_case_base16)

MBFL_DEFINE_TESTS_GROUP(base32,			mbfl_passwords_base32,			mbfl_string_is_base32)
MBFL_DEFINE_TESTS_GROUP(base64,			mbfl_passwords_base64,			mbfl_string_is_base64)
MBFL_DEFINE_TESTS_GROUP(ascii_noblank,		mbfl_passwords_printable_ascii_noblank, mbfl_string_is_printable_ascii_noblank)


#### examples

# This looks nice but  it is unsafe because predictable.  The tool  "pwgen" generates passwords that
# are "easy" to pronounce; to do it we have  too choose the right sequence of consonants and vowels;
# I  think it  comes down  to avoiding  certain consonants  sequences.  I  will have  to investigate
# further in the future.  (Marco Maggi; Nov 16, 2022)
#
function mbfl_passwords_mine_var () {
    mbfl_mandatory_nameref_parameter(PWD, 1, result variable)
    mbfl_declare_varref(BLOCK)

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
    mbfl_declare_varref(RV)
    mbfl_passwords_mine_var mbfl_datavar(RV)
    printf '%s' "$RV"
}

{
    printf 'example password: "'
    mbfl_passwords_mine
    printf '"\n\n'
} >&2


#### let's go

dotest mbfl-passwords-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
