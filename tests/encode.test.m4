# encode.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the encode.sh functions
# Date: Wed Apr 23, 2003
#
# Abstract
#
#	To select the tests in this file:
#
#		$ TESTMATCH=encode- make all tests
#
# Copyright (c) 2003, 2004, 2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
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

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)


#### encoding/decoding hex

function encode-hex-var-1.1 () {
    # No null bytes!!!
    local PLAIN='\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F' ENCODED
    local EXPECTED='0102030405060708090A0B0C0D0E0F'

    PLAIN=$(echo -e "$PLAIN")

    mbfl_encode_hex_var ENCODED "$PLAIN"
    dotest-equal "$EXPECTED" "$ENCODED"
}

### ------------------------------------------------------------------------

function decode-hex-2.1 () {
    mbfl_decode_hex 414243 | dotest-output ABC
}

### ------------------------------------------------------------------------

function filter-hex-var-1.1 () {
    local PLAIN=ABCDE ENCODED DECODED

    mbfl_encode_hex_var ENCODED "$PLAIN"
    mbfl_decode_hex_var DECODED "$ENCODED"
    dotest-equal "$PLAIN" "$DECODED"
}

function filter-hex-var-1.2 () {
    local PLAIN='\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F' ENCODED DECODED
    printf -v PLAIN "$PLAIN"

    mbfl_encode_hex_var ENCODED "$PLAIN"
    mbfl_decode_hex_var DECODED "$ENCODED"
    dotest-equal "$PLAIN" "$DECODED"
}

### ------------------------------------------------------------------------

function filter-hex-1.1 () {
    local PLAIN=ABCDE ENCODED DECODED

    ENCODED=$(mbfl_encode_hex "$PLAIN")
    DECODED=$(mbfl_decode_hex "$ENCODED")
    dotest-equal "$PLAIN" "$DECODED"
}

function filter-hex-1.2 () {
    local PLAIN='\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F' ENCODED DECODED
    printf -v PLAIN "$PLAIN"

    ENCODED=$(mbfl_encode_hex "$PLAIN")
    DECODED=$(mbfl_decode_hex "$ENCODED")
    dotest-equal "$PLAIN" "$DECODED"
}


#### encoding/decoding octal

function encode-oct-var-1.1 () {
    # No null bytes!!!
    local PLAIN='ABCDEFG' ENCODED
    local EXPECTED='101102103104105106107'

    mbfl_encode_oct_var ENCODED "$PLAIN"
    dotest-equal "$EXPECTED" "$ENCODED"
}

### ------------------------------------------------------------------------

function decode-oct-var-1.1 () {
    # No null bytes!!!
    local INPUT='101102103104105106107'
    local DECODED
    local EXPECTED=$'\101\102\103\104\105\106\107'

    mbfl_decode_oct_var DECODED "$INPUT"
    dotest-equal "$EXPECTED" "$DECODED"
}

### ------------------------------------------------------------------------

function decode-oct-1.1 () {
    mbfl_decode_oct 101102103 | dotest-output ABC
}

### ------------------------------------------------------------------------

function filter-oct-var-1.1 () {
    local PLAIN='\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F' ENCODED DECODED
    printf -v PLAIN "$PLAIN"

    mbfl_encode_oct_var ENCODED "$PLAIN"
    mbfl_decode_oct_var DECODED "$ENCODED"
    dotest-equal "$PLAIN" "$DECODED"
}


#### let's go

dotest encode-
dotest decode-
dotest filter-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
