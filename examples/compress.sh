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
script_USAGE="usage: ${script_PROGNAME} [options] FILE ..."
script_DESCRIPTION='Example script to compress files.'
script_EXAMPLES="Usage examples:

\t${script_PROGNAME} --compress file.ext\t\t;# 'file.ext' -> 'file.ext.gz'
\t${script_PROGNAME} --decompress file.ext.gz\t;# 'file.ext.gz' -> 'file.ext'

\t${script_PROGNAME} --bzip --stdout --compress file.ext >file.ext.bz2"

mbfl_INTERACTIVE='no'
source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ACTION_COMPRESS yes '' compress noarg "selects compress action"
mbfl_declare_option ACTION_DECOMPRESS no '' decompress noarg "selects decompress action"
mbfl_declare_option GZIP no G gzip noarg "selects gzip"
mbfl_declare_option BZIP no B bzip noarg "selects bzip2"
mbfl_declare_option AUTO yes B bzip noarg "automatically select compressor"
mbfl_declare_option KEEP no k keep noarg "keeps the original file"
mbfl_declare_option STDOUT no '' stdout noarg "writes output to stdout"
mbfl_declare_option GOON no '' go-on noarg "try to ignore errors when processing multiple files"

mbfl_file_enable_compress
mbfl_file_enable_listing

mbfl_main_declare_exit_code 2 error_compressing
mbfl_main_declare_exit_code 3 error_decompressing
mbfl_main_declare_exit_code 4 wrong_command_line_arguments
#page
## ------------------------------------------------------------
## Options update functions.
## ------------------------------------------------------------

function script_option_update_gzip () {
    mbfl_file_compress_select_gzip
    script_option_AUTO='no'
}
function script_option_update_bzip () {
    mbfl_file_compress_select_bzip
    script_option_AUTO='no'
}
function script_option_update_keep () {
    mbfl_file_compress_keep
}
function script_option_update_stdout () {
    mbfl_file_compress_stdout
}

#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function script_before_parsing_options () {
    mbfl_file_compress_nokeep
}
function script_action_compress () {
    local item size

    if ! mbfl_argv_all_files ; then
        exit_because_wrong_command_line_arguments
    fi
    for item in "${ARGV[@]}" ; do
        if test "${script_option_AUTO}" = 'yes' ; then
            size=$(mbfl_file_get_size "${item}")
            if test "${size}" -gt 10000000 ; then
                mbfl_file_compress_select_bzip
            else
                mbfl_file_compress_select_gzip
            fi
        fi
        if ! mbfl_file_compress "${item}" ; then
            if test "${script_option_GOON}" = 'yes' ; then
                mbfl_message_warning "unable to successfully compress '${item}'"
            else
                mbfl_message_error "unable to successfully compress '${item}'"
                exit_because_error_compressing
            fi
        fi
    done
    exit_success
}
function script_action_decompress () {
    local item ext

    if ! mbfl_argv_all_files ; then
        exit_because_wrong_command_line_arguments
    fi
    for item in "${ARGV[@]}" ; do
        ext=$(mbfl_file_extension "${item}")
        case "${ext}" in
            gz)
                mbfl_file_compress_select_gzip
                ;;
            bz2)
                mbfl_file_compress_select_bzip
                ;;
            *)
                mbfl_message_warning "unknown compressor extension '${ext}'"
                continue
                ;;
        esac
        if ! mbfl_file_decompress "${item}" ; then
            if test "${script_option_GOON}" = 'yes' ; then
                mbfl_message_warning "unable to successfully decompress '${item}'"
            else
                mbfl_message_error "unable to successfully decompress '${item}'"
                exit_because_error_decompressing
            fi
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
