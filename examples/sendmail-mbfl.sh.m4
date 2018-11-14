# Part of: Marco's Bash Functions Library
# Contents: example script that sends an email message
# Date: Thu Apr 23, 2009
#
# Abstract
#
#	This script shows how an MBFL script can send email. It supports
#	plain  connections  and  encrypted  connections  using  external
#	programs.
#
# Copyright (c) 2009, 2010, 2015, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
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

#page
#### global variables

script_PROGNAME=sendmail-mbfl.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2009, 2010, 2015, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='Send an email message.'
script_EXAMPLES="Usage examples:
\n\
\techo 'From: marco@localhost
\tTo: root@localhost
\tSubject: ciao
\n\
\tHow do you do?
\t' | ${script_PROGNAME} \\
\t\t--envelope-from=marco@localhost --envelope-to=root@localhost"

#page
#### load library

mbfl_library_loader

#page
#### command line options

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option FROM \
    '' F envelope-from witharg 'select envelope MAIL FROM address'
mbfl_declare_option TO \
    '' T envelope-to   witharg 'select envelope RCPT TO address'
mbfl_declare_option MESSAGE \
    -  M message witharg 'select the source of the email message'
mbfl_declare_option TEST_MESSAGE \
    no '' test-message noarg 'send a test message'

mbfl_declare_option HOST \
    localhost '' host witharg 'select the server hostname'
mbfl_declare_option PORT \
    ''        p port witharg 'select the server port'
mbfl_declare_option HOSTINFO_FILE \
    "$HOME/.mbfl-hostinfo" '' host-info witharg 'select the hostinfo file'

mbfl_declare_option TIMEOUT \
    5 '' timeout witharg 'select the connection timeout in seconds'

mbfl_declare_option SESSION_PLAIN \
    yes '' plain        noarg 'establish a plain connection (non-encrypted)'
mbfl_declare_option SESSION_TLS \
    no  '' tls          noarg 'establish a TLS bridge immediately'
mbfl_declare_option SESSION_STARTTLS \
    no  '' starttls     noarg 'establish a TLS bridge using STARTTLS'

mbfl_declare_option GNUTLS_CONNECTOR \
    yes '' gnutls noarg 'use gnutls-cli for TLS'
mbfl_declare_option OPENSSL_CONNECTOR \
    no '' openssl noarg 'use openssl for TLS'

mbfl_declare_option AUTHINFO_FILE \
    "$HOME/.mbfl-authinfo" '' auth-info witharg 'select the authinfo file'
mbfl_declare_option AUTH_USER \
    '' '' username witharg 'select the authorisation user'

mbfl_declare_option AUTH_NONE \
    yes '' auth-none noarg 'do not do authorisation'
mbfl_declare_option AUTH_PLAIN \
    no  '' auth-plain noarg 'select the plain authorisation type'
mbfl_declare_option AUTH_LOGIN \
    no  '' auth-login noarg 'select the login authorisation type'

#page
#### programs

mbfl_file_enable_remove

mbfl_declare_program base64
mbfl_declare_program date
mbfl_declare_program gnutls-cli
mbfl_declare_program grep
mbfl_declare_program hostname
mbfl_declare_program mkfifo
mbfl_declare_program openssl

#page
#### declare exit codes

mbfl_main_declare_exit_code 2 invalid_option
mbfl_main_declare_exit_code 3 invalid_message_source

mbfl_main_declare_exit_code 4 unreadable_host_file
mbfl_main_declare_exit_code 5 invalid_host_file
mbfl_main_declare_exit_code 6 unknown_host

mbfl_main_declare_exit_code 7 unreadable_auth_file
mbfl_main_declare_exit_code 8 invalid_auth_file
mbfl_main_declare_exit_code 9 unknown_auth_user

mbfl_main_declare_exit_code 10 failed_connection
mbfl_main_declare_exit_code 11 wrong_server_answer

#page
#### global variables

# Array and number of recipients  and the zero-based array holding them.
# Every time  the option "--envelope-to"  is found on the  command line,
# its value is added to the array and the counter incremented.
#
# After options parsing these variables are never modified.
#
declare -i RECIPIENTS_COUNT=0
declare -a RECIPIENTS

# Select the type  of session; valid values: plain,  tls, starttls.  The
# value can be selected:
#
# * by the options "--plain", "--tls" and "--starttls";
#
# * by reading the hostinfo file;
#
# * by defaulting to "plain".
#
SESSION_TYPE=

# Selected ESMTP authorisation type.   Valid values: none, login, plain.
# The value can be selected:
#
# * by the options "--auth-none", "--auth-plain" and "--auth-login";
#
# * by reading the hosinfo file;
#
# * by defaulting to "none".
#
AUTH_TYPE=

# The identifier for the program to use as TLS connector.  Valid values:
# "gnutls", "openssl"; if set to the empty string: no connector is used,
# so the session is in plain text.
#
CONNECTOR=gnutls

#page
#### option update functions

function script_option_update_to () {
    RECIPIENTS[$RECIPIENTS_COUNT]=$script_option_TO
    let ++RECIPIENTS_COUNT
}

function script_option_update_session_plain () {
    SESSION_TYPE=plain
}
function script_option_update_session_tls () {
    SESSION_TYPE=tls
}
function script_option_update_session_starttls () {
    SESSION_TYPE=starttls
}

function script_option_update_auth_none () {
    AUTH_TYPE=none
}
function script_option_update_auth_plain () {
    AUTH_TYPE=plain
}
function script_option_update_auth_login () {
    AUTH_TYPE=login
}

function script_option_update_gnutls_connector () {
    CONNECTOR=gnutls
}
function script_option_update_openssl_connector () {
    CONNECTOR=openssl
}
#page
function main () {
    local FROM_ADDRESS=
    local SERVER_HOSTNAME= SERVER_PORT=
    local AUTH_USER=$script_option_AUTH_USER
    local LOGIN_NAME= PASSWORD= MESSAGE=
    # Input  and   output  file  descriptors  when   using  a  connector
    # subprocess.
    local INFD=3 OUFD=4
    # Pathnames  of the  FIFOs used  to  talk to  the connector's  child
    # process.
    local INFIFO= OUFIFO=
    # This is for the PID of the connector external program, executed as
    # child process.
    local CONNECTOR_PID=
    # Timeout,  in seconds,  for the  read operation  on the  input file
    # descriptor.
    local READ_TIMEOUT=$script_option_TIMEOUT

    validate_and_normalise_configuration
    if ! {
            mbfl_message_verbose_printf 'connecting to \"%s:%d\"\n' "$SERVER_HOSTNAME" "$SERVER_PORT"
            mbfl_message_verbose_printf 'session type: %s, authentication %s\n' "$SESSION_TYPE" "$AUTH_TYPE"
            case $SESSION_TYPE in
		plain)
                    connect_establish_plain_connection
                    esmtp_exchange_greetings helo
                    ;;
		tls)
                    connect_make_fifos_for_connector
                    case $CONNECTOR in
			gnutls)     connect_using_gnutls ;;
			openssl)    connect_using_openssl ;;
                    esac
                    esmtp_exchange_greetings ehlo
                    ;;
		starttls)
                    connect_make_fifos_for_connector
                    case $CONNECTOR in
			gnutls)     connect_using_gnutls_starttls ;;
			openssl)    connect_using_openssl_starttls ;;
                    esac
                    esmtp_exchange_greetings ehlo
                    ;;
            esac
            mbfl_message_verbose 'connection established\n'
	}
    then exit_because_failed_connection
    fi
    esmtp_authentication
    esmtp_send_message
    esmtp_quit
    wait_for_connector_process
    exit_because_success
}
#page
function validate_and_normalise_configuration () {
    # Set to  "true" the first  time "hostinfo_read" is invoked.   It is
    # used to read the hostinfo file only once.
    local hostinfo_ALREADY_READ=false

    # Informations from the hostinfo file are stored in these variables.
    local hostinfo_HOST= hostinfo_PORT= hostinfo_SESSION_TYPE= hostinfo_AUTH_TYPE=

    # Validate the value in "script_option_TIMEOUT".
    if mbfl_string_is_empty "$script_option_TIMEOUT"
    then
        mbfl_message_error_printf 'null value as timeout'
        exit_because_invalid_option
    fi
    if ! mbfl_string_is_digit "$script_option_TIMEOUT"
    then
        mbfl_message_error_printf 'invalid value as timeout: %s' "$script_option_TIMEOUT"
        exit_because_invalid_option
    fi

    # Email addresses are selected with command line options.
    if mbfl_string_is_not_empty "$script_option_FROM"
    then FROM_ADDRESS=$script_option_FROM
    else
        mbfl_message_error 'empty string as MAIL FROM envelope address'
        exit_because_invalid_option
    fi
    if ((0 == RECIPIENTS_COUNT))
    then
        mbfl_message_error 'no recipients where selected'
        exit_because_invalid_option
    fi

    # Message source is selected with command line options.
    if test "$script_option_TEST_MESSAGE" != yes
    then
        if mbfl_string_is_empty "$script_option_MESSAGE"
	then
            mbfl_message_error 'missing selection of mail message source'
            exit_because_invalid_option
	fi
        if mbfl_string_not_equal "$script_option_MESSAGE" '-'
	then
            if ! mbfl_file_is_file "$script_option_MESSAGE"
	    then
                mbfl_message_error 'selected message file does not exist'
                exit_because_invalid_option
            fi
            if ! mbfl_file_is_readable "$script_option_MESSAGE"
	    then
                mbfl_message_error 'selected message file is not readable'
                exit_because_invalid_option
            fi
        fi
    fi

    # Server host and  port selection is done with  command line options
    # or reading the hostinfo file.
    #
    # After "hostinfo_read" we  always update "SERVER_HOSTNAME" with the
    # value from the  hostinfo file; this is because  the value from the
    # command line option may be just  a search key in the file, not the
    # full server hostname.
    if mbfl_string_is_not_empty "$script_option_HOST"
    then SERVER_HOSTNAME="$script_option_HOST"
    else
        hostinfo_read
        if mbfl_string_is_not_empty "$hostinfo_HOST"
        then SERVER_HOSTNAME="$hostinfo_HOST"
        else SERVER_HOSTNAME=localhost
        fi
    fi
    if ! mbfl_string_is_noblank "$SERVER_HOSTNAME"
    then
        mbfl_message_error 'selected hostname string has blank characters in it'
        exit_because_invalid_option
    fi
    if mbfl_string_is_not_empty "$script_option_PORT"
    then SERVER_PORT="$script_option_PORT"
    else
        hostinfo_read
        if mbfl_string_is_not_empty "$hostinfo_HOST"
	then SERVER_HOSTNAME="$hostinfo_HOST"
	fi
        if mbfl_string_is_not_empty "$hostinfo_PORT"
        then SERVER_PORT="$hostinfo_PORT"
        else SERVER_PORT=25
        fi
    fi
    if ! mbfl_string_is_digit "$SERVER_PORT"
    then
        mbfl_message_error 'selected port string is not numeric'
        exit_because_invalid_option
    fi

    # Session type is selected by  command line option, else by hostinfo
    # file, else defaults to "plain".
    if mbfl_string_is_empty "$SESSION_TYPE"
    then
        hostinfo_read
        if mbfl_string_is_not_empty "$hostinfo_HOST"
	then SERVER_HOSTNAME="$hostinfo_HOST"
	fi
        SESSION_TYPE=$hostinfo_SESSION_TYPE
        if mbfl_string_is_empty "$SESSION_TYPE"
	then SESSION_TYPE=plain
	fi
    fi

    # Authorisation  type is selected  by command  line option,  else by
    # hostinfo file, else defaults to "none".
    if mbfl_string_is_empty "$AUTH_TYPE"
    then
        hostinfo_read
        if mbfl_string_is_not_empty "$hostinfo_HOST"
	then SERVER_HOSTNAME="$hostinfo_HOST"
	fi
        AUTH_TYPE=$hostinfo_AUTH_TYPE
        if mbfl_string_is_empty "$AUTH_TYPE"
	then AUTH_TYPE=none
	fi
    fi
    if mbfl_string_not_equal "$AUTH_TYPE" 'none'
    then
        if mbfl_string_is_empty "$script_option_AUTHINFO_FILE"
	then
            mbfl_message_error 'empty string as auth file pathname'
            exit_because_invalid_option
        fi
        if ! mbfl_file_is_file "$script_option_AUTHINFO_FILE"
	then
            mbfl_message_error 'selected auth file does not exist'
            exit_because_invalid_option
        fi
        if ! mbfl_file_is_readable "$script_option_AUTHINFO_FILE"
	then
            mbfl_message_error 'selected auth file is not readable'
            exit_because_invalid_option
        fi
        if mbfl_string_is_empty "$script_option_AUTH_USER"
	then
            mbfl_message_error 'empty string as auth username'
            exit_because_invalid_option
        fi
        auth_read_credentials
    fi
    return 0
}
#page
#### establishing connections to remote servers

# Synopsis:
#
#       connect_establish_plain_connection
#
# Description:
#
#  Establish  a  plain  connection  with the  selected  SMTP
#  server: the hostname must be in the variable "SERVER_HOSTNAME",
#  the port  must be in the variable  "SERVER_PORT".  Read the
#  first line of greetings from the server, expecting a line
#  starting with "220".
#
#  Errors  are  detected when  opening  the file  descriptor
#  connected to the device representing the remote host.
#
function connect_establish_plain_connection () {
    local DEVICE
    printf -v DEVICE '/dev/tcp/%s/%d' "$SERVER_HOSTNAME" "$SERVER_PORT"
    INFD=3
    OUFD=$INFD
    if ! exec 3<>"$DEVICE"
    then
        mbfl_message_error_printf 'failed establishing connection to %s:%d' "$SERVER_HOSTNAME" $SERVER_PORT
        exit_because_failed_connection
    fi
    recv 220
    return 0
}
# Synopsis:
#
#       connect_using_gnutls
#
# Description:
#
#  Establish an  encrypted connection with  the selected host  using the
#  "gnutls-cli"  program as  connector.   The hostname  must  be in  the
#  variable  "SERVER_HOSTNAME",  the  port   must  be  in  the  variable
#  "SERVER_PORT".
#
#  The process is executed in background with stdin and stdout connected
#  to FIFOs,  which are then  connected to file descriptors.   The FIFOs
#  pathnames must  be in the  variables "OUFIFO" and "INFIFO";  the file
#  descriptors are in the variables "INFD" and "OUFD".
#
#  Text from  the process is  read until a  line starting with  "220" is
#  found:  this is the  line of  greetings from  the remote  server.  If
#  end-of-file comes first: exit the script with an error code.
#
function connect_using_gnutls () {
    local GNUTLS GNUTLS_FLAGS="--debug 0 --port $SERVER_PORT" success=no
    mbfl_message_verbose_printf 'connecting with gnutls, immediate encrypted bridge\n'
    mbfl_program_found_var GNUTLS gnutls-cli || exit $?
    mbfl_program_redirect_stderr_to_stdout
    if ! mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SERVER_HOSTNAME"
    then
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SERVER_HOSTNAME" "$SERVER_PORT"
        exit_failed_connection
    fi
    CONNECTOR_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of gnutls: $CONNECTOR_PID"
    connect_open_file_descriptors_to_fifos
    trap terminate_and_wait_for_connector_process EXIT
    recv_until_string 220
    return 0
}
# Synopsis:
#
#       connect_using_gnutls_starttls
#
# Description:
#
#  Establish  a  plain  connection  with  the selected  host  using  the
#  "gnutls-cli" program  as connector; exchange greetings  then send the
#  "STARTTLS" command and establish an encrypted bridge.
#
#  The hostname must be in the variable "SERVER_HOSTNAME", the port must
#  be in the variable "SERVER_PORT".
#
#  The process is executed in background with stdin and stdout connected
#  to FIFOs,  which are then  connected to file descriptors.   The FIFOs
#  pathnames must  be in the  variables "OUFIFO" and "INFIFO";  the file
#  descriptors are in the variables "INFD" and "OUFD".
#
#  Text from  the process is  read until a  line starting with  "220" is
#  found:  this is the  line of  greetings from  the remote  server.  If
#  end-of-file comes first: exit the script with an error code.
#
function connect_using_gnutls_starttls () {
    local GNUTLS GNUTLS_FLAGS="--debug 0 --starttls --port $SERVER_PORT"
    mbfl_message_verbose_printf 'connecting with gnutls, delayed encrypted bridge\n'
    mbfl_program_found_var GNUTLS gnutls-cli || exit $?
    mbfl_program_redirect_stderr_to_stdout
    if ! mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SERVER_HOSTNAME"
    then
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SERVER_HOSTNAME" "$SERVER_PORT"
        exit_failed_connection
    fi
    CONNECTOR_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of gnutls: $CONNECTOR_PID"
    connect_open_file_descriptors_to_fifos
    trap terminate_and_wait_for_connector_process EXIT
    recv_until_string 220
    esmtp_exchange_greetings ehlo
    send STARTTLS
    recv 220
    kill -SIGALRM $CONNECTOR_PID
    esmtp_exchange_greetings ehlo
    return 0
}
# Synopsis:
#
#       connect_using_openssl
#
# Description:
#
#  Establish an  encrypted connection with  the selected host  using the
#  "openssl" program as connector.  The hostname must be in the variable
#  "SERVER_HOSTNAME", the port must be in the variable "SERVER_PORT".
#
#  The process is executed in background with stdin and stdout connected
#  to FIFOs,  which are then  connected to file descriptors.   The FIFOs
#  pathnames must  be in the  variables "OUFIFO" and "INFIFO";  the file
#  descriptors are in the variables "INFD" and "OUFD".
#
#  Text from  the process is  read until a  line starting with  "220" is
#  found:  this is the  line of  greetings from  the remote  server.  If
#  end-of-file comes first: exit the script with an error code.
#
function connect_using_openssl () {
    local OPENSSL OPENSSL_FLAGS="s_client -quiet -connect $SERVER_HOSTNAME:$SERVER_PORT" success=no
    mbfl_message_verbose_printf 'connecting with openssl, immediate encrypted bridge\n'
    mbfl_program_found_var OPENSSL openssl || exit $?
    mbfl_program_redirect_stderr_to_stdout
    if ! mbfl_program_execbg $OUFIFO $INFIFO "$OPENSSL" $OPENSSL_FLAGS
    then
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SERVER_HOSTNAME" "$SERVER_PORT"
        exit_failed_connection
    fi
    CONNECTOR_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of openssl: $CONNECTOR_PID"
    connect_open_file_descriptors_to_fifos
    trap terminate_and_wait_for_connector_process EXIT
    recv_until_string 220
    return 0
}
# Synopsis:
#
#       connect_using_openssl_starttls
#
# Description:
#
#  Establish  a  plain  connection  with  the selected  host  using  the
#  "openssl" program as connector.  The hostname must be in the variable
#  "SERVER_HOSTNAME", the  port must  be in the  variable "SERVER_PORT".
#  The  encrypted  bridge  is  established  by  "openssl"  itself  after
#  exchanging greetings using the ESMTP protocol.
#
#  The process is executed in background with stdin and stdout connected
#  to FIFOs,  which are then  connected to file descriptors.   The FIFOs
#  pathnames must  be in the  variables "OUFIFO" and "INFIFO";  the file
#  descriptors are in the variables "INFD" and "OUFD".
#
#  Text from  the process is  read until a  line starting with  "220" is
#  found:  this is the  line of  greetings from  the remote  server.  If
#  end-of-file comes first: exit the script with an error code.
#
function connect_using_openssl_starttls () {
    local OPENSSL OPENSSL_FLAGS="s_client -quiet -starttls smtp -connect $SERVER_HOSTNAME:$SERVER_PORT"
    local success=no
    mbfl_message_verbose_printf 'connecting with openssl, delayed encrypted bridge\n'
    mbfl_program_found_var OPENSSL openssl || exit $?
    mbfl_program_redirect_stderr_to_stdout
    if ! mbfl_program_execbg $OUFIFO $INFIFO "$OPENSSL" $OPENSSL_FLAGS
    then
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SERVER_HOSTNAME" "$SERVER_PORT"
        exit_failed_connection
    fi
    CONNECTOR_PID=$mbfl_program_BGPID
    mbfl_message_debug "pid of openssl: $CONNECTOR_PID"
    connect_open_file_descriptors_to_fifos
    trap terminate_and_wait_for_connector_process EXIT
    return 0
}
#page
#### waiting for the connector process

# Synopsis:
#
#       wait_for_connector_process
#
# Description:
#
#  To be called when successfully exiting the script.
#  Use the "wait" command to wait for the termination of the
#  connector process.   The pid of the connector  must be in
#  "CONNECTOR_PID".
#
#  This is  to avoid zombie  processes to be left  around by
#  the script.
#
function wait_for_connector_process () {
    test -n "$CONNECTOR_PID" && {
        trap '' EXIT
        mbfl_message_debug_printf 'waiting for connector process (pid %s)' $CONNECTOR_PID
        wait $CONNECTOR_PID
        mbfl_message_debug_printf 'gathered connector process'
    }
    CONNECTOR_PID=
}
# Synopsis:
#
#       terminate_and_wait_for_connector_process
#
# Description:
#
#  To  be called  when an  error occurs  by the  "trap" EXIT
#  handler.
#
#  Force the  termination of the connector  process and wait
#  for   it.   The  pid   of  the   connector  must   be  in
#  "CONNECTOR_PID".
#
#  This is  to avoid zombie  processes to be left  around by
#  the script.
#
function terminate_and_wait_for_connector_process () {
    test -n "$CONNECTOR_PID" && {
        mbfl_message_debug_printf 'forcing termination of connector process (pid %s)' $CONNECTOR_PID
        kill -SIGTERM $CONNECTOR_PID &>/dev/null
        mbfl_message_debug_printf 'waiting for connector process (pid %s)' $CONNECTOR_PID
        wait $CONNECTOR_PID &>/dev/null
        mbfl_message_debug_printf 'gathered connector process'
    }
    CONNECTOR_PID=
}
#page
#### handling of FIFOs to the connector

# Synopsis:
#
#       connect_make_fifos_for_connector
#
# Description:
#
#  Create two  temporary FIFOs to  be used to chat  with the
#  connector process.
#
#  The FIFO pathnames are stored in the variables "INFIFO"
#  and "OUFIFO".   "INFIFO" will be  used by this  script to
#  receive data  from the connector.  "OUFIFO"  will be used
#  by this script to send data to the connector.
#
#  If an  error occurs creating  the FIFOs: exit  the script
#  with an error code.
#
#  FIXME The pathnames of  the FIFOs are randomly generated,
#  but not in a special safe way.  Can this be fixed?
#
function connect_make_fifos_for_connector () {
    local MKFIFO
    if ! mbfl_file_find_tmpdir_var TMPDIR
    then
        mbfl_message_error 'unable to determine pathname of temporary directory'
        exit_failure
    fi
    INFIFO=${TMPDIR}/in.${RANDOM}.$$
    OUFIFO=${TMPDIR}/out.${RANDOM}.$$
    mbfl_program_found_var MKFIFO mkfifo || exit $?
    mbfl_message_debug 'creating FIFOs for connector subprocess'
    trap connect_cleanup_fifos EXIT
    if ! mbfl_program_exec "$MKFIFO" --mode=0600 "$INFIFO" "$OUFIFO"
    then
        mbfl_message_error 'unable to create FIFOs'
        exit_failure
    fi
    return 0
}
# Synopsis:
#
#       connect_open_file_descriptors_to_fifos
#
# Description:
#
#  Connect the FIFOs to the connector to the selected file
#  descriptors.
#
#  Notice  the strange  quoting needed  to  perform variable
#  expansion for file descriptors: that is the way it is for
#  redirections under the Bourne shells.
#
function connect_open_file_descriptors_to_fifos () {
    eval "exec ${INFD}<>\"\$INFIFO\" ${OUFD}>\"\$OUFIFO\""
    connect_cleanup_fifos
    trap "" EXIT
    return 0
}
# Synopsis:
#
#       connect_cleanup_fifos
#
# Description:
#
#  Remove the input and output FIFOs to the connector,
#  ignoring error messages.
#
function connect_cleanup_fifos () {
    mbfl_file_remove "$INFIFO" &>/dev/null || true
    mbfl_file_remove "$OUFIFO" &>/dev/null || true
}
#page
#### receiving data from the server

# Synopsis:
#
#       recv <expected_code>
#
# Description:
#
#  Read a  single line from  the file descriptor  $INFD, and
#  log it if debugging mode is  on.  If the first 3 chars in
#  the  line are  not  equal  to the  given  code: quit  the
#  session and exit the script with an error code.
#
#  This is meant  to be the standard way  of reading answers
#  from the server.
#
function recv () {
    local EXPECTED_CODE=${1:?}
    local line
    IFS= read -rs -t $READ_TIMEOUT line <&$INFD
    if test 127 -lt $?
    then
        mbfl_message_error_printf 'read timeout exceeded'
        exit_because_wrong_server_answer
    fi
    mbfl_message_debug_printf 'recv: %s' "$line"
    test "${line:0:3}" = "$EXPECTED_CODE" || {
        send %s QUIT
        IFS= read -rs -t $READ_TIMEOUT line <&$INFD
        if test $? -lt 128
        then mbfl_message_debug_printf 'recv: %s' "$line"
        fi
        exit_because_wrong_server_answer
    }
    return 0
}
# Synopsis:
#
#       recv_string <expected_string>
#
# Description:
#
#  Read a  single line from  the file descriptor  $INFD, and
#  log it if debugging mode  is on.  If the beginning of the
#  line is not  equal to the given string:  quit the session
#  and exit the script with an error code.
#
#  This is  meant to be a  special way to  read answers from
#  the server.
#
function recv_string () {
    local EXPECTED_STRING=${1:?}
    local line len=${#EXPECTED_STRING}
    IFS= read -rs -t $READ_TIMEOUT line <&$INFD
    if test 127 -lt $?
    then
        mbfl_message_error_printf 'read timeout exceeded'
        exit_because_wrong_server_answer
    fi
    mbfl_message_debug_printf 'recv: %s' "$line"
    test "${line:0:$len}" = "$EXPECTED_STRING" || {
        send %s QUIT
        IFS= read -rs -t $READ_TIMEOUT line <&$INFD
        mbfl_message_debug_printf 'recv: %s' "$line"
        exit_because_wrong_server_answer
    }
    return 0
}
# Synopsis:
#
#       recv_until_string <expected_string>
#
# Description:
#
#  Read multiple lines from the file descriptor $INFD, and
#  log them if debugging mode  is on.  If the beginning of a
#  line  equals the  given string:  Stop reading  and return
#  with  success;  if end--of--file  comes  first: exit  the
#  script with an error code.
#
#  This  is meant  to read  output  from the  server or  the
#  connector, until  a known string comes.  It  is used when
#  the  connector outputs  informations about  the encrypted
#  bridge and  when the server sends  informations about its
#  capabilities.
#
function recv_until_string () {
    local EXPECTED_STRING=${1:?}
    local line len=${#EXPECTED_STRING} success=no
    mbfl_message_debug_printf 'reading (tm %s)' $READ_TIMEOUT
    while IFS= read -rs -t $READ_TIMEOUT line <&$INFD
    do
        mbfl_message_debug_printf 'recv: %s' "$line"
        test "${line:0:$len}" = "$EXPECTED_STRING" && {
            success=yes
            break
        }
    done
    if test 127 -lt $?
    then
        mbfl_message_error_printf 'read timeout exceeded'
        exit_because_wrong_server_answer
    fi
    test $success = no && {
        mbfl_message_error_printf 'failed to receive string \"%s\" from server' "$EXPECTED_STRING"
        exit_because_wrong_server_answer
    }
    return 0
}
#page
#### sending data to the server

# Synopsis:
#
#       send <string>
#       send <pattern> <arg> ...
#
# Description:
#
#  Write a line of text to the file descriptor $OUFD;
#  format the first  parameters with the optional arguments.
#  If debugging mode is on: Log the line.
#
function send () {
    local pattern=${1:?"missing patter parameter to '$FUNCNAME'"}
    shift
    local line=$(printf "$pattern" "$@")
    printf '%s\r\n' "$line" >&$OUFD
    mbfl_message_debug_printf 'sent (%d): %s' ${#line} "$line"
    return 0
}
# Synopsis:
#
#       send_no_log <string>
#       send_no_log <pattern> <arg> ...
#
# Description:
#
#  Like "send()" but, when debugging  mode is on: do not log
#  the  line itself,  only a  message.  This  is  to prevent
#  secrets to be logged.
#
function send_no_log () {
    local pattern=${1:?"missing pattern parameter to '$FUNCNAME'"}
    shift
    local line=$(printf "$pattern" "$@")
    printf '%s\r\n' "$line" >&$OUFD
    mbfl_message_debug_printf 'sent: secrets line'
    return 0
}
#page
#### email message

#
# Synopsis:
#
#       read_and_send_message
#
# Description:
#
#  Acquire the  email message from the  selected source and  write it to
#  $OUFD.  The source is selected by the command line parameters.
#
#  Just to  be safe: a newline  is appended to the  message; this allows
#  the message to read by "read" without discarding the last line.
#
#  Read the email message from stdin line by line, and write it to $OUFD
#  line by line  appending the carriage return, line  feed sequence.  If
#  debugging mode is on: Log a line.
#
function read_and_send_message () {
    {
        local line
        if test "$script_option_TEST_MESSAGE" = yes
        then
            # Here  we can  detect an  error  through the  exit code  of
            # "print_test_message".
            print_test_message || {
                mbfl_message_error 'unable to compose test message'
                exit_because_invalid_message_source
            }
            mbfl_message_verbose 'composed test message\n'
        else
            if test "$script_option_MESSAGE" = -
            then
                mbfl_message_verbose 'reading message from stdin\n'
                exec 5<&0
            else
                mbfl_message_verbose 'reading message from file\n'
                exec 5<"$script_option_MESSAGE"
            fi
            # Here  it is  impossible  to distinguish  between an  error
            # reading the source and an the end of file.
            while IFS= read -rs line <&5
            do
                if test "${line:0:1}" = '.'
                then printf '.%s\n' "$line"
                else printf  '%s\n' "$line"
                fi
            done
            exec 5<&-
        fi
     } | {
        local line
        local -i lines_count=0 bytes_count=0
        while IFS= read -rs line
        do
            printf '%s\r\n' "$line" >&$OUFD
            let ++lines_count
            bytes_count=$(($bytes_count+${#line}+2))
        done
        mbfl_message_debug_printf 'sent message (%d lines, %d bytes)' $lines_count $bytes_count
    }
    if test $? -eq 0
    then return 0
    else exit $?
    fi
}
# Synopsis:
#
#       print_test_message
#
# Description:
#
#  Compose and  print to stdout  a test email  message.  The
#  addresses  must be  in the  variables  "FROM_ADDRESS" and
#  "TO_ADDRESS".
#
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
Configuration:
\timmediate starttls:\t\t$script_option_STARTTLS
\tdelayed starttls:\t\t$script_option_STARTTLS_STARTTLS
\tuse gnutls-cli connector:\t$script_option_GNUTLS_CONNECTOR
\tuse openssl connector:\t$script_option_OPENSSL_CONNECTOR
\tselected connector:\t\t$CONNECTOR
\tauth file:\t\t\t'$script_option_AUTHINFO_FILE'
\tauth user:\t\t\t'$script_option_AUTH_USER'
\tauth method plain:\t\t$script_option_AUTH_PLAIN
\tauth method login:\t\t$script_option_AUTH_LOGIN
--\x20
The $script_PROGNAME script
Copyright $script_COPYRIGHT_YEARS $script_AUTHOR
"
    printf "$MESSAGE"
}
#page
#### SMTP/ESMTP protocol

# Synopsis:
#
#        esmtp_exchange_greetings helo
#        esmtp_exchange_greetings ehlo
#
# Description:
#
#  Exchange  greetings with  the server.   Send a  "HELO" or
#  "EHLO" line and read  lines until the first starting with
#  "250 ".
#
function esmtp_exchange_greetings () {
    local TYPE=${1:?"missing type of greetings parameter to '$FUNCNAME'"}
    local HOSTNAME_PROGRAM
    HOSTNAME_PROGRAM=$(mbfl_program_found hostname) || exit $?
    LOCAL_HOSTNAME=$(mbfl_program_exec "$HOSTNAME_PROGRAM" --fqdn) || {
        mbfl_message_error 'unable to acquire local hostname'
        exit_failure
    }
    mbfl_message_verbose 'esmtp: exchanging greetings with server\n'
    case $TYPE in
        helo) send 'HELO %s' "$LOCAL_HOSTNAME" ;;
        ehlo) send 'EHLO %s' "$LOCAL_HOSTNAME" ;;
    esac
    recv_until_string '250 '
}
function pipe_base64 () {
    mbfl_program_exec "$BASE64"
}
# Synopsis:
#
#       esmtp_authentication
#
# Description:
#
#  Do the  selected authentication process  with credentials
#  already read from the selected authinfo file.
#
#  The  selected  authentication  must  be in  the  variable
#  "AUTH_TYPE", the  login name and the password  must be in
#  the variables "LOGIN_NAME" and "PASSWORD".
#
#  Notice that  the secrets are not logged  by the debugging
#  functions.
#
function esmtp_authentication () {
    case "$AUTH_TYPE" in
        none)
            :
            ;;
        plain)
            local BASE64 ENCODED_STRING
            BASE64=$(mbfl_program_found base64) || exit $?
            mbfl_message_verbose 'performing AUTH PLAIN authentication\n'
            ENCODED_STRING=$(printf '\x00%s\x00%s' "$LOGIN_NAME" "$PASSWORD" | pipe_base64) || {
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            }
            send_no_log 'AUTH PLAIN %s' "$ENCODED_STRING"
            recv 235
            ;;
        login)
            local BASE64 ENCODED_STRING
            BASE64=$(mbfl_program_found base64) || exit $?
            mbfl_message_verbose 'performing AUTH LOGIN authentication\n'
            send 'AUTH LOGIN'
            recv 334
            ENCODED_STRING=$(echo -n "$LOGIN_NAME" | pipe_base64) || {
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            }
            send_no_log "$ENCODED_STRING"
            recv 334
            ENCODED_STRING=$(echo -n "$PASSWORD"   | pipe_base64) || {
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            }
            send_no_log "$ENCODED_STRING"
            recv 235
            ;;
    esac
    return 0
}
# Synopsis:
#
#       esmtp_send_message
#
# Description:
#
#  Do the SMTP dialog required to send a message.
#
function esmtp_send_message () {
    local -i i
    mbfl_message_verbose 'esmtp: sending message\n'
    send 'MAIL FROM:<%s>' "$FROM_ADDRESS"
    recv 250
    for ((i=0; i < RECIPIENTS_COUNT; ++i))
    do
        send 'RCPT TO:<%s>' "${RECIPIENTS[$i]}"
        recv 250
    done
    send %s DATA
    recv 354
    read_and_send_message
    send %s .
    recv 250
    return 0
}
# Synopsis:
#
#       esmtp_quit
#
# Description:
#
#  Quit an SMTP session.
#
function esmtp_quit () {
    mbfl_message_verbose 'esmtp: end dialogue\n'
    send %s QUIT
    recv 221
    return 0
}
#page
#### authentication

# Synopsis:
#
#       auth_read_credentials
#
# Description:
#
#  Read  the credentials  from the  selected  authinfo file.
#  The authinfo  file, user key  and host name are  from the
#  command line options.
#
#  The login name and the password are left in the variables
#  "LOGIN_NAME" and "PASSWORD".
#
#  The autinfo file is meant to have lines like:
#
#       machine smtp.gmail.com login the-user-name password the-pass-word
#
#  and it is searched with a grep regular expression.
#
function auth_read_credentials () {
    local SPLITFIELD LINE FOUND=false
    local -i SPLITCOUNT
    local MACHINE_KEY LOGIN_KEY PASSWORD_KEY
    local MACHINE_VAL LOGIN_VAL PASSWORD_VAL

    mbfl_message_debug_printf 'reading authinfo file: %s' "$script_option_AUTHINFO_FILE"
    while IFS= read LINE
    do
	mbfl_string_split "$LINE" ' '
	if ((6 != SPLITCOUNT))
	then continue
	fi
	MACHINE_KEY=${SPLITFIELD[0]}
	MACHINE_VAL=${SPLITFIELD[1]}
	LOGIN_KEY=${SPLITFIELD[2]}
	LOGIN_VAL=${SPLITFIELD[3]}
	PASSWORD_KEY=${SPLITFIELD[4]}
	PASSWORD_VAL=${SPLITFIELD[5]}
	if { mbfl_string_not_equal "$MACHINE_KEY" 'machine' || \
		 mbfl_string_not_equal "$LOGIN_KEY" 'login' || \
		 mbfl_string_not_equal "$PASSWORD_KEY" 'password'; }
	then continue
	elif { mbfl_string_equal "$MACHINE_VAL" "$SERVER_HOSTNAME" && mbfl_string_equal_substring "$LOGIN_VAL" 0 "$AUTH_USER"; }
	then
	    FOUND=true
	    break
	fi
    done <"$script_option_AUTHINFO_FILE"

    if $FOUND
    then
	LOGIN_NAME=$LOGIN_VAL
	PASSWORD=$PASSWORD_VAL
	# This  is reserved  information,  so  do not  print  it on  the
	# terminal!!!
	#
	# mbfl_message_debug_printf 'username %s, password %s' "$LOGIN_NAME" "$PASSWORD"
	return 0
    else
        mbfl_message_error_printf 'unknown authorisation information for \"%s@%s\"' "$AUTH_USER" "$SERVER_HOSTNAME"
        exit_because_unknown_auth_user
    fi
}

