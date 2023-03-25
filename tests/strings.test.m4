# string.test --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the string library
# Date: Fri Apr 18, 2003
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=string-
#
#	will select these tests.
#
# Copyright (c) 2004, 2005, 2009, 2013, 2014, 2018, 2020, 2023 Marco Maggi
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
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### quoted characters

function string-is-quoted-char-1.1 () {
    ! mbfl_string_is_quoted_char abcdefg 3
}
function string-is-quoted-char-1.2 () {
    mbfl_string_is_quoted_char 'ab\cdefg' 3
}
function string-is-quoted-char-1.3 () {
    mbfl_string_is_quoted_char 'ab\ndefg' 3
}

### --------------------------------------------------------------------

function string-equal-unquoted-1.1 () {
    mbfl_string_is_equal_unquoted_char abcdefg 3 d
}
function string-equal-unquoted-1.2 () {
    ! mbfl_string_is_equal_unquoted_char 'abc\defg' 3 d
}

### --------------------------------------------------------------------

function string-quote-1.1 () {
    mbfl_string_quote \\a\\b\\c | dotest-output \\\\a\\\\b\\\\c
}
function string-quote-2.1 () {
    mbfl_string_quote abc | dotest-output abc
}
function string-quote-3.1 () {
    mbfl_string_quote "a b\tc\n\r" | dotest-output a\ b\\\\tc\\\\n\\\\r
}

### --------------------------------------------------------------------

function string-quote-var-1.1 () {
    local RV
    if mbfl_string_quote_var RV \\a\\b\\c
    then dotest-equal \\\\a\\\\b\\\\c "$RV"
    fi
}
function string-quote-var-2.1 () {
    local RV
    if mbfl_string_quote_var RV abc
    then dotest-equal abc "$RV"
    fi
}
function string-quote-var-3.1 () {
    local RV
    if mbfl_string_quote_var RV "a b\tc\n\r"
    then dotest-equal 'a b\\tc\\n\\r' "$RV"
    fi
}


#### string inspection: emptiness

function string-is-empty-1.1.1 () {
    mbfl_string_is_empty ''
}

function string-is-empty-1.1.2 () {
    mbfl_string_is_empty
}

function string-is-empty-1.2 () {
    ! mbfl_string_is_empty a
}

function string-is-empty-1.3 () {
    ! mbfl_string_is_empty abcdefghilm
}

### --------------------------------------------------------------------

function string-is-not-empty-1.1.1 () {
    ! mbfl_string_is_not_empty ''
}

function string-is-not-empty-1.1.2 () {
    ! mbfl_string_is_not_empty
}

function string-is-not-empty-1.2 () {
    mbfl_string_is_not_empty a
}

function string-is-not-empty-1.3 () {
    mbfl_string_is_not_empty abcdefghilm
}


#### string inspection: length

function string-length-1.1.1 () {
    mbfl_string_length '' | dotest-output 0
}

function string-length-1.1.2 () {
    mbfl_string_length    | dotest-output 0
}

function string-length-1.2 () {
    mbfl_string_length a | dotest-output 1
}

function string-length-1.3 () {
    mbfl_string_length abcdefghilm | dotest-output 11
}

### --------------------------------------------------------------------

function string-len-1.1 () {
    local VAR=ciao

    dotest-equal 4 mbfl_string_len(VAR)
}

function string-len-1.2 () {
    local VAR=

    dotest-equal 0 mbfl_string_len(VAR)
}

### --------------------------------------------------------------------

function string-length-equal-to-1.1.1 () {
    mbfl_string_length_equal_to 0 ''
}

function string-length-equal-to-1.1.2 () {
    mbfl_string_length_equal_to 0
}

function string-length-equal-to-1.2 () {
    mbfl_string_length_equal_to 1 a
}

function string-length-equal-to-1.3 () {
    mbfl_string_length_equal_to 11 abcdefghilm
}


#### string inspection: character at index

function string-index-1.1 () {
    mbfl_string_index abcdefghilm 0 | dotest-output a
}

function string-index-1.2 () {
    mbfl_string_index abcdefghilm 4 | dotest-output e
}

function string-index-1.3 () {
    mbfl_string_index abcdefghilm 10 | dotest-output m
}

function string-index-1.4 () {
    mbfl_string_index abcdefghilm 11 | dotest-output
}

### --------------------------------------------------------------------

function string-index-var-1.1 () {
    local RV
    if mbfl_string_index_var RV abcdefghilm 0
    then dotest-equal a "$RV"
    fi
}

function string-index-var-1.2 () {
    local RV
    if mbfl_string_index_var RV abcdefghilm 4
    then dotest-equal e "$RV"
    fi
}

function string-index-var-1.3 () {
    local RV
    if mbfl_string_index_var RV abcdefghilm 10
    then dotest-equal m "$RV"
    fi
}

function string-index-var-1.4 () {
    local RV
    #                           01234567890
    if mbfl_string_index_var RV abcdefghilm 11
    then dotest-equal '' "$RV"
    fi
}


#### string inspection: first character

function string-first-1.1 () {
    mbfl_string_first abcdefghilm d | dotest-output 3
}

function string-first-1.2 () {
    mbfl_string_first abcdefghilm a | dotest-output 0
}

function string-first-1.3 () {
    mbfl_string_first abcdefghilm m | dotest-output 10
}

function string-first-1.4 () {
    mbfl_string_first abcdefghilm X | dotest-output
}

function string-first-1.5 () {
    mbfl_string_first abcdeabcde a 3 | dotest-output 5
}

function string-first-1.6 () {
    mbfl_string_first abcdeabcde e 5 | dotest-output 9
}

function string-first-1.7 () {
    mbfl_string_first abcdeabcde e 4 | dotest-output 4
}

### --------------------------------------------------------------------

function string-first-var-1.1 () {
    local RV
    if mbfl_string_first_var RV abcdefghilm d
    then dotest-equal 3 "$RV"
    fi
}

function string-first-var-1.2 () {
    local RV
    if mbfl_string_first_var RV abcdefghilm a
    then dotest-equal 0 "$RV"
    fi
}

function string-first-var-1.3 () {
    local RV
    if mbfl_string_first_var RV abcdefghilm m
    then dotest-equal 10 "$RV"
    fi
}

function string-first-var-1.4 () {
    local RV
    if mbfl_string_first_var RV abcdefghilm X
    then dotest-equal "$RV"
    fi
}

function string-first-var-1.5 () {
    local RV
    if mbfl_string_first_var RV abcdeabcde a 3
    then dotest-equal 5 "$RV"
    fi
}

function string-first-var-1.6 () {
    local RV
    if mbfl_string_first_var RV abcdeabcde e 5
    then dotest-equal 9 "$RV"
    fi
}

function string-first-var-1.7 () {
    local RV
    if mbfl_string_first_var RV abcdeabcde e 4
    then dotest-equal 4 "$RV"
    fi
}


#### string inspection: last character

function string-last-1.1 () {
    mbfl_string_last abcdefghilm d | dotest-output 3
}
function string-last-1.2 () {
    mbfl_string_last abcdefghilm a | dotest-output 0
}
function string-last-1.3 () {
    mbfl_string_last abcdefghilm m | dotest-output 10
}
function string-last-1.4 () {
    mbfl_string_last abcdefghilm X | dotest-output
}
function string-last-1.5 () {
    mbfl_string_last abcdefghilm a 3 | dotest-output 0
}
function string-last-1.6 () {
    mbfl_string_last abcdeabcde a 7 | dotest-output 5
}
function string-last-1.7 () {
    mbfl_string_last abcdeabcde e 7 | dotest-output 4
}
function string-last-1.8 () {
    mbfl_string_last abcdeabcde e 4 | dotest-output 4
}

### --------------------------------------------------------------------

function string-last-var-1.1 () {
    local RV
    if mbfl_string_last_var RV abcdefghilm d
    then dotest-equal 3 "$RV"
    fi
}
function string-last-var-1.2 () {
    local RV
    if mbfl_string_last_var RV abcdefghilm a
    then dotest-equal 0 "$RV"
    fi
}
function string-last-var-1.3 () {
    local RV
    if mbfl_string_last_var RV abcdefghilm m
    then dotest-equal 10 "$RV"
    fi
}
function string-last-var-1.4 () {
    local RV
    if mbfl_string_last_var RV abcdefghilm X
    then dotest-equal "$RV"
    fi
}
function string-last-var-1.5 () {
    local RV
    if mbfl_string_last_var RV abcdefghilm a 3
    then dotest-equal 0 "$RV"
    fi
}
function string-last-var-1.6 () {
    local RV
    if mbfl_string_last_var RV abcdeabcde a 7
    then dotest-equal 5 "$RV"
    fi
}
function string-last-var-1.7 () {
    local RV
    if mbfl_string_last_var RV abcdeabcde e 7
    then dotest-equal 4 "$RV"
    fi
}
function string-last-var-1.8 () {
    local RV
    if mbfl_string_last_var RV abcdeabcde e 4
    then dotest-equal 4 "$RV"
    fi
}


#### string inspection: range of characters

function string-range-1.1 () {
    mbfl_string_range abcdefghilm 0 end | dotest-output abcdefghilm
}

function string-range-1.2 () {
    mbfl_string_range abcdefghilm 0 | dotest-output abcdefghilm
}

function string-range-1.3 () {
    mbfl_string_range abcdefghilm 0 4 | dotest-output abcd
}

function string-range-1.4 () {
    mbfl_string_range abcdefghilm 4 end | dotest-output efghilm
}

function string-range-1.5 () {
    mbfl_string_range abcdefghilm 4 END | dotest-output efghilm
}

### --------------------------------------------------------------------

function string-range-var-1.1 () {
    local RV
    if mbfl_string_range_var RV abcdefghilm 0 end
    then dotest-equal abcdefghilm "$RV"
    fi
}

function string-range-var-1.2 () {
    local RV
    if mbfl_string_range_var RV abcdefghilm 0
    then dotest-equal abcdefghilm "$RV"
    fi
}

function string-range-var-1.3 () {
    local RV
    if mbfl_string_range_var RV abcdefghilm 0 4
    then dotest-equal abcd "$RV"
    fi
}

function string-range-var-1.4 () {
    local RV
    if mbfl_string_range_var RV abcdefghilm 4 end
    then dotest-equal efghilm "$RV"
    fi
}

function string-range-var-1.5 () {
    local RV
    if mbfl_string_range_var RV abcdefghilm 0 END
    then dotest-equal abcdefghilm "$RV"
    fi
}


#### string inspection: string has prefix

function string-has-prefix-1.1 () {
    mbfl_string_has_prefix 'ciao'  'ciao mamma'
}
function string-has-prefix-2.1 () {
    ! mbfl_string_has_prefix 'hello' 'ciao mamma'
}


#### string inspection: string has suffix

function string-has-suffix-1.1 () {
    mbfl_string_has_suffix 'ciao mamma' 'mamma'
}
function string-has-suffix-2.1 () {
    ! mbfl_string_has_suffix 'ciao mamma' 'mom'
}


#### string inspection: string has prefix and suffix

function string-has-prefix-and-suffix-1.1 () {
    mbfl_string_has_prefix_and_suffix 'ciao' 'ciao mamma' 'mamma'
}
function string-has-prefix-and-suffix-1.2 () {
    mbfl_string_has_prefix_and_suffix 'ciao m' 'ciao mamma' 'o mamma'
}
function string-has-prefix-and-suffix-2.1 () {
    ! mbfl_string_has_suffix 'ciao' 'ciao mamma' 'mom'
}
function string-has-prefix-and-suffix-2.2 () {
    ! mbfl_string_has_suffix 'hello' 'ciao mamma' 'mma'
}


#### sptlitting a string into characters

function string-chars-1.1 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abcdefghilm
    mbfl_string_chars $string
    dotest-equal "${#string}" $SPLITCOUNT && \
	dotest-equal a "${SPLITFIELD[0]}" && \
	dotest-equal b "${SPLITFIELD[1]}" && \
	dotest-equal c "${SPLITFIELD[2]}" && \
	dotest-equal d "${SPLITFIELD[3]}" && \
	dotest-equal e "${SPLITFIELD[4]}" && \
	dotest-equal f "${SPLITFIELD[5]}" && \
	dotest-equal g "${SPLITFIELD[6]}" && \
	dotest-equal h "${SPLITFIELD[7]}" && \
	dotest-equal i "${SPLITFIELD[8]}" && \
	dotest-equal l "${SPLITFIELD[9]}"
}
function string-chars-1.2 {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string="abcde fghilm"
    mbfl_string_chars "${string}"
    dotest-equal "${#string}" $SPLITCOUNT && \
	dotest-equal a "${SPLITFIELD[0]}" && \
	dotest-equal b "${SPLITFIELD[1]}" && \
	dotest-equal c "${SPLITFIELD[2]}" && \
	dotest-equal d "${SPLITFIELD[3]}" && \
	dotest-equal e "${SPLITFIELD[4]}" && \
	dotest-equal " " "${SPLITFIELD[5]}" && \
	dotest-equal f "${SPLITFIELD[6]}" && \
	dotest-equal g "${SPLITFIELD[7]}" && \
	dotest-equal h "${SPLITFIELD[8]}" && \
	dotest-equal i "${SPLITFIELD[9]}" && \
	dotest-equal l "${SPLITFIELD[10]}"
}
function string-chars-1.3 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string="abcde\nfghilm"
    mbfl_string_chars "${string}"
    dotest-equal $((${#string} - 1)) $SPLITCOUNT && \
	dotest-equal a "${SPLITFIELD[0]}" && \
	dotest-equal b "${SPLITFIELD[1]}" && \
	dotest-equal c "${SPLITFIELD[2]}" && \
	dotest-equal d "${SPLITFIELD[3]}" && \
	dotest-equal e "${SPLITFIELD[4]}" && \
	dotest-equal "\n" "${SPLITFIELD[5]}" && \
	dotest-equal f "${SPLITFIELD[6]}" && \
	dotest-equal g "${SPLITFIELD[7]}" && \
	dotest-equal h "${SPLITFIELD[8]}" && \
	dotest-equal i "${SPLITFIELD[9]}" && \
	dotest-equal l "${SPLITFIELD[10]}"
}
function string-chars-1.4 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string="abcde\rfghilm"
    mbfl_string_chars "${string}"
    dotest-equal $((${#string} - 1)) $SPLITCOUNT && \
	dotest-equal a "${SPLITFIELD[0]}" && \
	dotest-equal b "${SPLITFIELD[1]}" && \
	dotest-equal c "${SPLITFIELD[2]}" && \
	dotest-equal d "${SPLITFIELD[3]}" && \
	dotest-equal e "${SPLITFIELD[4]}" && \
	dotest-equal "\r" "${SPLITFIELD[5]}" && \
	dotest-equal f "${SPLITFIELD[6]}" && \
	dotest-equal g "${SPLITFIELD[7]}" && \
	dotest-equal h "${SPLITFIELD[8]}" && \
	dotest-equal i "${SPLITFIELD[9]}" && \
	dotest-equal l "${SPLITFIELD[10]}" && \
	dotest-equal m "${SPLITFIELD[11]}"
}
function string-chars-1.5 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc\\
    mbfl_string_chars "$string"
    dotest-equal 4 $SPLITCOUNT && \
	dotest-equal a "${SPLITFIELD[0]}" && \
	dotest-equal b "${SPLITFIELD[1]}" && \
	dotest-equal c "${SPLITFIELD[2]}" && \
	dotest-equal $'\\' "${SPLITFIELD[3]}"
}
function string-chars-1.6 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc\def
    mbfl_string_chars "$string"
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal a "${SPLITFIELD[0]}" && \
	dotest-equal b "${SPLITFIELD[1]}" && \
	dotest-equal c "${SPLITFIELD[2]}" && \
	dotest-equal \d "${SPLITFIELD[3]}" && \
	dotest-equal e "${SPLITFIELD[4]}" && \
	dotest-equal f "${SPLITFIELD[5]}"
}


#### matching a substring

function string-equal-substring-1.1 () {
    ! mbfl_string_equal_substring abcdefghi 0 123
}
function string-equal-substring-1.2 () {
    mbfl_string_equal_substring abcdefghi 0 abc
}
function string-equal-substring-1.3 () {
    mbfl_string_equal_substring abcdefghi 2 cde
}
function string-equal-substring-1.4 () {
    ! mbfl_string_equal_substring abcdefghi 6 ghilm
}
function string-equal-substring-1.5 () {
    mbfl_string_equal_substring abcdefghi 6 ghi
}
function string-equal-substring-1.6 () {
    ! mbfl_string_equal_substring abcdefghi 4 123
}



function string-split-1.1 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc:def:ghi:lmn:opq:rs
    mbfl_string_split "$string" :
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}
function string-split-1.2 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc:::def:::ghi:::lmn:::opq:::rs
    mbfl_string_split "$string" :::
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}
function string-split-1.3 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc:def:ghi:lmn:opq:rs
    mbfl_string_split "$string" _
    dotest-equal 1 $SPLITCOUNT && dotest-equal $string "${SPLITFIELD[0]}"
}
function string-split-1.4 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=:abc:def
    mbfl_string_split "$string" :

    dotest-equal "" "${SPLITFIELD[0]}" && \
	dotest-equal abc "${SPLITFIELD[1]}" && \
	dotest-equal def "${SPLITFIELD[2]}" && \
	dotest-equal 3 $SPLITCOUNT
}
function string-split-1.5 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc::def:ghi
    mbfl_string_split "$string" :

    dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal ""  "${SPLITFIELD[1]}" && \
	dotest-equal def "${SPLITFIELD[2]}" && \
	dotest-equal ghi "${SPLITFIELD[3]}" && \
	dotest-equal 4 $SPLITCOUNT
}
function string-split-1.6 () {
    local SPLITFIELD SPLITCOUNT string
    declare -a SPLITFIELD

    string=abc::::def::ghi
    mbfl_string_split "$string" ::

    dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal ""  "${SPLITFIELD[1]}" && \
	dotest-equal def "${SPLITFIELD[2]}" && \
	dotest-equal ghi "${SPLITFIELD[3]}" && \
	dotest-equal 4 $SPLITCOUNT
}


