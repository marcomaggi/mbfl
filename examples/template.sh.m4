# ... .sh --
# 
# Part of: ...
# Contents: ...
# Date: ...
# 
# Abstract
# 
# 
# 
# Copyright (c) 2004 Marco Maggi
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

#set -e
#set -x

m4_changequote([[, ]])

#PAGE
## ------------------------------------------------------------
## Service variables required by MBFL.
## ------------------------------------------------------------

script_PROGNAME="..."
script_AUTHOR="Marco Maggi"
script_COPYRIGHT_YEARS="2004"

script_VERSION="1.0"
script_LICENSE=GPL

script_USAGE="usage: ${script_PROGNAME} [options] ...
A script template.
Options:
\t-a --alpha             alpha action
\t-bVALUE
\t   --beta=VALUE        sets option beta\n
\t-i --interactive       ask before doing dangerous operations
\t-f --force             do not ask before dangerous operations
\t   --encoded-args      decode arguments following this option
\t                       from the hex format (example: 414243 -> ABC)
\t-v --verbose           verbose execution
\t   --silent            silent execution
\t   --null              use the null character as terminator
\t   --debug             print debug messages
\t   --test              tests execution
\t   --version           print version informations and exit
\t   --version-only      print version number and exit
\t   --license           print license informations and exit
\t-h --help --usage      print usage informations and exit
"

#PAGE
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

#PAGE
## ------------------------------------------------------------
## Libraries.
## ------------------------------------------------------------

m4_include(libmbfl.sh)

#PAGE
function script_begin () {
    return 0
}
function script_end () {
    return 0
}
function script_option () {
    local OPTNAME="${1}"


    case "${OPTNAME}" in
	a|alpha)
	    mbfl_option_ACTION=alpha
	    ;;
	*)
	    return 2
	    ;;
    esac
    return 0
}
function script_option_with () {
    local OPTNAME="${1}"
    local OPTVAL="${2}"


    case "${OPTNAME}" in
	b|beta)
	    echo "option beta: ${OPTVAL}"
	    ;;
	*)
	    return 2
	    ;;
    esac
    return 0
}
function script_action_alpha () {
    echo "action alpha"
    return 0
}
#PAGE
## ------------------------------------------------------------
## Main script.
## ------------------------------------------------------------

mbfl_main

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# End:
