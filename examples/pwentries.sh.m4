# Part of: Marco's BASH Functions Library
# Contents: script to read entries from /etc/passwd
# Date: Nov 14, 2018
#
# Abstract
#
#	This script reads entries from "/etc/passwd".
#
# Copyright (c) 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
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

script_PROGNAME=pwentries.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='Read entries from /etc/passwd.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME}
\t${script_PROGNAME} --print-xml
"

#page
#### library loading

mbfl_library_loader

#page
#### declare exit codes

mbfl_main_declare_exit_code 2 cannot_read_file
mbfl_main_declare_exit_code 3 cannot_print_results

#page
#### script options

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ACTION_PRINT	yes '' print        noarg 'print the entries'
mbfl_declare_option ACTION_PRINT_XML	no  '' print-xml    noarg 'print the entries as XML'
mbfl_declare_option ACTION_PRINT_JSON	no  '' print-json   noarg 'print the entries as JSON'

#page
#### main functions

function main () {
    mbfl_main_print_usage_screen_brief
    exit_because_success
}

function script_action_print () {
    if ! mbfl_system_passwd_read
    then
    	mbfl_message_error_printf 'reading entries\n'
    	exit_because_cannot_read_file
    fi
    if mbfl_system_passwd_print_entries
    then exit_success
    else
	mbfl_message_error_printf 'printing entries\n'
	exit_because_cannot_print_results
    fi
}

function script_action_print_xml () {
    if ! mbfl_system_passwd_read
    then
    	mbfl_message_error_printf 'reading entries\n'
    	exit_because_cannot_read_file
    fi
    if mbfl_system_passwd_print_entries_as_xml
    then exit_success
    else
	mbfl_message_error_printf 'printing entries\n'
	exit_because_cannot_print_results
    fi
}

function script_action_print_json () {
    if ! mbfl_system_passwd_read
    then
    	mbfl_message_error_printf 'reading entries\n'
    	exit_because_cannot_read_file
    fi
    if mbfl_system_passwd_print_entries_as_json
    then exit_success
    else
	mbfl_message_error_printf 'printing entries\n'
	exit_because_cannot_print_results
    fi
}

#page
#### let's go

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
