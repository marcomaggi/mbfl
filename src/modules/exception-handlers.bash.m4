# exception-handlers.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: exception handlers
# Date: May  3, 2023
#
# Abstract
#
#       This module defines exception handlers.
#
# Copyright (c) 2023 Marco Maggi
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


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### initialisation

function mbfl_initialise_module_exception_handlers () {
    declare -ga mbfl_exception_handlers_STACK=()
}


#### interface

function mbfl_exception_handlers_push () {
    mbfl_mandatory_parameter(mbfl_HANDLER, 1, applicable exception handler)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_exception_handlers_STACK)

    mbfl_slot_set(mbfl_exception_handlers_STACK, $mbfl_DIM, "$mbfl_HANDLER")
}
function mbfl_exception_handlers_pop () {
    mbfl_variable_unset(mbfl_slot_spec(mbfl_exception_handlers_STACK, $((mbfl_DIM-1))))
}
function mbfl_exception_handlers_run () {
    mbfl_mandatory_parameter(mbfl_CND, 1, condition object)
    declare -i mbfl_LAST=mbfl_slots_number(mbfl_exception_handlers_STACK)-1
    declare mbfl_HANDLER=_(mbfl_exception_handlers_STACK, $mbfl_LAST)

    eval "$mbfl_HANDLER" "$mbfl_CND"
    declare mbfl_RETURN_STATUS=$?
}



### end of file
# Local Variables:
# mode: sh
# End:
