# integers.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: handling integers
# Date: Apr 18, 2023
#
# Abstract
#
#
#
# Copyright (c) 2023 Marco Maggi <mrc.mgg@gmail.com>
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
function mbfl_integer_compare () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    if mbfl_integer_eq($LEFT, $RIGHT)
    then return 0
    elif mbfl_integer_lt($LEFT, $RIGHT)
    then return 1
    else return 2
    fi
}
function mbfl_integer_equal () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    mbfl_integer_eq($LEFT, $RIGHT)
}
function mbfl_integer_not_equal () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    mbfl_integer_neq($LEFT, $RIGHT)
}
function mbfl_integer_less () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    mbfl_integer_lt($LEFT, $RIGHT)
}
function mbfl_integer_less_or_equal () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    mbfl_integer_le($LEFT, $RIGHT)
}
function mbfl_integer_greater () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    mbfl_integer_gt($LEFT, $RIGHT)
}
function mbfl_integer_greater_or_equal () {
    mbfl_mandatory_integer_parameter(LEFT,  1, left integer)
    mbfl_mandatory_integer_parameter(RIGHT, 2, right integer)

    mbfl_integer_ge($LEFT, $RIGHT)
}

### end of file
# Local Variables:
# mode: sh
# End:
