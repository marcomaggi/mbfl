# mbfl-arch.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-arch library
# Date: Apr 10, 2023
#
# Abstract
#
#	This file must be executed with one among:
#
#		$ make all test TESTMATCH=mbfl-arch-
#		$ make all check TESTS=tests/mbfl-arch.test ; less tests/mbfl-arch.log
#
#	that will select these tests.
#
# Copyright (c) 2023 Marco Maggi
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

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_ARCH")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### command interfaces: tar

function mbfl-arch-tar-1.1 () {
    local rootdir arootdir brootdir tarfile
    rootdir=$(dotest-mkdir top) || exit_because_failure
    arootdir=$(dotest-mkdir top/a) || exit_because_failure
    brootdir=$(dotest-mkdir top/b) || exit_because_failure
    tarfile=$(dotest-mkfile a.tar) || exit_because_failure

    {
	dotest-mkdir "top/a/alpha" || exit_because_failure
	dotest-mkdir "top/a/beta" || exit_because_failure
	dotest-mkfile "top/a/alpha/file.ext" || exit_because_failure
	dotest-mkfile "top/a/beta/file.ext" || exit_because_failure
    } >/dev/null

    mbfl_file_enable_tar
    mbfl_tar_create_to_stdout "$arootdir" | \
	mbfl_tar_extract_from_stdin "$brootdir"
    dotest-program-exec diff --recursive "$arootdir" "$brootdir" | dotest-output
    dotest-clean-files
}
function mbfl-arch-tar-2.1 () {
    local rootdir arootdir brootdir tarfile
    rootdir=$(dotest-mkdir top) || exit_because_failure
    arootdir=$(dotest-mkdir top/a) || exit_because_failure
    brootdir=$(dotest-mkdir top/b) || exit_because_failure
    tarfile=$(dotest-mkfile a.tar) || exit_because_failure

    {
	dotest-mkdir "top/a/alpha" || exit_because_failure
	dotest-mkdir "top/a/beta" || exit_because_failure
	dotest-mkfile "top/a/alpha/file.ext" || exit_because_failure
	dotest-mkfile "top/a/beta/file.ext" || exit_because_failure
    } >/dev/null

    mbfl_file_enable_tar
    mbfl_tar_create_to_file "$arootdir" "${tarfile}"
    mbfl_tar_extract_from_stdin "$brootdir" <"${tarfile}"

    dotest-program-exec diff --recursive "$arootdir" "$brootdir" | dotest-output
    dotest-clean-files
}


#### file compression: gzip

# Keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-gzip-1.1 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.gz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_gzip
    mbfl_file_compress_keep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-gzip-1.2 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.gz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_gzip
    mbfl_file_compress_nokeep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# Keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-gzip-1.3 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.gz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_gzip
    mbfl_file_compress_keep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-gzip-1.4 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.gz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_gzip
    mbfl_file_compress_nokeep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}


#### file compression: bzip2

# Keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-bzip2-1.1 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.bz2) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_bzip2
    mbfl_file_compress_keep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-bzip2-1.2 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.bz2) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_bzip2
    mbfl_file_compress_nokeep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# Keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-bzip2-1.3 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.bz2) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_bzip2
    mbfl_file_compress_keep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-bzip2-1.4 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.bz2) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_bzip2
    mbfl_file_compress_nokeep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}


#### file compression: lzip

# Keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-lzip-1.1 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.lz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_lzip
    mbfl_file_compress_keep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-lzip-1.2 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.lz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_lzip
    mbfl_file_compress_nokeep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# Keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-lzip-1.3 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.lz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_lzip
    mbfl_file_compress_keep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-lzip-1.4 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.lz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_lzip
    mbfl_file_compress_nokeep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}


#### file compression: xz

# Keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-xz-1.1 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.xz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_xz
    mbfl_file_compress_keep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Print compressed data to stdout.
#
function mbfl-arch-compression-xz-1.2 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.xz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_xz
    mbfl_file_compress_nokeep
    mbfl_file_compress_stdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME" >"$COMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME" >"$UNCOMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# Keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-xz-1.3 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.xz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_xz
    mbfl_file_compress_keep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}

# No keep input file.  Write compressed data to a file.
#
function mbfl-arch-compression-xz-1.4 () {
    local UNCOMPRESSED_PATHNAME COMPRESSED_PATHNAME
    UNCOMPRESSED_PATHNAME=$(dotest-mkfile file.ext) || exit  $?
    COMPRESSED_PATHNAME=$(dotest-mkfile file.ext.xz) || exit  $?
    local retval input_text=0123456789 output_text

    mbfl_file_enable_compress
    mbfl_file_compress_select_xz
    mbfl_file_compress_nokeep
    mbfl_file_compress_nostdout

    echo $input_text >"$UNCOMPRESSED_PATHNAME"

    #mbfl_set_option_show_program

    mbfl_file_compress "$UNCOMPRESSED_PATHNAME"
    retval=$?
    if ((0 == retval))
    then
	mbfl_file_decompress "$COMPRESSED_PATHNAME"
	retval=$?
	if ((0 == retval))
	then
	    output_text=$(<"$UNCOMPRESSED_PATHNAME")
	    dotest-equal "$input_text" "$output_text"
	    retval=$?
	fi
    fi

    dotest-clean-files
    return $retval
}


#### let's go

dotest mbfl-arch-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
