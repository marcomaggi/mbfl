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
## Greetings.
## ------------------------------------------------------------

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

'

function exit_callback () {
    printf '\n## ------------------------------------------------------------\n\n'
}

trap exit_callback EXIT

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
## Setup.
## ------------------------------------------------------------

PROGNAME=${0##*/}
SRCDIR=${1:-${PWD}}

RM=$(type -p rm) || error 'unable to find executable "rm"'
TLA=$(type -p tla) || error 'unable to find executable "tla"'
HEAD=$(type -p head) || error 'unable to find executable "head"'
TAIL=$(type -p tail) || error 'unable to find executable "tail"'
TR=$(type -p tr) || error 'unable to find executable "tr"'

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

cd "${SRCDIR}"
SRCDIR=${PWD}
verbose 'source directory set to: %s' "${SRCDIR}"

tree_IDENTIFIER=$(arch  tree-version)
tree_ARCHIVE=${tree_IDENTIFIER%%/*}
tree_NAME=${tree_IDENTIFIER##*/}
tree_CATEGORY=$(arch    parse-package-name --category   "${tree_IDENTIFIER}")
tree_BRANCH=$(arch      parse-package-name --branch     "${tree_IDENTIFIER}")
tree_MAJOR_MINOR_VERSION=$(arch     parse-package-name --vsn        "${tree_IDENTIFIER}")
tree_REVISION_ID=$(arch revisions | lastof)
tree_REVISION=${tree_REVISION_ID##*-}

case "${tree_BRANCH}" in
    alpha)
        tree_REVISION_LEVEL=a
        tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
        ;;
    beta)
        tree_REVISION_LEVEL=b
        tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
        ;;
    stable|main)
        tree_REVISION_LEVEL=.
        tree_VERSION=${tree_MAJOR_MINOR_VERSION}.${tree_REVISION}
        ;;
    *)
        tree_REVISION_LEVEL=x
        tree_VERSION=${tree_MAJOR_MINOR_VERSION}.0
        ;;
esac

tree_XVERSION=${tree_MAJOR_MINOR_VERSION}${tree_REVISION_LEVEL}${tree_REVISION}

tree_NAME_LOWERCASE=$(tolower "${tree_CATEGORY}")

verbose 'archive identifier:  %s' "${tree_ARCHIVE}"
verbose 'tree identifier:     %s--%s' "${tree_NAME}" "${tree_REVISION_ID}"
verbose 'tree version:        %s' "${tree_VERSION}"
verbose 'tree xversion:       %s' "${tree_XVERSION}"

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## File system inspection.
## ------------------------------------------------------------

MAGIC_STRING='# DevelStuff magic string for "configure.ac".'

verbose 'looking for "configure.ac" with DevelStuff magic string as first line...'
if test -f configure.ac ; then
    if test "$(firstof <configure.ac)" != "${MAGIC_STRING}" ; then
        if question '\tforeign "configure.ac" exists, overwrite?' ; then
            remove configure.ac
        else
            warning 'execution aborted.'
            exit 1
        fi
    else
        verbose '\tfound, it will be overwritten'
    fi
else
    verbose '\tnot found, creating new template file'
fi

## ------------------------------------------------------------

#page
## ------------------------------------------------------------
## Configuration file creation.
## ------------------------------------------------------------

{
    printf '%s
#
# This file was automatically generated by executing:
#
#       sh ${top_srcdir}/infrastructure/make-configure-ac.sh
#
# in the top source directory of this (sub)project. The script
# makes use of GNU Arch to retrieve the project name and version
# number, and does basic source tree inspection to find known
# configuration files (for example under the "meta" directory).
#
# The real GNU Autoconf configuration script is in "configure.ds",
# which is loaded in this file. A set of macros is also loaded
# from "${top_srcdir}/infrastructure/acmacros.m4".


AC_INIT([%s], [%s])
AC_PREREQ(2.60)

AC_SUBST([PACKAGE_VERSION], [%s])
AC_DEFINE([PACKAGE_VERSION], ["%s"], [full package version])

AC_SUBST([PACKAGE_XVERSION], [%s])
AC_DEFINE([PACKAGE_XVERSION], ["%s"], [full extended package version])

AC_SUBST([PACKAGE_VERSION_MAJOR_MINOR], [%s])
AC_DEFINE([PACKAGE_VERSION_MAJOR_MINOR], ["%s"], [package version major.minor])

AC_SUBST([PACKAGE_NAME_LOWERCASE],  [%s])
AC_DEFINE([PACKAGE_NAME_LOWERCASE], ["%s"], [package name in lower case chars])

' \
"${MAGIC_STRING}"                                               \
"${tree_CATEGORY}" "${tree_XVERSION}"                           \
"${tree_VERSION}" "${tree_VERSION}"                             \
"${tree_XVERSION}" "${tree_XVERSION}"                           \
"${tree_MAJOR_MINOR_VERSION}" "${tree_MAJOR_MINOR_VERSION}"     \
"${tree_NAME_LOWERCASE}" "${tree_NAME_LOWERCASE}"

## ------------------------------------------------------------

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


## ------------------------------------------------------------

CONFIG_SCRIPT=${tree_NAME_LOWERCASE}-config
CONFIG_SCRIPT_PATHNAME=meta/${CONFIG_SCRIPT}.in
if test -f "${CONFIG_SCRIPT_PATHNAME}" ; then
    verbose 'adding configuration inspection script as config file (%s)' "${CONFIG_SCRIPT}"
    printf 'AC_CONFIG_FILES([meta.d/%s:%s])\n' ${CONFIG_SCRIPT} ${CONFIG_SCRIPT_PATHNAME}
else
    verbose 'skipping configuration inspection script'
fi

for item in preinstall postinstall preremoval postremoval ; do
    if test -f meta/${item}.in ; then
        verbose 'adding "%s" script as config file' ${item}
        printf 'AC_CONFIG_FILES([meta.d/%s:meta/%s.in])\n' ${item} ${item}
    else
        verbose '"%s" script not found' ${item}
    fi
done

for section in bin doc dev ; do
    for file in doinst.sh slack-desc ; do
        pathname=meta/slackware/${section}/${file}.in
        if test -f ${pathname} ; then
            verbose 'adding "%s" script as config file' ${pathname}
            printf 'AC_CONFIG_FILES([meta.d/slackware/%s:meta/slackware/%s.in])\n' \
                ${section}/${file} ${section}/${file}
            break
        else
            verbose '"%s" script not found (not an error)' ${pathname}
        fi
    done
done

## ------------------------------------------------------------

    printf 'm4_include([configure.ds])

### end of file\n'
} >configure.ac

### end of file
# Local Variables:
# mode: sh
# End:
