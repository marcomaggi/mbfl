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
## GNU Arch interface.
## ------------------------------------------------------------

function vc-program-gnu-arch () {
    declare TLA=`user-find-executable tla` && exec "${TLA}" "${@}"
}
function vc-assert-preconditions () {
    exec user-find-executable tla
}
function vc-program-gnu-arch-parse-package-name () {
    exec vc-program-gnu-arch parse-package-name "${@}";
}
function vc-program-gnu-arch-my-default-archive () {
    exec vc-program-gnu-arch my-default-archive "${@}"    
}
function vc-program-gnu-arch-archives-names () {
    exec vc-program-gnu-arch archives --names "${@}"
}
function vc-program-gnu-arch-archives ()         {
    exec vc-program-gnu-arch archives "${@}"
}
function vc-program-gnu-arch-whereis-archive () {
    exec vc-program-gnu-arch whereis-archive "${@}"
}
function vc-program-gnu-arch-archive-setup () {
    exec vc-program-gnu-arch archive-setup "${@}"
}
function vc-program-gnu-arch-add-log-version () {
    exec vc-program-gnu-arch add-log-version "${@}"
}
function vc-program-gnu-arch-set-tree-version () {
    exec vc-program-gnu-arch set-tree-version "${@}"
}
function vc-program-gnu-arch-init-tree () {
    exec vc-program-gnu-arch init-tree "${@}"
}
function vc-program-gnu-arch-tree-lint () {
    exec vc-program-gnu-arch tree-lint "${@}"
}
function vc-program-gnu-arch-import () {
    exec vc-program-gnu-arch import "${@}"
}
function vc-program-gnu-arch-commit () {
    exec vc-program-gnu-arch commit "${@}"
}
function vc-program-gnu-arch-add () {
    exec vc-program-gnu-arch add "${@}"
}
function vc-program-gnu-arch-delete () {
    exec vc-program-gnu-arch delete "${@}"
}
function vc-program-gnu-arch-delete () {
    exec vc-program-gnu-arch move "${@}"
}
function vc-program-gnu-arch-tree-root () {
    exec vc-program-gnu-arch tree-root "${@}"
}
function vc-program-gnu-arch-tree-version () {
    exec vc-program-gnu-arch tree-version "${@}"
}
function vc-program-gnu-arch-versions () {
    exec vc-program-gnu-arch versions "${@}"
}
function vc-program-gnu-arch-revisions () {
    exec vc-program-gnu-arch revisions "${@}"
}
function vc-program-gnu-arch-inventory-source-both () {
    exec vc-program-gnu-arch inventory --source --both "$@"
}
function vc-program-gnu-arch-inventory-source-both-names () {
    exec vc-program-gnu-arch inventory --source --both --names "$@"
}
function vc-program-gnu-arch-make-log () {
    exec vc-program-gnu-arch make-log "${@}"
}
#page
## ------------------------------------------------------------
## Package name and version.
## ------------------------------------------------------------

function vc-print-tree-root-directory () { vc-program-gnu-arch-tree-root; }
function vc-print-tree-version        () { vc-program-gnu-arch-tree-version; }
function vc-print-tree-version-list   () { vc-program-gnu-arch-versions; }
function vc-print-tree-revision () {
# It should be this:
#
#    vc-p-print-with-tree-version --lvl
#
# but for some reason an error is raised; so we do:
TAIL=`user-find-executable tail` || exit 1
vc-print-tree-revision-list | ${TAIL} -1
}
function vc-print-tree-revision-list  () { vc-program-gnu-arch-revisions; }
function vc-p-print-with-tree-version () {
VERSION="`vc-print-tree-version`" || exit 1
vc-program-gnu-arch-parse-package-name "$@" "${VERSION}"
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
precious ^(\+.*|\.gdbinit|\.#ckpts-lock|=build\.*|=install\.*|CVS|CVS\.adm|RCS|RCSLOG|SCCS|TAGS|=emacs\.desktop|=auto)$
backup ^.*(~|\.~[0-9]+~|\.bak|\.swp|\.orig|\.rej|\.original|\.modified|\.reject)$
unrecognized ^(.*\.(o|a|so|core|so(\.[[:digit:]]+)*)|core)$
source ^[_=a-zA-Z0-9].*$
### end of file'
}
function vc-tree-fix-tagging-method () {
ROOTDIR=`vc-print-tree-root-directory` || exit 1
ARCHDIR="${ROOTDIR}/{arch}"

    { user-validate-directory-writable "${ROOTDIR}" && \
	user-validate-directory-writable "${ARCHDIR}"; } || exit 1
    vc-p-tree-echo-tagging-method >"${ARCHDIR}/=tagging-method"
}

#page
## ------------------------------------------------------------
## Source files listing.
## ------------------------------------------------------------

function vc-print-registered-sources () {
ROOTDIR=`vc-print-tree-root-directory` || exit 1

{ user-validate-directory-readable "${ROOTDIR}" && \
    user-pathname-executable "${ROOTDIR}"; } || exit 1
(cd "${ROOTDIR}" && vc-program-gnu-arch-inventory-source-both)
}
function vc-print-unregistered-sources () {
ROOTDIR=`vc-print-tree-root-directory` || exit 1
item=
dirname=
tailname=
idname=

source `mbfl-config`

{ user-validate-directory-readable "${ROOTDIR}" && \
    user-pathname-executable "${ROOTDIR}"; } || exit 1

(cd "${ROOTDIR}"; vc-program-gnu-arch-inventory-source-both-names | \
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
ROOTDIR=`vc-print-tree-root-directory` || exit 1
item=

{ user-validate-directory-readable "${ROOTDIR}" && \
    user-pathname-executable "${ROOTDIR}"; } || exit 1

(cd "${ROOTDIR}" && vc-print-unregistered-sources | while read item; do
	user-message-verbose "adding '${item}'"
	vc-program-gnu-arch-add "${item}"
done)
vc-tree-lint
}
function vc-tree-delete () {
item=

for item in "${@}" ; do
    { vc-program-gnu-arch-delete "${item}" && \
        vc-log-add-sentence "deleted '${item}'"; } || exit 1
done
}
function vc-tree-move () {
FROM="${1:?missing from pathname parameter}"
TO="${2:?missing to pathname parameter}"

vc-program-gnu-arch-move "${FROM}" "${TO}" && \
    vc-log-add-sentence "moved '${FROM}' to '${TO}'"
}
#page
## ------------------------------------------------------------
## Log file functions.
## ------------------------------------------------------------

function vc-print-log-file-name () {
DIR=`vc-print-tree-root-directory` || exit 1
PKG=`vc-print-tree-package` || exit 1
ARCH=`vc-print-tree-archive` || exit 1

    echo "${DIR}/++log.${PKG}--${ARCH}"
}
function vc-log-edit () {
LOGFILE=`vc-print-log-file-name` || exit 1
vc-log-make || exit 1
emacsclient "${LOGFILE}"
}
function vc-log-make () {
vc-log-file-exists || vc-program-gnu-arch-make-log
}
function vc-log-file-exists () {
logfile=`vc-print-log-file-name` || exit 1
user-validate-file "${logfile}"
}
function vc-log-add-sentence () {
SENTENCE="${1:?missing sentence parameter to ${FUNCNAME}}"
logfile=`vc-print-log-file-name` || exit 1
DATE=`user-print-short-time` || exit 1
    
{ vc-log-make && user-make-backup-file "${logfile}"; } || exit 1
echo -e "\n* ${DATE}: ${SENTENCE}\n" | user-fold-sentence >>"${logfile}"
}
#page
## ------------------------------------------------------------
## Archive management.
## ------------------------------------------------------------

function vc-archive-select () {
ARCHIVE="${1:?missing archive name parameter to ${FUNCNAME}}"
vc-program-gnu-arch-my-default-archive "${ARCHIVE}"
vc-print-archive-default
}
function vc-print-archive-default () {
vc-program-gnu-arch-my-default-archive
}
function vc-print-archive-list () {
vc-program-gnu-arch-archives-names
}
function vc-print-archive-location-list () {
line=
location=

vc-program-gnu-arch-archives | while read line && read location; do
    printf '%-40s%s\n' "${line}" "${location}"
done
}
function vc-print-archive-location () {
ARCHIVE="${1:?missing archive name parameter to ${FUNCNAME}}"
vc-program-gnu-arch-whereis-archive "${ARCHIVE}"
}
#page
## ------------------------------------------------------------
## Tree management.
## ------------------------------------------------------------

function vc-tree-create-new () {
CATEGORY="${1:?missing category parameter to ${FUNCNAME}}"

vc-program-gnu-arch-init-tree
vc-tree-make-branch-from-branch "${CATEGORY}"
}
function vc-tree-make-branch-from-branch () {
PACKAGE="${1:?missing package parameter to ${FUNCNAME}}"

vc-program-gnu-arch-archive-setup "${PACKAGE}"	&& \
    vc-program-gnu-arch-add-log-version "${PACKAGE}"	&& \
    vc-program-gnu-arch-set-tree-version "${PACKAGE}"	&& \
    vc-log-make
}
function vc-tree-import () {
vc-program-gnu-arch-import && vc-log-make
}
function vc-tree-commit () {
{ vc-log-file-exists || vc-log-edit; } || exit 1
vc-program-gnu-arch-commit && vc-log-make
}
function vc-tree-lint () {
vc-program-gnu-arch-tree-lint
}

### end of file
# Local Variables:
# mode: sh
# End:
