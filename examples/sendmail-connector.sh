#! /bin/bash
#
# Part of: Marco's Bash Functions Library
# Contents: example script to send email using bg process
# Date: Thu Apr 23, 2009
#
# Abstract
#
#       This  script  just  sends  a  hardcoded  email  message  from  a
#       hardcoded address  to a hardcoded  address.  It makes no  use of
#       MBFL.
#
#         The purpose  of this  script is  to understand  how to  send a
#       message through a process in background.
#
# Copyright (c) 2009, 2010, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
#
# The author hereby grants  permission to use, copy, modify, distribute,
# and  license this  software  and its  documentation  for any  purpose,
# provided that  existing copyright notices  are retained in  all copies
# and that  this notice  is included verbatim in any  distributions.  No
# written agreement, license, or royalty  fee is required for any of the
# authorized uses.  Modifications to this software may be copyrighted by
# their authors and need not  follow the licensing terms described here,
# provided that the new terms are clearly indicated on the first page of
# each file where they apply.
#
# IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
# FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
# ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
# DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
# POSSIBILITY OF SUCH DAMAGE.
#
# THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
# INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
# MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
# NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
# AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
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
    printf -v MESSAGE_ID '%d-%d-%d@%s' \
        $RANDOM $RANDOM $RANDOM "$LOCAL_HOSTNAME"
    MESSAGE="Sender: $FROM_ADDRESS
From: $FROM_ADDRESS
To: $TO_ADDRESS
Subject: demo from $PROGNAME
Message-ID: <$MESSAGE_ID>
Date: $DATE

This is a text demo from the $PROGNAME script.
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
    mkfifo --mode=0600 $INFIFO $OUFIFO
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
    if test "$LOGGING_TO_STDERR" = yes
    then printf '%s log: recv: %s\n' "$PROGNAME" "$line"
    fi
    if test "${line:0:3}" != "$EXPECTED_CODE"
    then
        send %s QUIT
        # It is cleaner to wait for the reply from the
        # server.
        IFS= read line <&3
        if test "$LOGGING_TO_STDERR" = yes
        then printf '%s log: recv: %s\n' "$PROGNAME" "$line"
        fi
        exit 2
    fi
}
function send () {
    local template=${1:?}
    shift
    local line
    printf -v line "$template" "$@"
    printf '%s\r\n' "$line" >&4
    if test "$LOGGING_TO_STDERR" = yes
    then printf '%s log: sent: %s\n' "$PROGNAME" "$line"
    fi
}
function read_and_send_message () {
    local line
    local -i count=0
    while IFS= read line
    do
        if test "${line:0:1}" = '.'
        then printf '.%s\r\n' "$line" >&4
        else printf  '%s\r\n' "$line" >&4
        fi
        let ++count
    done
    if test "$LOGGING_TO_STDERR" = yes
    then printf '%s log: sent message (%d lines)\n' "$PROGNAME" $count
    fi
}
function connector () {
    local HOSTNAME=${1:?} query= answer= line=
    local DEVICE
    printf -v DEVICE '/dev/tcp/%s/%d' "$HOSTNAME" $SMTP_PORT
    exec 3<>"$DEVICE"
    # Read the  greetings from the server, echo  them to the
    # client.
    IFS= read -t 5 answer <&3
    if ((127 < $?))
    then
        printf '%s: connection timed out\n' "$PROGNAME" >&2
        exit 2
    fi
    printf '%s\n' "$answer"
    # Read the query from the client, echo it to the server.
    while read query
    do
        printf '%s\r\n' "$query" >&3
        # Read the  answer from the  server, echo it  to the
        # client.
        IFS= read -t 5 answer <&3
        if ((127 < $?))
        then
            printf '%s: connection timed out\n' "$PROGNAME" >&2
            exit 2
        fi
        printf '%s\n' "$answer"
        # Test special queries.
        if test "$query" = QUIT$'\r'
        then
            IFS= read -t 5 answer <&3
            if ((127 < $?))
            then
                printf '%s: connection timed out\n' "$PROGNAME" >&2
                exit 2
            fi
            printf '%s\n' "$answer"
            exit
        fi
        if test "$query" = DATA$'\r'
        then
            # Read data lines from  the client, echo them to
            # the server up until ".\r" is read.
            while IFS= read line
            do
                printf '%s\n' "$line" >&3
                test "${line:0:2}" = .$'\r' && break
            done
            # Read the answer to  data from the server, echo
            # it to the client.
            IFS= read -t 5 answer <&3
            if ((127 < $?))
            then
                printf '%s: connection timed out\n' "$PROGNAME" >&2
                exit 2
            fi
            printf '%s\n' "$answer"
        fi
    done
    # We should never come here.
    exit 1
}

main

### end of file
