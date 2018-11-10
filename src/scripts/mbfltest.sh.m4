# mbfltest.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: wrapper for the test library
# Date: Wed Aug 17, 2005
#
# Abstract
#
#	Execute a Bash subprocess running test files in it.
#
# Copyright (c) 2005, 2009, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
#
# This program is  free software: you can redistribute  it and/or modify
# it under the  terms of the GNU General Public  License as published by
# the Free Software Foundation, either version  3 of the License, or (at
# your option) any later version.
#
# This program  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See the  GNU
# General Public License for more details.
#
# You should  have received  a copy  of the  GNU General  Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#page
#### MBFL's related options and variables

script_PROGNAME=mbfltest.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2005'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL3
script_USAGE="usage: ${script_PROGNAME} [options] FILE ..."
script_DESCRIPTION='Interface to the MBFL test library.'
script_EXAMPLES="Usage examples:

\t${script_PROGNAME} module1.test module2.test
\t${script_PROGNAME} --start --end module1.test module2.test"

source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option START no '' start noarg 'print start messages for tests'
mbfl_declare_option END no '' end noarg 'print end messages for tests'
mbfl_declare_option MATCH '' '' match witharg 'select match pattern for tests'
mbfl_declare_option DIRECTORY "${PWD}" \
    '' directory witharg 'change directory before executing tests'
mbfl_declare_option LIBRARY '' '' library witharg 'select the MBFL library'

mbfl_main_declare_exit_code 2 file_not_found

#page
#### option update functions

function script_option_update_start () {
    export TESTSTART='yes'
}
function script_option_update_end () {
    export TESTSUCCESS='yes'
}
function script_option_update_match () {
    local OPTNAME=$1
    local OPTARG=$2
    export TESTMATCH="$OPTARG"
}

#page
#### main functions

function main () {
    local item FILES lib testlib=$(mbfl-config --testlib)
    local -i i=0

    if test $ARGC -eq 0
    then
        mbfl_message_error "no files on the command line"
        exit_because_file_not_found
    fi
    mbfl_argv_all_files || exit_because_file_not_found
    for item in "${ARGV[@]}"
    do
        if mbfl_file_is_file "${item}"
	then FILES[$i]=$(mbfl_file_normalise "$item")
        else
            mbfl_message_error_printf 'file not found "%s"' "$item"
            exit_because_file_not_found
        fi
        let ++i
    done

    if test -n "$script_option_LIBRARY"
    then lib=$(mbfl_file_normalise "$script_option_LIBRARY")
    else lib=$(mbfl-config)
    fi

    mbfl_cd "$script_option_DIRECTORY"
    for item in "${FILES[@]}"
    do
        mbfl_message_debug_printf 'executing subprocess for test "%s"\n' "$item"
        {
            printf 'source %s || exit 2\n' "$lib"
            printf 'source %s || exit 2\n' "$testlib"
            mbfl_option_debug && echo 'mbfl_set_option_debug'
            printf 'export MBFL_LIBRARY=%s\n' "$lib"
            printf 'mbfl_TEST_FILE=%s\n' "$item"
            printf 'source %s\n' "$item"
        } | mbfl_program_bash
    done

    exit_success
}

#page
#### let's go

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
