# Part of: Marco's BASH Functions Library
# Contents: example script that sends an email message
# Date: Thu Apr 23, 2009
#
# Abstract
#
#	This script shows how an MBFL script can send email.
#
# Copyright (c) 2009 Marco Maggi <marcomaggi@gna.org>
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
## MBFL's related options and variables.
## ------------------------------------------------------------

script_PROGNAME=mbfl-mail.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2009'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='Send an email message.'
script_EXAMPLES="Usage examples:

\techo 'From: marco@localhost
\tTo: root@localhost
\tSubject: ciao

\tHow do you do?' | ${script_PROGNAME} --from=marco --to=root"

mbfl_INTERACTIVE='no'
source "${MBFL_LIBRARY:=$(mbfl-config)}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option FROM '' F from witharg 'select envelope MAIL FROM address'
mbfl_declare_option TO   '' T to   witharg 'select envelope RCPT TO address'
mbfl_declare_option BODY -  B body witharg 'select file/body of the message'

mbfl_declare_option HOST 'localhost' n hostname witharg 'select the server hostname'
mbfl_declare_option PORT 25          p port     witharg 'select the server port'

#page
## ------------------------------------------------------------
## Declare exit codes.
## ------------------------------------------------------------

mbfl_main_declare_exit_code 2 failed_connection

#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function main () {
    local FROM_ADDRESS=$script_option_FROM
    local TO_ADDRESS=$script_option_TO
    local BODY=

    read_body           || exit $?
    open_session        || exit $?
    recv 220
    send 'HELO %s' 127.0.0.1
    recv 250
    send 'MAIL FROM:<%s>' "$FROM_ADDRESS"
    recv 250
    send 'RCPT TO:<%s>' "$TO_ADDRESS"
    recv 250
    send %s DATA
    recv 354
    send "${BODY}"
    send %s .
    recv 250
    send %s QUIT
    recv 221

    exit_because_success
}
function read_body () {
    if test "$script_option_BODY" = -
    then
        local line=
        while read line
        do
            if test -z "$BODY"
            then BODY="$line"
            else BODY="${BODY}\n$line"
            fi
        done
    else BODY=$(mbfl_file_read "$script_option_BODY")
    fi
}
#page
## ------------------------------------------------------------
## Connection functions.
## ------------------------------------------------------------

function open_session () {
    local HOSTNAME=$script_option_HOST
    local SMTP_PORT=$script_option_PORT
    local msg=$(printf 'connecting to %s:%d' "$HOSTNAME" "$SMTP_PORT")
    mbfl_message_verbose "$msg\n"
    exec 3<>"/dev/tcp/${HOSTNAME}/$SMTP_PORT" || {
        mbfl_message_error \
            $(printf 'failed establishing connection to %s:%d' "$HOSTNAME" "$SMTP_PORT")
        exit_because_failed_connection
    }
    trap 'exec 3<&-' EXIT
}
function recv () {
    local EXPECTED_CODE=${1:?}
    local line=
    read line <&3
    local msg=$(printf 'recv: %s\n' "$line")
    mbfl_message_debug "$msg"
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
    local msg=$(printf 'sent: %s\n' "${line}")
    mbfl_message_debug "$msg"
}

#page
## ------------------------------------------------------------
## Start.
## ------------------------------------------------------------

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