#### splitting a string at blanks

function string-split-blanks-1.1 () {
    local -a SPLITFIELD
    local -i SPLITCOUNT
    local STRING

    # Single space.
    STRING='abc def ghi lmn opq rs'
    mbfl_string_split_blanks "$STRING"
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}

function string-split-blanks-1.2 () {
    local -a SPLITFIELD
    local -i SPLITCOUNT
    local STRING

    # Multiple spaces.
    STRING='abc   def   ghi   lmn   opq   rs'
    mbfl_string_split_blanks "$STRING"
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}

function string-split-blanks-1.3 () {
    local -a SPLITFIELD
    local -i SPLITCOUNT
    local STRING

    # Single tab.
    printf -v STRING 'abc\tdef\tghi\tlmn\topq\trs'
    mbfl_string_split_blanks "$STRING"
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}

function string-split-blanks-1.4 () {
    local -a SPLITFIELD
    local -i SPLITCOUNT
    local STRING

    # Multiple spaces.
    printf -v STRING 'abc\t\t\tdef\t\t\tghi\t\t\tlmn\t\t\topq\t\t\trs'
    mbfl_string_split_blanks "$STRING"
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}

function string-split-blanks-1.5 () {
    local -a SPLITFIELD
    local -i SPLITCOUNT
    local STRING

    # Some spaces, some tabs.
    printf -v STRING 'abc\t \tdef\t\t ghi \t\tlmn\t \topq\t\t   rs'
    mbfl_string_split_blanks "$STRING"
    dotest-equal 6 $SPLITCOUNT && \
	dotest-equal abc "${SPLITFIELD[0]}" && \
	dotest-equal def "${SPLITFIELD[1]}" && \
	dotest-equal ghi "${SPLITFIELD[2]}" && \
	dotest-equal lmn "${SPLITFIELD[3]}" && \
	dotest-equal opq "${SPLITFIELD[4]}" && \
	dotest-equal rs  "${SPLITFIELD[5]}"
}


#### character class predicates

function string-is-1.1 () { mbfl_string_is_alpha abcd; }
function string-is-1.2 () { ! mbfl_string_is_alpha 123 ; }
function string-is-1.3 () { ! mbfl_string_is_alpha ab12; }
function string-is-1.4 () { ! mbfl_string_is_alpha ''; }

function string-is-2.1 () { mbfl_string_is_digit 123; }
function string-is-2.2 () { ! mbfl_string_is_digit abcd; }
function string-is-2.3 () { ! mbfl_string_is_digit 12ab; }
function string-is-2.4 () { ! mbfl_string_is_digit ''; }

function string-is-3.1 () { mbfl_string_is_alnum abcd; }
function string-is-3.2 () { mbfl_string_is_alnum 123; }
function string-is-3.3 () { mbfl_string_is_alnum ab12; }
function string-is-3.4 () { ! mbfl_string_is_alnum ''; }

function string-is-4.1 () { mbfl_string_is_noblank abcd; }
function string-is-4.2 () { ! mbfl_string_is_noblank $'\n'; }
function string-is-4.3 () { ! mbfl_string_is_noblank $'\t'; }
function string-is-4.4 () { ! mbfl_string_is_noblank $'\r'; }
function string-is-4.5 () { ! mbfl_string_is_noblank " "; }
function string-is-4.6 () { ! mbfl_string_is_noblank $'ab\ncd'; }
function string-is-4.7 () { ! mbfl_string_is_noblank ''; }

function string-is-5.1 () { mbfl_string_is_name abcd; }
function string-is-5.2 () { mbfl_string_is_name ab_cd; }
function string-is-5.3 () { mbfl_string_is_name _abcd123; }
function string-is-5.4 () { ! mbfl_string_is_name 1abcd3 ; }
function string-is-5.5 () { ! mbfl_string_is_name "\n"; }
function string-is-5.6 () { ! mbfl_string_is_name ''; }

function string-is-6.1 () { mbfl_string_is_identifier abcd; }
function string-is-6.2 () { mbfl_string_is_identifier ab_cd; }
function string-is-6.3 () { mbfl_string_is_identifier _abcd123; }
function string-is-6.4 () { ! mbfl_string_is_identifier 1abcd3 ; }
function string-is-6.5 () { ! mbfl_string_is_identifier "\n"; }
function string-is-6.6 () { ! mbfl_string_is_identifier '-abcd123'; }
function string-is-6.7 () { mbfl_string_is_identifier a-b_c-d; }
function string-is-6.8 () { ! mbfl_string_is_identifier ''; }

function string-is-7.1 () { mbfl_string_is_username abcd; }
function string-is-7.2 () { mbfl_string_is_username ab_cd; }
function string-is-7.3 () { mbfl_string_is_username _abcd123; }
function string-is-7.4 () { mbfl_string_is_username 1abcd3 ; }
function string-is-7.5.1 () { ! mbfl_string_is_username $'\n'; }
function string-is-7.5.2 () { ! mbfl_string_is_username $'marco\n'; }
function string-is-7.6 () { mbfl_string_is_username '-abcd123'; }
function string-is-7.7 () { mbfl_string_is_username a-b_c-d; }
function string-is-7.8 () { ! mbfl_string_is_username ''; }
function string-is-7.9 () { mbfl_string_is_username marco.firefox; }
function string-is-7.10 () { mbfl_string_is_username 123; }
function string-is-7.11 () { mbfl_string_is_username +123; }
function string-is-7.12 () { ! mbfl_string_is_username +abc; }

function string-is-8.1 () { mbfl_string_is_extended_identifier abcd; }
function string-is-8.2 () { mbfl_string_is_extended_identifier ab_cd; }
function string-is-8.3 () { mbfl_string_is_extended_identifier _abcd123; }
function string-is-8.4 () { ! mbfl_string_is_extended_identifier 1abcd3 ; }
function string-is-8.5 () { ! mbfl_string_is_extended_identifier "\n"; }
function string-is-8.6 () { ! mbfl_string_is_extended_identifier '-abcd123'; }
function string-is-8.7 () { mbfl_string_is_extended_identifier a-b_c-d; }
function string-is-8.8 () { ! mbfl_string_is_extended_identifier ''; }
function string-is-8.9 () { ! mbfl_string_is_extended_identifier '-abc.d.1_23'; }

function string-is-9.1 () { mbfl_string_is_groupname abcd; }
function string-is-9.2 () { mbfl_string_is_groupname ab_cd; }
function string-is-9.3 () { mbfl_string_is_groupname _abcd123; }
function string-is-9.4 () { mbfl_string_is_groupname 1abcd3 ; }
function string-is-9.5.1 () { ! mbfl_string_is_groupname $'\n'; }
function string-is-9.5.2 () { ! mbfl_string_is_groupname $'marco\n'; }
function string-is-9.6 () { mbfl_string_is_groupname '-abcd123'; }
function string-is-9.7 () { mbfl_string_is_groupname a-b_c-d; }
function string-is-9.8 () { ! mbfl_string_is_groupname ''; }
function string-is-9.9 () { mbfl_string_is_groupname marco.firefox; }
function string-is-9.10 () { mbfl_string_is_groupname 123; }
function string-is-9.11 () { mbfl_string_is_groupname +123; }
function string-is-9.12 () { ! mbfl_string_is_groupname +abc; }

function string-is-10.1 () { mbfl_string_is_ascii_symbol_char '('; }
function string-is-10.2 () { ! mbfl_string_is_ascii_symbol_char 'a'; }

function string-is-11.1 () { mbfl_string_is_lower_case_vowel_char 'a'; }
function string-is-11.2 () { ! mbfl_string_is_lower_case_vowel_char 'A'; }

function string-is-12.1 () { mbfl_string_is_lower_case_consonant_char 'c'; }
function string-is-12.2 () { ! mbfl_string_is_lower_case_consonant_char 'C'; }

function string-is-13.1 () { mbfl_string_is_lower_case_base16 'd'; }
function string-is-13.2 () { ! mbfl_string_is_lower_case_base16 'D'; }

function string-is-14.1 () { mbfl_string_is_upper_case_vowel_char 'A'; }
function string-is-14.2 () { ! mbfl_string_is_upper_case_vowel_char 'a'; }

function string-is-15.1 () { mbfl_string_is_upper_case_consonant_char 'B'; }
function string-is-15.2 () { ! mbfl_string_is_upper_case_consonant_char 'b'; }

function string-is-16.1 () { mbfl_string_is_upper_case_base16 'D'; }
function string-is-16.2 () { ! mbfl_string_is_upper_case_base16 'd'; }

function string-is-17.1 () { mbfl_string_is_mixed_case_vowel_char 'a'; }
function string-is-17.2 () { mbfl_string_is_mixed_case_vowel_char 'A'; }
function string-is-17.3 () { ! mbfl_string_is_mixed_case_vowel_char 'x'; }

function string-is-18.1 () { mbfl_string_is_mixed_case_consonant_char 'x'; }
function string-is-18.2 () { mbfl_string_is_mixed_case_consonant_char 'x'; }
function string-is-18.3 () { ! mbfl_string_is_mixed_case_consonant_char '2'; }

function string-is-19.1 () { mbfl_string_is_mixed_case_base16 'D'; }
function string-is-19.2 () { mbfl_string_is_mixed_case_base16 'd'; }
function string-is-19.3 () { ! mbfl_string_is_mixed_case_base16 'x'; }

function string-is-20.1 () { mbfl_string_is_base32_char '4'; }
function string-is-20.2 () { mbfl_string_is_base32_char 'A'; }
function string-is-20.3 () { ! mbfl_string_is_base32_char ','; }

function string-is-21.1 () { mbfl_string_is_base64_char 'd'; }
function string-is-21.2 () { mbfl_string_is_base64_char '3'; }
function string-is-21.3 () { ! mbfl_string_is_base64_char '('; }

function string-is-22.1 () { mbfl_string_is_printable_ascii_noblank_char 'd'; }
function string-is-22.2 () { mbfl_string_is_printable_ascii_noblank_char '3'; }
function string-is-22.3 () { ! mbfl_string_is_printable_ascii_noblank_char ' '; }

function string-is-23.1 () {   mbfl_string_is_lower_case_alphabet_char 'c'; }
function string-is-23.2 () { ! mbfl_string_is_lower_case_alphabet_char 'C'; }

function string-is-24.1 () {   mbfl_string_is_lower_case_alnum_char 'c'; }
function string-is-24.2 () { ! mbfl_string_is_lower_case_alnum_char 'C'; }

function string-is-25.1 () {   mbfl_string_is_upper_case_alphabet_char 'C'; }
function string-is-25.2 () { ! mbfl_string_is_upper_case_alphabet_char 'c'; }

function string-is-26.1 () {   mbfl_string_is_upper_case_alnum_char 'C'; }
function string-is-26.2 () {   mbfl_string_is_upper_case_alnum_char '2'; }
function string-is-26.3 () { ! mbfl_string_is_upper_case_alnum_char 'd'; }

function string-is-27.1 () {   mbfl_string_is_mixed_case_alphabet_char 'c'; }
function string-is-27.2 () {   mbfl_string_is_mixed_case_alphabet_char 'C'; }
function string-is-27.3 () { ! mbfl_string_is_mixed_case_alphabet_char '2'; }

function string-is-28.1 () {   mbfl_string_is_mixed_case_alnum_char 'c'; }
function string-is-28.2 () {   mbfl_string_is_mixed_case_alnum_char 'C'; }
function string-is-28.3 () {   mbfl_string_is_mixed_case_alnum_char '3'; }
function string-is-28.3 () { ! mbfl_string_is_mixed_case_alnum_char '('; }


#### validating email addresses

function string-is-email-address-1.1 () {
    mbfl_string_is_email_address 'marco'
}

function string-is-email-address-1.2 () {
    mbfl_string_is_email_address 'marco@localhost'
}

function string-is-email-address-1.3 () {
    mbfl_string_is_email_address 'marco.maggi@localhost.luna'
}

function string-is-email-address-1.4 () {
    mbfl_string_is_email_address 'maRCo.maggi-123@locALhost-123.luna'
}

function string-is-email-address-1.5 () {
    mbfl_string_is_email_address 'marco_maggi@localhost_luna'
}

### --------------------------------------------------------------------

function string-is-email-address-2.1 () {
    ! mbfl_string_is_email_address ''
}

function string-is-email-address-2.2 () {
    ! mbfl_string_is_email_address 'marco@'
}

function string-is-email-address-2.3 () {
    ! mbfl_string_is_email_address '@localhost'
}

function string-is-email-address-2.4 () {
    ! mbfl_string_is_email_address '@'
}

function string-is-email-address-2.5 () {
    ! mbfl_string_is_email_address 'marco@@localhost'
}

function string-is-email-address-2.6 () {
    ! mbfl_string_is_email_address 'marco@localhost@there'
}


#### validating network port numbers

function string-is-network-port-1.1 () {
    mbfl_string_is_network_port 25
}
function string-is-network-port-2.1 () {
    ! mbfl_string_is_network_port ciao
}


#### validating network hostnames

function string-is-network-hostname-1.1 () {
    mbfl_string_is_network_hostname localhost
}
function string-is-network-hostname-1.2 () {
    mbfl_string_is_network_hostname www.ciao.it
}
function string-is-network-hostname-2.1 () {
    ! mbfl_string_is_network_hostname 'ciao mamma'
}


#### validating network IP address

function string-is-network-ip-address-1.1 () {
    mbfl_string_is_network_ip_address 127.0.0.1
}
function string-is-network-ip-address-1.2 () {
    mbfl_string_is_network_ip_address 123.222.111.0
}

function string-is-network-ip-address-2.1 () {
    ! mbfl_string_is_network_ip_address 'ciao mamma'
}
function string-is-network-ip-address-2.2 () {
    ! mbfl_string_is_network_ip_address 1.2.3.4.5
}
function string-is-network-ip-address-2.3 () {
    ! mbfl_string_is_network_ip_address 500.0.0.0
}


#### uppercase and lowercase conversion

function string-toupper-1.1 () {
    mbfl_string_toupper abcdefghilm | dotest-output ABCDEFGHILM
}
function string-toupper-1.2 () {
    mbfl_string_toupper ABCDEFGHILM | dotest-output ABCDEFGHILM
}
function string-toupper-1.3 () {
    mbfl_string_toupper "" | dotest-output ""
}

### --------------------------------------------------------------------

function string-tolower-1.1 () {
    mbfl_string_tolower ABCDEFGHILM | dotest-output abcdefghilm
}
function string-tolower-1.2 () {
    mbfl_string_tolower abcdefghilm | dotest-output abcdefghilm
}
function string-tolower-1.3 () {
    mbfl_string_tolower "" | dotest-output ""
}

### --------------------------------------------------------------------

function string-toupper-var-1.1 () {
    local RV
    mbfl_string_toupper_var RV abcdefghilm
    dotest-equal ABCDEFGHILM "$RV"
}
function string-toupper-var-1.2 () {
    local RV
    mbfl_string_toupper_var RV ABCDEFGHILM
    dotest-equal ABCDEFGHILM "$RV"
}
function string-toupper-var-1.3 () {
    local RV
    mbfl_string_toupper_var RV ""
    dotest-equal "" "$RV"
}

### --------------------------------------------------------------------

function string-tolower-var-1.1 () {
    local RV
    mbfl_string_tolower_var RV ABCDEFGHILM
    dotest-equal abcdefghilm "$RV"
}
function string-tolower-var-1.2 () {
    local RV
    mbfl_string_tolower_var RV abcdefghilm
    dotest-equal abcdefghilm "$RV"
}
function string-tolower-var-1.3 () {
    local RV
    mbfl_string_tolower_var RV ""
    dotest-equal "" "$RV"
}



function string-sprintf-1.1 () {
    local var=1

    mbfl_sprintf var "pre-%s-post" woah
    test "$var" = "pre-woah-post"
}


#### replacing

function string-replace-1.1 () {
    mbfl_string_replace 'abcdefg' 'cde' '123' | dotest-output 'ab123fg'
}

function string-replace-1.2 () {
    mbfl_string_replace 'abcdefg' 'cde' '' | dotest-output 'abfg'
}

### ------------------------------------------------------------------------

function string-replace-var-1.1 () {
    local RV
    mbfl_string_replace_var RV 'abcdefg' 'cde' '123'
    dotest-equal 'ab123fg' "$RV"
}

function string-replace-var-1.2 () {
    local RV
    mbfl_string_replace_var RV 'abcdefg' 'cde' ''
    dotest-equal 'abfg' "$RV"
}


#### skipping

function string-skip-1.1 () {
    local i=3
    local string=abcdefg

    # The char "z" is not present in the string: leave "i" untouched.
    mbfl_string_skip $string i z
    dotest-equal 3 $i
}
function string-skip-1.2 () {
    local i=3
    local string=aaaaaaa

    # The whole string  is filled with "a": increment "i"  to the length
    # of the string itself.
    mbfl_string_skip $string i a
    dotest-equal ${#string} $i
}
function string-skip-1.3 () {
    local i=3
    local string=abcccccdefg

    # Skip until the index of the "d" character.
    mbfl_string_skip $string i c
    dotest-equal 7 $i
}


#### comparison

function string-equal-1.1 () {
    mbfl_string_equal '' ''
}

function string-equal-1.2 () {
    ! mbfl_string_equal 'a' ''
}

function string-equal-1.3 () {
    ! mbfl_string_equal '' 'a'
}

function string-equal-1.3 () {
    mbfl_string_equal 'ciao' 'ciao'
}

function string-equal-1.4 () {
    ! mbfl_string_equal 'ciao' 'hello'
}

### --------------------------------------------------------------------

function string-not-equal-1.1 () {
    ! mbfl_string_not_equal '' ''
}

function string-not-equal-1.2 () {
    mbfl_string_not_equal 'a' ''
}

function string-not-equal-1.3 () {
    mbfl_string_not_equal '' 'a'
}

function string-not-equal-1.3 () {
    ! mbfl_string_not_equal 'ciao' 'ciao'
}

function string-not-equal-1.4 () {
    mbfl_string_not_equal 'ciao' 'hello'
}

### --------------------------------------------------------------------

function string-less-1.1 () {
    ! mbfl_string_less '' ''
}

function string-less-1.2 () {
    ! mbfl_string_less 'a' ''
}

function string-less-1.3 () {
    mbfl_string_less '' 'a'
}

function string-less-1.3 () {
    ! mbfl_string_less 'ciao' 'ciao'
}

function string-less-1.4 () {
    mbfl_string_less 'ciao' 'hello'
}

function string-less-1.4 () {
    ! mbfl_string_less 'hello' 'ciao'
}

### --------------------------------------------------------------------

function string-greater-1.1 () {
    ! mbfl_string_greater '' ''
}

function string-greater-1.2 () {
    mbfl_string_greater 'a' ''
}

function string-greater-1.3 () {
    ! mbfl_string_greater '' 'a'
}

function string-greater-1.3 () {
    ! mbfl_string_greater 'ciao' 'ciao'
}

function string-greater-1.4 () {
    ! mbfl_string_greater 'ciao' 'hello'
}

function string-greater-1.4 () {
    mbfl_string_greater 'hello' 'ciao'
}

### --------------------------------------------------------------------

function string-less-or-equal-1.1 () {
    mbfl_string_less_or_equal '' ''
}

function string-less-or-equal-1.2 () {
    ! mbfl_string_less_or_equal 'a' ''
}

function string-less-or-equal-1.3 () {
    mbfl_string_less_or_equal '' 'a'
}

function string-less-or-equal-1.3 () {
    mbfl_string_less_or_equal 'ciao' 'ciao'
}

function string-less-or-equal-1.4 () {
    mbfl_string_less_or_equal 'ciao' 'hello'
}

function string-less-or-equal-1.4 () {
    ! mbfl_string_less_or_equal 'hello' 'ciao'
}

### --------------------------------------------------------------------

function string-greater-or-equal-1.1 () {
    mbfl_string_greater_or_equal '' ''
}

function string-greater-or-equal-1.2 () {
    mbfl_string_greater_or_equal 'a' ''
}

function string-greater-or-equal-1.3 () {
    ! mbfl_string_greater_or_equal '' 'a'
}

function string-greater-or-equal-1.3 () {
    mbfl_string_greater_or_equal 'ciao' 'ciao'
}

function string-greater-or-equal-1.4 () {
    ! mbfl_string_greater_or_equal 'ciao' 'hello'
}

function string-greater-or-equal-1.4 () {
    mbfl_string_greater_or_equal 'hello' 'ciao'
}

### ------------------------------------------------------------------------

function string-is-yes-1.1 () {
    mbfl_string_is_yes 'yes'
}

function string-is-yes-1.2 () {
    ! mbfl_string_is_yes 'no'
}

function string-is-no-1.1 () {
    mbfl_string_is_no 'no'
}

function string-is-no-1.2 () {
    ! mbfl_string_is_no 'yes'
}


#### comparison using macros

function string-macro-equal-1.1 () {
    mbfl_string_eq('', '')
}

function string-macro-equal-1.2 () {
    ! mbfl_string_eq('a', '')
}

function string-macro-equal-1.3 () {
    ! mbfl_string_eq('', 'a')
}

function string-macro-equal-1.3 () {
    mbfl_string_eq('ciao', 'ciao')
}

function string-macro-equal-1.4 () {
    ! mbfl_string_eq('ciao', 'hello')
}

### --------------------------------------------------------------------

function string-macro-not-equal-1.1 () {
    ! mbfl_string_neq('', '')
}

function string-macro-not-equal-1.2 () {
    mbfl_string_neq('a', '')
}

function string-macro-not-equal-1.3 () {
    mbfl_string_neq('', 'a')
}

function string-macro-not-equal-1.3 () {
    ! mbfl_string_neq('ciao', 'ciao')
}

function string-macro-not-equal-1.4 () {
    mbfl_string_neq('ciao', 'hello')
}

### --------------------------------------------------------------------

function string-macro-less-1.1 () {
    ! mbfl_string_lt('', '')
}

function string-macro-less-1.2 () {
    ! mbfl_string_lt('a', '')
}

function string-macro-less-1.3 () {
    mbfl_string_lt('', 'a')
}

function string-macro-less-1.3 () {
    ! mbfl_string_lt('ciao', 'ciao')
}

function string-macro-less-1.4 () {
    mbfl_string_lt('ciao', 'hello')
}

function string-macro-less-1.4 () {
    ! mbfl_string_lt('hello', 'ciao')
}

### --------------------------------------------------------------------

function string-macro-greater-1.1 () {
    ! mbfl_string_gt('', '')
}

function string-macro-greater-1.2 () {
    mbfl_string_gt('a', '')
}

function string-macro-greater-1.3 () {
    ! mbfl_string_gt('', 'a')
}

function string-macro-greater-1.3 () {
    ! mbfl_string_gt('ciao', 'ciao')
}

function string-macro-greater-1.4 () {
    ! mbfl_string_gt('ciao', 'hello')
}

function string-macro-greater-1.4 () {
    mbfl_string_gt('hello', 'ciao')
}

### --------------------------------------------------------------------

function string-macro-less-or-equal-1.1 () {
    mbfl_string_le('', '')
}

function string-macro-less-or-equal-1.2 () {
    ! mbfl_string_le('a', '')
}

function string-macro-less-or-equal-1.3 () {
    mbfl_string_le('', 'a')
}

function string-macro-less-or-equal-1.3 () {
    mbfl_string_le('ciao', 'ciao')
}

function string-macro-less-or-equal-1.4 () {
    mbfl_string_le('ciao', 'hello')
}

function string-macro-less-or-equal-1.4 () {
    ! mbfl_string_le('hello', 'ciao')
}

### --------------------------------------------------------------------

function string-macro-greater-or-equal-1.1 () {
    mbfl_string_ge('', '')
}

function string-macro-greater-or-equal-1.2 () {
    mbfl_string_ge('a', '')
}

function string-macro-greater-or-equal-1.3 () {
    ! mbfl_string_ge('', 'a')
}

function string-macro-greater-or-equal-1.3 () {
    mbfl_string_ge('ciao', 'ciao')
}

function string-macro-greater-or-equal-1.4 () {
    ! mbfl_string_ge('ciao', 'hello')
}

function string-macro-greater-or-equal-1.4 () {
    mbfl_string_ge('hello', 'ciao')
}

### ------------------------------------------------------------------------

function string-macro-equal-fixed-1.1 () {
    mbfl_string_eq_yes('yes')
}
function string-macro-equal-fixed-1.2 () {
    ! mbfl_string_eq_yes('ciao')
}

function string-macro-equal-fixed-2.1 () {
    mbfl_string_eq_no('no')
}
function string-macro-equal-fixed-2.2 () {
    ! mbfl_string_eq_no('ciao')
}

function string-macro-equal-fixed-1.1 () {
    mbfl_string_eq_true('true')
}
function string-macro-equal-fixed-1.2 () {
    ! mbfl_string_eq_true('ciao')
}

function string-macro-equal-fixed-2.1 () {
    mbfl_string_eq_false('false')
}
function string-macro-equal-fixed-2.2 () {
    ! mbfl_string_eq_false('ciao')
}

### ------------------------------------------------------------------------

function string-macro-not-equal-fixed-1.1 () {
    ! mbfl_string_neq_yes('yes')
}
function string-macro-not-equal-fixed-1.2 () {
    mbfl_string_neq_yes('ciao')
}

function string-macro-not-equal-fixed-2.1 () {
    ! mbfl_string_neq_no('no')
}
function string-macro-not-equal-fixed-2.2 () {
    mbfl_string_neq_no('ciao')
}

function string-macro-not-equal-fixed-1.1 () {
    ! mbfl_string_neq_true('true')
}
function string-macro-not-equal-fixed-1.2 () {
    mbfl_string_neq_true('ciao')
}

function string-macro-not-equal-fixed-2.1 () {
    ! mbfl_string_neq_false('false')
}
function string-macro-not-equal-fixed-2.2 () {
    mbfl_string_neq_false('ciao')
}


#### inspection using macros

function string-macro-empty-1.1 () {
    local -r STR
    mbfl_string_empty(STR)
}
function string-macro-empty-1.2 () {
    local -r STR='ciao'
    ! mbfl_string_empty(STR)
}

function string-macro-empty-2.1 () {
    local -r STR=
    mbfl_string_not_empty(STR)
    dotest-equal 1 $? 'empty string is empty'
}
function string-macro-empty-2.2 () {
    local -r STR='ciao'
    mbfl_string_not_empty(STR)
    dotest-equal 0 $? 'non-empty string is not empty'
}

### ------------------------------------------------------------------------

function string-macro-last-char-1.1 () {
    local -r STR='ciao'
    dotest-equal 'o' mbfl_string_last_char(STR)
}
function string-macro-last-char-1.2 () {
    local -r STR=$'ciao\n'
    dotest-equal $'\n' "mbfl_string_last_char(STR)"
}
function string-macro-last-char-1.3 () {
    local -r STR=
    dotest-equal '' "mbfl_string_last_char(STR)"
}


#### miscellaneous

function string-strip-carriage-return-var-1.1 () {
    local RV LINE=$'ciao mamma\r'

    mbfl_string_strip_carriage_return_var RV "$LINE"
    dotest-equal 'ciao mamma' "$RV"
}

function string-strip-carriage-return-var-1.2 () {
    local RV LINE=$'ciao mamma\n'

    mbfl_string_strip_carriage_return_var RV "$LINE"
    dotest-equal $'ciao mamma\n' "$RV"
}

function string-strip-carriage-return-var-1.3 () {
    local RV LINE=

    mbfl_string_strip_carriage_return_var RV "$LINE"
    dotest-equal '' "$RV"
}


#### specific strings

function string-bool-1.1 () {
    mbfl_string_is_true 'true'
}
function string-bool-1.2 () {
    ! mbfl_string_is_true 'false'
}
function string-bool-2.1 () {
    ! mbfl_string_is_false 'true'
}
function string-bool-2.2 () {
    mbfl_string_is_false 'false'
}


#### let's go

dotest string-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
