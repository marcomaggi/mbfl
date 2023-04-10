# hooks.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: Emacs-like hooks
# Date: Mar 26, 2023
#
# Abstract
#
#	Emacs-like hooks implementation.
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


#### local macros

MBFL_DEFINE_UNDERSCORE_MACRO()


#### interface

function mbfl_hook_define () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOKS, 1, reference to hook variable)
    mbfl_hook_reset _(mbfl_HOOKS)
}
function mbfl_hook_add () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOKS,	1, reference to hook variable)
    mbfl_mandatory_parameter(mbfl_HOOK_COMMAND,		2, hook command)
    declare -i mbfl_HOOK_NUM=mbfl_slots_number(mbfl_HOOKS)

    mbfl_slot_set(mbfl_HOOKS, $mbfl_HOOK_NUM, "$mbfl_HOOK_COMMAND")
}
function mbfl_hook_run () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOKS, 1, reference to hook variable)
    declare -i mbfl_I mbfl_HOOK_NUM=mbfl_slots_number(mbfl_HOOKS)
    declare mbfl_HOOK_COMMAND

    for ((mbfl_I=0; mbfl_I < mbfl_HOOK_NUM; ++mbfl_I))
    do
	mbfl_HOOK_COMMAND=mbfl_slot_qref(mbfl_HOOKS,mbfl_I)
	eval "$mbfl_HOOK_COMMAND"
    done
}
function mbfl_hook_reset () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOKS, 1, reference to hook variable)

    unset -v _(mbfl_HOOKS)
    declare -ga _(mbfl_HOOKS)
}

### end of file
# Local Variables:
# mode: sh
# End:
