#
# Part of: Marco's Bash Functions Library
# Contents: atexit module
# Date: Sun Nov 25, 2018
#
# Abstract
#
#
#
# Copyright (C) 2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
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


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### global variables

mbfl_hook_declare(mbfl_atexit_HANDLERS)

function mbfl_atexit_enable () {
    trap mbfl_atexit_run EXIT
}
function mbfl_atexit_disable () {
    trap EXIT
}
function mbfl_atexit_register () {
    mbfl_mandatory_parameter(mbfl_HANDLER,	1, handler script)
    mbfl_optional_parameter(mbfl_IDVAR,		2)
    mbfl_hook_add _(mbfl_atexit_HANDLERS) "$mbfl_HANDLER" "$mbfl_IDVAR"
}
function mbfl_atexit_forget () {
    mbfl_mandatory_integer_parameter(mbfl_HANDLER_ID, 1, handler id)
    mbfl_hook_remove _(mbfl_atexit_HANDLERS) $mbfl_HANDLER_ID
}
function mbfl_atexit_run () {
    mbfl_hook_run _(mbfl_atexit_HANDLERS)
}
function mbfl_atexit_clear () {
    mbfl_hook_remove_commands _(mbfl_atexit_HANDLERS)
}

### end of file
# Local Variables:
# mode: sh
# End:
