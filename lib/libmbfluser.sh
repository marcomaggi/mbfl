# libmbfluser.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: library of functions for interactive user
# Date: Fri Oct  8, 2004
# 
# Abstract
# 
#	This file declares a set of functions providing and interface
#	to GNU Arch: a revision control system. There is a single
#	executable file named "tla" (dunno why).
#
#	This library requires "libmbfl.sh" and "libmbfluser.sh", so
#	loads them through the "mbfl-config" interface.
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
## Setup.
## ------------------------------------------------------------

mbfl_LOADED_USERLIB='yes'

if test "${mbfl_LOADED_MBFL}" != 'yes' ; then
    source "${MBFL_PATH:-`mbfl-config`}" || {
	echo 'unable to load the MBFL functions library' >&2
	exit 2
    }
fi

function user-is-login-shell () {
    test "$SHLVL" = 1
}

#page
## ------------------------------------------------------------
## Common message functions.
## ------------------------------------------------------------

function user-message-error   () { echo "error: ${1}"   >&2; }
function user-message-warning () { echo "warning: ${1}" >&2; }
function user-message-verbose () { echo "${@}" >&2; }

function user-message-missing-executable () {
    user-message-error "cannot find executable '${1}'"
}
function user-message-file-not-found () {
    user-message-error "file not found '${1}'"
}

#page
## ------------------------------------------------------------
## Pathname functions.
## ------------------------------------------------------------

function user-p-pathname-test () {
    local MODE="${1:?missing test mode to ${FUNCNAME}}"
    local MODE_DESCR="${2:?missing test mode description to ${FUNCNAME}}"
    local PATHNAME="${3:?missing pathname parameter to ${FUNCNAME}}"

    if test ! ${MODE} "${PATHNAME}" ; then
	user-message-error "not ${MODE_DESCR} '${PATHNAME}'"
	return 1
    else
	return 0
    fi
}
function user-pathname-readable () {
    user-p-pathname-test '-r' 'readable' "$@"
}
function user-pathname-writable () {
    user-p-pathname-test '-w' 'writable' "$@"
}
function user-pathname-executable () {
    user-p-pathname-test '-x' 'executable' "$@"
}
function user-pathname-readable-and-writable () {
    local PATHNAME="${1:?missing pathname parameter to ${FUNCNAME}}"
    user-pathname-readable "${PATHNAME}" && user-pathname-writable "${PATHNAME}"
}
#page
## ------------------------------------------------------------
## Directory functions.
## ------------------------------------------------------------

function user-validate-directory () {
    local PATHNAME="${1}"    

    if test -z "${PATHNAME}" ; then
	user-message-error "null pathname"
	return 1
    elif test ! -d "${PATHNAME}" ; then
	if test -f "${PATHNAME}" ; then
	    user-message-error "pathname is a file not a directory '${PATHNAME}'"
	elif test ! -e "${PATHNAME}" ; then
	    user-message-error "unexistent pathname '${PATHNAME}'"
	else
	    user-message-error "pathname is not a directory '${PATHNAME}'"
	fi
	return 1
    fi
    return 0
}

function user-validate-directory-readable () {
    local PATHNAME="${1}"    
    user-validate-directory "${PATHNAME}" && user-pathname-readable "${PATHNAME}"
}
function user-validate-directory-writable () {
    local PATHNAME="${1}"
    user-validate-directory "${PATHNAME}" && user-pathname-writable "${PATHNAME}"
}
function user-validate-directory-readable-and-writable () {
    local PATHNAME="${1}"    
    user-validate-directory "${PATHNAME}" && \
	user-pathname-readable-and-writable "${PATHNAME}"
}

#page
## ------------------------------------------------------------
## File functions.
## ------------------------------------------------------------

function user-validate-file () {
    local PATHNAME="${1}"    

    if test -z "${PATHNAME}" ; then
	user-message-error "null pathname"
	return 1
    elif test ! -f "${PATHNAME}" ; then
	if test -d "${PATHNAME}" ; then
	    user-message-error "pathname is a directory not a file '${PATHNAME}'"
	elif test ! -e "${PATHNAME}" ; then
	    user-message-error "unexistent pathname '${PATHNAME}'"
	else
	    user-message-error "pathname is not a file '${PATHNAME}'"
	fi
	return 1
    fi
    return 0
}

function user-validate-file-readable () {
    local PATHNAME="${1}"    
    user-validate-file "${PATHNAME}" && user-pathname-readable "${PATHNAME}"
}
function user-validate-file-writable () {
    local PATHNAME="${1}"    
    user-validate-file "${PATHNAME}" && user-pathname-writable "${PATHNAME}"
}
function user-validate-file-readable-and-writable () {
    local PATHNAME="${1}"    
    user-validate-file "${PATHNAME}" && \
	user-pathname-readable-and-writable "${PATHNAME}"
}

#page
## ------------------------------------------------------------
## Environment related functions.
## ------------------------------------------------------------

function user-fix-path-variable () {
    local item
    declare -a mbfl_FIELDS FIELDS
    declare -i dimension COUNT i


    mbfl_variable_colon_variable_drop_duplicate PATH
    mbfl_variable_colon_variable_to_array PATH
    dimension=${#mbfl_FIELDS[*]}

    for ((i=0, COUNT=0; $i < ${dimension}; ++i)); do
	item="${mbfl_FIELDS[$i]}"
	user-validate-directory-readable "${item}" || {
	    user-message-warning "dropping unexistent or unreadable '${item}'"
	    continue
	}
	FIELDS[${COUNT}]="${item}"
	let ++COUNT
    done
    mbfl_FIELDS=("${FIELDS[@]}")
    mbfl_variable_array_to_colon_variable PATH
    return 0
}

#page
## ------------------------------------------------------------
## Executable files.
## ------------------------------------------------------------

# If an alias exists for a program, "type -p $program" will
# return the empty string; that is why we have to use
# "type -ap $program", which will return the correct file
# pathname. Unfortunately: if PATH holds the same directory
# more than once, or there exist programs with the same name
# in more than one PATH elements: "type -ap $program" will
# return more than one line of output, one for each executable
# file found.

function user-find-executable () {
    local PROGRAM="${1:?missing program parameter to ${FUNCNAME}}"
    local program=

    for program in `type -ap "${PROGRAM}"`; do
	if test -n "${program}" -a -x "${program}"; then
	    echo "${program}"
	    return 0
	fi
    done
#     type -ap "${PROGRAM}" | while read -t 1 program; do
# 	if test -n "${program}" -a -x "${program}"; then
# 	    echo "${program}"
# 	    while read -t 1; do :; done
# 	    return 0
# 	fi
#     done

    user-message-missing-executable "${PROGRAM}"
    return 1
}

#page
## ------------------------------------------------------------
## Specific files and directory functions.
## ------------------------------------------------------------

function user-make-temporary-user-directory () {
    local MKDIR=`user-find-executable mkdir ` || return 1
    local mode=0700

    
    if test -z "${USER}" ; then
	user-message-warning "null variable 'USER'"
	TMPDIR='/tmp'
    else
	TMPDIR="/tmp/${USER}"
    fi

    if test ! -d "${TMPDIR}" ; then
	user-message-verbose "creating temporary directory '${TMPDIR}'"
	${MKDIR} --parents --mode=${mode} "${TMPDIR}"
    fi
    export TMPDIR
}
function user-make-tempfile () {
    local TEMPFILE=`user-find-executable tempfile` || return 1
    local DIR="${TMPDIR:-/tmp/${USER}}"

    test ! -d "${DIR}" -o ! -w "${DIR}" -o ! -O "${DIR}" && DIR='/tmp'
    ${TEMPFILE} --directory="${DIR}"
}

#page
## ------------------------------------------------------------
## Common file functions.
## ------------------------------------------------------------

function user-source-file () {
    local FILE="${1:?missing file parameter to ${FUNCNAME}}"

    user-validate-file-readable "${FILE}" && {
	user-message-verbose "sourcing '${FILE}'"
	source "${FILE}"
    }
}

#page
## ------------------------------------------------------------
## Backup files.
## ------------------------------------------------------------

function rmtilde () {
    local FIND=`user-find-executable find` || return 1
    local FIND_FLAGS=
    local DIR="${1:-.}"
    local DEPTH="${2:-0}"

    test $DEPTH = 0 && FIND_FLAGS="${FIND_FLAGS} -maxdepth 1"
    ${FIND} "${DIR}" -name '*~' $FIND_FLAGS -exec /bin/rm -v '{}' ';'
}
function rmtilde-recursive () {
    rmtilde "${1:-.}" 1
}

#page
## ------------------------------------------------------------
## Shows console colors.
## ------------------------------------------------------------

# Note from the author: this function is not mine; but
# unfortunately I have lost the reference to the source.

function user-console-colors () {
    local line1=
    local line2=
    local fore=
    local back=
    local esc="\033["    

    echo -e "This shell script shows all standard colour combinations on the\n\
current console. If no colours appear, your console does not\n\
support ANSI colour selections."

    echo -n " _ _ _ _ _40 _ _ _ 41_ _ _ _42 _ _ _ 43"
    echo "_ _ _ 44_ _ _ _45 _ _ _ 46_ _ _ _47 _"
    for fore in 30 31 32 33 34 35 36 37; do
	line1="$fore  "
	line2="    "
	for back in 40 41 42 43 44 45 46 47; do
	    line1="${line1}${esc}${back};${fore}m Normal  ${esc}0m"
	    line2="${line2}${esc}${back};${fore};1m Bold    ${esc}0m"
	done
	echo -e "$line1\n$line2"
    done
    echo 'The whole ANSI selection sequence is then: \033 [ 3 7 ; 4 4 ; 1 m'

    return 0
}

#page
## ------------------------------------------------------------
## Specific program jobs.
## ------------------------------------------------------------

function user-print-short-date () { program-date '+%b %d %Y'; }
function user-print-short-time () { program-date '+%b %d %Y, %T'; }

function user-fold-sentence () { program-fold --width=72; }

function user-make-backup-file () {
    local FILENAME="${1:?missing file name parameter to ${FUNCNAME}}"
    program-cp --force --backup=numbered "${FILENAME}" "${FILENAME}"
}
#page
## ------------------------------------------------------------
## Specific programs and programs combinations.
## ------------------------------------------------------------

function program-sudo-mount () {
    local MOUNT=`user-find-executable mount` || return 1
    local SUDO=`user-find-executable sudo` || return 1
    ${SUDO} ${MOUNT} "$@"
}
function program-wrapper () {
    local program=`user-find-executable ${1}` && { shift && ${program} "$@"; }
}
function program-grep () { program-wrapper grep "$@"; }
function program-date () { program-wrapper date "$@"; }
function program-fold () { program-wrapper fold "$@"; }
function program-rm   () { program-wrapper rm "$@"; }
function program-mv   () { program-wrapper mv "$@"; }
function program-cp   () { program-wrapper cp "$@"; }

#page
## ------------------------------------------------------------
## Partition mounting interface.
## ------------------------------------------------------------

function admin-partition-assert-mounted-rw () {
    local rex='%s.\+rw,'
    admin-partition-p-assert-mounted-mode "$@"
}
function admin-partition-assert-mounted-ro () {
    local rex='%s.\+ro,'
    admin-partition-p-assert-mounted-mode "$@"
}
function admin-partition-p-assert-mounted-mode () {
    local MOUNT_POINT="${1:?missing mount point parameter to ${FUNCNAME}}"    
    local MOUNT_FILE='/etc/mtab' grep=

    user-validate-directory "${MOUNT_POINT}" || return 1
    grep=$(printf "$rex" "${MOUNT_POINT}")
    test -n "`program-grep $grep ${MOUNT_FILE}`"
}
function admin-partition-mount-rw () {
    local MOUNT_POINT="${1:?missing mount point parameter to ${FUNCNAME}}"

    user-validate-directory "${MOUNT_POINT}" || return 1
    program-sudo-mount -o remount,rw "${MOUNT_POINT}" || {
	user-message-error \
	    "remounting read-write partition '${MOUNT_POINT}'"
	return 1
    }
}

### end of file
# Local Variables:
# mode: sh
# End:
