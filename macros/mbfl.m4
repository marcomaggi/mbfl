m4_divert(-1)
# mbfl.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: proprocessing macros.
# Date: Tue Aug 31, 2004
# 
# Abstract
# 
# 
# 
# Copyright (c) 2004 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
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

m4_changequote([, ])
m4_changecom([##])

#page
#
# Routines.
#

m4_define([MBFL_APPEND], [m4_define([$1], m4_defn([$1])m4_shift($@))])

#page
#
# Templates.
#

m4_define([MBFL_SCRIPT_HEADER], [# MBFL_V_SCRIPT_NAME --
##
## Part of: MBFL_V_SCRIPT_PACKAGE
## Contents: MBFL_V_SCRIPT_DESCRIPTION
## Build date: m4_syscmd([date --universal])m4_dnl
## 
## Abstract
MBFL_V_SCRIPT_ABSTRACT
## Copyright (c) MBFL_V_COPYRIGHT_YEARS MBFL_V_AUTHORS
##
m4_ifelse(MBFL_V_LICENSE, [GPL], [m4_dnl
## This file  is free software you  can redistribute it  and/or modify it
## under the terms of the GNU  General Public License as published by the
## Free Software  Foundation; either version  2, or (at your  option) any
## later version.
##
## This  file is  distributed in  the hope  that it  will be  useful, but
## WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
## MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
## General Public License for more details.
##
## You  should have received  a copy  of the  GNU General  Public License
## along with this file; see the file COPYING.  If not, write to the Free
## Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
## 02111-1307, USA.
], MBFL_V_LICENSE, [LGPL], [
## This is free software; you  can redistribute it and/or modify it under
## the terms of the GNU Lesser General Public License as published by the
## Free Software  Foundation; either version  2.1 of the License,  or (at
## your option) any later version.
##
## This library  is distributed in the  hope that it will  be useful, but
## WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
## MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
## Lesser General Public License for more details.
##
## You  should have  received a  copy of  the GNU  Lesser  General Public
## License along  with this library; if  not, write to  the Free Software
## Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
## USA.
], MBFL_V_LICENSE, [BSD], [
## The author  hereby grant permission to use,  copy, modify, distribute,
## and  license this  software  and its  documentation  for any  purpose,
## provided that  existing copyright notices  are retained in  all copies
## and that  this notice  is included verbatim  in any  distributions. No
## written agreement, license, or royalty  fee is required for any of the
## authorized uses.  Modifications to this software may be copyrighted by
## their authors and need not  follow the licensing terms described here,
## provided that the new terms are clearly indicated on the first page of
## each file where they apply.
##
## IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
## FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
## ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
## DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
## POSSIBILITY OF SUCH DAMAGE.
##
## THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
## INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
## MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
## NON-INFRINGEMENT.  THIS  SOFTWARE  IS  PROVIDED  ON AN "AS  IS" BASIS,
## AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
## MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
])##
])

#page
#
# Script body.
#

m4_define([MBFL_SCRIPT], [m4_divert(0)m4_dnl
MBFL_SCRIPT_HEADER
MBFL_V_GLOBAL_VARIABLES
MBFL_V_OPTION_FUNCTIONS
source ${MBFL_LIBRARY:=$(mbfl.sh)}
])

m4_define([MBFL_END], [
mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
m4_divert(-1)])

#page
#
# Global variables and related macros.
#

m4_define([MBFL_SCRIPT_NAME],
    [m4_define([MBFL_V_SCRIPT_NAME], [$1])])
m4_define([MBFL_SCRIPT_VERSION],
    [m4_define([MBFL_V_VERSION], [$1])])
m4_define([MBFL_SCRIPT_PACKAGE],
    [m4_define([MBFL_V_SCRIPT_PACKAGE], [$1])])
m4_define([MBFL_SCRIPT_DESCRIPTION],
    [m4_define([MBFL_V_SCRIPT_DESCRIPTION], [$1])])
m4_define([MBFL_SCRIPT_ABSTRACT],
    [m4_define([MBFL_V_SCRIPT_ABSTRACT], [$1])])
m4_define([MBFL_COPYRIGHT_YEARS],
    [m4_define([MBFL_V_COPYRIGHT_YEARS], [$1])])
m4_define([MBFL_AUTHORS],
    [m4_define([MBFL_V_AUTHORS], [$1])])
m4_define([MBFL_LICENSE],
    [m4_define([MBFL_V_LICENSE], [$1])])

m4_define([MBFL_V_SCRIPT_USAGE])

m4_define([MBFL_V_GLOBAL_VARIABLES], [
script_PROGNAME="MBFL_V_SCRIPT_NAME"
script_AUTHOR="MBFL_V_AUTHORS"
script_COPYRIGHT_YEARS="MBFL_V_COPYRIGHT_YEARS"
script_VERSION="MBFL_V_VERSION"
script_LICENSE="MBFL_V_LICENSE"
script_USAGE="usage: ${script_PROGNAME} [options] [--] ...
options:
MBFL_V_USAGE
\t-i
\t--interactive
\t\task before doing dangerous operations
\t-f
\t--force
\t\tdo not ask before dangerous operations
\t--encoded-args
\t\tdecode arguments following this option
\t\tfrom the hex format (example: 414243 -> ABC)
\t-v
\t--verbose
\t\tverbose execution
\t--silent
\t\tsilent execution
\t--null
\t\tuse the null character as terminator
\t--debug
\t\tprint debug messages
\t--test
\t\ttests execution
\t--version
\t\tprint version informations and exit
\t--version-only
\t\tprint version number and exit
\t--license
\t\tprint license informations and exit
\t-h
\t--help
\t--usage
\t\tprint usage informations and exit
"
])

#page
#
# Options processing.
#

m4_define([MBFL_V_OPTIONS])
m4_define([MBFL_V_ACTIONS])
m4_define([MBFL_V_OPTIONS_WITH])

m4_define([MBFL_V_OPTION_FUNCTIONS], [
function script_option () {
    local OPTNAME="${1:?${FUNCNAME} error: missing option name argument}"

    case "${OPTNAME}" in
MBFL_V_ACTIONS[]m4_dnl
MBFL_V_OPTIONS[]m4_dnl
        *)
            return 2
            ;;
    esac
    return 0
}
function script_option_with () {
    local OPTNAME="${1:?${FUNCNAME} error: missing option name argument}"
    local OPTVAL="${2:?${FUNCNAME} error: missing option value argument}"

    case "${OPTNAME}" in
MBFL_V_OPTIONS_WITH[]m4_dnl
        *)
            return 2
            ;;
    esac
    return 0
}
])

#page
#
# Declares a command line option. Synopsis:
#
#	MBFL_OPTION(keyword, default, brief, long, has_value, description, function)
#                   $1       $2       $3     $4    $5         $6           $7
#

m4_define([MBFL_OPTION], [
MBFL_APPEND([MBFL_V_GLOBAL_VARIABLES], script_option_$1=$2)
MBFL_APPEND([MBFL_V_USAGE], \t-$3[]m4_ifelse($5, 1, [VALUE])
\t--$4[]m4_ifelse($5, 1, [=VALUE])
\t\t$6)
m4_ifelse($5, 1, [MBFL_APPEND([MBFL_V_OPTIONS_WITH], [m4_dnl
        $3|$4)
            script_option_$1="${OPTVAL}"
	    mbfl_main_invoke_script_function script_option_[]m4_translit($1, [A-Z], [a-z])
            ;;
])],
    [MBFL_APPEND([MBFL_V_OPTIONS], [m4_dnl
        $3|$4)
            script_option_$1=1
	    mbfl_main_invoke_script_function script_option_m4_translit($1, [A-Z], [a-z])
            ;;
])])
])

# end of file
# Local Variables:
# mode: sh
# End:
