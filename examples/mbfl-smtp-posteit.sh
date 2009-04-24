# Part of: Marco's BASH Functions Library
# Contents: example script that sends an email message with Poste.it
# Date: Thu Apr 23, 2009
#
# Abstract
#
#	This script shows how an MBFL script can send email using
#	"gnutls-cli" and the Poste.it server.
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

script_PROGNAME=mbfl-smtp-posteit.sh
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

mbfl_declare_option AUTH_FILE "$HOME/.authinfo" A auth-file witharg 'select the authorisation file'
mbfl_declare_option AUTH_USER '' U auth-user witharg 'select the authorisation user'
mbfl_declare_option AUTH_PLAIN no  '' auth-plain noarg 'select the plain authorisation type'
mbfl_declare_option AUTH_LOGIN yes '' auth-login noarg 'select the login authorisation type'

mbfl_declare_option HOST 'relay.poste.it' n hostname witharg 'select the server hostname'
mbfl_declare_option PORT 465 p port witharg 'select the server port'

#page
## ------------------------------------------------------------
## Programs.
## ------------------------------------------------------------

mbfl_declare_program base64
mbfl_declare_program grep
mbfl_declare_program mkfifo
mbfl_declare_program gnutls-cli
mbfl_file_enable_remove

#page
## ------------------------------------------------------------
## Declare exit codes.
## ------------------------------------------------------------

mbfl_main_declare_exit_code 2 failed_connection
mbfl_main_declare_exit_code 3 unknown_auth_user
mbfl_main_declare_exit_code 4 unreadable_auth_file
mbfl_main_declare_exit_code 5 invalid_auth_file

#page
## ------------------------------------------------------------
## Option update functions.
## ------------------------------------------------------------

AUTH_TYPE=AUTH_LOGIN
GNUTLSCLI_PID=

function script_option_update_AUTH_PLAIN () {
    AUTH_TYPE=AUTH_PLAIN
}
function script_option_update_AUTH_LOGIN () {
    AUTH_TYPE=AUTH_LOGIN
}
#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function main () {
    local BASE64=$(mbfl_program_found base64) || exit $?
    local FROM_ADDRESS=$script_option_FROM
    local TO_ADDRESS=$script_option_TO
    local BODY= LOGIN_NAME= PASSWORD=
    local msg=

    mbfl_program_validate_declared || \
        exit_because_program_not_found
    trap cleanup_on_exit EXIT

    read_body || exit $?
    read_auth || exit $?
    open_session || exit $?
    recv_gnutls_cli_greetings
    # Tell gnutls to start a TLS session
    kill -s SIGALRM $GNUTLSCLI_PID
    recv_server_greetings
    send 'EHLO %s' localhost
    multirecv 250
    case "$AUTH_TYPE" in
        AUTH_PLAIN)
            mbfl_message_verbose 'performing AUTH PLAIN authentication\n'
            send 'AUTH PLAIN %s' $(printf "\x00${LOGIN_NAME}\x00${PASSWORD}" | \
                mbfl_program_exec "$BASE64")
            recv 250
            ;;
        AUTH_LOGIN)
            mbfl_message_verbose 'performing AUTH LOGIN authentication\n'
            send 'AUTH LOGIN'
            recv 334
            send $(echo "${LOGIN_NAME}" | mbfl_program_exec "$BASE64")
            recv 334
            send $(echo "${PASSWORD}"   | mbfl_program_exec "$BASE64")
            recv 235
            ;;
        *)
            local msg=$(printf 'unknown authorisation type: %s' "$AUTH_TYPE")
            mbfl_message_error "$msg"
            exit_failure
            ;;
    esac
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
function cleanup_on_exit () {
    if test -n "$GNUTLSCLI_PID"
    then kill -s SIGTERM "$GNUTLSCLI_PID"
    fi
    # Better to close the output channel first?
    exec 4>&- 3<&-
}

#page
## ------------------------------------------------------------
## Body.
## ------------------------------------------------------------

function read_body () {
    mbfl_message_verbose 'reading message\n'
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
## Auth file.
## ------------------------------------------------------------

function read_auth () {
    local GREP=$(mbfl_program_found grep)
    local auth_user=$script_option_AUTH_USER
    local auth_file=$script_option_AUTH_FILE
    local HOSTNAME=$script_option_HOST
    local line=

    mbfl_message_verbose 'reading auth file\n'
    mbfl_file_is_readable "$auth_file" || {
        local msg=$(printf 'unreadable auth file \"%s\"' "$auth_file")
        mbfl_message_error "$msg"
        exit_because_unreadable_auth_file
    }
    line=$(mbfl_program_exec "${GREP}" "$auth_user" "$auth_file") || {
        local msg=$(printf 'unknown auth user name \"%s\"' "$LOGIN_NAME")
        mbfl_message_error "$msg"
        exit_because_unknown_auth_user
    }
    set -- $line
    auth_file_validate_word "$1" machine        first   || exit $?
    auth_file_validate_word "$2" "$HOSTNAME"    second  || exit $?
    auth_file_validate_word "$3" login          third   || exit $?
    auth_file_validate_word "$5" password       fifth   || exit $?
    LOGIN_NAME=$4
    PASSWORD=$6
# This is reserved information so do not print it on the terminal!!!
#     local msg=$(printf 'username %s, password %s' "$LOGIN_NAME" "$PASSWORD")
#     mbfl_message_debug "$msg"
    return 0
}
function auth_file_validate_word () {
    local GOT=${1:?} EXPECTED=${2:?} POSITION=${3:?} msg=
    if test "$GOT" = "$EXPECTED"
    then
        msg=$(printf 'good %s word of auth record (%s)' $POSITION $GOT)
        mbfl_message_verbose "$msg\n"
    else
        msg=$(printf 'expected \"%s\" as %s word of auth record, got \"%s\"' \
            "$EXPECTED" "$POSITION" "$GOT")
        mbfl_message_error "$msg"
        exit_because_invalid_auth_file
    fi
}

#page
## ------------------------------------------------------------
## Connection functions.
## ------------------------------------------------------------

function open_session () {
    local MKFIFO GNUTLSCLI msg
    local HOSTNAME=${script_option_HOST} PORT=${script_option_PORT}
    local GNUTLS_FLAGS=" --crlf --starttls --port $PORT"
    local INPIPE=/tmp/marco/in.$$ OUPIPE=/tmp/marco/out.$$
    MKFIFO=$(mbfl_program_found mkfifo)        || exit $?
    GNUTLSCLI=$(mbfl_program_found gnutls-cli) || exit $?
    mbfl_program_exec "$MKFIFO" $INPIPE $OUPIPE || {
        mbfl_message_error 'unable to create FIFOs'
        exit_failure
    }
    msg=$(printf 'connecting to \"%s:%s\"' "$HOSTNAME" "$PORT")
    mbfl_message_verbose "$msg\n"
    if ! mbfl_program_execbg $OUPIPE $INPIPE "$GNUTLSCLI" $GNUTLS_FLAGS "$HOSTNAME"
    then
        msg=$(printf 'failed connection to \"%s:%s\"' "$HOSTNAME" "$PORT")
        mbfl_message_error "$msg"
        exit_failed_connection
    fi
    GNUTLSCLI_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of gnutls-cli: $GNUTLSCLI_PID"
    mbfl_message_verbose 'connection succeeded\n'
    exec 3<>$INPIPE 4>$OUPIPE
    mbfl_file_remove $INPIPE
    mbfl_file_remove $OUPIPE
}
function recv_gnutls_cli_greetings () {
    local i
    for ((i=0; $i < 5; ++i)); do
        read line <&3
        msg=$(printf 'drop line from gnutls-cli: %s' "$line")
        mbfl_message_debug "$msg"
    done
    mbfl_message_debug 'consumed lines from gnutls-cli greetings'
}
function recv_server_greetings () {
    # Consume lines until 220
    local line=
    while read line <&3
    do
        msg=$(printf 'drop greetings line from server: %s' "$line")
        mbfl_message_debug "$msg"
        test "${line:0:3}" = 220 && break
    done
}
function send () {
    local pattern=${1:?}
    shift
    local line=$(printf "${pattern}" "$@")
    printf '%s\r\n' "${line}" >&4
    local msg=$(printf 'sent: %s\n' "${line}")
    mbfl_message_debug "$msg"
}
function recv () {
    local EXPECTED_CODE=${1:?}
    local line=
    read line <&3
    local msg=$(printf 'recv: %s\n' "$line")
    mbfl_message_debug "$msg"
    if test "$EXPECTED_CODE" != \* -a "${line:0:3}" != "$EXPECTED_CODE"
    then
        send %s QUIT
        read line <&3
        msg=$(printf 'recv: %s\n' "$line")
        mbfl_message_debug "$msg"
        exit 2
    fi
}
# Receive lines  starting with the  given code; stop  at the
# first  line starting  with the  given code  followed  by a
# space.  This  is to  read the multiline  answer to  a EHLO
# query.
function multirecv () {
    local EXPECTED_CODE=${1:?}
    local line=
    while read line <&3
    do
        local msg=$(printf 'multirecv: %s\n' "$line")
        mbfl_message_debug "$msg"
        if test "${line:0:3}" != "$EXPECTED_CODE"
        then
            send %s QUIT
            read line <&3
            msg=$(printf 'recv: %s\n' "$line")
            mbfl_message_debug "$msg"
            exit 2
        fi
        test "${line:0:4}" = "$EXPECTED_CODE " && break
    done
}

#page
## ------------------------------------------------------------
## Start.
## ------------------------------------------------------------

mbfl_main || exit $?

### end of file
# Local Variables:
# mode: sh
# End:
