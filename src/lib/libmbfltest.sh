# libmbfltest.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: test functions
# Date: Mon Oct  4, 2004
#
# Abstract
#
#	This file  defines a set  of functions to  be used to  drive the
#	test suite. It must be sources  at the beginning of all the test
#	files.
#
# Copyright (c) 2004-2005, 2009, 2013, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
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
#### shell configuration

shopt -s expand_aliases

declare mbfl_LOADED_MBFL_TEST='yes'

test -z ${dotest_TEST_NUMBER}        && declare -i dotest_TEST_NUMBER=0
test -z ${dotest_TEST_FAILED_NUMBER} && declare -i dotest_TEST_FAILED_NUMBER=0
declare -a dotest_TEST_FAILED

#page
#### output messages

alias dotest-echo='dotest-p-echo ${FUNCNAME}'
function dotest-p-echo () {
    local name=${1:?"missing funcname argument to '${FUNCNAME}'"}
    shift
    echo -e "$name: $@" >&2
}
alias dotest-debug='dotest-p-debug ${FUNCNAME}'
function dotest-p-debug () {
    local name=${1:?"missing funcname argument to '${FUNCNAME}'"}
    shift
    dotest-option-debug && echo -e "*** $name ***: $@" >&2
}

alias dotest-printf='dotest-p-printf ${FUNCNAME}'
function dotest-p-printf () {
    local name=${1:?"missing funcname argument to '${FUNCNAME}'"}
    local TEMPLATE=${2:?"missing template argument to '${FUNCNAME}'"}
    shift 2
    {
	printf '%s:' "$name"
	printf "$TEMPLATE"  "$@"
	echo
    } >&2
}

#page
#### configuration

function dotest-p-create-option-functions () {
    local item

    for item in verbose debug test report-start report-success
    do
        eval function dotest-set-$item \(\) \
             \{ function dotest-option-$item \(\) \{ true\;  \}\; \}
        eval function dotest-unset-$item \(\) \
             \{ function dotest-option-$item \(\) \{ false\; \}\; \}
        dotest-unset-$item
    done
}
dotest-p-create-option-functions

#page
#### test execution

function dotest () {
    local PATTERN=${1:?"missing test function pattern parameter to '${FUNCNAME}'"}
    local -a FUNCTIONS
    local name item result ORGPWD=$PWD
    local -i exit_status

    dotest-p-report-start-from-environment
    dotest-p-report-success-from-environment

    for item in `compgen -A function "$PATTERN"`
    do
	if [[ $item =~ $TESTMATCH ]]
	then
            # When a single  test function name is  selected, "$item" is
            # equal to "$PATTERN", then here  "name" is set to the empty
            # string.

	    let ++dotest_TEST_NUMBER
	    name=${item##${PATTERN}}
	    if test -n "$name" -o "$item" = "$PATTERN"
	    then
		item="${PATTERN}${name}"
		if dotest-option-report-start
		then dotest-echo "${item} -- start"
		fi
		#echo ---$FUNCNAME--$item--- >&2
		result=$("$item")
		exit_status=$?
		#echo ---$FUNCNAME--$exit_status--- >&2
		if ((0 == exit_status))
		then
		    if dotest-option-report-success
		    then dotest-echo "${item} -- success"
                    else
			if dotest-option-report-start
			then echo
			fi
                    fi
		else
		    dotest-echo "${item} -- *** FAILED ***\n"
		    dotest_TEST_FAILED+=("$item")
		    let ++dotest_TEST_FAILED_NUMBER
		fi
		if test -n "$result"
		then printf '%s\n' "$result" >&2
		fi
		dotest-cd "$ORGPWD"
	    fi
	fi
    done

    return 0
}
function dotest-p-report-start-from-environment () {
    case $TESTSTART in
	yes)
	    dotest-set-report-start
	    ;;
	no)
	    dotest-unset-report-start
	    ;;
    esac
}
function dotest-p-report-success-from-environment () {
    case $TESTSUCCESS in
	yes)
	    dotest-set-report-success
	    ;;
	no)
	    dotest-unset-report-success
	    ;;
    esac
}

#page
#### testing results

function dotest-output () {
    local expected_output="$1"
    local -i globmode=0 expected_output_len
    local output

    expected_output_len=${#expected_output}
    if test "${expected_output:$((${expected_output_len}-1)):1}" = '*'
    then
	globmode=1
	expected_output="${expected_output:0:$((${expected_output_len}-1))}"
	expected_output_len=${#expected_output}
    fi

    # Read all the  lines from stdin, setting a timeout  of 4 seconds at
    # every read.
    #
    {
	while IFS="" read -r -t 4
	do
	    if test ${#output} -eq 0
	    then output="$REPLY"
	    else output+="\n${REPLY}"
	    fi
	done
    }

    if dotest-string-is-empty "$expected_output"
    then
	if dotest-string-is-not-empty "$output"
	then
	    {
		echo "${FUNCNAME}:"
		echo "   expected output of zero length"
		echo "   got:      '$output'"
	    } >&2
	    return 1
	fi
    else
	if test \
	    \( $globmode -eq 0 -a "$expected_output" != "$output" \) -o  \
	    \( $globmode -eq 1 -a "$expected_output" != "${output:0:${expected_output_len}}" \)
	then
	    {
		echo "${FUNCNAME}:"
		echo "   expected: '$expected_output'"
		echo "   got:      '$output'"
	    } >&2
	    return 1
	fi
    fi
    return 0
}
function dotest-equal () {
    local expected="$1"
    local got="$2"

    if test "$expected" = "$got"
    then return 0
    else
	{
	    echo "${FUNCNAME}:"
	    echo "   expected: '$expected'"
	    echo "   got:      '$got'"
	} >&2
	return 1
    fi
}

#page
#### file functions

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
    cd "$DIRNAME"
    dotest-option-verbose && dotest-echo "current directory: '$PWD'"
}
function dotest-mktmpdir () {
    dotest-program-mkdir "$(dotest-echo-tmpdir)"
}
function dotest-mkdir () {
    local NAME="${1:?missing directory name parameter to ${FUNCNAME}}"
    local PREFIX="$2"

    if test -n "$PREFIX"
    then PREFIX="$(dotest-echo-tmpdir)/${PREFIX}"
    else PREFIX="$(dotest-echo-tmpdir)"
    fi

    NAME="${PREFIX}/${NAME}"
    dotest-program-mkdir "$NAME"
    echo "$NAME"
}
function dotest-mkfile () {
    local NAME="${1:?missing file name parameter to ${FUNCNAME}}"
    local PREFIX="$2"

    if test -n "$PREFIX"
    then PREFIX="$(dotest-echo-tmpdir)/${PREFIX}"
    else PREFIX="$(dotest-echo-tmpdir)"
    fi
    NAME=${PREFIX}/${NAME}
    dotest-option-verbose && dotest-echo "creating file '$NAME'"

    dotest-mktmpdir
    if dotest-option-test
    then echo echo \>"$NAME"
    else
	if ! echo >"$NAME"
	then
	    dotest-clean-files
	    exit 2
	fi
    fi
    echo "$NAME"
}
function dotest-clean-files () {
    local result=$?
    dotest-program-rm "$(dotest-echo-tmpdir)"
    return $result
}

function dotest-mkpathname () {
    local NAME="${1:?missing file name parameter to ${FUNCNAME}}"
    local PREFIX="$2"

    if test -n "$PREFIX"
    then PREFIX="$(dotest-echo-tmpdir)/${PREFIX}"
    else PREFIX="$(dotest-echo-tmpdir)"
    fi
    NAME=${PREFIX}/${NAME}

    dotest-mktmpdir
    echo "$NAME"
}

function dotest-assert-file-exists () {
    local FILE_NAME=${1:?"missing file name to '${FUNCNAME}'"}
    local ERROR_MESSAGE=${2:?"missing error message to '${FUNCNAME}'"}

    if test ! -f "$FILE_NAME"
    then
        dotest-echo "$ERROR_MESSAGE"
        dotest-clean-files
        return 1
    else return 0
    fi
}
function dotest-assert-file-unexists () {
    local FILE_NAME=${1:?"missing file name to '${FUNCNAME}'"}
    local ERROR_MESSAGE=${2:?"missing error message to '${FUNCNAME}'"}

    if test -f "$FILE_NAME"
    then
        dotest-echo "$ERROR_MESSAGE"
        dotest-clean-files
        return 1
    else return 0
    fi
}

#page
#### program interfaces

function dotest-program-mkdir () {
    local FLAGS

    if dotest-option-verbose
    then FLAGS='--verbose'
    fi
    if ! dotest-program-exec /bin/mkdir --parents ${FLAGS} --mode=0700 "$@" >&2
    then
	dotest-clean-files
	exit 2
    fi
}
function dotest-program-rm () {
    local FLAGS

    if dotest-option-verbose
    then FLAGS='--verbose'
    fi
    dotest-program-exec /bin/rm --force --recursive ${FLAGS} "$@" >&2
}
function dotest-program-exec () {
    if dotest-option-test
    then echo "$@"
    else
	if ! "$@"
        then
	    dotest-clean-files
	    exit 2
        fi
    fi
}

#page
#### utility functions

function dotest-string-is-empty () {
    test ${#1} -eq 0
}
function dotest-string-is-not-empty () {
    test ${#1} -ne 0
}

#page
#### final report

trap dotest-clean-files EXIT

function dotest-final-report () {
    if ((0 != dotest_TEST_NUMBER))
    then
        printf '\n'
        printf 'Test file "%s"\n' "${mbfl_TEST_FILE:-$0}"
        printf '\tNumber of executed tests: %d\n' ${dotest_TEST_NUMBER}
        printf '\tNumber of failed tests:   %d\n' ${dotest_TEST_FAILED_NUMBER}
        if ((0 != ${#dotest_TEST_FAILED[@]}))
	then
	    local -i i

            printf 'Failed tests:\n'
            for ((i=0; i < ${#dotest_TEST_FAILED[@]}; ++i))
	    do printf '   %s\n' "${dotest_TEST_FAILED[$i]}"
            done
        fi
        printf '\n'
    fi
    if ((0 == dotest_TEST_FAILED_NUMBER))
    then exit 0
    else exit 1
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
