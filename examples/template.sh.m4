# Part of: Marco's BASH Functions Library
# Contents: script template
# Date: Sun Sep 12, 2004
#
# Abstract
#
#	This  script  template  shows  how  an  MBFL  script  should  be
#	organised  to  use  MBFL.   This script  makes  use  of  "action
#	options": its behaviour is configured with command line options,
#	similarly  to  what  "tar"  does with  the  options  "--create",
#	"--extract" and the like.
#
# Copyright (c) 2004, 2005, 2009, 2012, 2013, 2014, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# The author hereby grants  permission to use, copy, modify, distribute,
# and  license this  software  and its  documentation  for any  purpose,
# provided that  existing copyright notices  are retained in  all copies
# and that  this notice  is included verbatim in any  distributions.  No
# written agreement, license, or royalty  fee is required for any of the
# authorized uses.  Modifications to this software may be copyrighted by
# their authors and need not  follow the licensing terms described here,
# provided that the new terms are clearly indicated on the first page of
# each file where they apply.
#
# IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
# FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
# ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
# DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
# POSSIBILITY OF SUCH DAMAGE.
#
# THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
# INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
# MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
# NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
# AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

#page
#### MBFL's related options and variables

script_PROGNAME=template.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2004, 2005, 2009, 2012, 2014, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='This is an example script.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} --alpha"

#page
#### library embedding

mbfl_embed_library

#page
#### declare external programs usage

#mbfl_file_enable_compress
#mbfl_file_enable_copy
#mbfl_file_enable_make_directory
#mbfl_file_enable_listing
#mbfl_file_enable_stat
#mbfl_file_enable_owner_and_group
#mbfl_file_enable_permissions
#mbfl_file_enable_move
#mbfl_file_enable_remove
#mbfl_file_enable_symlink
#mbfl_file_enable_tar
#mbfl_declare_program git

#page
#### declare exit codes

mbfl_main_declare_exit_code 2 second_error
mbfl_main_declare_exit_code 3 third_error
mbfl_main_declare_exit_code 3 fourth_error
mbfl_main_declare_exit_code 8 eighth_error

#page
#### configure global behaviour

mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit

#page
#### script options

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ACTION_ONE   yes '' one   noarg 'selects action one'
mbfl_declare_option ACTION_TWO   no  '' two   noarg 'selects action two'
mbfl_declare_option ACTION_THREE no  '' three noarg 'selects action three'
mbfl_declare_option ACTION_FOUR  no  '' four  noarg 'selects action four'

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ALPHA no a alpha noarg 'selects action alpha'
mbfl_declare_option BETA '' b beta  witharg 'selects option beta'
mbfl_declare_option VALUE '' '' value witharg 'selects a value'
mbfl_declare_option FILE '' f file witharg 'selects a file'
mbfl_declare_option ENABLE no e enable noarg 'enables a feature'
mbfl_declare_option DISABLE no d disable noarg 'disables a feature'

#page
#### option update functions

function script_option_update_beta () {
    printf 'option beta: %s\n' "$script_option_BETA"
}
function script_option_update_alpha () {
    printf 'option alpha\n'
}

#page
#### main functions

function script_before_parsing_options () {
    mbfl_message_verbose "$FUNCNAME\n"

    if mbfl_string_is_not_empty "$script_option_BETA"
    then printf 'option beta: %s\n' "$script_option_BETA"
    fi
    return 0
}
function script_after_parsing_options () {
    mbfl_message_verbose "$FUNCNAME\n"
    return 0
}
function main () {
    mbfl_program_validate_declared || exit_because_program_not_found
    printf "arguments: %d, '%s'\n" $ARGC "${ARGV[*]}"
    exit_because_success
}
function script_action_one () {
    printf "action one, arguments: %d, '%s'\n" $ARGC "${ARGV[*]}"
    exit_because_success
}
function script_action_two () {
    printf 'action two\n'
    exit_because_success
}
function script_action_three () {
    printf "action three, arguments: %d, '%s'\n" $ARGC "${ARGV[*]}"
    exit_because_success
}
function script_action_four () {
    printf "action four, arguments: %d, '%s'\n" $ARGC "${ARGV[*]}"
    exit_because_success
}

#page
#### let's go

#mbfl_set_option_debug
mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
