#!/bin/bash
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
# Copyright (c) 2005 Marco Maggi
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

script_PROGNAME=mbflpp.sh
script_VERSION='__PACKAGE_VERSION__'
script_COPYRIGHT_YEARS=2005
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] <INFILE >OUTFILE"
script_DESCRIPTION='Script preprocessor for MBFL.'
script_EXAMPLES="Usage examples:

${scripts_PROGNAME} <INFILE >OUTFILE
${scripts_PROGNAME} --outfile=OUTFILE INFILE1 INFILE2 ..."

source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option PRESERVE_COMMENTS \
    no "" preserve-comments noarg "do not filter out comments"
mbfl_declare_option ADD_BASH \
    no "" add-bash noarg "add '#!${BASH}' at the beginning"
mbfl_declare_option DEFINE \
    "" "" define witharg "define a new symbols (m4 syntax)"
mbfl_declare_option INCLUDE \
    "" "" include witharg "add a search path for files"
mbfl_declare_option LIBRARY \
    "" "" library witharg "include an M4 library"
mbfl_declare_option OUTPUT \
    - o output witharg "selects an output file, '-' for stdout"
mbfl_declare_option EVAL \
    no e eval noarg "if used evaluates the output script in bash, instead of printing it"

mbfl_declare_program m4
mbfl_declare_program grep
mbfl_declare_program sed

mbfl_main_declare_exit_code 2 wrong_command_line_arguments

#page
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

hidden_option_DATADIR='__PKGDATADIR__'

declare symbols libraries includes

#page
## ------------------------------------------------------------
## Option update functions.
## ------------------------------------------------------------

function script_option_update_define () {
    symbols="${symbols} --define=${script_option_DEFINE}"
}
function script_option_update_library () {
    libraries="${libraries} ${script_option_LIBRARY}"
}
function script_option_update_include () {
    includes="${includes} --include=${script_option_INCLUDE}"
}

#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function main () {
    local M4_FLAGS='--prefix-builtins'
    local libfile=${hidden_option_DATADIR}/preprocessor.m4
    local item

    
    M4_FLAGS="${M4_FLAGS} ${includes} ${symbols}"
    mbfl_file_is_readable "${libfile}" && M4_FLAGS="${M4_FLAGS} ${libfile}"
    M4_FLAGS="${M4_FLAGS} ${libraries}"    

    if ! {
        if test $ARGC -eq 0 ; then
            mbfl_file_cat -
        else
            mbfl_argv_all_files || exit_because_wrong_command_line_arguments
            for item in "${ARGV[@]}" ; do
                mbfl_message_verbose "reading '${item}'\n"
                mbfl_file_cat - <"${item}"
            done
        fi
    } | {
        if test "${script_option_ADD_BASH}" = "yes"; then
            printf '#!%s\n' "${BASH}"
        fi
        if test "${script_option_PRESERVE_COMMENTS}" = "yes"; then
            program_m4 ${M4_FLAGS} -
        else
            program_m4 ${M4_FLAGS} - | filter_drop_comments
        fi
    } | {
        if test "${script_option_EVAL}" = 'yes' ; then
            exec "${BASH}"
        else
            mbfl_file_cat "${script_option_OUTPUT}"
        fi
    } ; then exit $?; fi
    exit_success
}

#page
## ------------------------------------------------------------
## Stream filters.
## ------------------------------------------------------------

function filter_drop_comments () {
    program_grep --invert-match -e '^[ \t]*#' -e '^$' | \
        program_sed -e 's/^[[:blank:]]\+//'
}

#page
## ------------------------------------------------------------
## Program interfaces.
## ------------------------------------------------------------

function program_m4 () {
    local M4=$(mbfl_program_found m4)
    mbfl_program_exec ${M4} "$@"
}
function program_grep () {
    local GREP=$(mbfl_program_found grep)
    mbfl_program_exec ${GREP} "$@"
}
function program_sed () {
    local SED=$(mbfl_program_found sed)
    mbfl_program_exec ${SED} "$@"
}

#page
## ------------------------------------------------------------
## Let's go.
## ------------------------------------------------------------

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
