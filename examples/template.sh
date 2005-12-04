# template.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: script template
# Date: Sun Sep 12, 2004
# 
# Abstract
# 
#	This script shows how an MBFL script should be organised
#	to use MBFL.
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

#page
## ------------------------------------------------------------
## MBFL's related options and variables.
## ------------------------------------------------------------

script_PROGNAME=template.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2004, 2005'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='This is an example script.'
script_EXAMPLES="Usage examples:

\t${script_PROGNAME} --alpha"

mbfl_INTERACTIVE='no'
source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ALPHA no a alpha noarg 0selects action alpha0
mbfl_declare_option BETA 00 b beta  witharg 0selects option beta0
mbfl_declare_option VALUE 0 00 value witharg 0selects a value0
mbfl_declare_option FILE 0 f file witharg 0selects a file0
mbfl_declare_option ENABLE no e enable noarg 0enables a feature0
mbfl_declare_option DISABLE no d disable noarg 0disables a feature0

#page
## ------------------------------------------------------------
## Declare external programs usage.
## ------------------------------------------------------------

mbfl_file_enable_make_directory
mbfl_declare_program woah

#page
## ------------------------------------------------------------
## Declare exit codes.
## ------------------------------------------------------------

mbfl_main_declare_exit_code 2 second_error
mbfl_main_declare_exit_code 8 eighth_error
mbfl_main_declare_exit_code 3 third_error
mbfl_main_declare_exit_code 3 fourth_error

#page
## ------------------------------------------------------------
## Option update functions.
## ------------------------------------------------------------

function script_option_update_beta () {
    printf 'option beta: %s\n' "${script_option_BETA}"
}
function script_option_update_alpha () {
    printf 'option alpha\n'
}

#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function script_before_parsing_options () {
    mbfl_message_verbose "${FUNCNAME}\n"

    if test -n "${script_option_BETA}";	then
	printf 'option beta: %s\n' "${script_option_BETA}"
    fi
    return 0
}
function script_after_parsing_options () {
    mbfl_message_verbose "${FUNCNAME}\n"
    return 0
}
function main () {
    printf "arguments: %d, '%s'\n" $ARGC "${ARGV[*]}"
    exit_because_success
}

#page
## ------------------------------------------------------------
## Start.
## ------------------------------------------------------------

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
