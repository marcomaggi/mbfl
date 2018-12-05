# encode.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: encode/decode strings
# Date: Wed Apr 23, 2003
#
# Abstract
#
#	This module defines some simple encoding/deconding functions for
#	strings.  Notice that, internally,  Bash represents strings as C
#	language style ASCIIZ  arrays, so it is  impossible to correctly
#	handle  null bytes  in  a  Bash variable:  the  string will  get
#	truncated at the null byte.
#
# Copyright (c) 2003-2005, 2009, 2013, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
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
# USA.
#

#page
#### encoding hexadecimal

function mbfl_encode_hex_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable reference)
    mbfl_mandatory_parameter(mbfl_INPUT, 2, input string)
    local -i mbfl_I
    local mbfl_OCTET mbfl_ENCODED_OCTET

    for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; ++mbfl_I))
    do
	printf -v mbfl_OCTET         '%d' "'${mbfl_INPUT:${mbfl_I}:1}"
	printf -v mbfl_ENCODED_OCTET '%02X' "$mbfl_OCTET"
	mbfl_RESULT_VARREF+=$mbfl_ENCODED_OCTET
    done
    return 0
}

function mbfl_encode_hex () {
    mbfl_mandatory_parameter(INPUT, 1, input string)
    local RESULT_VARNAME
    mbfl_encode_hex_var RESULT_VARNAME "$INPUT"
    echo "$RESULT_VARNAME"
}

#page
#### encoding octal

function mbfl_encode_oct_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable reference)
    mbfl_mandatory_parameter(mbfl_INPUT, 2, input string)
    local -i mbfl_I
    local mbfl_OCTET mbfl_ENCODED_OCTET

    for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; ++mbfl_I))
    do
	printf -v mbfl_OCTET         '%d' "'${mbfl_INPUT:${mbfl_I}:1}"
	printf -v mbfl_ENCODED_OCTET '%03o' "$mbfl_OCTET"
	mbfl_RESULT_VARREF+=$mbfl_ENCODED_OCTET
    done
    return 0
}

function mbfl_encode_oct () {
    mbfl_mandatory_parameter(INPUT, 1, input string)
    local RESULT_VARNAME
    mbfl_encode_oct_var RESULT_VARNAME "$INPUT"
    echo "$RESULT_VARNAME"
}

#page
#### decoding hexadecimal

function mbfl_decode_hex_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable reference)
    mbfl_mandatory_parameter(mbfl_INPUT, 2, input string)
    local -i mbfl_I
    local mbfl_DECODED_OCTET

    for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; mbfl_I+=2))
    do
	printf -v mbfl_DECODED_OCTET "\\x${mbfl_INPUT:${mbfl_I}:2}"
	mbfl_RESULT_VARREF+=$mbfl_DECODED_OCTET
    done
    return 0
}

function mbfl_decode_hex () {
    mbfl_mandatory_parameter(INPUT, 1, input string)
    local RESULT_VARNAME
    mbfl_decode_hex_var RESULT_VARNAME "$INPUT"
    echo "$RESULT_VARNAME"
}

#page
#### decoding octal

function mbfl_decode_oct_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable reference)
    mbfl_mandatory_parameter(mbfl_INPUT, 2, input string)
    local -i mbfl_I
    local mbfl_DECODED_OCTET

    for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; mbfl_I+=3))
    do
	printf -v mbfl_DECODED_OCTET "\\${mbfl_INPUT:${mbfl_I}:3}"
	mbfl_RESULT_VARREF+=$mbfl_DECODED_OCTET
    done
    return 0
}

function mbfl_decode_oct () {
    mbfl_mandatory_parameter(INPUT, 1, input string)
    local RESULT_VARNAME
    mbfl_decode_oct_var RESULT_VARNAME "$INPUT"
    echo "$RESULT_VARNAME"
}

### end of file
# Local Variables:
# mode: sh
# End:
