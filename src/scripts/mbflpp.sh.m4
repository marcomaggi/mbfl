# mbflpp.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: script preprocessor
# Date: Tue Mar 29, 2005
#
# Abstract
#
#	Preprocessor for BASH scripts using MBFL.
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

script_PROGNAME=mbflpp.sh
script_VERSION='__PACKAGE_VERSION__'
script_COPYRIGHT_YEARS='2005, 2009'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL3
script_USAGE="usage: ${script_PROGNAME} [options] <INFILE >OUTFILE"
script_DESCRIPTION='Script preprocessor for MBFL.'
script_EXAMPLES="Usage examples:

${script_PROGNAME} <INFILE >OUTFILE
${script_PROGNAME} --outfile=OUTFILE INFILE1 INFILE2 ..."

#page
#### load the library

m4_include(loader.sh)

#page
#### command line options

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option PRESERVE_COMMENTS no '' preserve-comments noarg "do not filter out comments"
mbfl_declare_option ADD_BASH          no '' add-bash          noarg "add '#!${BASH}' at the beginning"
mbfl_declare_option DEFINE            ''  D define            witharg "define a new symbols (m4 syntax)"
mbfl_declare_option INCLUDE           ''  I include           witharg "add a search path for files"
mbfl_declare_option LIBRARY           '' '' library           witharg "include an M4 library"
mbfl_declare_option OUTPUT            -   o output            witharg "selects an output file, '-' for stdout"
mbfl_declare_option EVAL              no  e eval              noarg "if used evaluates the output script in bash, instead of printing it"
mbfl_declare_option NO_PREPROCESSOR   no '' no-prepro         noarg "do not load the m4 preprocessor library"

#page
#### external programs declarations

mbfl_declare_program m4
mbfl_declare_program grep
mbfl_declare_program sed
mbfl_declare_program cat

#page
#### exit code declarations

mbfl_main_declare_exit_code 2 wrong_command_line_arguments

#page
#### global variables

declare -r hidden_option_DATADIR='__PKGDATADIR__'

declare symbols libraries includes

#page
#### option update functions

function script_option_update_define () {
    symbols+=" --define=${script_option_DEFINE}"
}
function script_option_update_library () {
    libraries+=" ${script_option_LIBRARY}"
}
function script_option_update_include () {
    includes+=" --include=${script_option_INCLUDE}"
}

#page
#### main functions

function main () {
    local M4_FLAGS='--prefix-builtins'
    local PREPROCESSOR=${hidden_option_DATADIR}/preprocessor.m4


    M4_FLAGS+=" ${includes} ${symbols}"
    if { test "$NO_PREPROCESSOR" = no && mbfl_file_is_readable "$PREPROCESSOR"; }
    then M4_FLAGS+=" ${PREPROCESSOR}"
    fi
    M4_FLAGS+=" ${libraries}"

    if ! {
            if test $ARGC -eq 0
    	    then program_cat
            else
    		mbfl_argv_all_files || exit_because_wrong_command_line_arguments
    		program_cat "${ARGV[@]}"
            fi
    	} | {
            if test "$script_option_ADD_BASH" = 'yes'
    	    then printf '#!%s\n' "$BASH"
            fi
            if test "$script_option_PRESERVE_COMMENTS" = 'yes'
    	    then program_m4 ${M4_FLAGS} -
            else program_m4 ${M4_FLAGS} - | filter_drop_comments
            fi
    	} | {
            if test "$script_option_EVAL" = 'yes'
    	    then exec "$BASH"
            else
    		if test "$script_option_OUTPUT" = '-'
    		then program_cat
    		else program_cat >"$script_option_OUTPUT"
    		fi
            fi
    	}
    then exit $?
    fi
    exit_success
}

#page
#### stream filters

function filter_drop_comments () {
    program_grep --invert-match --regexp='^[ \t]*#' --regexp='^$' | \
        program_sed --expression='s/^[ \t]\+//g'
}

#page
#### program interfaces

function program_m4 () {
    local M4
    mbfl_program_found_var M4 m4 || exit $?
    mbfl_program_exec "$M4" "$@"
}
function program_grep () {
    local GREP
    mbfl_program_found_var GREP grep || exit $?
    mbfl_program_exec "$GREP" "$@"
}
function program_sed () {
    local SED
    mbfl_program_found_var SED sed || exit?
    mbfl_program_exec "$SED" "$@"
}
function program_cat () {
    local CAT
    mbfl_program_found_var CAT cat || exit $?
    mbfl_program_exec "$CAT" "$@"
}

#page
#### let's go

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
