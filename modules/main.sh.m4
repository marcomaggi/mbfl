# main.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: main script module
# Date: Mon May 17, 2004
# 
# Abstract
# 
# 
# 
# Copyright (c) 2004, 2005 Marco Maggi
# 
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
# 
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
#


#PAGE
## ------------------------------------------------------------
## Generic variables.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then
    mbfl_option_TMPDIR="${TMPDIR:-/tmp/${USER}}"
    mbfl_ORG_PWD="${PWD}"
    mbfl_main_SCRIPT_FUNCTION=main
    mbfl_main_PRIVATE_SCRIPT_FUNCTION=
fi

function mbfl_main_set_main () {
    mbfl_main_SCRIPT_FUNCTION="${1:?}"
}
function mbfl_main_set_private_main () {
    mbfl_main_PRIVATE_SCRIPT_FUNCTION="${1:?}"
}
#page
## ------------------------------------------------------------
## Exit codes management.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then
    declare -a mbfl_main_EXIT_CODES mbfl_main_EXIT_NAMES
    mbfl_main_EXIT_CODES[0]=0
    mbfl_main_EXIT_NAMES[0]='success'
fi

function exit_success () {
    exit_because_success
}
function mbfl_main_declare_exit_code () {
    mandatory_parameter(CODE, 1, exit code)
    mandatory_parameter(DESCRIPTION, 2, exit code name)
    local i=${#mbfl_main_EXIT_CODES[@]}
    mbfl_main_EXIT_NAMES[${i}]=${DESCRIPTION}
    mbfl_main_EXIT_CODES[${i}]=${CODE}
}
function mbfl_main_create_exit_functions () {
    local i name

    for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i)); do
        name=exit_because_${mbfl_main_EXIT_NAMES[${i}]}
        eval function "${name}" "()" "{ exit ${mbfl_main_EXIT_CODES[${i}]}; }"
    done
}
function mbfl_main_list_exit_codes () {
    local i

    for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i)); do
        printf '%d %s\n' ${mbfl_main_EXIT_CODES[${i}]} ${mbfl_main_EXIT_NAMES[${i}]}
    done
}
function mbfl_main_print_exit_code () {
    mandatory_parameter(NAME, 1, exit code name)
    local i

    for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i)); do
        if test "${mbfl_main_EXIT_NAMES[${i}]}" = "${NAME}"; then
            printf '%d\n' ${mbfl_main_EXIT_CODES[${i}]}
        fi
    done
}
function mbfl_main_print_exit_code_names () {
    mandatory_parameter(CODE, 1, exit code)
    local i

    for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i)); do
        if test "${mbfl_main_EXIT_CODES[${i}]}" = "${CODE}"; then
            printf '%s\n' ${mbfl_main_EXIT_NAMES[${i}]}
        fi
    done
}

#PAGE
## ------------------------------------------------------------
## License message variables.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then

mbfl_message_LICENSE_GPL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This file  is free software you  can redistribute it  and/or modify it
under the terms of the GNU  General Public License as published by the
Free Software  Foundation; either version  2, or (at your  option) any
later version.\n
This  file is  distributed in  the hope  that it  will be  useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.\n
You  should have received  a copy  of the  GNU General  Public License
along with this file; see the file COPYING.  If not, write to the Free
Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
02111-1307, USA.
"

mbfl_message_LICENSE_LGPL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; you  can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software  Foundation; either version  2.1 of the License,  or (at
your option) any later version.\n
This library  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
Lesser General Public License for more details.\n
You  should have  received a  copy of  the GNU  Lesser  General Public
License along  with this library; if  not, write to  the Free Software
Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
USA.
"

mbfl_message_LICENSE_BSD="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
The author  hereby grant permission to use,  copy, modify, distribute,
and  license this  software  and its  documentation  for any  purpose,
provided that  existing copyright notices  are retained in  all copies
and that  this notice  is included verbatim  in any  distributions. No
written agreement, license, or royalty  fee is required for any of the
authorized uses.  Modifications to this software may be copyrighted by
their authors and need not  follow the licensing terms described here,
provided that the new terms are clearly indicated on the first page of
each file where they apply.\n
IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
POSSIBILITY OF SUCH DAMAGE.\n
THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN \"AS  IS\" BASIS,
AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
"

fi

#PAGE
## ------------------------------------------------------------
## Version message variables.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then

mbfl_message_VERSION="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is  free software; see the  source or use the  --license option for
copying conditions.  There is NO warranty; not  even for MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.
"

fi

#PAGE
## ------------------------------------------------------------
## Main function.
## ------------------------------------------------------------

function mbfl_main () {
    local exit_code=0
    local action_func
    local item code


    mbfl_message_set_progname "${script_PROGNAME}"
    mbfl_main_create_exit_functions

    mbfl_invoke_script_function script_before_parsing_options
    mbfl_getopts_parse
    mbfl_invoke_script_function script_after_parsing_options
    if test -n "${mbfl_main_PRIVATE_SCRIPT_FUNCTION}" ; then
        mbfl_invoke_script_function ${mbfl_main_PRIVATE_SCRIPT_FUNCTION}
    else
        mbfl_invoke_script_function ${mbfl_main_SCRIPT_FUNCTION}
    fi
}
function mbfl_invoke_script_function () {
    mandatory_parameter(item, 1, function name)
    if test "$(type -t ${item})" = "function"; then ${item}; else return 0; fi
}

### end of file
# Local Variables:
# mode: sh
# End:
