# base.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: base functions
# Date: Wed Oct  6, 2004
# 
# Abstract
# 
# 
# 
# Copyright (c) 2004 Marco Maggi
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
# USA.
# 
#

function mbfl_set_maybe () {
    test -n "${1}" && eval ${1}=\'"${2}"\'
}
function mbfl_read_maybe_null () {
    mandatory_parameter(VARNAME, 1, variable name)

    if mbfl_option_null ; then
	read -d $'\x00' $VARNAME
    else
	read $VARNAME
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
