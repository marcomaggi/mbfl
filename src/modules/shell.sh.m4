# shell.sh.m4 --
#
# Part of: Marco's BASH functions library
# Contents: shell facilities module
# Date: Oct 21, 2020
#
# Abstract
#
#	This module  defines an easier-to-remember API  for the facilities of  the shell, especially
#	introspection.
#
# Copyright (c) 2020 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#

#page
#### introspection functions

function mbfl_shell_is_function () {
    mbfl_mandatory_parameter(FUNC, 1, function name)
    local -r WORD=$(type -t "$FUNC")
    test 'function' '=' "$WORD"
}

### end of file
# Local Variables:
# mode: sh
# End:
