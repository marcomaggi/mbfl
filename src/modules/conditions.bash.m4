# conditions.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: exceptional conditions descriptors module
# Date: May  2, 2023
#
# Abstract
#
#       This module defines standard objects describing exceptional conditions.
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


#### global variables

function mbfl_initialise_module_conditions () {
    mbfl_default_object_declare_global(mbfl_condition_t)
    mbfl_default_object_declare_global(mbfl_error_condition_t)
    mbfl_default_object_declare_global(mbfl_warning_condition_t)
    mbfl_default_object_declare_global(mbfl_logic_error_condition_t)
    mbfl_default_object_declare_global(mbfl_runtime_error_condition_t)

    mbfl_default_class_define _(mbfl_condition_t)               _(mbfl_default_object)    'mbfl_condition' 'message'
    mbfl_default_class_define _(mbfl_warning_condition_t)       _(mbfl_condition_t)       'mbfl_warning_condition'
    mbfl_default_class_define _(mbfl_error_condition_t)         _(mbfl_condition_t)       'mbfl_error_condition'
    mbfl_default_class_define _(mbfl_logic_error_condition_t)   _(mbfl_error_condition_t) 'mbfl_logic_error_condition'
    mbfl_default_class_define _(mbfl_runtime_error_condition_t) _(mbfl_error_condition_t) 'mbfl_runtime_error_condition'
}
function mbfl_condition_print () {
    mbfl_mandatory_nameref_parameter(ERR, 1, reference to error descriptor object)
    mbfl_declare_varref(MSG)

    mbfl_condition_message_var _(MSG) _(ERR)
    if mbfl_error_condition_is_a _(ERR)
    then mbfl_message_error "$MSG"
    elif mbfl_warning_condition_is_a _(ERR)
    then mbfl_message_warning "$MSG"
    else printf '%s\n' "$MSG"
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
