# libmbfltest.sh --
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
# Copyright (c) 2004, 2005 Marco Maggi
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
## Shell configuration.
## ------------------------------------------------------------

shopt -s expand_aliases

mbfl_LOADED_MBFL_TEST='yes'

#page
## ------------------------------------------------------------
## Output messages.
## ------------------------------------------------------------

alias dotest-echo='dotest-p-echo ${FUNCNAME}'
function dotest-p-echo () {
    local name="$1"
    shift
    echo -e "$name: $@" >&2
}
alias dotest-debug='dotest-p-debug ${FUNCNAME}'
function dotest-p-debug () {
    local name="$1"
    shift
    dotest-option-debug && echo -e "*** $name ***: $@" >&2
}

#page
## ------------------------------------------------------------
## Configuration.
## ------------------------------------------------------------

function dotest-p-create-option-functions () {
    local item

    for item in verbose debug test report-start report-success ; do
        eval function dotest-set-$item \(\) \
            \{ function dotest-option-$item \(\) \{ true\;  \}\; \}
            eval function dotest-unset-$item \(\) \
                \{ function dotest-option-$item \(\) \{ false\; \}\; \}
                dotest-unset-$item
    done
}
dotest-p-create-option-functions

#page
## ------------------------------------------------------------
## Test execution.
## ------------------------------------------------------------

function dotest () {
    local PATTERN="${1:?missing test function pattern parameter to ${FUNCNAME}}"
    local FUNCTIONS; declare -a FUNCTIONS
    local name= item= result=
    local ORGPWD="$PWD"


    PATTERN="${TESTMATCH:-${PATTERN}}"
    dotest-p-report-start-from-environment
    dotest-p-report-success-from-environment

    for item in `compgen -A function "${PATTERN}"` ; do
        # When a single test function name is selected, "$item" is equal
        # to "$PATTERN", then here "name" is set to the empty string.

	let ++dotest_TEST_NUMBER
	name="${item##${PATTERN}}"
	if test -n "${name}" -o "${item}" = "${PATTERN}" ; then
	    item="${PATTERN}${name}"
	    if dotest-option-report-start ; then
                dotest-echo "${item} -- start"
            fi
	    if result=$("${item}") ; then
		if dotest-option-report-success ; then
		    dotest-echo "${item} -- success"
                else
                    if dotest-option-report-start ; then
                        echo
                    fi
                fi
	    else
		dotest-echo "${item} -- *** FAILED ***\n"
		dotest_TEST_FAILED="${dotest_TEST_FAILED} ${item}"
		let ++dotest_TEST_FAILED_NUMBER
	    fi
	    if test -n "$result" ; then
		echo "$result" >&2
		echo >&2
	    fi
	    dotest-cd "${ORGPWD}"
	fi
    done

    return 0
}
function dotest-p-report-start-from-environment () {
    case "${TESTSTART}" in
	yes)
	    dotest-set-report-start
	    ;;
	no)
	    dotest-unset-report-start
	    ;;
    esac
}
function dotest-p-report-success-from-environment () {
    case "${TESTSUCCESS}" in
	yes)
	    dotest-set-report-success
	    ;;
	no)
	    dotest-unset-report-success
	    ;;
    esac
}

#page
## ------------------------------------------------------------
## Testing results.
## ------------------------------------------------------------

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
	if test ! -z "${output}" -a ${#output} -eq 0 ; then
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
## ------------------------------------------------------------
## File functions.
## ------------------------------------------------------------

function dotest-echo-tmpdir () {
    echo "${TMPDIR:-/tmp}/dotest.$$"
}
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

function dotest-assert-file-exists () {
    local FILE_NAME=${1:?"missing file name to '${FUNCNAME}'"}
    local ERROR_MESSAGE=${2:?"missing error message to '${FUNCNAME}'"}

    if test ! -f "${FILE_NAME}" ; then
        dotest-echo "${ERROR_MESSAGE}"
        dotest-clean-files
        return 1
    fi
    return 0
}
function dotest-assert-file-unexists () {
    local FILE_NAME=${1:?"missing file name to '${FUNCNAME}'"}
    local ERROR_MESSAGE=${2:?"missing error message to '${FUNCNAME}'"}

    if test -f "${FILE_NAME}" ; then
        dotest-echo "${ERROR_MESSAGE}"
        dotest-clean-files
        return 1
    fi
    return 0
}

#page
## ------------------------------------------------------------
## Program interfaces.
## ------------------------------------------------------------

function dotest-program-mkdir () {
    dotest-option-verbose && FLAGS="--verbose"
    if ! dotest-program-exec /bin/mkdir --parents ${FLAGS} --mode=0700 "$@" >&2
        then
	dotest-clean-files
	exit 2
    fi
}
function dotest-program-rm () {
    dotest-option-verbose && FLAGS="--verbose"
    dotest-program-exec /bin/rm --force --recursive ${FLAGS} "$@" >&2
}
function dotest-program-exec () {
    if dotest-option-test ; then
	echo "$@"
    else
	if ! "$@"
            then 
	    dotest-clean-files
	    exit 2
        fi
    fi
}

#page
## ------------------------------------------------------------
## Final report.
## ------------------------------------------------------------

trap dotest-final-report EXIT

test -z ${dotest_TEST_NUMBER} && declare -i dotest_TEST_NUMBER=0
test -z ${dotest_TEST_FAILED_NUMBER} && declare -i dotest_TEST_FAILED_NUMBER=0
test -z ${dotest_TEST_FAILED} && dotest_TEST_FAILED=

function dotest-final-report () {
    local item


    if test ${dotest_TEST_NUMBER} -ne 0 ; then
        printf '\n'
        printf "Test file '${mbfl_TEST_FILE:-$0}'\n"
        printf "\tNumber of executed tests: ${dotest_TEST_NUMBER}\n"
        printf "\tNumber of failed tests:   ${dotest_TEST_FAILED_NUMBER}\n"
        if test -n "${dotest_TEST_FAILED}" ; then
            printf "Failed tests:\n"
            for item in ${dotest_TEST_FAILED} ; do
                printf "   ${item}\n" >&2
            done
        fi
        printf '\n'
    fi
    dotest-clean-files
}

### end of file
# Local Variables:
# mode: sh
# End:
