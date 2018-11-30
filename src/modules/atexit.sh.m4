#
# Part of: Marco's Bash Functions Library
# Contents: atexit module
# Date: Sun Nov 25, 2018
#
# Abstract
#
#
#
# Copyright (C) 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
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
#### global variables

declare -a mbfl_atexit_HANDLERS
declare -i mbfl_atexit_NEXT=0

function mbfl_atexit_enable () {
    trap mbfl_atexit_run EXIT
}

function mbfl_atexit_disable () {
    trap '' EXIT
}

function mbfl_atexit_register () {
    mbfl_mandatory_parameter(mbfl_HANDLER, 1, handler script)
    mbfl_optional_parameter(mbfl_IDVAR, 2)

    if mbfl_string_is_not_empty "$mbfl_IDVAR"
    then local -n mbfl_ID_VARREF=$mbfl_IDVAR
    else local mbfl_ID_VARREF
    fi

    mbfl_atexit_HANDLERS[$mbfl_atexit_NEXT]=$mbfl_HANDLER
    mbfl_ID_VARREF=$mbfl_atexit_NEXT
    let ++mbfl_atexit_NEXT
}

function mbfl_atexit_forget () {
    mbfl_mandatory_integer_parameter(ID, 1, handler id)

    mbfl_atexit_HANDLERS[$ID]=
}

function mbfl_atexit_run () {
    local HANDLER
    local -i i

    for ((i=${#mbfl_atexit_HANDLERS[@]}-1; i >= 0; --i))
    do
	HANDLER=${mbfl_atexit_HANDLERS[$i]}
	if mbfl_string_is_not_empty "$HANDLER"
	then
	    # Remove the handler.
	    mbfl_atexit_HANDLERS[$i]=
	    # Run it.
	    "$HANDLER"
	fi
    done
}

function mbfl_atexit_clear () {
    mbfl_atexit_HANDLERS=()
    mbfl_atexit_NEXT=0
}

### end of file
# Local Variables:
# mode: sh
# End:
