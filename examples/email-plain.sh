#
# Part of: Marco's Bash Functions Library
# Contents: example script to send email
# Date: Thu Apr 23, 2009
#
# Abstract
#
#       This script just sends a hardcoded email message from
#       a hardcoded address to a hardcoded address.  It makes
#       no use of MBFL.
#
#         The purpose of this script is to understand how to
#       handle the SMTP protocol.
#
# Copyright (c) 2009 Marco Maggi <marcomaggi@gna.org>
#
# This  program  is free  software:  you  can redistribute  it
# and/or modify it  under the terms of the  GNU General Public
# License as published by the Free Software Foundation, either
# version  3 of  the License,  or (at  your option)  any later
# version.
#
# This  program is  distributed in  the hope  that it  will be
# useful, but  WITHOUT ANY WARRANTY; without  even the implied
# warranty  of  MERCHANTABILITY or  FITNESS  FOR A  PARTICULAR
# PURPOSE.   See  the  GNU  General Public  License  for  more
# details.
#
# You should  have received a  copy of the GNU  General Public
# License   along   with    this   program.    If   not,   see
# <http://www.gnu.org/licenses/>.
#

PROGNAME=email-plain.sh

function main () {
    local HOSTNAME=localhost
    local SMTP_PORT=25
    local FROM_ADDRESS=marco@localhost
    local TO_ADDRESS=root@localhost
    local BODY='From: marco@localhost
To: root@localhost
Subject: proof

This is a text proof.
-- \nMarco
'
    local LOGGING_TO_STDERR=yes

    open_session "$HOSTNAME"
    recv 220
    send 'HELO %s' 127.0.0.1
    recv 250
    send 'MAIL FROM:<%s>' "${FROM_ADDRESS}"
    recv 250
    send 'RCPT TO:<%s>' "${TO_ADDRESS}"
    recv 250
    send %s DATA
    recv 354
    send "${BODY}"
    send %s .
    recv 250
    send %s QUIT
    recv 221
}
function open_session () {
    local HOSTNAME=${1:?}
    exec 3<>"/dev/tcp/${HOSTNAME}/${SMTP_PORT}"
    trap 'exec 3<&-' EXIT
}
function recv () {
    local EXPECTED_CODE=${1:?}
    local line=
    read line <&3
    test "$LOGGING_TO_STDERR" = yes && \
        printf '%s log: recv: %s\n' "${PROGNAME}" "${line}"
    if test "${line:0:3}" != "$EXPECTED_CODE"
    then
        send %s QUIT
        exit 2
    fi
}
function send () {
    local pattern=${1:?}
    shift
    local line=$(printf "${pattern}" "$@")
    printf '%s\r\n' "${line}" >&3
    test "$LOGGING_TO_STDERR" = yes && \
        printf '%s log: sent: %s\n' "${PROGNAME}" "${line}"
}

main

### end of file
