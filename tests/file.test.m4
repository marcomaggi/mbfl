# file.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for file module
# Date: Sun Apr 20, 2003
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=file-
#
#	that will select these tests.
#
# Copyright (c) 2003, 2004, 2005, 2009, 2013, 2018, 2020, 2023, 2024 Marco Maggi
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

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)

testfile="$TMPDIR/proof.txt"


#### file name functions: internal parsing utilities

function file-backwards-looking-at-double-dot-1.1 () {
    #                                            01234567890
    mbfl_p_file_backwards_looking_at_double_dot '/path/to/..' 10
}
function file-backwards-looking-at-double-dot-1.2 () {
    #                                            01
    mbfl_p_file_backwards_looking_at_double_dot '..' 1
}
function file-backwards-looking-at-double-dot-1.3 () {
    ! mbfl_p_file_backwards_looking_at_double_dot '.' 0
}
function file-backwards-looking-at-double-dot-1.4 () {
    ! mbfl_p_file_backwards_looking_at_double_dot '/.' 1
}
function file-backwards-looking-at-double-dot-1.5 () {
    ! mbfl_p_file_backwards_looking_at_double_dot 'a.' 1
}
function file-backwards-looking-at-double-dot-1.6 () {
    ! mbfl_p_file_backwards_looking_at_double_dot 'a..' 1
}

### --------------------------------------------------------------------

function file-looking-at-component-beginning-1.1.1 () {
    mbfl_p_file_looking_at_component_beginning 'file.ext' 0
}
function file-looking-at-component-beginning-1.1.2 () {
    ! mbfl_p_file_looking_at_component_beginning 'file.ext' 1
}
function file-looking-at-component-beginning-1.2.1 () {
    #                                           01234567890123456
    mbfl_p_file_looking_at_component_beginning '/path/to/file.ext' 9
}
function file-looking-at-component-beginning-1.2.2 () {
    #                                             01234567890123456
    ! mbfl_p_file_looking_at_component_beginning '/path/to/file.ext' 10
}
function file-looking-at-component-beginning-1.3 () {
    #                                             01234567890123456
    ! mbfl_p_file_looking_at_component_beginning '/path/to/file.ext' 8
}


#### file name functions: extension

file-extension-1.1 () {
    mbfl_file_extension /path/to/file.ext | dotest-output ext
}
file-extension-1.2 () {
    mbfl_file_extension /path/to/file. | dotest-output
}
file-extension-1.3 () {
    mbfl_file_extension /path/to/file | dotest-output
}
file-extension-1.4 () {
    mbfl_file_extension /path/to/file.ext/ab | dotest-output
}
file-extension-1.5 () {
    mbfl_file_extension /path/to/some.file.ext | dotest-output ext
}
file-extension-1.6 () {
    mbfl_file_extension a | dotest-output
}
file-extension-1.7 () {
    mbfl_file_extension /path/to/.file.ext | dotest-output ext
}
file-extension-1.8 () {
    mbfl_file_extension /path/to/.dotfile | dotest-output
}
file-extension-1.8 () {
    mbfl_file_extension .dotfile | dotest-output
}

### --------------------------------------------------------------------

file-extension-var-1.1 () {
    local RV
    mbfl_file_extension_var RV /path/to/file.ext
    dotest-equal 'ext' "$RV"
}
file-extension-var-1.2 () {
    local RV
    mbfl_file_extension_var RV /path/to/file.
    dotest-equal '' "$RV"
}
file-extension-var-1.3 () {
    local RV
    mbfl_file_extension_var RV /path/to/file
    dotest-equal '' "$RV"
}
file-extension-var-1.4 () {
    local RV
    mbfl_file_extension_var RV /path/to/file.ext/ab
    dotest-equal '' "$RV"
}
file-extension-var-1.5 () {
    local RV
    mbfl_file_extension_var RV /path/to/some.file.ext
    dotest-equal 'ext' "$RV"
}
file-extension-var-1.6 () {
    local RV
    mbfl_file_extension_var RV a
    dotest-equal '' "$RV"
}
file-extension-var-1.7 () {
    local RV
    mbfl_file_extension_var RV /path/to/.file.ext
    dotest-equal 'ext' "$RV"
}
file-extension-var-1.8 () {
    local RV
    mbfl_file_extension_var RV /path/to/.dotfile
    dotest-equal '' "$RV"
}
file-extension-var-1.9 () {
    local RV
    mbfl_file_extension_var RV .dotfile
    dotest-equal '' "$RV"
}


#### file name functions: dirname

function file-dirname-1.1 () {
    mbfl_file_dirname /path/to/file.ext | dotest-output '/path/to'
}
function file-dirname-1.2 () {
    mbfl_file_dirname file.ext | dotest-output .
}
function file-dirname-1.3 () {
    mbfl_file_dirname /file.ext | dotest-output /
}
function file-dirname-1.4 () {
    mbfl_file_dirname //file.ext | dotest-output /
}
function file-dirname-1.5 () {
    mbfl_file_dirname /path/to///file.ext | dotest-output '/path/to'
}
function file-dirname-1.6 () {
    mbfl_file_dirname //////file.ext | dotest-output '/'
}
function file-dirname-1.7 () {
    mbfl_file_dirname a/b | dotest-output 'a'
}
function file-dirname-1.8 () {
    mbfl_file_dirname a | dotest-output '.'
}
function file-dirname-1.9 () {
    mbfl_file_dirname ../a | dotest-output '..'
}
function file-dirname-1.10 () {
    mbfl_file_dirname ./a | dotest-output '.'
}
function file-dirname-1.11 () {
    mbfl_file_dirname ../abcd | dotest-output '..'
}
function file-dirname-1.12 () {
    mbfl_file_dirname ./abcd | dotest-output '.'
}
function file-dirname-1.13 () {
    mbfl_file_dirname ../abcd/efgh | dotest-output '../abcd'
}
function file-dirname-1.14 () {
    mbfl_file_dirname ./abcd/efgh | dotest-output './abcd'
}

### --------------------------------------------------------------------

function file-dirname-var-1.1 () {
    local RV
    mbfl_file_dirname_var RV /path/to/file.ext
    dotest-equal '/path/to' "$RV"
}
function file-dirname-var-1.2 () {
    local RV
    mbfl_file_dirname_var RV file.ext
    dotest-equal . "$RV"
}
function file-dirname-var-1.3 () {
    local RV
    mbfl_file_dirname_var RV /file.ext
    dotest-equal / "$RV"
}
function file-dirname-var-1.4 () {
    local RV
    mbfl_file_dirname_var RV //file.ext
    dotest-equal / "$RV"
}
function file-dirname-var-1.5 () {
    local RV
    mbfl_file_dirname_var RV /path/to///file.ext
    dotest-equal '/path/to' "$RV"
}
function file-dirname-var-1.6 () {
    local RV
    mbfl_file_dirname_var RV //////file.ext
    dotest-equal '/' "$RV"
}
function file-dirname-var-1.7 () {
    local RV
    mbfl_file_dirname_var RV a/b
    dotest-equal 'a' "$RV"
}
function file-dirname-var-1.8 () {
    local RV
    mbfl_file_dirname_var RV a
    dotest-equal '.' "$RV"
}
function file-dirname-var-1.9 () {
    local RV
    mbfl_file_dirname_var RV ../a
    dotest-equal '..' "$RV"
}
function file-dirname-var-1.10 () {
    local RV
    mbfl_file_dirname_var RV ./a
    dotest-equal '.' "$RV"
}
function file-dirname-var-1.11 () {
    local RV
    mbfl_file_dirname_var RV ../abcd
    dotest-equal '..' "$RV"
}
function file-dirname-var-1.12 () {
    local RV
    mbfl_file_dirname_var RV ./abcd
    dotest-equal '.' "$RV"
}
function file-dirname-var-1.13 () {
    local RV
    mbfl_file_dirname_var RV ../abcd/efgh
    dotest-equal '../abcd' "$RV"
}
function file-dirname-var-1.14 () {
    local RV
    mbfl_file_dirname_var RV ./abcd/efgh
    dotest-equal './abcd' "$RV"
}


#### file name functions: rootname

function file-rootname-1.1 () {
    mbfl_file_rootname '/path/to/file.ext' | dotest-output '/path/to/file'
}
function file-rootname-1.2 () {
    mbfl_file_rootname /path/to/file | dotest-output '/path/to/file'
}
function file-rootname-1.3 () {
    mbfl_file_rootname /path/to.to/file | dotest-output '/path/to.to/file'
}
function file-rootname-1.4.1 () {
    mbfl_file_rootname .dotfile | dotest-output '.dotfile'
}
function file-rootname-1.4.2 () {
    mbfl_file_rootname /path/to/.dotfile | dotest-output /path/to/.dotfile
}
function file-rootname-1.4.3 () {
    mbfl_file_rootname .dotfile.ext | dotest-output '.dotfile'
}
function file-rootname-1.5 () {
    mbfl_file_rootname a | dotest-output 'a'
}
function file-rootname-1.6 () {
    mbfl_file_rootname '/' | dotest-output '/'
}
function file-rootname-1.7 () {
    mbfl_file_rootname '.' | dotest-output '.'
}
function file-rootname-1.8 () {
    mbfl_file_rootname '..' | dotest-output '..'
}
function file-rootname-1.9 () {
    mbfl_file_rootname 'file.ext' | dotest-output 'file'
}
function file-rootname-1.10 () {
    mbfl_file_rootname '/path/to/file..ext' | dotest-output '/path/to/file.'
}
function file-rootname-1.11 () {
    #                   012345678901234567
    mbfl_file_rootname '/path/to/file.ext/' | dotest-output '/path/to/file'
}
function file-rootname-1.12 () {
    mbfl_file_rootname '/path/to/file.ext///' | dotest-output '/path/to/file'
}

### --------------------------------------------------------------------

function file-rootname-var-1.1 () {
    local RV
    mbfl_file_rootname_var RV /path/to/file.ext
    dotest-equal '/path/to/file' "$RV"
}
function file-rootname-var-1.2 () {
    local RV
    mbfl_file_rootname_var RV /path/to/file
    dotest-equal '/path/to/file' "$RV"
}
function file-rootname-var-1.3 () {
    local RV
    mbfl_file_rootname_var RV /path/to.to/file
    dotest-equal '/path/to.to/file' "$RV"
}
function file-rootname-var-1.4.1 () {
    local RV
    mbfl_file_rootname_var RV .dotfile
    dotest-equal '.dotfile' "$RV"
}
function file-rootname-var-1.4.2 () {
    local RV
    mbfl_file_rootname_var RV /path/to/.dotfile
    dotest-equal '/path/to/.dotfile' "$RV"
}
function file-rootname-var-1.4.3 () {
    local RV
    mbfl_file_rootname_var RV .dotfile.ext
    dotest-equal '.dotfile' "$RV"
}
function file-rootname-var-1.5 () {
    local RV
    mbfl_file_rootname_var RV a
    dotest-equal 'a' "$RV"
}
function file-rootname-var-1.6 () {
    local RV
    mbfl_file_rootname_var RV '/'
    dotest-equal '/' "$RV"
}
function file-rootname-var-1.7 () {
    local RV
    mbfl_file_rootname_var RV '.'
    dotest-equal '.' "$RV"
}
function file-rootname-var-1.8 () {
    local RV
    mbfl_file_rootname_var RV '..'
    dotest-equal '..' "$RV"
}
function file-rootname-var-1.9 () {
    local RV
    mbfl_file_rootname_var RV 'file.ext'
    dotest-equal 'file' "$RV"
}
function file-rootname-var-1.10 () {
    local RV
    mbfl_file_rootname_var RV '/path/to/file..ext'
    dotest-equal '/path/to/file.' "$RV"
}
function file-rootname-var-1.11 () {
    local RV
    mbfl_file_rootname_var RV '/path/to/file.ext/'
    dotest-equal '/path/to/file' "$RV"
}
function file-rootname-var-1.12 () {
    local RV
    mbfl_file_rootname_var RV '/path/to/file.ext///'
    dotest-equal '/path/to/file' "$RV"
}


#### file name functions: tailname

function file-tail-1.1 () {
    mbfl_file_tail /path/to/file.ext | dotest-output 'file.ext'
}
function file-tail-1.2 () {
    mbfl_file_tail /path/to/ | dotest-output
}
function file-tail-1.3 () {
    mbfl_file_tail file.ext | dotest-output 'file.ext'
}

### --------------------------------------------------------------------

function file-tail-var-1.1 () {
    local RV
    mbfl_file_tail_var RV /path/to/file.ext
    dotest-equal 'file.ext' "$RV"
}
function file-tail-var-1.2 () {
    local RV
    mbfl_file_tail_var RV /path/to/
    dotest-equal '' "$RV"
}
function file-tail-var-1.3 () {
    local RV
    mbfl_file_tail_var RV file.ext
    dotest-equal 'file.ext' "$RV"
}


#### file name functions: split

function file-split-1.1 () {
    local -a SPLITPATH
    local -i SPLITCOUNT

    mbfl_file_split /path/to/file.ext
    dotest-equal path "${SPLITPATH[0]}" && \
        dotest-equal to "${SPLITPATH[1]}" && \
        dotest-equal file.ext "${SPLITPATH[2]}" &&\
	dotest-equal 3 $SPLITCOUNT
}
function file-split-1.2 () {
    local -a SPLITPATH
    local -i SPLITCOUNT

    mbfl_file_split a
    dotest-equal a "${SPLITPATH[0]}" && \
    	dotest-equal 1 $SPLITCOUNT
}
function file-split-1.3 () {
    local -a SPLITPATH
    local -i SPLITCOUNT

    mbfl_file_split ///path///////////to/file.ext
    dotest-equal path "${SPLITPATH[0]}" && \
        dotest-equal to "${SPLITPATH[1]}" && \
        dotest-equal file.ext "${SPLITPATH[2]}" && \
	dotest-equal 3 $SPLITCOUNT
}


#### pathname normalisation: stripping trailing slashes

function file-strip-trailing-slash-1.1 () {
    mbfl_file_strip_trailing_slash '/path/to/file.ext' | dotest-output '/path/to/file.ext'
}
function file-strip-trailing-slash-1.2 () {
    mbfl_file_strip_trailing_slash '/path/to/dir.ext/' | dotest-output '/path/to/dir.ext'
}
function file-strip-trailing-slash-1.3 () {
    mbfl_file_strip_trailing_slash '/path/to/dir.ext///' | dotest-output '/path/to/dir.ext'
}
function file-strip-trailing-slash-1.4 () {
    mbfl_file_strip_trailing_slash '/' | dotest-output '.'
}
function file-strip-trailing-slash-1.5 () {
    mbfl_file_strip_trailing_slash '///' | dotest-output '.'
}
function file-strip-trailing-slash-1.6 () {
    mbfl_file_strip_trailing_slash 'file' | dotest-output 'file'
}

### --------------------------------------------------------------------

function file-strip-trailing-slash-var-1.1 () {
    local RV
    mbfl_file_strip_trailing_slash_var RV '/path/to/file.ext'
    dotest-equal '/path/to/file.ext' "$RV"
}
function file-strip-trailing-slash-var-1.2 () {
    local RV
    mbfl_file_strip_trailing_slash_var RV '/path/to/dir.ext/'
    dotest-equal '/path/to/dir.ext' "$RV"
}
function file-strip-trailing-slash-var-1.3 () {
    local RV
    mbfl_file_strip_trailing_slash_var RV '/path/to/dir.ext///'
    dotest-equal '/path/to/dir.ext' "$RV"
}
function file-strip-trailing-slash-var-1.4 () {
    local RV
    mbfl_file_strip_trailing_slash_var RV '/'
    dotest-equal '.' "$RV"
}
function file-strip-trailing-slash-var-1.5 () {
    local RV
    mbfl_file_strip_trailing_slash_var RV '///'
    dotest-equal '.' "$RV"
}
function file-strip-trailing-slash-var-1.6 () {
    local RV
    mbfl_file_strip_trailing_slash_var RV 'file'
    dotest-equal 'file' "$RV"
}


#### pathname normalisation: stripping leading slashes

function file-strip-leading-slash-1.1 () {
    mbfl_file_strip_leading_slash '/path/to/file.ext' | dotest-output 'path/to/file.ext'
}
function file-strip-leading-slash-1.2 () {
    mbfl_file_strip_leading_slash '/path/to/dir.ext/' | dotest-output 'path/to/dir.ext/'
}
function file-strip-leading-slash-1.3 () {
    mbfl_file_strip_leading_slash '///path/to/dir.ext' | dotest-output 'path/to/dir.ext'
}
function file-strip-leading-slash-1.4 () {
    mbfl_file_strip_leading_slash '/' | dotest-output '.'
}
function file-strip-leading-slash-1.5 () {
    mbfl_file_strip_leading_slash '///' | dotest-output '.'
}
function file-strip-leading-slash-1.6 () {
    mbfl_file_strip_leading_slash 'file' | dotest-output 'file'
}

### --------------------------------------------------------------------

function file-strip-leading-slash-var-1.1 () {
    local RV
    mbfl_file_strip_leading_slash_var RV '/path/to/file.ext'
    dotest-equal 'path/to/file.ext' "$RV"
}
function file-strip-leading-slash-var-1.2 () {
    local RV
    mbfl_file_strip_leading_slash_var RV '/path/to/dir.ext/'
    dotest-equal 'path/to/dir.ext/' "$RV"
}
function file-strip-leading-slash-var-1.3 () {
    local RV
    mbfl_file_strip_leading_slash_var RV '///path/to/dir.ext/'
    dotest-equal 'path/to/dir.ext/' "$RV"
}
function file-strip-leading-slash-var-1.4 () {
    local RV
    mbfl_file_strip_leading_slash_var RV '/'
    dotest-equal '.' "$RV"
}
function file-strip-leading-slash-var-1.5 () {
    local RV
    mbfl_file_strip_leading_slash_var RV '///'
    dotest-equal '.' "$RV"
}
function file-strip-leading-slash-var-1.6 () {
    local RV
    mbfl_file_strip_leading_slash_var RV 'file'
    dotest-equal 'file' "$RV"
}


#### pathname normalisation: full normalisation

function file-normalise-1.1 () {
    local testdir
    testdir=$(dotest-mkdir a/b) || exit_because_failure

    {
	dotest-cd-tmpdir
	mbfl_file_normalise a/b
	dotest-clean-files
    } | dotest-output "${testdir}"
}
function file-normalise-1.2 () {
    mbfl_file_normalise /path/to/file.ext | dotest-output "/path/to/file.ext"
}
function file-normalise-1.4 () {
    local testdir
    testdir=$(dotest-mkdir a/b) || exit_because_failure

    {
	dotest-cd-tmpdir
	mbfl_file_normalise "a/b/.."
	dotest-clean-files
    } | dotest-output "$(dotest-echo-tmpdir)/a"
}
function file-normalise-1.5 () {
    local testdir=`dotest-mkdir a/b/c`

    {
	dotest-cd-tmpdir
	mbfl_file_normalise "a/./b/./c"
	dotest-clean-files
    } | dotest-output "${testdir}"
}
function file-normalise-1.6 () {
    local testdir=`dotest-mkdir a/b/c`

    {
	dotest-cd-tmpdir
	mbfl_file_normalise "a/b/c/../.."
	dotest-clean-files
    } | dotest-output "$(dotest-echo-tmpdir)/a"
}
function file-normalise-1.7 () {
    local testdir=`dotest-mkdir a/b`

    {
	dotest-cd-tmpdir a/b
	mbfl_file_normalise ../b
	dotest-clean-files
    } | dotest-output "${testdir}"
}

### --------------------------------------------------------------------

function file-normalise-2.3 () {
    mbfl_file_normalise a/b wo | dotest-output wo/a/b
}
function file-normalise-2.4 () {
    mbfl_file_normalise X/../Y abc/def/ghi/lmn/opq/rst | \
	dotest-output abc/def/ghi/lmn/opq/rst/Y
}
function file-normalise-2.5 () {
    mbfl_file_normalise X/Y/../Y abc/def/ghi/lmn/opq/rst | \
	dotest-output abc/def/ghi/lmn/opq/rst/X/Y
}
function file-normalise-2.6 () {
    mbfl_file_normalise X/Y/../Y abc/def/ghi/../lmn/opq/rst | \
	dotest-output abc/def/lmn/opq/rst/X/Y
}


#### pathname normalisation: realpath
#
# We run these tests  only if an executable "realpath" is found  at package configuration-time.  For
# some reason  I cannot figure out:  the Ubuntu installation at  Travis CI may not  have a reachable
# "realpath".  (Marco Maggi; Sep 23, 2020)
#

if mbfl_file_is_executable "$mbfl_PROGRAM_REALPATH"
then

    function file-realpath-1.1 () {
	declare TESTPATH
	TESTPATH=$(dotest-mkdir a/b) || exit_because_failure

	mbfl_file_enable_realpath

	{
	    dotest-cd-tmpdir
	    mbfl_file_realpath a/b
	    dotest-clean-files
	} | dotest-output "$TESTPATH"
    }

    # Try realpath on a file that does not exist.
    #
    function file-realpath-1.2 () {
	mbfl_file_enable_realpath
	! mbfl_file_realpath a/b/c --quiet
    }

### --------------------------------------------------------------------

    function file-realpath-var-1.1 () {
	declare TESTPATH
	TESTPATH=$(dotest-mkdir a/b) || exit_because_failure
	declare RV

	mbfl_file_enable_realpath

	dotest-cd-tmpdir
	mbfl_file_realpath_var RV a/b
	dotest-clean-files
	dotest-equal "$TESTPATH" "$RV"
    }

fi


#### relative pathnames: extracting subpathnames

function file-subpathname-1.1 () {
    mbfl_file_subpathname /a /a | dotest-output ./
}

function file-subpathname-2.1 () {
    mbfl_file_subpathname /a/b/c /a/ | dotest-output ./b/c
}

function file-subpathname-2.2 () {
    mbfl_file_subpathname /a/b/c /a | dotest-output ./b/c
}

function file-subpathname-3.1 () {
    ! mbfl_file_subpathname /a/b/c /d
}

### --------------------------------------------------------------------

function file-subpathname-var-1.1 () {
    local RV
    mbfl_file_subpathname_var RV /a /a
    dotest-equal ./ "$RV"
}

function file-subpathname-var-2.1 () {
    local RV
    mbfl_file_subpathname_var RV /a/b/c /a/
    dotest-equal ./b/c "$RV"
}

function file-subpathname-var-2.2 () {
    local RV
    mbfl_file_subpathname_var RV /a/b/c /a
    dotest-equal ./b/c "$RV"
}

function file-subpathname-var-3.1 () {
    local RV
    ! mbfl_file_subpathname_var RV /a/b/c /d
}


#### removing files and directories

function file-remove-1.1 () {
    dotest-mktmpdir
    local name result
    name=$(dotest-mkfile file.ext) || exit_because_failure

    mbfl_file_enable_remove
    mbfl_file_remove_file "$name"
    test ! -f "$name"
    dotest-clean-files
}
function file-remove-1.2 () {
    local name result
    name=$(dotest-mkdir dir.d) || exit_because_failure

    mbfl_file_enable_remove
    mbfl_file_remove_directory "$name"
    test ! -d "$name"
    dotest-clean-files
}
function file-remove-1.3 () {
    dotest-mktmpdir
    local name
    name=$(dotest-mkfile file.ext) || exit_because_failure

    mbfl_file_enable_remove
    mbfl_file_remove "$name"
    test ! -e "$name"
    dotest-clean-files
}
function file-remove-1.4 () {
    dotest-mktmpdir
    local name
    name=$(dotest-mkfile file.ext) || exit_because_failure

    mbfl_file_enable_remove
    mbfl_file_remove "$name"
    test ! -e "$name"
    dotest-clean-files
}


#### creating directories

function file-mkdir-1.1 () {
    local name="$(dotest-echo-tmpdir)/dir.d"

    mbfl_file_enable_make_directory
    mbfl_file_make_directory "$name"
    dotest-clean-files
}


#### creating links

function file-link-1.1 () {
    dotest-mktmpdir
    local ORIGINAL_NAME LINK_NAME
    ORIGINAL_NAME=$(dotest-mkfile file.ext) || exit_because_failure
    LINK_NAME=$(dotest-mkpathname link.ext) || exit_because_failure

    mbfl_file_enable_symlink
    mbfl_file_link "$ORIGINAL_NAME" "$LINK_NAME"
    mbfl_file_is_file "$ORIGINAL_NAME" && mbfl_file_is_file "$LINK_NAME"
    dotest-clean-files
}

function file-symlink-1.1 () {
    dotest-mktmpdir
    local ORIGINAL_NAME LINK_NAME
    ORIGINAL_NAME=$(dotest-mkfile file.ext)    || exit_because_failure
    LINK_NAME=$(dotest-mkpathname symlink.ext) || exit_because_failure

    mbfl_file_enable_symlink
    mbfl_file_symlink "$ORIGINAL_NAME" "$LINK_NAME"
    mbfl_file_is_file "$ORIGINAL_NAME" && mbfl_file_is_symlink "$LINK_NAME"
    dotest-clean-files
}


#### file system inspection: file owner

function file-owner-1.1 () {
    local name
    name=$(dotest-mkfile file.ext) || exit_because_failure

    mbfl_file_enable_owner_and_group
    {
	mbfl_file_get_owner "$name"
	dotest-clean-files
    } | dotest-output $USER
}

### --------------------------------------------------------------------

function file-owner-var-1.1 () {
    local name RV
    name=$(dotest-mkfile file.ext) || exit_because_failure

    mbfl_file_enable_owner_and_group
    mbfl_file_get_owner_var RV "$name"
    dotest-clean-files
    dotest-equal "$USER" "$RV"
}


#### file system inspection: file size

function file-size-1.1 () {
    local PATHNAME
    PATHNAME=$(dotest-mkfile file.ext) || exit_because_failure

    echo -n 0123456789 >"${PATHNAME}"
    mbfl_file_enable_stat
    {
	mbfl_file_get_size "${PATHNAME}"
	dotest-clean-files
    } | dotest-output 10
}

### --------------------------------------------------------------------

function file-size-var-1.1 () {
    local PATHNAME RV
    PATHNAME=$(dotest-mkfile file.ext) || exit_because_failure

    echo -n 0123456789 >"${PATHNAME}"
    mbfl_file_enable_stat
    mbfl_file_get_size_var RV "${PATHNAME}"
    dotest-clean-files
    dotest-equal 10 "$RV"
}


#### predicates

file-is-file-1.1 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    mbfl_file_is_file "${PATHNAME}"
    result=$?
    dotest-clean-files
    return $result
}
file-is-file-1.2 () {
    mbfl_file_is_file a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a file: \"a\""
}

# ------------------------------------------------------------

file-is-readable-1.1 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    mbfl_file_is_readable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-is-readable-1.2 () {
    mbfl_file_is_readable a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a file: \"a\""
}
file-is-readable-1.3 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    chmod u-r "${PATHNAME}"
    mbfl_file_is_readable "${PATHNAME}" print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not readable: \"${PATHNAME}\""
    result=$?; dotest-clean-files; return $result
}

# ------------------------------------------------------------

file-is-writable-1.1 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    mbfl_file_is_writable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-is-writable-1.2 () {
    mbfl_file_is_writable a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a file: \"a\""
}
file-is-writable-1.3 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    chmod u-w "${PATHNAME}"
    mbfl_file_is_writable "${PATHNAME}" print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not writable: \"${PATHNAME}\""
    result=$?; dotest-clean-files; return $result
}

# ------------------------------------------------------------

file-is-executable-1.1 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    chmod u+x "${PATHNAME}"
    mbfl_file_is_executable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-is-executable-1.2 () {
    mbfl_file_is_executable a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a file: \"a\""
}
file-is-executable-1.3 () {
    local PATHNAME result
    PATHNAME=$(dotest-mkfile pathname) || exit  $?

    chmod u-x "${PATHNAME}"
    mbfl_file_is_executable "${PATHNAME}" print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not executable: \"${PATHNAME}\""
    result=$?; dotest-clean-files; return $result
}

# ------------------------------------------------------------

file-is-directory-1.1 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    mbfl_file_is_directory "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-is-directory-1.2 () {
    mbfl_file_is_directory a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a directory: \"a\""
}

# ------------------------------------------------------------

file-directory-is-readable-1.1.1 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    mbfl_file_directory_is_readable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-directory-is-readable-1.1.2 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    mbfl_directory_is_readable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-directory-is-readable-1.2 () {
    mbfl_file_directory_is_readable a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a directory: \"a\""
}
file-directory-is-readable-1.3 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    chmod u-r "${PATHNAME}"
    mbfl_file_directory_is_readable "${PATHNAME}" print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not readable: \"${PATHNAME}\""
    chmod u+r "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}

# ------------------------------------------------------------

file-directory-is-writable-1.1.1 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    mbfl_file_directory_is_writable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-directory-is-writable-1.1.2 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    mbfl_directory_is_writable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-directory-is-writable-1.2 () {
    mbfl_file_directory_is_writable a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a directory: \"a\""
}
file-directory-is-writable-1.3 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    chmod u-w "${PATHNAME}"
    mbfl_file_directory_is_writable "${PATHNAME}" print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not writable: \"${PATHNAME}\""
    result=$?; dotest-clean-files; return $result
}

# ------------------------------------------------------------

file-directory-is-executable-1.1.1 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    chmod 0700 "${PATHNAME}"
    mbfl_file_directory_is_executable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-directory-is-executable-1.1.2 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    chmod 0700 "${PATHNAME}"
    mbfl_directory_is_executable "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}
file-directory-is-executable-1.2 () {
    mbfl_file_directory_is_executable a print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not a directory: \"a\""
}
file-directory-is-executable-1.3 () {
    local PATHNAME=$(dotest-mkdir pathname) result

    chmod u-x "${PATHNAME}"
    mbfl_file_directory_is_executable "${PATHNAME}" print_error 2>&1 | \
        dotest-output "<unknown>: error: the pathname is not executable: \"${PATHNAME}\""
    chmod u+x "${PATHNAME}"
    result=$?; dotest-clean-files; return $result
}


#### permissions

file-get-permissions-1.1 () {
    dotest-mktmpdir
    local PATHNAME MODE=0750
    PATHNAME=$(dotest-mkfile file.ext) || exit  $?

    chmod ${MODE} "${PATHNAME}"
    mbfl_file_enable_permissions
    {
	mbfl_file_get_permissions "$PATHNAME"
	dotest-clean-files
    } | dotest-output ${MODE}
}
file-get-permissions-2.1 () {
    dotest-mktmpdir
    local PATHNAME MODE=0750
    PATHNAME=$(dotest-mkfile file.ext) || exit  $?

    mbfl_file_enable_permissions
    mbfl_file_set_permissions ${MODE} "${PATHNAME}"
    {
	mbfl_file_get_permissions "${PATHNAME}"
	dotest-clean-files
    } | dotest-output ${MODE}
}


#### writing

file-write-1.1 () {
    dotest-mktmpdir
    local STRING="this string" CONTENT PATHNAME
    PATHNAME=$(dotest-mkfile file.ext) || exit  $?

    mbfl_file_write "${STRING}" "${PATHNAME}"
    CONTENT=$(<"${PATHNAME}")
    dotest-clean-files
    dotest-equal "${STRING}" "${CONTENT}"
}

file-append-1.1 () {
    dotest-mktmpdir
    local STRING="this string" CONTENT PATHNAME
    PATHNAME=$(dotest-mkfile file.ext) || exit  $?

    mbfl_file_write "${STRING}" "${PATHNAME}"
    mbfl_file_append " ${STRING}" "${PATHNAME}"
    CONTENT=$(<"${PATHNAME}")
    dotest-clean-files
    dotest-equal "${STRING} ${STRING}" "${CONTENT}"
}

file-read-1.1 () {
    dotest-mktmpdir
    local STRING="this string" CONTENT PATHNAME
    PATHNAME=$(dotest-mkfile file.ext) || exit  $?

    mbfl_file_write "${STRING}" "${PATHNAME}"
    CONTENT=$(mbfl_file_read "${PATHNAME}")
    dotest-clean-files
    dotest-equal "${STRING}" "${CONTENT}"
}


#### moving

function file-move-1.1 () {
    local src dst
    src=$(dotest-mkfile file.ext) || exit  $?
    dst=$(dotest-echo-tmpdir)/file2.ext || exit  $?

    mbfl_file_enable_move
    mbfl_file_move "${src}" "${dst}"
    test -f "${dst}" -a ! -f "${src}"
    dotest-equal 0 $?
    dotest-clean-files
}
function file-move-1.2 () {
    local src dst
    src=$(dotest-mkdir file.ext) || exit  $?
    dst=$(dotest-echo-tmpdir)/file2.ext || exit  $?

    mbfl_file_enable_move
    mbfl_file_move "${src}" "${dst}"
    test -d "${dst}" -a ! -e "${src}"
    dotest-equal 0 $?
    dotest-clean-files
}
function file-move-2.1 () {
    local src dst dir
    src=$(dotest-mkfile file.ext) || exit  $?
    dir=$(dotest-mkdir wap) || exit  $?
    dst=${dir}/file.ext

    mbfl_file_enable_move
    mbfl_file_move_to_directory "${src}" "${dir}"
    test -f "${dst}" -a ! -f "${src}"
    dotest-equal 0 $?
    dotest-clean-files
}
function file-move-2.2 () {
    local src dst dir
    src=$(dotest-mkdir file.ext) || exit  $?
    dir=$(dotest-mkdir wap) || exit  $?
    dst=${dir}/file.ext || exit  $?

    mbfl_file_enable_move
    mbfl_file_move_to_directory "${src}" "${dir}"
    test -d "${dst}" -a ! -e "${src}"
    dotest-equal 0 $?
    dotest-clean-files
}


#### copying

function file-copy-1.1 () {
    local src dst
    src=$(dotest-mkfile file.ext) || exit  $?
    dst=$(dotest-echo-tmpdir)/file2.ext || exit  $?

    mbfl_file_enable_copy
    mbfl_file_copy "${src}" "${dst}"
    test -f "${dst}" -a -f "${src}"
    dotest-equal 0 $?
    dotest-clean-files
}
function file-copy-2.1 () {
    local src dst dir
    src=$(dotest-mkfile file.ext) || exit  $?
    dir=$(dotest-mkdir wap) || exit  $?
    dst=${dir}/file.ext

    mbfl_file_enable_copy
    mbfl_file_copy_to_directory "${src}" "${dir}"
    test -f "${dst}" -a -f "${src}"
    dotest-equal 0 $?
    dotest-clean-files
}


#### file commands: interface to "stat"

function file-stat-1.1 () {
    local PATHNAME RESULT
    PATHNAME=$(dotest-mkfile file.ext) || exit  $?

    mbfl_file_enable_stat
    RESULT=$(mbfl_file_stat "$PATHNAME" --format='%F')
    dotest-equal 0 $? && dotest-equal regular $RESULT
    dotest-clean-files
}
function file-stat-1.2 () {
    local PATHNAME=/bin RESULT

    mbfl_file_enable_stat
    RESULT=$(mbfl_file_stat "${PATHNAME}" --format='%F')
    dotest-equal 0 $? && dotest-equal directory $RESULT
    dotest-clean-files
}


#### file permissions functions

function file-permissions-conversion-symbolic-to-octal-1.1 () {
    mbfl_file_symbolic_to_octal_permissions 'rwx' | dotest-output '7'
}
function file-permissions-conversion-symbolic-to-octal-1.2 () {
    mbfl_file_symbolic_to_octal_permissions 'r-x' | dotest-output '5'
}
function file-permissions-conversion-symbolic-to-octal-1.3 () {
    mbfl_file_octal_to_symbolic_permissions '7' | dotest-output 'rwx'
}
function file-permissions-conversion-symbolic-to-octal-1.4 () {
    mbfl_file_octal_to_symbolic_permissions '5' | dotest-output 'r-x'
}


#### let's go

dotest file-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
