# mbflutils-files.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-passwords library
# Date: Feb 19, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=mbfl-passwords-
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

mbfl_load_library("$MBFL_TESTS_LIBMBFL")
mbfl_load_library("$MBFL_TESTS_LIBMBFLPASSWORDS")
mbfl_load_library("$MBFL_TESTS_LIBMBFLTEST")


#### digits

function mbfl-passwords-digits-1.1 () {
    local PASSWD=$(mbfl_passwords_digits 1)
    dotest-printf 'generated password: "%s"\n' "$PASSWD" >&2
    dotest-equal 1 mbfl_string_len(PASSWD) && \
	mbfl_string_is_digit "$PASSWD"
}

function mbfl-passwords-digits-1.2 () {
    local PASSWD=$(mbfl_passwords_digits 75)
    dotest-printf 'generated password: "%s"\n' "$PASSWD"
    dotest-equal 75 mbfl_string_len(PASSWD) && \
	mbfl_string_is_digit "$PASSWD"
}

if false
then

# printf 'mbfl_passwords_ascii_symbols: (%d) %s\n' ${#MBFL_PASSWORDS_ASCII_SYMBOLS[@]} $(mbfl_passwords_ascii_symbols 1)
# printf 'mbfl_passwords_ascii_symbols: (%d) %s\n' ${#MBFL_PASSWORDS_ASCII_SYMBOLS[@]} $(mbfl_passwords_ascii_symbols 75)

echo

### ------------------------------------------------------------------------

printf 'mbfl_passwords_lower_case_vowels: (%d) %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_VOWELS[@]} $(mbfl_passwords_lower_case_vowels 1)
printf 'mbfl_passwords_lower_case_vowels: (%d) %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_VOWELS[@]} $(mbfl_passwords_lower_case_vowels 75)

printf 'mbfl_passwords_lower_case_consonants (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_CONSONANTS[@]} $(mbfl_passwords_lower_case_consonants 1)
printf 'mbfl_passwords_lower_case_consonants (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_CONSONANTS[@]} $(mbfl_passwords_lower_case_consonants 75)

printf 'mbfl_passwords_lower_case_alphabet (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_ALPHABET[@]} $(mbfl_passwords_lower_case_alphabet 1)
printf 'mbfl_passwords_lower_case_alphabet (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_ALPHABET[@]} $(mbfl_passwords_lower_case_alphabet 75)

printf 'mbfl_passwords_lower_case_alnum (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_ALNUM[@]} $(mbfl_passwords_lower_case_alnum 1)
printf 'mbfl_passwords_lower_case_alnum (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_ALNUM[@]} $(mbfl_passwords_lower_case_alnum 75)

printf 'mbfl_passwords_lower_case_base16 (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_BASE16[@]} $(mbfl_passwords_lower_case_base16 1)
printf 'mbfl_passwords_lower_case_base16 (%d): %s\n' ${#MBFL_PASSWORDS_LOWER_CASE_BASE16[@]} $(mbfl_passwords_lower_case_base16 75)

echo

### ------------------------------------------------------------------------

printf 'mbfl_passwords_upper_case_vowels: (%d) %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_VOWELS[@]} $(mbfl_passwords_upper_case_vowels 75)
printf 'mbfl_passwords_upper_case_vowels: (%d) %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_VOWELS[@]} $(mbfl_passwords_upper_case_vowels 75)

printf 'mbfl_passwords_upper_case_consonants (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_CONSONANTS[@]} $(mbfl_passwords_upper_case_consonants 1)
printf 'mbfl_passwords_upper_case_consonants (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_CONSONANTS[@]} $(mbfl_passwords_upper_case_consonants 75)

printf 'mbfl_passwords_upper_case_alphabet (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]} $(mbfl_passwords_upper_case_alphabet 1)
printf 'mbfl_passwords_upper_case_alphabet (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_ALPHABET[@]} $(mbfl_passwords_upper_case_alphabet 75)

printf 'mbfl_passwords_upper_case_alnum (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_ALNUM[@]} $(mbfl_passwords_upper_case_alnum 1)
printf 'mbfl_passwords_upper_case_alnum (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_ALNUM[@]} $(mbfl_passwords_upper_case_alnum 75)

printf 'mbfl_passwords_upper_case_base16 (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_BASE16[@]} $(mbfl_passwords_upper_case_base16 1)
printf 'mbfl_passwords_upper_case_base16 (%d): %s\n' ${#MBFL_PASSWORDS_UPPER_CASE_BASE16[@]} $(mbfl_passwords_upper_case_base16 75)

echo

### ------------------------------------------------------------------------

printf 'mbfl_passwords_mixed_case_vowels: (%d) %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_VOWELS[@]} $(mbfl_passwords_mixed_case_vowels 75)
printf 'mbfl_passwords_mixed_case_vowels: (%d) %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_VOWELS[@]} $(mbfl_passwords_mixed_case_vowels 75)

printf 'mbfl_passwords_mixed_case_consonants (%d): %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_CONSONANTS[@]} $(mbfl_passwords_mixed_case_consonants 1)
printf 'mbfl_passwords_mixed_case_consonants (%d): %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_CONSONANTS[@]} $(mbfl_passwords_mixed_case_consonants 75)

printf 'mbfl_passwords_mixed_case_alphabet (%d): %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_ALPHABET[@]} $(mbfl_passwords_mixed_case_alphabet 1)
printf 'mbfl_passwords_mixed_case_alphabet (%d): %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_ALPHABET[@]} $(mbfl_passwords_mixed_case_alphabet 75)

printf 'mbfl_passwords_mixed_case_alnum (%d): %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_ALNUM[@]} $(mbfl_passwords_mixed_case_alnum 1)
printf 'mbfl_passwords_mixed_case_alnum (%d): %s\n' ${#MBFL_PASSWORDS_MIXED_CASE_ALNUM[@]} $(mbfl_passwords_mixed_case_alnum 75)

echo

### ------------------------------------------------------------------------

printf 'mbfl_passwords_base32: (%d) %s\n' ${#MBFL_PASSWORDS_BASE32[@]} $(mbfl_passwords_base32 1)
printf 'mbfl_passwords_base32: (%d) %s\n' ${#MBFL_PASSWORDS_BASE32[@]} $(mbfl_passwords_base32 75)

printf 'mbfl_passwords_base64: (%d) %s\n' ${#MBFL_PASSWORDS_BASE64[@]} $(mbfl_passwords_base64 1)
printf 'mbfl_passwords_base64: (%d) %s\n' ${#MBFL_PASSWORDS_BASE64[@]} $(mbfl_passwords_base64 75)

printf 'mbfl_passwords_ascii: (%d) %s\n' ${#MBFL_PASSWORDS_ASCII[@]} "$(mbfl_passwords_ascii 1)"
printf 'mbfl_passwords_ascii: (%d) %s\n' ${#MBFL_PASSWORDS_ASCII[@]} "$(mbfl_passwords_ascii 75)"

echo

### ------------------------------------------------------------------------

printf 'mbfl_passwords_mine: %s\n' $(mbfl_passwords_mine)

fi


#### let's go

dotest mbfl-passwords-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
