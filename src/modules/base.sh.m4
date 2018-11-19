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
# Copyright (c) 2004-2005, 2009, 2013, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
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

declare mbfl_LOADED='yes'

: ${script_PROGNAME:='<unknown>'}
: ${script_VERSION:='<unknown>'}
: ${script_COPYRIGHT_YEARS:='<unknown>'}
: ${script_AUTHOR:='<unknown>'}
: ${script_LICENSE:='<unknown>'}
: ${script_USAGE:='<unknown>'}
: ${script_DESCRIPTION:='<unknown>'}
: ${script_EXAMPLES:=}

#page
#### miscellaneous functions

function mbfl_set_maybe () {
    if mbfl_string_is_not_empty "$1"
    then eval $1=\'"$2"\'
    fi
}
function mbfl_read_maybe_null () {
    mbfl_mandatory_parameter(VARNAME, 1, variable name)

    if mbfl_option_null
    then IFS= read -rs -d $'\x00' $VARNAME
    else IFS= read -rs $VARNAME
    fi
}

#page
#### global option creation functions

m4_define([[[mbfl_create_option_procedure]]],[[[
    function mbfl_set_option_$1 ()   { function mbfl_option_$1 () { true;  }; }
    function mbfl_unset_option_$1 () { function mbfl_option_$1 () { false; }; }
    mbfl_unset_option_$1
]]])

mbfl_create_option_procedure([[[test]]])
mbfl_create_option_procedure([[[verbose_program]]])
mbfl_create_option_procedure([[[show_program]]])
mbfl_create_option_procedure([[[verbose]]])
mbfl_create_option_procedure([[[debug]]])
mbfl_create_option_procedure([[[null]]])
mbfl_create_option_procedure([[[interactive]]])
mbfl_create_option_procedure([[[encoded_args]]])

function mbfl_option_test_save () {
    if mbfl_option_test
    then mbfl_save_option_TEST=yes
    fi
    mbfl_unset_option_test
}
function mbfl_option_test_restore () {
    if mbfl_string_equal "$mbfl_save_option_TEST" 'yes'
    then mbfl_set_option_test
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
