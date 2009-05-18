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
# Copyright (c) 2003-2005, 2009 Marco Maggi <marcomaggi@gna.org>
#
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
    mandatory_parameter(STRING, 1, prompt string)
    optional_parameter(PROGNAME, 2, ${script_PROGNAME})
    local PROMPT="${PROGNAME}: ${STRING}? (yes/no) "
    local ANS=
    while IFS= read -r -e -p "$PROMPT" ANS && \
        test "$ANS" != 'yes' -a "$ANS" != 'no'
    do echo "${PROGNAME}: please answer yes or no."
    done
    test "$ANS" = yes
}
function mbfl_dialog_ask_password () {
    mandatory_parameter(PROMPT, 1, prompt)
    local PASSWORD= STTY=
    STTY=$(mbfl_program_found stty) || exit $?
    echo -n "${prompt}: " >&2
    "$STTY" cbreak -echo </dev/tty >/dev/tty 2>&1
    IFS= read -rs PASSWORD
    "$STTY" -cbreak echo </dev/tty >/dev/tty 2>&1
    echo >&2
    printf %s "${PASSWORD}"
}

### end of file
# Local Variables:
# mode: sh
# End:
