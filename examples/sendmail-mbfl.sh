# Part of: Marco's Bash Functions Library
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
## Global variables.
## ------------------------------------------------------------

script_PROGNAME=sendmail-mbfl.sh
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

\tHow do you do?' | ${script_PROGNAME} \
   --from=marco@localhost --to=root@localhost"

#page
## ------------------------------------------------------------
## Load library.
## ------------------------------------------------------------

mbfl_INTERACTIVE=no
mbfl_LOADED=no
mbfl_INSTALLED=$(mbfl-config) &>/dev/null
mbfl_HARDCODED=
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
    test -n "$item" -a -f "$item" -a -r "$item" && {
        source "$item" &>/dev/null || {
            printf '%s error: loading MBFL file "%s"\n' \
                "$script_PROGNAME" "$item" >&2
            exit 2
        }
    }
done
unset -v item
test "$mbfl_LOADED" = yes || {
    printf '%s error: incorrect evaluation of MBFL\n' \
        "$script_PROGNAME" >&2
    exit 2
}
#page
## ------------------------------------------------------------
## Command line options.
## ------------------------------------------------------------

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option FROM \
    '' F from witharg 'select envelope MAIL FROM address'
mbfl_declare_option TO \
    '' T to   witharg 'select envelope RCPT TO address'
mbfl_declare_option MESSAGE \
    -  M message witharg 'select the source of the email message'
mbfl_declare_option TEST_MESSAGE \
    -  '' test-message noarg 'send a test message'

mbfl_declare_option HOST \
    localhost n hostname witharg 'select the server hostname'
mbfl_declare_option PORT \
    25        p port     witharg 'select the server port'

mbfl_declare_option STARTTLS \
    no '' starttls noarg 'establish a TLS bridge'
mbfl_declare_option DELAY_TLS \
    no '' delay-tls noarg 'establish a TLS bridge after server greetings'

mbfl_declare_option AUTH_FILE \
    "$HOME/.authinfo" A auth-file witharg 'select the authorisation file'
mbfl_declare_option USERNAME \
    '' U username witharg 'select the authorisation user'
mbfl_declare_option AUTH_PLAIN \
    no  '' auth-plain noarg 'select the plain authorisation type'
mbfl_declare_option AUTH_LOGIN \
    yes '' auth-login noarg 'select the login authorisation type'

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
GNUTLSCLI=

function script_option_update_AUTH_PLAIN () {
    AUTH_TYPE=AUTH_PLAIN
}
function script_option_update_AUTH_LOGIN () {
    AUTH_TYPE=AUTH_LOGIN
}
#page
function main () {
    local FROM_ADDRESS=$script_option_FROM
    local TO_ADDRESS=$script_option_TO
    local BODY INFD OUFD

    read_message || exit $?
    connect      || exit $?
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

    exit_because_success
}
#page
function connect () {
    local SMTP_HOST=$script_option_HOST
    local SMTP_PORT=$script_option_PORT

    if test "$script_option_STARTTLS" = yes
    then
        local msg DEVICE
        msg=$(printf 'connecting to %s:%d' "$SMTP_HOST" "$SMTP_PORT")
        mbfl_message_verbose "$msg\n"
        DEVICE=$(printf '/dev/tcp/%s/%d' "$SMTP_HOST" $SMTP_PORT)
        INFD=3
        OUFD=3
        exec 3<>"$DEVICE" || {
            msg=$(printf 'failed establishing connection to %s:%d' "$SMTP_HOST" "$SMTP_PORT")
            mbfl_message_error "$msg"
            exit_because_failed_connection
        }
        trap 'exec 3<&-' EXIT
    else
        local CONNECTOR=$script_option_CONNECTOR
        local msg DEVICE MKFIFO
        local INPIPE=/tmp/marco/in.$$ OUPIPE=/tmp/marco/out.$$

        MKFIFO=$(mbfl_program_found mkfifo)        || exit $?
        mbfl_message_debug 'creating FIFOs for connector dialogue'
        mbfl_program_exec "$MKFIFO" $INPIPE $OUPIPE || {
            mbfl_message_error 'unable to create FIFOs'
            exit_failure
        }
        case "$CONNECTOR" in
            gnutls)
                local GNUTLS GNUTLS_FLAGS=" --crlf --starttls --port $SMTP_PORT"
                GNUTLS=$(mbfl_program_found gnutls-cli) || exit $?
                msg=$(printf 'connecting to \"%s:%s\"' "$SMTP_HOST" "$SMTP_PORT")
                mbfl_message_verbose "$msg\n"
                if ! mbfl_program_execbg $OUPIPE $INPIPE "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOST"
                then
                    msg=$(printf 'failed connection to \"%s:%s\"' "$SMTP_HOST" "$PORT")
                    mbfl_message_error "$msg"
                    exit_failed_connection
                fi
                GNUTLS_PID=$mbfl_program_BGPID
                mbfl_message_debug "pid of gnutls: $GNUTLS_PID"
                mbfl_message_verbose 'connection succeeded\n'
                ;;
            openssl)
                ;;
            *)
                mbfl_message_error "internal: unknown connector $CONNECTOR"
                exit_failure
                ;;
        esac

        exec $INFD<>$INPIPE $OUFD>$OUPIPE
        mbfl_file_remove $INPIPE
        mbfl_file_remove $OUPIPE
    fi
}
#page
function recv () {
    local EXPECTED_CODE=${1:?}
    local line msg
    IFS= read line <&$INFD
    msg=$(printf 'recv: %s\n' "$line")
    mbfl_message_debug "$msg"
    if test "${line:0:3}" != "$EXPECTED_CODE"
    then
        send %s QUIT
        IFS=read -t 3 line <$INFD
        msg=$(printf 'recv: %s\n' "$line")
        exit 2
    fi
}
function send () {
    local pattern=${1:?}
    shift
    local line=$(printf "${pattern}" "$@")
    printf '%s\r\n' "${line}" >&$OUFD
    local msg=$(printf 'sent: %s\n' "${line}")
    mbfl_message_debug "$msg"
}
function read_and_send_message () {
    local line msg
    local -i count=0
    while IFS= read line
    do
        printf '%s\r\n' "$line" >&$OUFD
        let ++count
    done
    msg=$(printf '%s log: sent message (%d lines)' "$PROGNAME" $count)
    mbfl_message_debug "$msg"
}
#page

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
