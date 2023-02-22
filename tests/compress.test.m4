# compress.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the compress.sh example script
# Date: Tue Aug 16, 2005
#
# Abstract
#
#	To select the tests in this file:
#
#		$ TESTMATCH=compress- make all test
#
# Copyright (c) 2005, 2012, 2013, 2018, 2020, 2023 Marco Maggi
# <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#


#### setup

mbfl_load_library("$MBFL_TESTS_LIBMBFL_CORE")
mbfl_load_library("$MBFL_TESTS_LIBMBFL_TEST")

function compress () {
    local -r examplesdir=${examplesdir:?'missing examplesdir in the environment'}

    if false
    then "$BASH" examples/compress.sh --debug -v "$@"
    else "$BASH" examples/compress.sh "$@"
    fi
}

# These functions access uplevel variables.
function sub-compress-assert-after-compression () {
    sub-compress-assert-unexistent-original && sub-compress-assert-existent-compressed
}
function sub-compress-assert-after-decompression () {
    sub-compress-assert-existent-original && sub-compress-assert-unexistent-compressed
}

function sub-compress-assert-unexistent-original () {
    dotest-assert-file-unexists "$original" 'original file still exists'
}
function sub-compress-assert-unexistent-compressed () {
    dotest-assert-file-unexists "$compressed" 'compressed file still exists'
}
function sub-compress-assert-existent-original () {
    dotest-assert-file-exists "$original" 'original file does not exist'
}
function sub-compress-assert-existent-compressed () {
    dotest-assert-file-exists "$compressed" 'compressed file does not exist'
}



function compress-gzip-compress-1.1 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.gz"

    mbfl_file_enable_remove
    compress --compress "$original"
    sub-compress-assert-after-compression
    dotest-clean-files
}
function compress-gzip-compress-1.2 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.gz"

    mbfl_file_enable_remove
    compress --keep --compress "$original"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}
function compress-gzip-compress-1.3 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.gz"

    mbfl_file_enable_remove
    compress --stdout --compress "$original" >"$compressed"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}



function compress-gzip-decompress-2.1 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.gz"

    compress --compress "$original"
    sub-compress-assert-after-compression || dotest-clean-files
    compress --decompress "$compressed"
    sub-compress-assert-after-decompression
    dotest-clean-files
}
function compress-gzip-decompress-2.2 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.gz"

    compress --compress "$original"
    sub-compress-assert-after-compression || dotest-clean-files
    compress --keep --decompress "$compressed"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}
function compress-gzip-decompress-2.3 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.gz"

    compress --compress "$original"
    sub-compress-assert-after-compression || dotest-clean-files
    compress --stdout --decompress "$compressed" >"$original"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}



function compress-bzip-compress-1.1 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.bz2"

    mbfl_file_enable_remove
    compress --bzip --compress "$original"
    sub-compress-assert-after-compression
    dotest-clean-files
}
function compress-bzip-compress-1.2 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.bz2"

    mbfl_file_enable_remove
    compress --bzip --keep --compress "$original"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}
function compress-bzip-compress-1.3 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.bz2"

    mbfl_file_enable_remove
    compress --bzip --stdout --compress "$original" >"$compressed"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}



function compress-bzip-decompress-2.1 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.bz2"
    local result=

    compress --bzip --compress "$original"
    sub-compress-assert-after-compression || dotest-clean-files
    compress --decompress "$compressed"
    sub-compress-assert-after-decompression
    dotest-clean-files
}
function compress-bzip-decompress-2.2 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.bz2"

    compress --bzip --compress "$original"
    sub-compress-assert-after-compression || dotest-clean-files
    compress --keep --decompress "$compressed"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}
function compress-bzip-decompress-2.3 () {
    dotest-mktmpdir
    local original=$(dotest-mkfile file.ext)
    local compressed="${original}.bz2"

    compress --bzip --compress "$original"
    sub-compress-assert-after-compression || dotest-clean-files
    compress --stdout --decompress "$compressed" >"$original"
    sub-compress-assert-existent-original && sub-compress-assert-existent-compressed
    dotest-clean-files
}


#### let's go

dotest compress-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
