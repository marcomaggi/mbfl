# Part of: Marco's Bash Functions Library
# Contents: example script that sends an email message
# Date: Thu Apr 23, 2009
#
# Abstract
#
#	This script shows how an MBFL script can send email.
#	It supports plain connections and encrypted
#	connections using external programs.
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

\tHow do you do?
\t' | ${script_PROGNAME} \\
\t\t--from=marco@localhost --to=root@localhost"

#page
## ------------------------------------------------------------
## Load library.
## ------------------------------------------------------------

mbfl_INTERACTIVE=no
mbfl_LOADED=no
mbfl_INSTALLED=$(mbfl-config) &>/dev/null
mbfl_HARDCODED=
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do test -n "$item" -a -f "$item" -a -r "$item" && {
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
    no '' test-message noarg 'send a test message'

mbfl_declare_option HOST \
    localhost n hostname witharg 'select the server hostname'
mbfl_declare_option PORT \
    25        p port     witharg 'select the server port'

mbfl_declare_option STARTTLS \
    no '' starttls noarg 'establish a TLS bridge immediately'
mbfl_declare_option DELAYED_STARTTLS \
    no '' delayed-starttls noarg 'establish a TLS bridge after server greetings'
mbfl_declare_option GNUTLS_CONNECTOR \
    no '' gnutls noarg 'use gnutls-cli for TLS'
mbfl_declare_option OPENSSL_CONNECTOR \
    no '' openssl noarg 'use openssl for TLS'

mbfl_declare_option AUTH_FILE \
    "$HOME/.authinfo" '' auth-file witharg 'select the authorisation file'
mbfl_declare_option AUTH_USER \
    '' '' username witharg 'select the authorisation user'
mbfl_declare_option AUTH_PLAIN \
    no  '' auth-plain noarg 'select the plain authorisation type'
mbfl_declare_option AUTH_LOGIN \
    yes '' auth-login noarg 'select the login authorisation type'

#page
## ------------------------------------------------------------
## Programs.
## ------------------------------------------------------------

mbfl_file_enable_remove

mbfl_declare_program base64
mbfl_declare_program date
mbfl_declare_program gnutls-cli
mbfl_declare_program grep
mbfl_declare_program hostname
mbfl_declare_program mkfifo
mbfl_declare_program openssl

#page
## ------------------------------------------------------------
## Declare exit codes.
## ------------------------------------------------------------

mbfl_main_declare_exit_code 2 invalid_option
mbfl_main_declare_exit_code 3 invalid_message_source
mbfl_main_declare_exit_code 2 failed_connection
mbfl_main_declare_exit_code 3 unknown_auth_user
mbfl_main_declare_exit_code 4 unreadable_auth_file
mbfl_main_declare_exit_code 5 invalid_auth_file


#page
## ------------------------------------------------------------
## Option update functions.
## ------------------------------------------------------------

# Selected   ESMTP   authorisation   type.   Valid   values:
# "AUTH_LOGIN", "AUTH_PLAIN".
AUTH_TYPE=AUTH_LOGIN

# The identifier  for the program  to use as  TLS connector.
# Valid  values: "GNUTLS",  "OPENSSL"; if  set to  the empty
# string: no connector  is used, so the session  is in plain
# text.
CONNECTOR=

function script_option_update_AUTH_PLAIN () {
    AUTH_TYPE=AUTH_PLAIN
}
function script_option_update_AUTH_LOGIN () {
    AUTH_TYPE=AUTH_LOGIN
}
function script_option_update_GNUTLS_CONNECTOR () {
    CONNECTOR=GNUTLS
}
function script_option_update_OPENSSL_CONNECTOR () {
    CONNECTOR=OPENSSL
}
#page
function main () {
    local FROM_ADDRESS=$script_option_FROM
    local TO_ADDRESS=$script_option_TO
    local SMTP_HOST=$script_option_HOST
    local SMTP_PORT=$script_option_PORT
    local MESSAGE
    # Input  and  output   file  descriptors  when  using  a
    # connector subprocess.
    local INFD= OUFD=
    # This is for the PID of the connector external program,
    # executed as child process.
    local CONNECTOR_PID=
    # Pathnames of the FIFOs used to talk to the connector's
    # child process.
    local INFIFO= OUFIFO=

    validate_command_line_options
    read_message_from_selected_source
    {
        mbfl_message_verbose_printf 'connecting to \"%s:%d\"\n' "$SMTP_HOST" "$SMTP_PORT"

        if test -z "$CONNECTOR"
        then
            connect_establish_plain_connection
            smtp_exchange_greetings
        else
            if test "$script_option_STARTTLS" = yes
            then
                connect_make_fifos_for_connector
                case "$CONNECTOR" in
                    GNUTLS)
                        connect_using_gnutls
                        ;;
                    OPENSSL)
                        connect_using_openssl
                        ;;
                    *)
                        mbfl_message_error "internal: unknown connector $CONNECTOR"
                        exit_failure
                        ;;
                esac
                connect_establish_tls_connection
                esmtp_exchange_greetings
                esmtp_authentication
            elif test "$script_option_DELAYED_STARTTLS" = yes
            then
                connect_make_fifos_for_connector
                case "$CONNECTOR" in
                    GNUTLS)
                        connect_using_gnutls_delayed
                        ;;
                    OPENSSL)
                        connect_using_openssl_delayed
                        ;;
                    *)
                        mbfl_message_error "internal: unknown connector $CONNECTOR"
                        exit_failure
                        ;;
                esac
                connect_establish_tls_connection
                esmtp_exchange_greetings
                esmtp_authentication
            fi
        fi
        mbfl_message_verbose 'connection established\n'
    } || exit_because_failed_connection
    esmtp_send_message
    esmtp_quit
    test -n "$CONNECTOR" && wait $CONNECTOR_PID
    exit_because_success
}
function validate_command_line_options () {
    test -n "$script_option_FROM" || {
        mbfl_message_error 'empty string as MAIL FROM envelope address'
        exit_because_invalid_option
    }
    test -n "$script_option_TO" || {
        mbfl_message_error 'empty string as RCPT TO envelope address'
        exit_because_invalid_option
    }
    test "$script_option_TEST_MESSAGE" = no && {
        test -n "$script_option_MESSAGE" || {
            mbfl_message_error 'missing selection of mail message source'
            exit_because_invalid_option
        }
        test "$script_option_MESSAGE" = - || {
            mbfl_file_is_file "$script_option_MESSAGE" || {
                mbfl_message_error 'selected message file does not exist'
                exit_because_invalid_option
            }
            mbfl_file_is_readable "$script_option_MESSAGE" || {
                mbfl_message_error 'selected message file is not readable'
                exit_because_invalid_option
            }
        }
    }
    test -n "$script_option_HOST" || {
        mbfl_message_error 'empty string as SMTP server hostname'
        exit_because_invalid_option
    }
    mbfl_string_is_noblank "$script_option_HOST" || {
        mbfl_message_error 'selected hostname string has blank character in it'
        exit_because_invalid_option
    }
    test -n "$script_option_PORT" || {
        mbfl_message_error 'empty string as SMTP server port number'
        exit_because_invalid_option
    }
    mbfl_string_is_digit "$script_option_PORT" || {
        mbfl_message_error 'selected port string is not numeric'
        exit_because_invalid_option
    }
    test "$script_option_STARTTLS" = yes -o "$script_option_DELAYED_STARTTLS" = yes && {
        test -n "$script_option_AUTH_FILE" || {
            mbfl_message_error 'empty string as auth file pathname'
            exit_because_invalid_option
        }
        mbfl_file_is_file "$script_option_AUTH_FILE" || {
            mbfl_message_error 'selected auth file does not exist'
            exit_because_invalid_option
        }
        mbfl_file_is_readable "$script_option_AUTH_FILE" || {
            mbfl_message_error 'selected auth file is not readable'
            exit_because_invalid_option
        }
        test -n "$script_option_USERNAME" || {
            mbfl_message_error 'empty string as auth username'
            exit_because_invalid_option
        }
    }
    return 0
}
#page
function read_message_from_selected_source () {
    local line msg
    local -i count=0
    if test "$script_option_TEST_MESSAGE" = yes
    then
        # Here we can detect  an error through the exit code
        # of "print_test_message".
        MESSAGE=$(print_test_message) || {
            mbfl_message_error 'unable to compose test message'
            exit_because_invalid_message_source
        }
        mbfl_message_verbose 'composed test message\n'
    else
        if test "$script_option_MESSAGE" = -
        then
            mbfl_message_verbose 'reading message from stdin'
            exec 5<&0
        else
            mbfl_message_verbose 'reading message from file'
            exec 5<"$script_option_MESSAGE"
        fi
        # Here  it is impossible  to distinguish  between an
        # error reading the source and an the end of file.
        while IFS= read line <&5
        do
            if test -z "$MESSAGE"
            then MESSAGE="$line"
            else MESSAGE="$MESSAGE\n$line"
            fi
            let ++count
        done
        exec 5<&-
        mbfl_message_verbose_printf 'read message (%d lines)\n' $count
    fi
    # Append a newline just to be sure
    MESSAGE="$MESSAGE\n"
    return 0
}
function print_test_message () {
    local LOCAL_HOSTNAME DATE MESSAGE_ID MESSAGE
    local HOSTNAME_PROGRAM DATE_PROGRAM
    HOSTNAME_PROGRAM=$(mbfl_program_found hostname)     || exit $?
    DATE_PROGRAM=$(mbfl_program_found date)             || exit $?
    LOCAL_HOSTNAME=$(mbfl_program_exec "$HOSTNAME_PROGRAM" --fqdn) || {
        mbfl_message_error 'unable to determine fully qualified hostname for test message'
        exit_failure
    }
    DATE=$(mbfl_program_exec "$DATE_PROGRAM" --rfc-2822) || {
        mbfl_message_error 'unable to determine date in RFC-2822 format for test message'
        exit_failure
    }
    MESSAGE_ID=$(printf '%d-%d-%d@%s' $RANDOM $RANDOM $RANDOM "$LOCAL_HOSTNAME")
    MESSAGE="Sender: $FROM_ADDRESS
From: $FROM_ADDRESS
To: $TO_ADDRESS
Subject: test message from $script_PROGNAME
Message-ID: <$MESSAGE_ID>
Date: $DATE

This is a test message from the $script_PROGNAME script.
--\x20
The $script_PROGNAME script
Copyright $script_COPYRIGHT_YEARS $script_AUTHOR
"
    printf "$MESSAGE"
}
#page
function connect_establish_plain_connection () {
    local DEVICE=$(printf '/dev/tcp/%s/%d' "$SMTP_HOST" "$SMTP_PORT")
    INFD=3
    OUFD=$INFD
    exec 3<>"$DEVICE" || {
        msg=$(printf 'failed establishing connection to %s:%d' "$SMTP_HOST" $SMTP_PORT)
        mbfl_message_error "$msg"
        exit_because_failed_connection
    }
    return 0
}
function connect_using_gnutls () {
    local GNUTLS GNUTLS_FLAGS=" --crlf --port $SMTP_PORT"
    GNUTLS=$(mbfl_program_found gnutls-cli) || exit $?
    mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOST" || {
        msg=$(printf 'failed connection to \"%s:%s\"' "$SMTP_HOST" "$SMTP_PORT")
        mbfl_message_error "$msg"
        exit_failed_connection
    }
    CONNECTOR_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of gnutls: $CONNECTOR_PID"
    return 0
}
function connect_using_gnutls_delayed () {
    local GNUTLS GNUTLS_FLAGS=" --crlf --starttls --port $SMTP_PORT"
    GNUTLS=$(mbfl_program_found gnutls-cli) || exit $?
    mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOST" || {
        msg=$(printf 'failed connection to \"%s:%s\"' "$SMTP_HOST" "$SMTP_PORT")
        mbfl_message_error "$msg"
        exit_failed_connection
    }
    CONNECTOR_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of gnutls: $CONNECTOR_PID"
    esmtp_exchange_greetings
    kill -SIGALRM $CONNECTOR_PID
    return 0
}
function connect_using_openssl () {
# $ openssl s_client -connect smtp.myhost.com:25 -starttls smtp
# $ openssl s_client -connect smtp.myhost.com:465
    exit_because_failed_connection
}
function connect_using_openssl_delayed () {
    exit_because_failed_connection
}
#page
function connect_make_fifos_for_connector () {
    local MKFIFO
    TMPDIR=$(mbfl_file_find_tmpdir) || {
        mbfl_message_error 'unable to determine pathname of temporary directory'
        exit_failure
    }
    INFIFO=$TMPDIR/in.$RANDOM.$$
    OUFIFO=$TMPDIR/out.$RANDOM.$$
    MKFIFO=$(mbfl_program_found mkfifo) || exit $?
    mbfl_message_debug 'creating FIFOs for connector subprocess'
    trap connect_cleanup_fifos EXIT
    mbfl_program_exec "$MKFIFO" --mode=0600 "$INFIFO" "$OUFIFO" || {
        mbfl_message_error 'unable to create FIFOs'
        exit_failure
    }
    return 0
}
function connect_cleanup_fifos () {
    mbfl_file_remove "$INFIFO" &>/dev/null || true
    mbfl_file_remove "$OUFIFO" &>/dev/null || true
}
function connect_open_file_descriptors_to_fifos () {
    INFD=3
    OUFD=4
    exec $INFD<>$INFIFO $OUFD>$OUFIFO
    cleanup_fifos
    trap "" EXIT
    return 0
}
#page
function recv () {
    local EXPECTED_CODE=${1:?}
    local line msg
    IFS= read line <&$INFD
    msg=$(printf 'recv: %s\n' "$line")
    mbfl_message_debug "$msg"
    test "${line:0:3}" = "$EXPECTED_CODE" || {
        send %s QUIT
        IFS=read -t 3 line <$INFD
        msg=$(printf 'recv: %s\n' "$line")
        exit_failure
    }
    return 0
}
function send () {
    local pattern=${1:?}
    shift
    local line=$(printf "$pattern" "$@")
    printf '%s\r\n' "$line" >&$OUFD
    local msg=$(printf 'sent: %s\n' "$line")
    mbfl_message_debug "$msg"
    return 0
}
function read_and_send_message () {
    local line msg
    local -i count=0
    while IFS= read line
    do
        printf '%s\r\n' "$line" >&$OUFD
        let ++count
    done
    msg=$(printf 'sent message (%d lines)' $count)
    mbfl_message_debug "$msg"
    return 0
}
#page
function smtp_exchange_greetings () {
    local HOSTNAME_PROGRAM
    HOSTNAME_PROGRAM=$(mbfl_program_found hostname) || exit $?
    LOCAL_HOSTNAME=$(mbfl_program_exec "$HOSTNAME_PROGRAM" --fqdn) || {
        mbfl_message_error 'unable to acquire local hostname'
        exit_failure
    }
    mbfl_message_verbose 'esmtp: exchanging greetings with server\n'
    recv 220
    send 'HELO %s' "$LOCAL_HOSTNAME"
    recv 250
}
function esmtp_exchange_greetings () {
    local HOSTNAME_PROGRAM
    HOSTNAME_PROGRAM=$(mbfl_program_found hostname) || exit $?
    LOCAL_HOSTNAME=$(mbfl_program_exec "$HOSTNAME_PROGRAM" --fqdn) || {
        mbfl_message_error 'unable to acquire local hostname'
        exit_failure
    }
    mbfl_message_verbose 'esmtp: exchanging greetings with server\n'
    recv 220
    send 'EHLO %s' "$LOCAL_HOSTNAME"
    recv 250
}
function pipe_base64 () {
    mbfl_program_exec "$BASE64"
}
function esmtp_authentication () {
    local BASE64 LOGIN_NAME= PASSWORD= msg= ENCODED_STRING=
    BASE64=$(mbfl_program_found base64) || exit $?
    auth_read_credentials
    case "$AUTH_TYPE" in
        AUTH_PLAIN)
            mbfl_message_verbose 'performing AUTH PLAIN authentication\n'
            ENCODED_STRING=$(printf '\x00%s\x00%s' "$LOGIN_NAME" "$PASSWORD" | pipe_base64)
            test ${PIPESTATUS[1]} -eq 0 || {
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            }
            send 'AUTH PLAIN %s' "$ENCODED_STRING"
            recv 235
            ;;
        AUTH_LOGIN)
            mbfl_message_verbose 'performing AUTH LOGIN authentication\n'
            send 'AUTH LOGIN'
            recv 334
            ENCODED_STRING=$(echo -n "$LOGIN_NAME" | pipe_base64)
            test ${PIPESTATUS[1]} -eq 0 || {
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            }
            send "$ENCODED_STRING"
            recv 334
            ENCODED_STRING=$(echo -n "$PASSWORD"   | pipe_base64)
            test ${PIPESTATUS[1]} -eq 0 || {
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            }
            send "$ENCODED_STRING"
            recv 235
            ;;
        *)
            local msg=$(printf 'internal error, unknown authorisation type: %s' "$AUTH_TYPE")
            mbfl_message_error "$msg"
            exit_failure
            ;;
    esac
    return 0
}
function esmtp_send_message () {
    mbfl_message_verbose 'esmtp: sending message\n'
    send 'MAIL FROM:<%s>' "$FROM_ADDRESS"
    recv 250
    send 'RCPT TO:<%s>' "$TO_ADDRESS"
    recv 250
    send %s DATA
    recv 354
    printf "$MESSAGE" | read_and_send_message
    send %s .
    recv 250
    return 0
}
function esmtp_quit () {
    mbfl_message_verbose 'esmtp: end dialogue\n'
    send %s QUIT
    recv 221
    return 0
}
#page
## ------------------------------------------------------------
## Auth file.
## ------------------------------------------------------------

function auth_read_credentials () {
    local auth_user=$script_option_AUTH_USER
    local auth_file=$script_option_AUTH_FILE
    local HOSTNAME=$script_option_HOST
    local line= GREP
    GREP=$(mbfl_program_found grep) || exit $?
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
    then mbfl_message_verbose_printf 'good %s word of auth record (%s)' $POSITION $GOT
    else
        msg=$(printf 'expected \"%s\" as %s word of auth record, got \"%s\"' \
            "$EXPECTED" "$POSITION" "$GOT")
        mbfl_message_error "$msg"
        exit_because_invalid_auth_file
    fi
}

#page

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
