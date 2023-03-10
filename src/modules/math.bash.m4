#
# Part of: Marco's Bash Functions Library
# Contents: mathematical expressions evaluator
# Date: Mar  3, 2023
#
# Abstract
#
#
#
# Copyright (C) 2023 Marco Maggi <mrc.mgg@gmail.com>
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

function mbfl_math_expr () {
    mbfl_mandatory_parameter(EXPR_STRING, 1, mathematical expression)
    local GAWK_EXPR RESULT
    printf -v GAWK_EXPR 'BEGIN { print %s }' "$EXPR_STRING"
    mbfl_program_exec "$mbfl_PROGRAM_GAWK" "$GAWK_EXPR"
}
function mbfl_math_expr_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    mbfl_mandatory_parameter(EXPR_STRING, 2, mathematical expression)
    local RESULT
    if RESULT=$(mbfl_math_expr "$EXPR_STRING")
    then RV=$RESULT
    else return $?
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
