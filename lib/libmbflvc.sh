# libmbflvc.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: functions for version control
# Date: Tue Sep 28, 2004
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
#	Functions with name prefixed by "vc-p-" are meant to be private
#	and should not be invoked directly.
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

mbfl_LOADED_VCLIB='yes'

if test "${mbfl_LOADED_USERLIB}" != 'yes' ; then
    source "`mbfl-config --userlib`" || {
	echo 'unable to load the user functions library' >&2
	exit 2
    }
fi

#page
## ------------------------------------------------------------
## GNU Arch interface.
## ------------------------------------------------------------

function program-gnu-arch () {
    local TLA="`user-find-executable tla`" && "$TLA" "$@"
}
function gnu-arch-parse-package-name () {
    program-gnu-arch parse-package-name "$@"
}
function vc-assert-preconditions () {
    user-find-executable tla || return 1
}
#page
## ------------------------------------------------------------
## Package name and version.
## ------------------------------------------------------------

function vc-print-tree-root-directory () { program-gnu-arch tree-root; }
function vc-print-tree-version        () { program-gnu-arch tree-version; }
function vc-print-tree-version-list   () { program-gnu-arch versions; }
function vc-print-tree-revision () {
# It should be this:
#
#    vc-p-print-with-tree-version --lvl
#
# but for some reason an error is raised; so we do:
    local TAIL=`user-find-executable tail` || return 1
    vc-print-tree-revision-list | ${TAIL} -1
}
function vc-print-tree-revision-list  () { program-gnu-arch revisions; }
function vc-p-print-with-tree-version () {
    local VERSION="`vc-print-tree-version`" || return 1
    gnu-arch-parse-package-name "$@" "${VERSION}"
}
function vc-print-tree-package () { vc-p-print-with-tree-version --package-version; }
function vc-print-tree-archive () { vc-p-print-with-tree-version --arch; }
function vc-print-tree-name    () { vc-p-print-with-tree-version --category; }
function vc-print-tree-branch  () { vc-p-print-with-tree-version --branch; }

#page
## ------------------------------------------------------------
## Tree setup.
## ------------------------------------------------------------

function vc-p-tree-echo-tagging-method () {
    echo '# <tree-root>/{arch}/=tagging-method --
explicit
untagged-source precious
exclude ^(.arch-ids|\{arch\}|\.arch-inventory)$
junk ^(,.*|autom4te\.cache)$
precious ^(\+.*|\.gdbinit|\.#ckpts-lock|=build\.*|=install\.*|CVS|CVS\.adm|RCS|RCSLOG|SCCS|TAGS|=emacs\.desktop)$
backup ^.*(~|\.~[0-9]+~|\.bak|\.swp|\.orig|\.rej|\.original|\.modified|\.reject)$
unrecognized ^(.*\.(o|a|so|core|so(\.[[:digit:]]+)*)|core)$
source ^[_=a-zA-Z0-9].*$
### end of file'
}
function vc-tree-fix-tagging-method () {
    local rootdir=`vc-print-tree-root-directory` || return 1
    local archdir="${rootdir}/{arch}"

    { user-validate-directory-writable "${rootdir}" && \
	user-validate-directory-writable "${archdir}"; } || return 1
    vc-p-tree-echo-tagging-method >"${archdir}/=tagging-method"
}

#page
## ------------------------------------------------------------
## Source files listing.
## ------------------------------------------------------------

function vc-print-registered-sources () {
    local rootdir=`vc-print-tree-root-directory` || return 1

    { user-validate-directory-readable "${rootdir}" && \
	user-pathname-executable "${rootdir}"; } || return 1
    (cd "${rootdir}" && program-gnu-arch inventory --source --both)
}
function vc-print-unregistered-sources () {
    local rootdir=`vc-print-tree-root-directory` || return 1
    local item dirname tailname idname

    { user-validate-directory-readable "${rootdir}" && \
	user-pathname-executable "${rootdir}"; } || return 1

    (cd "${rootdir}"; program-gnu-arch inventory --source --both --names | \
	while read item; do
	    if test -f "${item}" ; then
		dirname=`mbfl_file_dirname "${item}"`
		tailname=`mbfl_file_tail "${item}"`
		test "${dirname:0:1}" = "=" && continue
		test "${tailname:0:1}" = "=" && continue
		test -f "${dirname}/.arch-ids/${tailname}.id" || echo "${item}"
	    elif test -d "${item}" ; then
		test -d "${item}/.arch-ids" || echo "${item}"
	    fi
    done)
}
function vc-tree-register-sources () {
    local rootdir=`vc-print-tree-root-directory` || return 1
    local item=

    { user-validate-directory-readable "${rootdir}" && \
	user-pathname-executable "${rootdir}"; } || return 1

    (cd "${rootdir}" && vc-print-unregistered-sources | while read item; do
	user-message-verbose "adding '${item}'"
	program-gnu-arch add "${item}"
    done)
    vc-tree-lint
}
function vc-tree-delete () {
    local PATHNAME="${1:?missing pathname parameter to ${FUNCNAME}}"
    program-gnu-arch delete "${PATHNAME}" && \
	vc-log-add-sentence "deleted '${PATHNAME}'"
}
function vc-tree-move () {
    local FROM="${1:?missing from pathname parameter to ${FUNCNAME}}"
    local TO="${2:?missing to pathname parameter to ${FUNCNAME}}"

    program-gnu-arch move "${FROM}" "${TO}" && \
	vc-log-add-sentence "moved '${FROM}' to '${TO}'"
}
#page
## ------------------------------------------------------------
## Log file functions.
## ------------------------------------------------------------

function vc-print-log-file-name () {
    local DIR=`vc-print-tree-root-directory` || return 1
    local PKG=`vc-print-tree-package` || return 1
    local ARCH=`vc-print-tree-archive` || return 1

    echo "${DIR}/++log.${PKG}--${ARCH}"
}
function vc-log-edit () {
    local LOGFILE=`vc-print-log-file-name` || return 1
    vc-log-make || return 1
    emacsclient "${LOGFILE}"
}
function vc-log-make () {
    vc-log-file-exists || program-gnu-arch make-log
}
function vc-log-file-exists () {
    local logfile=`vc-print-log-file-name` || return 1
    user-validate-file "${logfile}"
}
function vc-log-add-sentence () {
    local SENTENCE="${1:?missing sentence parameter to ${FUNCNAME}}"
    local logfile=`vc-print-log-file-name` || return 1
    local DATE=`user-print-short-time` || return 1
    
    { vc-log-make && user-make-backup-file "${logfile}"; } || return 1
    echo -e "\n* ${DATE}: ${SENTENCE}\n" | user-fold-sentence >>"${logfile}"
}
#page
## ------------------------------------------------------------
## Archive management.
## ------------------------------------------------------------

function vc-archive-select () {
    local ARCHIVE="${1:?missing archive name parameter to ${FUNCNAME}}"
    program-gnu-arch my-default-archive "${ARCHIVE}"
    vc-print-archive-default
}
function vc-print-archive-default () {
    program-gnu-arch my-default-archive
}
function vc-print-archive-list () {
    local LINE=
    local FLAG=0

    program-gnu-arch archives | while read LINE; do
	if test $FLAG = 0; then echo "$LINE" && FLAG=1; else FLAG=0; fi
    done
}
function vc-print-archive-locations () {
    local LINE=
    local LOCA=
    local FLAG=0

    program-gnu-arch archives | while read LINE && read LOCA; do
	printf '%-40s%s\n' "$LINE" "$LOCA"
    done
}
#page
## ------------------------------------------------------------
## Tree management.
## ------------------------------------------------------------

function vc-tree-create-new () {
    local CATEGORY="${1:?missing category parameter to ${FUNCNAME}}"

    program-gnu-arch init-tree
    vc-tree-make-branch-from-branch "${CATEGORY}"
}
function vc-tree-make-branch-from-branch () {
    local PACKAGE="${1:?missing package parameter to ${FUNCNAME}}"

    program-gnu-arch archive-setup "${PACKAGE}"	&& \
    program-gnu-arch add-log-version "${PACKAGE}"	&& \
    program-gnu-arch set-tree-version "${PACKAGE}"	&& \
    vc-log-make
}
function vc-tree-import () {
    program-gnu-arch import && vc-log-make
}
function vc-tree-commit () {
    { vc-log-file-exists || vc-log-edit; } || return 1
    program-gnu-arch commit && vc-log-make
}
function vc-tree-lint () {
    program-gnu-arch tree-lint
}

### end of file
# Local Variables:
# mode: sh
# End:
