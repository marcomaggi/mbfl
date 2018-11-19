# encode.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: encode/decode strings
# Date: Wed Apr 23, 2003
#
# Abstract
#
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

function mbfl_decode_hex () {
    mbfl_mandatory_parameter(INPUT, 1, input string)
    local -i i

    for ((i=0; i < ${#INPUT}; i=$((i + 2))))
    do echo -en "\\x${INPUT:$i:2}"
    done
    echo;# to end the line and let "read" acquire the stuff from a pipeline
}

function mbfl_decode_oct () {
    mbfl_mandatory_parameter(INPUT, 1, input string)
    local -i i

    for ((i=0; i < ${#INPUT}; i=$((i + 3))))
    do echo -en "\\0${INPUT:$i:3}"
    done
    echo;# to end the line and let "read" acquire the stuff from a pipeline
}


### end of file
# Local Variables:
# mode: sh
# End:
