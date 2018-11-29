# dialog.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: dialog functions
# Date: Sun Dec 21, 2003
#
# Abstract
#
#       This file is a collection of functions used to interact to the
#       user at the console.
#
# Copyright   (c)    2003-2005,   2009,    2013,   2018    Marco   Maggi
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
function mbfl_dialog_enable_programs () {
    mbfl_declare_program stty
}
function mbfl_dialog_yes_or_no () {
    mbfl_mandatory_parameter(STRING, 1, prompt string)
    mbfl_optional_parameter(PROGNAME, 2, ${script_PROGNAME})
    local PROMPT ANS
    printf -v PROMPT '%s: %s? (yes/no) ' "$PROGNAME" "$STRING"

    while { IFS= read -r -e -p "$PROMPT" ANS && \
		mbfl_string_not_equal "$ANS" 'yes' && \
		mbfl_string_not_equal "$ANS" 'no'; }
    do printf '%s: please answer yes or no.\n' "$PROGNAME"
    done
    mbfl_string_equal "$ANS" 'yes'
}

function mbfl_dialog_ask_password_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PROMPT, 2, prompt)
    local mbfl_PASSWORD mbfl_STTY

    mbfl_program_found_var mbfl_STTY stty || exit $?
    printf '%s: ' "mbfl_PROMPT" >&2
    "$mbfl_STTY" cbreak -echo </dev/tty >/dev/tty 2>&1
    IFS= read -rs mbfl_PASSWORD
    "$mbfl_STTY" -cbreak echo </dev/tty >/dev/tty 2>&1
    echo >&2
    mbfl_RESULT_VARREF=$mbfl_PASSWORD
}
function mbfl_dialog_ask_password () {
    mbfl_mandatory_parameter(PROMPT, 1, prompt)
    local RESULT_VARNAME
    if mbfl_dialog_ask_password_var RESULT_VARNAME "$PROMPT"
    then echo "$RV"
    else return $?
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
