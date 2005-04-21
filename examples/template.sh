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

#page
## ------------------------------------------------------------
## MBFL's related options and variables.
## ------------------------------------------------------------

script_PROGNAME=template.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS=2004
script_AUTHOR="Marco Maggi and Marco Maggi"
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='This is an example script.'

mbfl_INTERACTIVE='no'
source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ALPHA no a alpha noarg "selects action alpha"
mbfl_declare_option BETA "" b beta  witharg "selects option beta"
mbfl_declare_option VALUE 0 "" value witharg "selects a value"
mbfl_declare_option FILE 0 f file witharg "selects a file"
mbfl_declare_option ENABLE no e enable noarg "enables a feature"
mbfl_declare_option DISABLE no d disable noarg "disables a feature"

mbfl_file_enable_make_directory
mbfl_declare_program woah

mbfl_main_declare_exit_code 1 first_error
mbfl_main_declare_exit_code 8 second_error
mbfl_main_declare_exit_code 3 third_error
mbfl_main_declare_exit_code 3 fourth_error

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
function script_option_update_beta () {
    printf 'option beta: %s\n' "${script_option_BETA}"
}
function script_option_update_alpha () {
    printf 'option alpha\n'
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
