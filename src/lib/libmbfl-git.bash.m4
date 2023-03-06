#! libmbfl-git.bash.m4 --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: interface to the external program "git"
#! Date: Mar  6, 2023
#!
#! Abstract
#!
#!	Very basic interface to the version control program GIT.
#!
#! Copyright (c) 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!


#### library initialisation

function mbfl_vc_git_enable () {
    mbfl_declare_program git
}


#### configuration management: getting values

function mbfl_vc_git_config_local_get_value () {
    mbfl_mandatory_parameter(KEY, 1, key)
    mbfl_optional_parameter(DEFAULT, 2)
    mbfl_vc_git_program config --local --default "$DEFAULT" --get "$KEY"
}

function mbfl_vc_git_config_local_get_value_var () {
    mbfl_mandatory_nameref_parameter(VALUE, 1, result variable)
    mbfl_mandatory_parameter(KEY, 2, key)
    mbfl_optional_parameter(DEFAULT, 3)
    VALUE=$(mbfl_vc_git_config_local_get_value "$KEY" "$DEFAULT")
}

### ------------------------------------------------------------------------

function mbfl_vc_git_config_global_get_value () {
    mbfl_mandatory_parameter(KEY, 1, key)
    mbfl_optional_parameter(DEFAULT, 2)
    mbfl_vc_git_program config --global --default "$DEFAULT" --get "$KEY"
}

function mbfl_vc_git_config_global_get_value_var () {
    mbfl_mandatory_nameref_parameter(VALUE, 1, result variable)
    mbfl_mandatory_parameter(KEY, 2, key)
    mbfl_optional_parameter(DEFAULT, 3)
    VALUE=$(mbfl_vc_git_config_global_get_value "$KEY" "$DEFAULT")
}

### ------------------------------------------------------------------------

function mbfl_vc_git_config_get_value () {
    mbfl_vc_git_config_local_get_value "$@"
}
function mbfl_vc_git_config_get_value_var () {
    mbfl_vc_git_config_local_get_value_var "$@"
}


#### program interface

function mbfl_vc_git_program () {
    mbfl_local_varref(GIT_COMMAND)

    mbfl_program_found_var mbfl_datavar(GIT_COMMAND) git || exit $?
    mbfl_program_exec "$GIT_COMMAND" "$@"
}

#!# end of file
# Local Variables:
# mode: sh
# End:
