#! /bin/bash
#
# Part of: Marco's Bash Functions Library
# Contents: example script to send email using bg process
# Date: Thu Apr 23, 2009
#
# Abstract
#
#       This script just sends a hardcoded email message from
#       a hardcoded address to a hardcoded address.  It makes
#       no use of MBFL.
#
#         The purpose of this script is to understand how to
#       send a message through a process in background.
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

PROGNAME=${0##*/}
: ${TMPDIR:=/tmp}

function main () {
    local HOSTNAME=localhost
    local SMTP_PORT=25
    local FROM_ADDRESS=marco@localhost
    local TO_ADDRESS=root@localhost
    local LOGGING_TO_STDERR=yes

    open_session "$HOSTNAME"
    recv 220
    send 'HELO %s' 127.0.0.1
    recv 250
    send 'MAIL FROM:<%s>' "$FROM_ADDRESS"
    recv 250
    send 'RCPT TO:<%s>' "$TO_ADDRESS"
    recv 250
    send %s DATA
    recv 354
    print_message | read_and_send_message
    send %s .
    recv 250
    send %s QUIT
    recv 221
}
function print_message () {
    local LOCAL_HOSTNAME DATE MESSAGE_ID MESSAGE
    LOCAL_HOSTNAME=$(hostname --fqdn) || exit 2
    DATE=$(date --rfc-2822) || exit 2
    MESSAGE_ID=$(printf '%d-%d-%d@%s' \
        $RANDOM $RANDOM $RANDOM "$LOCAL_HOSTNAME")
    MESSAGE="Sender: $FROM_ADDRESS
From: $FROM_ADDRESS
To: $TO_ADDRESS
Subject: proof from $PROGNAME
Message-ID: <$MESSAGE_ID>
Date: $DATE

This is a text proof from the $PROGNAME script.
--\x20
Marco
"
    printf "$MESSAGE"
}
function open_session () {
    local HOSTNAME=${1:?}
    local INFIFO=${TMPDIR}/in.$$
    local OUFIFO=${TMPDIR}/out.$$
    # Bash  has  no  operation  equivalent to  the  C  level
    # "pipe()" function, so we have to use FIFOs.
    mkfifo $INFIFO $OUFIFO
    connector "$HOSTNAME" <$OUFIFO >$INFIFO &
    # Open the input FIFO for both reading and writing, else
    # "exec" will block waiting for the first char.
    exec 3<>$INFIFO 4>$OUFIFO
    # We have connected both the  ends of both the FIFOs, so
    # we  can remove them  from the  file system:  the FIFOs
    # will continue to exist  until the file descriptors are
    # closed.
    rm $INFIFO $OUFIFO
    trap 'exec 3<&- 4>&-' EXIT
}
function recv () {
    local EXPECTED_CODE=${1:?}
    local line=
    IFS= read line <&3
    test "$LOGGING_TO_STDERR" = yes && \
        printf '%s log: recv: %s\n' "$PROGNAME" "$line"
    if test "${line:0:3}" != "$EXPECTED_CODE"
    then
        send %s QUIT
        # It is cleaner to wait for the reply from the
        # server.
        IFS= read line <&3
        test "$LOGGING_TO_STDERR" = yes && \
            printf '%s log: recv: %s\n' "$PROGNAME" "$line"
        exit 2
    fi
}
function send () {
    local pattern=${1:?}
    shift
    local line=$(printf "$pattern" "$@")
    printf '%s\r\n' "$line" >&4
    test "$LOGGING_TO_STDERR" = yes && \
        printf '%s log: sent: %s\n' "$PROGNAME" "$line"
}
function read_and_send_message () {
    local line
    local -i count=0
    while IFS= read line
    do
        printf '%s\r\n' "$line" >&4
        let ++count
    done
    test "$LOGGING_TO_STDERR" = yes && \
        printf '%s log: sent message (%d lines)\n' "$PROGNAME" $count
}
function connector () {
    local HOSTNAME=${1:?} query= answer= line=
    local DEVICE=$(printf '/dev/tcp/%s/%d' "$HOSTNAME" $SMTP_PORT)
    exec 3<>"$DEVICE"
    # Read the  greetings from the server, echo  them to the
    # client.
    IFS= read answer <&3
    printf '%s\n' "$answer"
    # Read the query from the client, echo it to the server.
    while read query
    do
        printf '%s\r\n' "$query" >&3
        # Read the  answer from the  server, echo it  to the
        # client.
        IFS= read answer <&3
        printf '%s\n' "$answer"
        # Test special queries.
        test "$query" = QUIT$'\r' && {
            IFS= read answer <&3
            printf '%s\n' "$answer"
            exit
        }
        test "$query" = DATA$'\r' && {
            # Read data lines from  the client, echo them to
            # the server up until ".\r" is read.
            while IFS= read line
            do
                printf '%s\n' "$line" >&3
                test "${line:0:2}" = .$'\r' && break
            done
            # Read the answer to  data from the server, echo
            # it to the client.
            IFS= read answer <&3
            printf '%s\n' "$answer"
        }
    done
    # We should never come here.
    exit 1
}

main

### end of file
