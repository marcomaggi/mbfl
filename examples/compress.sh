# compress.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: script example for the compress interface
# Date: Fri Aug 12, 2005
# 
# Abstract
# 
#	This script shows how to use the interface to the compression
#	programs.
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

script_PROGNAME=compress.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2005'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='Example script to compress files.'

source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ACTION_COMPRESS yes '' compress noarg "selects compress action"
mbfl_declare_option ACTION_DECOMPRESS no '' decompress noarg "selects decompress action"
mbfl_declare_option GZIP no G gzip noarg "selects gzip"
mbfl_declare_option BZIP no B bzip noarg "selects bzip2"
mbfl_declare_option KEEP no k keep noarg "keeps the original file"

mbfl_file_enable_compress

mbfl_main_declare_exit_code 2 error_compressing
mbfl_main_declare_exit_code 3 error_decompressing
mbfl_main_declare_exit_code 4 wrong_command_line_arguments
#page
## ------------------------------------------------------------
## Options update functions.
## ------------------------------------------------------------

function script_option_update_gzip () {
    mbfl_file_compress_select_gzip
}
function script_option_update_bzip () {
    mbfl_file_compress_select_bzip
}
function script_option_update_keep () {
    mbfl_file_compress_keep
}

#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function script_before_parsing_options () {
    mbfl_file_compress_nokeep
}
function script_action_compress () {
    local item

    if ! mbfl_argv_all_files ; then
        exit_because_wrong_command_line_arguments
    fi
    for item in "${ARGV[@]}" ; do
        if ! mbfl_file_compress "${item}" ; then
            mbfl_message_error "compressing '${item}'"
            exit_because_error_compressing
        fi
    done
    exit_success
}
function script_action_decompress () {
    local item

    if ! mbfl_argv_all_files ; then
        exit_because_wrong_command_line_arguments
    fi
    for item in "${ARGV[@]}" ; do
        if ! mbfl_file_decompress "${item}" ; then
            mbfl_message_error "decompressing '${item}'"
            exit_because_error_decompressing
        fi
    done
    exit_success
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