#page
#### hostinfo file

# Synopsis:
#
#       hostinfo_read
#
# Description:
#
#  Read the hostinfo file to select the port number.
#
#  The  pathname  of   the  hostinfo  file  must  be   in  the  variable
#  "script_option_HOSTINFO_FILE".  The  host name  key  must  be in  the
#  variable "script_option_HOST".
#
#  At   the  first  invocation,   this  function   is  called   it  sets
#  "hostinfo_ALREADY_READ" to  true; subsequent invocations  will detect
#  this and just return success, doing nothing.
#
#  The  selected   hostname,  port  and  session  type   are  stored  in
#  "hostinfo_HOST", "hostinfo_PORT" and "hostinfo_SESSION_TYPE".
#
function hostinfo_read () {
    if $hostinfo_ALREADY_READ
    then return 0
    fi
    local SPLITFIELD LINE FOUND=false
    local -i SPLITCOUNT
    local MACHINE_KEY SERVICE_KEY PORT_KEY SESSION_KEY AUTH_KEY
    local MACHINE_VAL SERVICE_VAL PORT_VAL SESSION_VAL AUTH_VAL

    mbfl_message_debug_printf 'reading hostinfo file: %s' "$script_option_HOSTINFO_FILE"
    while IFS= read LINE
    do
	mbfl_string_split "$LINE" ' '
	if ((10 != SPLITCOUNT))
	then continue
	fi
	MACHINE_KEY=${SPLITFIELD[0]}
	MACHINE_VAL=${SPLITFIELD[1]}
	SERVICE_KEY=${SPLITFIELD[2]}
	SERVICE_VAL=${SPLITFIELD[3]}
	PORT_KEY=${SPLITFIELD[4]}
	PORT_VAL=${SPLITFIELD[5]}
	SESSION_KEY=${SPLITFIELD[6]}
	SESSION_VAL=${SPLITFIELD[7]}
	AUTH_KEY=${SPLITFIELD[8]}
	AUTH_VAL=${SPLITFIELD[9]}
	if test "$MACHINE_KEY"	!= machine	-o \
		"$SERVICE_KEY"	!= login	-o \
		"$PORT_KEY"	!= port		-o \
		"$SESSION_KEY"	!= session	-o \
		"$AUTH_KEY"	!= auth
	then continue
	elif test "$SERVICE_VAL" = "$SMTP" -a "$MACHINE_VAL" = "$script_option_HOST"
	then
	    FOUND=true
	    break
	fi
    done <"$script_option_HOSTINFO_FILE"

    if $FOUND
    then
	hostinfo_ALREADY_READ=true
	hostinfo_HOST=$MACHINE_VAL
	hostinfo_PORT=$PORT_VAL
	hostinfo_SESSION_TYPE=$SESSION_VAL
	hostinfo_AUTH_TYPE=$AUTH_VAL
	mbfl_message_debug_printf 'data from hostinfo: %s:%s, %s' "$hostinfo_HOST" "$hostinfo_PORT" "$hostinfo_SESSION_TYPE"
	return 0
    else
        mbfl_message_error_printf 'selected host (%s) is unknown to hostinfo file (%s)' "$script_option_HOST" "$script_option_HOSTINFO_FILE"
        exit_because_unknown_host
    fi
}

#page
### let's go

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
