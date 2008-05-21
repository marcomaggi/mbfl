# Part of: DevelStuff
# Contents: configure.ac builder
# Date: Tue Aug 21, 2007
# 
# Abstract
# 
# 
# 
# Copyright (c) 2007 Marco Maggi
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
## Setup.
## ------------------------------------------------------------

PROGNAME=${0##*/}

RM=$(type -p rm) || error 'unable to find executable "rm"'
HEAD=$(type -p head) || error 'unable to find executable "head"'
TAIL=$(type -p tail) || error 'unable to find executable "tail"'
TR=$(type -p tr) || error 'unable to find executable "tr"'

# To be initialised later.
TLA=

CDPATH=

## ------------------------------------------------------------

source vc-git-functions || { echo missing GIT functions library >&2; exit 2; }

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

# To be set to the top directory of the source tree.
SRCDIR=

## ------------------------------------------------------------

# The lowercase package name used to build source and binary
# distribution archive names, Autoconf plugin file names,
# Pkgconfig meta files, etc.
tree_PACKAGE_NAME=

# The state of this revision: devel, alpha, beta, stable.
tree_STATUS=

# The state of this revision expressed as single char: devel='d',
# alpha='a', beta='b', stable='.'.
tree_STATUS_CHAR=

# The major version number of this revision.
tree_MAJOR_VERSION=

# The minor version number of this revision.
tree_MINOR_VERSION=

# The patch level number of this revision.
tree_PATCH_LEVEL=

# The <MAJOR>.<MINOR> version number of this revision.
tree_MAJOR_MINOR_VERSION=

# The <MAJOR>.<MINOR><STATUS_CHAR><PATCH_LEVEL> version number of this
# revision.
tree_XVERSION=

# The <MAJOR>.<MINOR><STATUS_CHAR><PATCH_LEVEL> version number of this
# revision.
tree_VERSION=

## ------------------------------------------------------------

# If the  "${SRCDIR}/configure.ac" file starts  with this string:  it is
# supposed to have been generated automatically by this script, so it is
# safe to overwrite it.
MAGIC_STRING='# DevelStuff magic string for "configure.ac".'

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Main.
## ------------------------------------------------------------

# Synopsis:
#
#   main <top-source-directory>
#
function main () {
    ds-move-to-top-source-directory "$1"
    ds-print-greetings
    ds-tree-inspection
    ds-test-if-it-is-safe-to-overwrite-configure-ac || exit 0
    {
        ds-configure-ac-print-preamble
        ds-configure-ac-print-package-variables
        ds-configure-ac-print-infrastructure-stuff
        if test -d meta ; then
            ds-configure-ac-print-configuration-inspection-script
            ds-configure-ac-print-package-meta-files
            ds-configure-ac-print-pkgconfig-meta-file
            ds-configure-ac-print-slackware
        else
            verbose '"meta" directory not found (not an error)'
        fi
        ds-configure-ac-print-configure-ds
        printf '\n\n### end of file\n'
    } >configure.ac
}

## ------------------------------------------------------------

function ds-move-to-top-source-directory () {
    SRCDIR=${1:-${PWD}}
    cd "${SRCDIR}"
    SRCDIR=${PWD}
    verbose 'source directory set to: %s' "${SRCDIR}"
}
function ds-test-if-it-is-safe-to-overwrite-configure-ac () {
    verbose 'looking for "configure.ac" with DevelStuff magic string as first line...'
    if test -f configure.ac ; then
        if test "$(firstof <configure.ac)" != "${MAGIC_STRING}" ; then
            if question '\tforeign "configure.ac" exists, overwrite?' ; then
                remove configure.ac
            else
                warning 'execution aborted.'
                return 1
            fi
        else
            verbose '\tfound, it will be overwritten'
        fi
    else
        verbose '\tnot found, creating new template file'
    fi
    return 0
}

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Greetings.
## ------------------------------------------------------------

function ds-print-greetings () {
    printf '

## ------------------------------------------------------------

\tDevelStuff "configure.ac" builder

Automatically generates a GNU Autoconf template configuration
file.  Put your rules in a file named "configure.ds", it will
be included.

*** BEGIN WARNING ***

This script must be executed in the top source directory of
the (sub)project, or the source directory must be given as
argument.

*** END WARNING ***

' >&2
}

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Helper functions.
## ------------------------------------------------------------

function error () {
    local MESSAGE=${1:?"missing error message parameter in call to ${FUNCNAME}"}
    shift

    printf "${PROGNAME}: error: ${MESSAGE}\n" "${@}" >&2
    exit 2
}
function warning () {
    local MESSAGE=${1:?"missing warning message parameter in call to ${FUNCNAME}"}
    shift

    printf "${PROGNAME}: warning: ${MESSAGE}\n" "${@}" >&2
}
function verbose () {
    local MESSAGE=${1:?"missing message parameter in call to ${FUNCNAME}"}
    shift

    printf "${PROGNAME}: ${MESSAGE}\n" "${@}" >&2
}

## ------------------------------------------------------------

function question () {
    local MESSAGE=${1:?"missing message parameter in call to ${FUNCNAME}"}
    shift

    printf "${PROGNAME}: ${MESSAGE} [y|n] " "${@}" >&2
    read
    test "${REPLY}" = 'y'
}

## ------------------------------------------------------------

function arch () {
    local COMMAND=${1:?"missing command parameter in call to ${FUNCNAME}"}
    shift

    "${TLA}" ${COMMAND} "$@"
}
function lastof () {
    "${TAIL}" --lines=1
}
function tolower () {
    echo "$@" | "${TR}" '[A-Z]' '[a-z]'
}
function remove () {
    local FILE=${1:?"missing file name parameter in call to ${FUNCNAME}"}
    shift

    "${RM}" --verbose "${FILE}"
}
function firstof () {
    "${HEAD}" --lines=1
}

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Tree inspection.
## ------------------------------------------------------------

function ds-tree-inspection () {
    if vc-git-tree-is-git-controlled ; then
        verbose 'under GIT control'
        ds-tree-inspection-with-git
    elif test -d "{arch}" ; then    
        verbose 'under GNU Arch control'
        TLA=$(type -p tla) || error 'unable to find executable "tla"'
        ds-tree-inspection-with-arch
    else
        error 'unknown revision system for this source tree'
    fi

    case "${tree_STATUS}" in
        devel)
            tree_STATUS_CHAR=d
            tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
            ;;
        alpha)
            tree_STATUS_CHAR=a
            tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
            ;;
        beta)
            tree_STATUS_CHAR=b
            tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
            ;;
        stable|main)
            tree_STATUS_CHAR=.
            tree_VERSION=${tree_MAJOR_MINOR_VERSION}.${tree_PATCH_LEVEL}
            ;;
        *)
            tree_STATUS_CHAR=x
            tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
            ;;
    esac

    tree_XVERSION=${tree_MAJOR_MINOR_VERSION}${tree_STATUS_CHAR}${tree_PATCH_LEVEL}

    test -z "${tree_PACKAGE_NAME}" && error 'null package name'
    test -z "${tree_VERSION}" && error 'null package version'
    test -z "${tree_XVERSION}" && error 'null package extended version'

    verbose 'tree package name:   %s' "${tree_PACKAGE_NAME}"
    verbose 'tree version:        %s' "${tree_VERSION}"
    verbose 'tree xversion:       %s' "${tree_XVERSION}"
}

## ------------------------------------------------------------

function ds-tree-inspection-with-git () {
    vc-git-branch-acquire

    tree_PACKAGE_NAME=$(vc-git-config-print-package-name)
    tree_STATUS=$(vc-git-branch-print-status)
    vc-git-message-verbose "got: ${vc_git_branch_IDENTIFIER}"
    tree_MAJOR_MINOR_VERSION=$(vc-git-branch-print-major-minor-version)
    tree_MAJOR_VERSION=$(vc-git-branch-print-major-version)
    tree_MINOR_VERSION=$(vc-git-branch-print-minor-version)
    tree_PATCH_LEVEL=$(vc-git-branch-print-patch-level)
}
function ds-tree-inspection-with-arch () {
    local IDENTIFIER=$(arch  tree-version)

    tree_PACKAGE_NAME=${IDENTIFIER##*/}
    local CATEGORY=$(arch parse-package-name --category "${IDENTIFIER}")
    local STATUS=$(arch parse-package-name --branch "${IDENTIFIER}")
    tree_MAJOR_MINOR_VERSION=$(arch parse-package-name --vsn "${IDENTIFIER}")
    tree_MAJOR_VERSION=${tree_MAJOR_MINOR_VERSION%.[0-9]*}
    tree_MINOR_VERSION=${tree_MAJOR_MINOR_VERSION#[0-9]*.}
    local REVISION_ID=$(arch revisions | lastof)
    tree_PATCH_LEVEL=${REVISION_ID##*-}
}

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Configuration file creation: preamble and package setup.
## ------------------------------------------------------------

function ds-configure-ac-print-preamble () {
    echo "${MAGIC_STRING}"
    printf '#
# This file was automatically generated by executing:
#
#       sh ${ds_top_srcdir}/infrastructure/make-configure-ac.sh
#
# in the top source directory of this (sub)project. The script
# makes use of GNU Arch or GIT to retrieve the project name and
# version number, and does basic source tree inspection to find
# known configuration files (for example under the "meta"
# directory).
#
# The real GNU Autoconf configuration script is in "configure.ds",
# which is loaded in this file. A set of macros is also loaded
# from "${ds_top_srcdir}/infrastructure/acmacros.m4".
'
}
function ds-configure-ac-print-package-variables () {
    cat <<EOF
AC_INIT([${tree_PACKAGE_NAME}],[${tree_XVERSION}])
AC_PREREQ(2.60)

AC_SUBST([PACKAGE_VERSION],[${tree_VERSION}])
AC_DEFINE([PACKAGE_VERSION],["${tree_VERSION}"],[full package version])

AC_SUBST([PACKAGE_XVERSION],[${tree_XVERSION}])
AC_DEFINE([PACKAGE_XVERSION],["${tree_XVERSION}"],[full extended package version])

AC_SUBST([PACKAGE_VERSION_MAJOR],[${tree_MAJOR_VERSION}])
AC_DEFINE([PACKAGE_VERSION_MAJOR],["${tree_MAJOR_VERSION}"],[package version major number])

AC_SUBST([PACKAGE_VERSION_MINOR],[${tree_MINOR_VERSION}])
AC_DEFINE([PACKAGE_VERSION_MINOR],["${tree_MINOR_VERSION}"],[package version minor number])

AC_SUBST([PACKAGE_VERSION_PATCH],[${tree_PATCH_LEVEL}])
AC_DEFINE([PACKAGE_VERSION_PATCH],["${tree_PATCH_LEVEL}"],[package version patch number])

AC_SUBST([PACKAGE_VERSION_MAJOR_MINOR],[${tree_MAJOR_MINOR_VERSION}])
AC_DEFINE([PACKAGE_VERSION_MAJOR_MINOR],["${tree_MAJOR_MINOR_VERSION}"],[package version major.minor])

AC_SUBST([PACKAGE_NAME_LOWERCASE],[${tree_PACKAGE_NAME}])
AC_DEFINE([PACKAGE_NAME_LOWERCASE],["${tree_PACKAGE_NAME}"],[package name in lower case chars])
EOF
}

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Configuration file creation: source tree inspection.
## ------------------------------------------------------------

# Look  for a  "infrastructure"  directory  in the  pwd  or the  uplevel
# directory; if found  check for the existence of  the DevelStuff macros
# file and prints the Autoconf aux directory directive.
function ds-configure-ac-print-infrastructure-stuff () {
    verbose 'looking for "infrastructure" directory...'
    if test -d infrastructure -a -f infrastructure/acmacros.m4 ; then
        verbose '\tfound "./infrastructure" (suggesting single project layout)'
        printf 'AC_CONFIG_AUX_DIR([infrastructure])\nm4_include([infrastructure/acmacros.m4])\n\n'
    elif test -d ../infrastructure -a -f ../infrastructure/acmacros.m4 ; then
        verbose '\tfound "../infrastructure" (suggesting multiple project layout)'
        printf 'AC_CONFIG_AUX_DIR([../infrastructure])\nm4_include([../infrastructure/acmacros.m4])\n\n'
    else
        error '\tunable to find usable "infrastructure/acmacros.m4" file'
    fi
}

## ------------------------------------------------------------

function ds-configure-ac-print-configuration-inspection-script () {
    local CONFIG_SCRIPT=${tree_PACKAGE_NAME}-config
    local CONFIG_SCRIPT_PATHNAME=meta/${CONFIG_SCRIPT}.in

    if test -f "${CONFIG_SCRIPT_PATHNAME}" ; then
        verbose 'adding configuration inspection script as config file (%s)' "${CONFIG_SCRIPT}"
        printf 'AC_CONFIG_FILES([meta.d/%s:%s])\n' ${CONFIG_SCRIPT} ${CONFIG_SCRIPT_PATHNAME}
    else
        verbose 'skipping configuration inspection script'
    fi
}
function ds-configure-ac-print-package-meta-files () {
    for item in preinstall postinstall preremoval postremoval ; do
        if test -f meta/${item}.in ; then
            verbose 'adding "%s" script as config file' ${item}
            printf 'AC_CONFIG_FILES([meta.d/%s:meta/%s.in])\n' ${item} ${item}
        else
            verbose '"%s" script not found (not an error)' ${item}
        fi
    done
}
function ds-configure-ac-print-pkgconfig-meta-file () {
    local PKGCONFIG_META_FILE="${tree_PACKAGE_NAME}.pc"

    if test -f "meta/${PKGCONFIG_META_FILE}.in" ; then
        verbose 'adding "%s" script as config file' "${PKGCONFIG_META_FILE}"
        printf 'AC_CONFIG_FILES([meta.d/%s:meta/%s.in])\n' "${PKGCONFIG_META_FILE}" "${PKGCONFIG_META_FILE}"
    else
        verbose '"meta/%s.in" script not found (not an error)' "${PKGCONFIG_META_FILE}"
    fi
}
function ds-configure-ac-print-slackware () {
    local pathname= section=

    for section in bin doc dev ; do
        for file in doinst.sh slack-desc ; do
            pathname=meta/slackware/${section}/${file}.in
            if test -f ${pathname} ; then
                verbose 'adding "%s" script as config file' ${pathname}
                printf 'AC_CONFIG_FILES([meta.d/slackware/%s:meta/slackware/%s.in])\n' \
                    ${section}/${file} ${section}/${file}
            else
                verbose '"%s" script not found (not an error)' ${pathname}
            fi
        done
    done
}
function ds-configure-ac-print-configure-ds () {
    if test -f configure.ds ; then
        verbose 'found "configure.ds"'
        printf 'm4_include([configure.ds])\n'
    elif test -f configuration/configure.ds ; then
        verbose 'found "configuration/configure.ds"'
        printf 'm4_include([configuration/configure.ds])\n'
    else
        warning 'could not find "configure.ds"'
    fi
}

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Let's go.
## ------------------------------------------------------------

main "$@"


### end of file
# Local Variables:
# mode: sh
# End:
