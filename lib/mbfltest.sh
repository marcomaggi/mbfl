# test.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: test functions
# Date: Mon Oct  4, 2004
# 
# Abstract
# 
#	This file defines a set of functions to be used to drive
#	the test suite. It must be sources at the beginning of
#	all the test files.
# 
# Copyright (c) 2004 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
# your option) any later version.
# 
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
# 
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA.
# 

#page
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

shopt -s expand_aliases

function dotest-echo-tmpdir () {
    echo "${TMPDIR:-/tmp}/dotest.$$"
}

for item in verbose debug test ; do
    eval function dotest-set-$item \(\) \
	\{ function dotest-option-$item \(\) \{ true\;  \}\; \}
    eval function dotest-unset-$item \(\) \
	\{ function dotest-option-$item \(\) \{ false\; \}\; \}
	dotest-unset-$item
done

alias dotest-echo='dotest-p-echo ${FUNCNAME}'
function dotest-p-echo () {
    local name="$1"
    shift
    echo "$name: $@" >&2
}
alias dotest-debug='dotest-p-debug ${FUNCNAME}'
function dotest-p-debug () {
    local name="$1"
    shift
    dotest-option-debug && echo "*** $name ***: $@" >&2
}
#page
function dotest-set-report-start () {
    function dotest-option-report-start () { true; }
}
function dotest-unset-report-start () {
    function dotest-option-report-start () { false; }
}
dotest-unset-report-start

function dotest-set-report-success () {
    function dotest-option-report-success () { true; }
}
function dotest-unset-report-success () {
    function dotest-option-report-success () { false; }
}
dotest-set-report-success
#page
function dotest-output () {
    local expected_output="$1"
    local output= line=l ORGIFS="${IFS}" globmode=0 expected_output_len


    expected_output_len=${#expected_output}
    if test "${expected_output:$((${expected_output_len}-1)):1}" = "*" ; then
	globmode=1
	expected_output="${expected_output:0:$((${expected_output_len}-1))}"
	expected_output_len=${#expected_output}
    fi

    IFS=""
    while read -r -t 4 line; do
	if test -z "${output}"; then
	    output="$line"
	else
	    output="$output\n$line"
	fi
    done
    IFS="${ORGIFS}"

    if test -z "${expected_output}" ; then
	if test ! -z "${output}" ; then
	    echo "   expected output of zero length" >&2
	    echo "   got:      '$output'" >&2
	    return 1
	fi
    else
	if test \
	    \( $globmode = 0 -a "${expected_output}" != "${output}" \) -o  \
	    \( $globmode = 1 -a \
               "${expected_output}" != "${output:0:${expected_output_len}}" \) ; then
	    echo "   expected: '$expected_output'" >&2
	    echo "   got:      '$output'" >&2
	    return 1
	fi
    fi
    return 0
}
#page
function dotest () {
    local PATTERN="${1:?missing test function pattern parameter to ${FUNCNAME}}"
    local FUNCTIONS; declare -a FUNCTIONS
    local name= item= result=
    local i=0
    local ORGPWD="$PWD"


    PATTERN="${TESTMATCH:-${PATTERN}}"

    for item in `compgen -A function "${PATTERN}"` ; do
        # When a single test function name is selected, "$item" is equal
        # to "$PATTERN", then here "name" is set to the empty string.

	let ++dotest_TEST_NUMBER
	name="${item##${PATTERN}}"
	if test -n "${name}" -o "${item}" = "${PATTERN}" ; then
	    item="${PATTERN}${name}"
	    dotest-option-report-start && \
		dotest-echo "${item} -- start"
	    if result=`"${item}"` ; then
		dotest-option-report-success && \
		    dotest-echo "${item} -- success"
	    else
		dotest-echo "${item} -- *** FAILED ***"
		dotest_TEST_FAILED="${dotest_TEST_FAILED} ${item}"
		let ++dotest_TEST_FAILED_NUMBER
	    fi
	    test -n "$result" && {
		echo "$result" >&2
		echo >&2
	    }
	    dotest-cd "${ORGPWD}"
	fi
    done

    return 0
}
#page
function dotest-equal () {
    local expected="$1"
    local got="$2"

    if test "$expected" != "$got" ; then
	echo "   expected: '$expected'" >&2
	echo "   got:      '$got'" >&2
	return 1
    fi
}
#page
function dotest-cd-tmpdir () {
    cd "$(dotest-echo-tmpdir)" &>/dev/null
    test -n "$1" -a -d "$1" && cd "$1" &>/dev/null
    dotest-option-verbose && dotest-echo "current directory: '$PWD'"
}
function dotest-cd () {
    local DIRNAME="${1:?missing directory parameter to ${FUNCNAME}}"
    cd "${DIRNAME}"
    dotest-option-verbose && dotest-echo "current directory: '$PWD'"
}
function dotest-mktmpdir () {
    dotest-program-mkdir "$(dotest-echo-tmpdir)"
}
function dotest-mkdir () {
    local NAME="${1:?missing directory name parameter to ${FUNCNAME}}"
    local PREFIX="$2"

    if test -n "${PREFIX}" ; then
	PREFIX="$(dotest-echo-tmpdir)/${PREFIX}"
    else
	PREFIX="$(dotest-echo-tmpdir)"
    fi

    NAME="${PREFIX}/${NAME}"
    dotest-program-mkdir "${NAME}"
    echo "${NAME}"
}
function dotest-mkfile () {
    local NAME="${1:?missing file name parameter to ${FUNCNAME}}"
    local PREFIX="$2"

    if test -n "${PREFIX}" ; then
	PREFIX="$(dotest-echo-tmpdir)/${PREFIX}"
    else
	PREFIX="$(dotest-echo-tmpdir)"
    fi
    NAME="${PREFIX}/${NAME}"
    dotest-option-verbose && dotest-echo "creating file '$NAME'"

    dotest-mktmpdir
    if dotest-option-test ; then
	echo echo \>"${NAME}"
    else
	echo >"${NAME}" || {
	    dotest-clean-files
	    exit 2
	}
    fi
    echo "${NAME}"
}
function dotest-clean-files () {
    local result=$?
    dotest-program-rm "$(dotest-echo-tmpdir)"
    return $result
}
#page
function dotest-program-mkdir () {
    dotest-option-verbose && FLAGS="--verbose"
    dotest-program-exec /bin/mkdir --parents $FLAGS --mode=0700 "$@" >&2 || {
	dotest-clean-files
	exit 2
    }
}
function dotest-program-rm () {
    dotest-option-verbose && FLAGS="--verbose"
    dotest-program-exec /bin/rm --force --recursive $FLAGS "$@" >&2
}
function dotest-program-exec () {
    if dotest-option-test ; then
	echo "$@"
    else
	"$@" || {
	    dotest-clean-files
	    exit 2
	}
    fi
}
#page
trap dotest-final-report EXIT

test -z ${dotest_TEST_NUMBER} && declare -i dotest_TEST_NUMBER=0
test -z ${dotest_TEST_FAILED_NUMBER} && declare -i dotest_TEST_FAILED_NUMBER=0
test -z ${dotest_TEST_FAILED} && dotest_TEST_FAILED=

function dotest-final-report () {
    local item=

    echo
    echo "Test file '$0'"
    echo "Number of executed tests: ${dotest_TEST_NUMBER}"
    echo "Number of failed tests:   ${dotest_TEST_FAILED_NUMBER}"
    test -n "${dotest_TEST_FAILED}" && {
	echo "Failed tests:"
	for item in ${dotest_TEST_FAILED} ; do
	    echo "   ${item}" >&2
	done
    }
    echo

    dotest-clean-files
}

### end of file
# Local Variables:
# mode: sh
# End:
