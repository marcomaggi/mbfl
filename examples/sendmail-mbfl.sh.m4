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
#### MBFL's global variables

script_PROGNAME=sendmail-mbfl.sh
script_VERSION=2.0
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
#### script's global variables

# Default  authinfo  file pathname.   This  file  holds the  credentials
# needed to  login into  the mail  server.  See  below for  the expected
# format of this file.
#
declare script_option_AUTHINFO_FILE=~/.mbfl-authinfo

### ------------------------------------------------------------------------

# Default hostinfo  file pathname.   This file holds  informations about
# what is needed  to login into the SMTP server.
#
declare script_option_HOSTINFO_FILE=~/.mbfl-hostinfo

# The hostname of the SMTP server to use to send the message.  It can be
# configured with the "--host" option.
#
declare script_option_SMTP_HOSTNAME=localhost

# The port number of the SMTP server to use to send the message.  It can
# be  configured with  the "--port"  option or  by reading  the hostinfo
# file.
#
# NOTE Do *not*  use the "-i" option for this  variable!!!  Using it and
# not  initialising it  causes an  initialisation to  "0" by  default by
# Bash.  We do not want this!
#
declare script_option_SMTP_PORT

# Select the type of session;  valid values: plain, tls, starttls.  This
# variable should never be empty.  The value can be selected:
#
# * by the options "--plain", "--tls" and "--starttls";
#
# * by reading the hostinfo file;
#
# * by defaulting to "plain".
#
declare script_option_SESSION_TYPE

# Selected ESMTP authorisation type.   Valid values: none, login, plain.
# This variable should never be empty.  The value can be selected:
#
# * by the options "--auth-none", "--auth-plain" and "--auth-login";
#
# * by reading the hosinfo file;
#
# * by defaulting to "none".
#
declare script_option_AUTH_TYPE=none

### --------------------------------------------------------------------

# The email  address to use as  envelope when sending the  email message
# with SMTP.  This value is selected by the option "--envelope-from".
#
declare script_option_EMAIL_FROM_ADDRESS

# Array of recipients.   Every time the option  "--envelope-to" is found
# on the command  line: its value is added to  the array.  After options
# parsing this variable is never modified.
#
declare -a script_option_RECIPIENTS

# The username  to use when logging  into a SMTP server.   This value is
# selected by  the option "--envelope-from".   This option is  used only
# when the auth type is different from "none".
#
declare script_option_AUTH_USER

# The password  to use when logging  into a SMTP server.   This value is
# selected by reading the authinfo file.   This option is used only when
# the auth type is different from "none".
#
declare script_option_AUTH_PASSWORD

### ------------------------------------------------------------------------

# The identifier for the program to use as TLS connector.  Valid values:
# gnutls, openssl; if set to the  empty string: no connector is used, so
# the session is in plain text.
#
declare script_option_CONNECTOR=gnutls

# The timeout,  in seconds, to use  when reading lines from  the server.
# It can be configured with the "--timeout" option.
#
declare script_option_READ_TIMEOUT=5

### ------------------------------------------------------------------------

# The fully qualified domain name of the local hostname.
#
declare LOCAL_HOSTNAME

#page
#### load library

mbfl_library_loader

#page
#### command line options

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option EMAIL_FROM_ADDRESS	''   F envelope-from witharg 'select envelope MAIL FROM address'
mbfl_declare_option EMAIL_TO_ADDRESS	''   T envelope-to   witharg 'select envelope RCPT TO address'
mbfl_declare_option EMAIL_MESSAGE_SOURCE -   M message       witharg 'select the source of the email message'
mbfl_declare_option EMAIL_TEST_MESSAGE	no  '' test-message  noarg   'send a test message'

mbfl_declare_option HOSTINFO_FILE	"$script_option_HOSTINFO_FILE" '' host-info witharg 'select the hostinfo file'
mbfl_declare_option SMTP_HOSTNAME	"$script_option_SMTP_HOSTNAME" '' host witharg 'select the SMTP server hostname'
mbfl_declare_option SMTP_PORT		"$script_option_SMTP_PORT"      p port witharg 'select the SMTP server port'

mbfl_declare_option SESSION_PLAIN	yes '' plain        noarg 'establish a plain connection (non-encrypted)'
mbfl_declare_option SESSION_TLS		no  '' tls          noarg 'establish a TLS bridge immediately'
mbfl_declare_option SESSION_STARTTLS	no  '' starttls     noarg 'establish a TLS bridge using STARTTLS'

mbfl_declare_option GNUTLS_CONNECTOR	no  '' gnutls  noarg 'use gnutls-cli for TLS'
mbfl_declare_option OPENSSL_CONNECTOR	no  '' openssl noarg 'use openssl for TLS'

mbfl_declare_option AUTHINFO_FILE	"$script_option_AUTHINFO_FILE" '' auth-info witharg 'select the authinfo file'
mbfl_declare_option AUTH_USER		''  '' username witharg 'select the authorisation user'
mbfl_declare_option AUTH_NONE		yes '' auth-none  noarg 'do not do authorisation'
mbfl_declare_option AUTH_PLAIN		no  '' auth-plain noarg 'select the plain authorisation type'
mbfl_declare_option AUTH_LOGIN		no  '' auth-login noarg 'select the login authorisation type'

mbfl_declare_option READ_TIMEOUT	"$script_option_READ_TIMEOUT" '' timeout witharg 'select the connection timeout in seconds'

#page
#### programs

mbfl_file_enable_remove
mbfl_times_and_dates_enable

mbfl_declare_program base64
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
mbfl_main_declare_exit_code 12 read_timeout_expired
mbfl_main_declare_exit_code 13 error_reading_from_server

mbfl_main_declare_exit_code 14 error_writing_to_server

#page
#### option update functions

function script_option_update_authinfo_file () {
    if ! mbfl_file_is_readable "$script_option_AUTHINFO_FILE"
    then exit_because_invalid_option
    fi
}

function script_option_update_smtp_host () {
    if ! mbfl_string_is_network_hostname "$script_option_SMTP_HOSTNAME"
    then
        mbfl_message_error_printf 'invalid value as SMTP server hostname: "%s"' "$script_option_SMTP_HOSTNAME"
        exit_because_invalid_option
    fi
}

function script_option_update_smtp_port () {
    if ! mbfl_string_is_network_port "$script_option_SMTP_PORT"
    then
        mbfl_message_error_printf 'invalid value as SMTP server port number: "%s"' "$script_option_SMTP_PORT"
        exit_because_invalid_option
    fi
}

### ------------------------------------------------------------------------

function script_option_update_hostinfo_file () {
    if ! mbfl_file_is_readable "$script_option_HOSTINFO_FILE"
    then exit_because_invalid_option
    fi
}

### ------------------------------------------------------------------------

function script_option_update_session_plain () {
    script_option_SESSION_TYPE=plain
}
function script_option_update_session_tls () {
    script_option_SESSION_TYPE=tls
}
function script_option_update_session_starttls () {
    script_option_SESSION_TYPE=starttls
}

### ------------------------------------------------------------------------

function script_option_update_auth_none () {
    script_option_AUTH_TYPE=none
}
function script_option_update_auth_plain () {
    script_option_AUTH_TYPE=plain
}
function script_option_update_auth_login () {
    script_option_AUTH_TYPE=login
}

### --------------------------------------------------------------------

function script_option_update_email_from_address () {
    if ! mbfl_string_is_email_address "$script_option_EMAIL_FROM_ADDRESS"
    then exit_because_invalid_option
    fi
}

function script_option_update_email_to_address () {
    if mbfl_string_is_email_address "$script_option_EMAIL_TO_ADDRESS"
    then script_option_RECIPIENTS[${#script_option_RECIPIENTS[@]}]=$script_option_EMAIL_TO_ADDRESS
    else exit_because_invalid_option
    fi
}

### ------------------------------------------------------------------------

function script_option_update_gnutls_connector () {
    script_option_CONNECTOR=gnutls
}
function script_option_update_openssl_connector () {
    script_option_CONNECTOR=openssl
}

### ------------------------------------------------------------------------

function script_option_update_read_timeout () {
    if ! mbfl_string_is_digit "$script_option_READ_TIMEOUT"
    then
        mbfl_message_error_printf 'invalid value as timeout: %s' "$script_option_READ_TIMEOUT"
        exit_because_invalid_option
    fi
}

#page
function main () {
    # Input  and   output  file  descriptors  when   using  a  connector
    # subprocess.  This  script reads from  INFD to acquire  output from
    # the connector.   This script writes to  OUFD to send input  to the
    # connector.
    mbfl_local_varref(INFD, 3, -i)
    mbfl_local_varref(OUFD, 4, -i)
    # Pathnames  of the  FIFOs used  to  talk to  the connector's  child
    # process.
    mbfl_local_varref(INFIFO)
    mbfl_local_varref(OUFIFO)
    # The  PID of  the  connector external  program,  executed as  child
    # process.  If set to zero: it  means this process uses no connector
    # process.
    mbfl_local_varref(CONNECTOR_PID, 0, -i)

    validate_and_normalise_configuration

    mbfl_message_verbose_printf 'connecting to \"%s:%d\"\n' "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
    mbfl_message_verbose_printf 'session type: %s, authentication %s\n' "$script_option_SESSION_TYPE" "$script_option_AUTH_TYPE"
    case $script_option_SESSION_TYPE in
	plain)
            connect_establish_plain_connection mbfl_varname(INFD) mbfl_varname(OUFD) \
					       "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
	    mbfl_message_verbose 'connection established, exchange greetings\n'
            esmtp_exchange_greetings helo
            ;;

	tls)
            connect_make_fifos_for_connector
            case $script_option_CONNECTOR in
		gnutls)
		    connect_using_gnutls mbfl_varname(INFD) mbfl_varname(OUFD) \
					 mbfl_varname(CONNECTOR_PID) \
					 "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
		    ;;
		openssl)
		    connect_using_openssl mbfl_varname(INFD) mbfl_varname(OUFD) \
					  mbfl_varname(CONNECTOR_PID) \
					  "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
		    ;;
            esac
	    mbfl_message_verbose 'connection established, exchange greetings\n'
            esmtp_exchange_greetings ehlo
            ;;

	starttls)
            connect_make_fifos_for_connector
            case $script_option_CONNECTOR in
		gnutls)
		    connect_using_gnutls_starttls mbfl_varname(INFD) mbfl_varname(OUFD) \
						  mbfl_varname(CONNECTOR_PID) \
						  "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
		    ;;
		openssl)
		    connect_using_openssl_starttls mbfl_varname(INFD) mbfl_varname(OUFD) \
						   mbfl_varname(CONNECTOR_PID) \
						   "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
		    ;;
            esac
	    mbfl_message_verbose 'connection established, exchange greetings\n'
            esmtp_exchange_greetings ehlo
            ;;
    esac
    mbfl_message_verbose 'greetings exchanged, perform authentication\n'
    esmtp_authentication "$script_option_AUTH_TYPE" "$script_option_AUTH_USER" "$script_option_AUTH_PASSWORD"
    mbfl_message_verbose 'authentication performed, send message\n'
    esmtp_send_message
    esmtp_quit
    wait_for_connector_process $CONNECTOR_PID
    exit_because_success
}

#page
function validate_and_normalise_configuration () {
    # Email addresses are selected with command line options.
    #
    if ! mbfl_string_is_email_address "$script_option_EMAIL_FROM_ADDRESS"
    then
        mbfl_message_error 'invalid string as MAIL FROM envelope address: "%s"' "$script_option_EMAIL_FROM_ADDRESS"
        exit_because_invalid_option
    fi
    if mbfl_array_is_empty script_option_RECIPIENTS
    then
        mbfl_message_error 'no recipients where selected'
        exit_because_invalid_option
    fi
    {
	local -i i
	for ((i=0; i < ${#script_option_RECIPIENTS[@]}; ++i))
	do
	    if ! mbfl_string_is_email_address "${script_option_RECIPIENTS[$i]}"
	    then
		mbfl_message_error 'invalid string as RCPT TO envelope address: "%s"' "${script_option_RECIPIENTS[$i]}"
		exit_because_invalid_option
	    fi
	done
    }

    # Message source is selected with command line options.  If the test
    # message  is requested:  the  message source  is  ignored.  If  the
    # message source is '-': we must read the message from the stdin.
    #
    if ! mbfl_string_is_yes "$script_option_EMAIL_TEST_MESSAGE"
    then
        if mbfl_string_is_empty "$script_option_EMAIL_MESSAGE_SOURCE"
	then
            mbfl_message_error 'missing selection of mail message source'
            exit_because_invalid_option
	fi
        if mbfl_string_not_equal "$script_option_EMAIL_MESSAGE_SOURCE" '-'
	then
            if ! mbfl_file_is_file "$script_option_EMAIL_MESSAGE_SOURCE"
	    then
                mbfl_message_error 'selected message file does not exist: "%s"' "$script_option_EMAIL_MESSAGE_SOURCE"
                exit_because_invalid_option
            fi
            if ! mbfl_file_is_readable "$script_option_EMAIL_MESSAGE_SOURCE"
	    then
                mbfl_message_error_printf 'selected message file is not readable: "%s"' "$script_option_EMAIL_MESSAGE_SOURCE"
                exit_because_invalid_option
            fi
        fi
    fi

    # The SMTP  hostname should  be always already  selected.  If  it is
    # selected: we assume that is  its value has been already validated.
    # So there  is no need to  perform the validation again:  just check
    # that a value is there.
    #
    # We use  the hostname  for searching entries  in both  the hostinfo
    # file and the authinfo file.
    #
    if mbfl_string_is_empty "$script_option_SMTP_HOSTNAME"
    then
        mbfl_message_error 'internal failure: missing selection for SMTP hostname'
        exit_because_invalid_option
    fi

    # Should we  read the hostinfo  file?  Only if: port,  session type,
    # and auth type are not already selected.
    #
    # Here  we assume  that if  they  are selected:  they contain  valid
    # values,  either  default ones  or  values  from the  command  line
    # options.  So there is no need  to perform a full validation of the
    # values here: just check if there is a non-empty value.
    #
    if { mbfl_string_is_empty     "$script_option_SMTP_PORT"    || \
	     mbfl_string_is_empty "$script_option_SESSION_TYPE" || \
	     mbfl_string_is_empty "$script_option_AUTH_TYPE"; }
    then
	# Some value is missing, so  read the hostinfo file.  Select the
	# entry from the  file matching $script_option_SMTP_HOSTNAME and
	# store the corresponding values in the variables "hostinfo_*".
	#
	{
	    local hostinfo_SMTP_PORT hostinfo_SESSION_TYPE hostinfo_AUTH_TYPE

	    hostinfo_read "$script_option_HOSTINFO_FILE" "$script_option_SMTP_HOSTNAME" \
			  hostinfo_SMTP_PORT hostinfo_SESSION_TYPE hostinfo_AUTH_TYPE

	    # Update the script options that are not already set.
	    #
	    if mbfl_string_is_empty "$script_option_SMTP_PORT"
	    then script_option_SMTP_PORT=$hostinfo_SMTP_PORT
	    fi
	    if mbfl_string_is_empty "$script_option_SESSION_TYPE"
	    then script_option_SESSION_TYPE=$hostinfo_SESSION_TYPE
	    fi
	    if mbfl_string_is_empty "$script_option_AUTH_TYPE"
	    then script_option_AUTH_TYPE=$hostinfo_AUTH_TYPE
	    fi
	}
    fi

    # Should  we read  the  authinfo file?   Only if  the  auth type  is
    # different from  "none"; in which case  we expect a valid  value in
    # "script_option_AUTH_USER".
    #
    if mbfl_string_not_equal "$script_option_AUTH_TYPE" 'none'
    then
	if ! mbfl_string_is_email_address "$script_option_AUTH_USER"
	then
	    mbfl_message_error_printf 'invalid value for username: "%s"' "$script_option_AUTH_USER"
	    exit_because_invalid_option
	fi

	# Fine, read the authinfo file.   Select the entry from the file
	# matching            $script_option_SMTP_HOSTNAME           and
	# $script_option_AUTH_USER then  store the  corresponding values
	# in the variables "authinfo_*".
	{
	    local authinfo_AUTH_USER authinfo_AUTH_PASSWORD

	    authinfo_read "$script_option_AUTHINFO_FILE" "$script_option_SMTP_HOSTNAME" "$script_option_AUTH_USER" \
			  authinfo_AUTH_USER authinfo_AUTH_PASSWORD
	    # Override  the values  with  those read  from the  authinfo
	    # file.
	    script_option_AUTH_USER=$authinfo_AUTH_USER
	    script_option_AUTH_PASSWORD=$authinfo_AUTH_PASSWORD
	}
    fi
}

#page
#### establishing connections to remote servers

# Establish a plain connection with the selected SMTP server.  Read the
# first line  of greetings  from the server,  expecting a  line starting
# with "220".
#
# The hostname must be in the parameter "SMTP_HOSTNAME" as a string; the
# port must be in the parameter "SMTP_PORT" as an integer.
#
# The input file  descriptor, to read from the device,  is stored in the
# result variable  "INFD_RV".  The output  file descriptor, to  write to
# the device, is stored in the output variable "OUFD_RV".
#
# Errors are detected when opening the file descriptor connected to the
# device representing the remote host.
#
function connect_establish_plain_connection () {
    mbfl_mandatory_nameref_parameter(INFD_RV,   1, input file descriptor reference variable)
    mbfl_mandatory_nameref_parameter(OUFD_RV,   2, output file descriptor reference variable)
    mbfl_mandatory_parameter(SMTP_HOSTNAME,     3, SMTP hostname)
    mbfl_mandatory_integer_parameter(SMTP_PORT, 4, SMTP port)
    local DEVICE
    printf -v DEVICE '/dev/tcp/%s/%d' "$SMTP_HOSTNAME" "$SMTP_PORT"
    INFD_RV=3
    OUFD_RV=$INFD_RV

    # Notice how this works:
    #
    # 1. The external double quotes are processed, the line becomes:
    #
    #    eval exec 3<>"${DEVICE}"
    #
    # 2. The command "eval" is executed:
    #
    # 2.1. The internal double quotes are processed, the line becomes:
    #
    #    exec 3<>/dev/tcp/localhost/25
    #
    # 2.2. The command "exec" is executed.
    #
    if eval "exec ${INFD_RV}<>\"\${DEVICE}\""
    then recv 220
    else
        mbfl_message_error_printf 'failed establishing connection to %s:%d' "$SMTP_HOSTNAME" $SMTP_PORT
        exit_because_failed_connection
    fi
}

# Establish an  encrypted connection  with the  selected host  using the
# program "gnutls-cli" as connector.
#
# The hostname must be in the parameter "SMTP_HOSTNAME" as a string; the
# port must be in the parameter "SMTP_PORT" as an integer.
#
# The process is executed in  background with stdin and stdout connected
# to FIFOs,  which are  then connected to  file descriptors.   The FIFOs
# pathnames must  be in  the variables "OUFIFO"  and "INFIFO".
#
# The input  file descriptor, to read  from the connector, is  stored in
# the result variable  "INFD_RV".  The output file  descriptor, to write
# to the connector, is stored in the output variable "OUFD_RV".
#
# The PID  of the  connector process  is stored  in the  result variable
# referenced by "CONNECTOR_PID_RV".
#
# Text from  the process  is read  until a line  starting with  "220" is
# found:  this is  the line  of greetings  from the  remote server.   If
# end-of-file comes first: exit the script with an error code.
#
function connect_using_gnutls () {
    mbfl_mandatory_parameter(INFD_RV,                  1, input file descriptor reference variable)
    mbfl_mandatory_parameter(OUFD_RV,                  2, output file descriptor reference variable)
    mbfl_mandatory_nameref_parameter(CONNECTOR_PID_RV, 3, connector PID reference variable)
    mbfl_mandatory_parameter(SMTP_HOSTNAME,            4, SMTP hostname)
    mbfl_mandatory_integer_parameter(SMTP_PORT,        5, SMTP port)
    local GNUTLS GNUTLS_FLAGS="--debug 0 --port ${SMTP_PORT}"
    mbfl_program_found_var GNUTLS gnutls-cli || exit $?

    mbfl_message_verbose_printf 'connecting with gnutls, immediate encrypted bridge\n'
    mbfl_program_redirect_stderr_to_stdout
    if mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOSTNAME"
    then
	CONNECTOR_PID_RV=$mbfl_program_BGPID
	mbfl_message_debug_printf 'pid of gnutls: %d' $CONNECTOR_PID_RV
	connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
	trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
	recv_until_string 220
    else
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
        exit_because_failed_connection
    fi
}

# Establish  a  plain  connection  with  the  selected  host  using  the
# "gnutls-cli" program  as connector;  exchange greetings then  send the
# "STARTTLS" command and establish an encrypted bridge.
#
# The hostname must be in the parameter "SMTP_HOSTNAME" as a string; the
# port must be in the parameter "SMTP_PORT" as an integer.
#
# The process is executed in  background with stdin and stdout connected
# to FIFOs,  which are  then connected to  file descriptors.   The FIFOs
# pathnames must  be in  the variables "OUFIFO"  and "INFIFO".
#
# The input  file descriptor, to read  from the connector, is  stored in
# the result variable  "INFD_RV".  The output file  descriptor, to write
# to the connector, is stored in the output variable "OUFD_RV".
#
# The PID  of the  connector process  is stored  in the  result variable
# referenced by "CONNECTOR_PID_RV".
#
# Text from  the process  is read  until a line  starting with  "220" is
# found:  this is  the line  of greetings  from the  remote server.   If
# end-of-file comes first: exit the script with an error code.
#
function connect_using_gnutls_starttls () {
    mbfl_mandatory_parameter(INFD_RV,                  1, input file descriptor reference variable)
    mbfl_mandatory_parameter(OUFD_RV,                  2, output file descriptor reference variable)
    mbfl_mandatory_nameref_parameter(CONNECTOR_PID_RV, 3, connector PID reference variable)
    mbfl_mandatory_parameter(SMTP_HOSTNAME,            4, SMTP hostname)
    mbfl_mandatory_integer_parameter(SMTP_PORT,        5, SMTP port)
    local GNUTLS GNUTLS_FLAGS="--debug 0 --starttls --port ${SMTP_PORT}"
    mbfl_program_found_var GNUTLS gnutls-cli || exit $?

    mbfl_message_verbose_printf 'connecting with gnutls, delayed encrypted bridge\n'
    mbfl_program_redirect_stderr_to_stdout
    if mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOSTNAME"
    then
	CONNECTOR_PID_RV=$mbfl_program_BGPID
	mbfl_message_debug_printf 'pid of gnutls: %d' $CONNECTOR_PID_RV
	connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
	trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
	recv_until_string 220
	esmtp_exchange_greetings ehlo
	send STARTTLS
	recv 220
	kill -SIGALRM $CONNECTOR_PID_RV
	esmtp_exchange_greetings ehlo
    else
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
        exit_because_failed_connection
    fi
}

# Establish an  encrypted connection  with the  selected host  using the
# "openssl" program as connector.
#
# Read the  first line of  greetings from  the server, expecting  a line
# starting with "220".
#
# The process is executed in  background with stdin and stdout connected
# to FIFOs,  which are  then connected to  file descriptors.   The FIFOs
# pathnames must be in the variables "OUFIFO" and "INFIFO".
#
# The input  file descriptor, to read  from the connector, is  stored in
# the result variable  "INFD_RV".  The output file  descriptor, to write
# to the connector, is stored in the output variable "OUFD_RV".
#
# The PID  of the  connector process  is stored  in the  result variable
# referenced by "CONNECTOR_PID_RV".
#
# Text from  the process  is read  until a line  starting with  "220" is
# found:  this is  the line  of greetings  from the  remote server.   If
# end-of-file comes first: exit the script with an error code.
#
function connect_using_openssl () {
    mbfl_mandatory_parameter(INFD_RV,                  1, input file descriptor reference variable)
    mbfl_mandatory_parameter(OUFD_RV,                  2, output file descriptor reference variable)
    mbfl_mandatory_nameref_parameter(CONNECTOR_PID_RV, 3, connector PID reference variable)
    mbfl_mandatory_parameter(SMTP_HOSTNAME,            4, SMTP hostname)
    mbfl_mandatory_integer_parameter(SMTP_PORT,        5, SMTP port)
    local OPENSSL OPENSSL_FLAGS="s_client -quiet -connect ${SMTP_HOSTNAME}:${SMTP_PORT}"
    mbfl_program_found_var OPENSSL openssl || exit $?

    mbfl_message_verbose_printf 'connecting with openssl, immediate encrypted bridge\n'
    mbfl_program_redirect_stderr_to_stdout
    if mbfl_program_execbg $OUFIFO $INFIFO "$OPENSSL" $OPENSSL_FLAGS
    then
	CONNECTOR_PID_RV=$mbfl_program_BGPID
	mbfl_message_debug 'pid of openssl: %d' $CONNECTOR_PID_RV
	connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
	trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
	recv_until_string 220
    else
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
        exit_because_failed_connection
    fi
}

# Establish  a  plain  connection  with  the  selected  host  using  the
# "openssl" program as connector.
#
# Read the  first line of  greetings from  the server, expecting  a line
# starting with "220".
#
# NOTE!!!!   The encrypted  bridge  is established  by "openssl"  itself
# after exchanging greetings  using the ESMTP protocol; we  just have to
# read lines until the code 250 is received.
#
# The process is executed in  background with stdin and stdout connected
# to FIFOs,  which are  then connected to  file descriptors.   The FIFOs
# pathnames must be in the variables "OUFIFO" and "INFIFO".
#
# The input  file descriptor, to read  from the connector, is  stored in
# the result variable  "INFD_RV".  The output file  descriptor, to write
# to the connector, is stored in the output variable "OUFD_RV".
#
# The PID  of the  connector process  is stored  in the  result variable
# referenced by "CONNECTOR_PID_RV".
#
# Text from  the process  is read  until a line  starting with  "250" is
# found:  this is  the line  of greetings  from the  remote server.   If
# end-of-file comes first: exit the script with an error code.
#
function connect_using_openssl_starttls () {
    mbfl_mandatory_parameter(INFD_RV,                  1, input file descriptor reference variable)
    mbfl_mandatory_parameter(OUFD_RV,                  2, output file descriptor reference variable)
    mbfl_mandatory_nameref_parameter(CONNECTOR_PID_RV, 3, connector PID reference variable)
    mbfl_mandatory_parameter(SMTP_HOSTNAME,            4, SMTP hostname)
    mbfl_mandatory_integer_parameter(SMTP_PORT,        5, SMTP port)
    local OPENSSL OPENSSL_FLAGS="s_client -quiet -starttls smtp -connect ${SMTP_HOSTNAME}:${SMTP_PORT}"
    mbfl_program_found_var OPENSSL openssl || exit $?

    mbfl_message_verbose_printf 'connecting with openssl, delayed encrypted bridge\n'
    mbfl_program_redirect_stderr_to_stdout
    if mbfl_program_execbg $OUFIFO $INFIFO "$OPENSSL" $OPENSSL_FLAGS
    then
	CONNECTOR_PID_RV=$mbfl_program_BGPID
	mbfl_message_debug 'pid of openssl: %d' $CONNECTOR_PID_RV
	connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
	trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
	recv_until_string 250
    else
        mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
        exit_because_failed_connection
    fi
}

#page
#### waiting for the connector process

# To be  called when  successfully exiting the  script.  Use  the "wait"
# command to wait for the termination of the connector process (to avoid
# leaving around zombie processes).
#
# If this process uses a connector: the  pid of the connector must be in
# "CONNECTOR_PID".   If   this  process   does  not  use   a  connector:
# "CONNECTOR_PID" must be the empty string.
#
function wait_for_connector_process () {
    mbfl_optional_integer_parameter(CONNECTOR_PID, 1)

    if ((0 < CONNECTOR_PID))
    then
	# Remove       the       EXIT        trap       that       calls
	# "terminate_and_wait_for_connector_process()".
        trap '' EXIT
        mbfl_message_debug_printf 'waiting for connector process (pid %d)' $CONNECTOR_PID
        wait $CONNECTOR_PID
        mbfl_message_debug_printf 'gathered connector process'
    fi
}

# To be  called when  an error  occurs by the  "trap ...  EXIT" handler.
# Force the  termination of the  connector process  and wait for  it (to
# avoid leaving around zombie processes).
#
# If this process uses a connector: the  pid of the connector must be in
# "CONNECTOR_PID".   If   this  process   does  not  use   a  connector:
# "CONNECTOR_PID" must be the empty string.
#
function terminate_and_wait_for_connector_process () {
    mbfl_optional_integer_parameter(CONNECTOR_PID, 1)

    if ((0 < CONNECTOR_PID))
    then
        mbfl_message_debug_printf 'forcing termination of connector process (pid %d)' $CONNECTOR_PID
        kill -SIGTERM $CONNECTOR_PID &>/dev/null
        mbfl_message_debug_printf 'waiting for connector process (pid %d)' $CONNECTOR_PID
        wait $CONNECTOR_PID &>/dev/null
        mbfl_message_debug_printf 'gathered connector process'
    fi
}

#page
#### handling of FIFOs to the connector

# Create  two temporary  FIFOs to  be used  to chat  with the  connector
# process.
#
# The FIFO pathnames are stored  in the variables "INFIFO" and "OUFIFO".
# "INFIFO"  will  be used  by  this  script  to  receive data  from  the
# connector.  "OUFIFO" will  be used by this script to  send data to the
# connector.
#
# If an error  occurs creating the FIFOs: exit the  script with an error
# code.
#
# FIXME The pathnames of the FIFOs  are randomly generated, but not in a
# special safe way.  Can this be fixed?
#
function connect_make_fifos_for_connector () {
    local MKFIFO
    if ! mbfl_file_find_tmpdir_var TMPDIR
    then
        mbfl_message_error 'unable to determine pathname of temporary directory'
        exit_failure
    fi
    INFIFO=${TMPDIR}/connector-to-script.${RANDOM}.$$
    OUFIFO=${TMPDIR}/script-to-connector.${RANDOM}.$$
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

# Connect the FIFOs to the connector to the selected file descriptors.
#
# Notice the  strange quoting needed  to perform variable  expansion for
# file descriptors:  that is the  way it  is for redirections  under the
# Bourne shells.
#
function connect_open_file_descriptors_to_fifos () {
    mbfl_mandatory_nameref_parameter(INFD, 1, input-from-connector file descriptor reference variable)
    mbfl_mandatory_nameref_parameter(OUFD, 2, output-from-connector file descriptor reference variable)

    # Notice how this works:
    #
    # 1. The external double quotes are processed, the line becomes:
    #
    #    eval exec 3<>"${INFIFO}" 4>"${OUFIFO}"
    #
    # 2. The command "eval" is executed:
    #
    # 2.1. The internal double quotes are processed, the line becomes:
    #
    #    exec 3<>/tmp/connector-to-script.1234.555 4>script-to-connector.5678.555
    #
    # 2.2. The command "exec" is executed.
    #
    eval "exec ${INFD}<>\"\${INFIFO}\" ${OUFD}>\"\${OUFIFO}\""

    # Remove the EXIT trap that calls "connect_cleanup_fifos()".
    trap "" EXIT
    connect_cleanup_fifos
    return 0
}

# Remove the  input and  output FIFOs to  the connector,  ignoring error
# messages.
#
function connect_cleanup_fifos () {
    mbfl_file_remove "$INFIFO" &>/dev/null || true
    mbfl_file_remove "$OUFIFO" &>/dev/null || true
}

#page
#### basic reading operations from the server

# Read a line  from "INFD" and store  it in the variable  "REPLY" in the
# environment  of the  caller.  When  successful return  zero; otherwise
# exit the script with the appropriate exit code.
#
# Use the parameter "READ_TIMEOUT" to set the read timeout in seconds.
#
function read_from_server () {
    mbfl_mandatory_parameter(INFD,         1, input file descriptor)
    mbfl_mandatory_parameter(READ_TIMEOUT, 2, read timeout)
    local -i EXIT_CODE

    IFS= read -rs -t $READ_TIMEOUT -u $INFD REPLY
    EXIT_CODE=$?
    mbfl_string_strip_carriage_return_var REPLY "$REPLY"
    mbfl_message_debug_printf 'recv: %s' "$REPLY"
    if ((0 == EXIT_CODE))
    then return 0
    elif ((128 < EXIT_CODE))
    then
        mbfl_message_error 'read timeout exceeded'
        exit_because_read_timeout_expired
    else
        mbfl_message_error 'error reading from server'
        exit_because_error_reading_from_server
    fi
}

# Assuming a  previous read  operation from the  server yielded  a wrong
# answer: try to cleanly close the connection, then exit the script.
#
function try_to_cleanly_close_the_connection_after_wrong_answer () {
    mbfl_mandatory_parameter(INFD,         1, input file descriptor)
    mbfl_mandatory_parameter(script_option_READ_TIMEOUT, 2, read timeout)
    if send %s QUIT
    then read_from_server $INFD $script_option_READ_TIMEOUT
    fi
    exit_because_wrong_server_answer
}

#page
#### receiving data from the server

# Read a single line from $INFD, and log it if debugging mode is on.  If
# the first 3  chars in the line  are not equal to the  given code: quit
# the session and exit the script with an error code.
#
# This  is meant  to be  the standard  way of  reading answers  from the
# server.
#
function recv () {
    mbfl_mandatory_parameter(EXPECTED_CODE, 1, expected code)
    local REPLY

    read_from_server $INFD $script_option_READ_TIMEOUT
    if mbfl_string_equal "${REPLY:0:3}" "$EXPECTED_CODE"
    then return 0
    else try_to_cleanly_close_the_connection_after_wrong_answer $INFD $script_option_READ_TIMEOUT
    fi
}

# Read  a single  line from  the file  descriptor $INFD,  and log  it if
# debugging mode is  on.  If the beginning  of the line is  not equal to
# the given string:  quit the session and exit the  script with an error
# code.
#
# This is meant to be a special way to read answers from the server.
#
function recv_string () {
    mbfl_mandatory_parameter(EXPECTED_STRING, 1, expected string)
    local -ri EXPECTED_STRING_LEN=${#EXPECTED_STRING}
    local REPLY

    read_from_server $INFD $script_option_READ_TIMEOUT
    if mbfl_string_equal "${REPLY:0:${EXPECTED_STRING_LEN}}" "$EXPECTED_STRING"
    then return 0
    else try_to_cleanly_close_the_connection_after_wrong_answer $INFD $script_option_READ_TIMEOUT
    fi
}

# Read multiple  lines from the file  descriptor $INFD, and log  them if
# debugging mode  is on.  If  the beginning of  a line equals  the given
# string: stop reading  and return with success;  if end--of--file comes
# first: exit the script with an error code.
#
# This is meant to read output from the server or the connector, until a
# known  string   comes.   It  is   used  when  the   connector  outputs
# informations  about the  encrypted bridge  and when  the server  sends
# informations about its capabilities.
#
function recv_until_string () {
    mbfl_mandatory_parameter(EXPECTED_STRING, 1, expected string)
    local -ri EXPECTED_STRING_LEN=${#EXPECTED_STRING}
    local REPLY

    while true
    do
	read_from_server $INFD $script_option_READ_TIMEOUT
	if mbfl_string_equal "${REPLY:0:${EXPECTED_STRING_LEN}}" "$EXPECTED_STRING"
	then return 0
	fi
    done
}

#page
#### basic writing operations from the server

# Write  a  single line  of  text  to  "$OUFD", appending  the  required
# carriage return and newline  characters.  When successful: return with
# code zero; otherwise exit the script with the appropriate exit code.
#
# We accept writing empty lines.
#
function write_to_server () {
    mbfl_mandatory_parameter(OUFD, 1, output file descriptor)
    mbfl_optional_parameter(LINE, 2)

    if printf '%s\r\n' "$LINE" >&"$OUFD"
    then
	mbfl_message_debug_printf 'sent (%d bytes): %s' ${#LINE} "$LINE"
	return 0
    else
	mbfl_message_error 'writing to the server'
	exit_because_error_writing_to_server
    fi
}

# Like "write_to_server()", but never log the sent line.
#
function write_to_server_no_log () {
    mbfl_mandatory_parameter(OUFD, 1, output file descriptor)
    mbfl_optional_parameter(LINE, 2)

    if printf '%s\r\n' "$LINE" >&"$OUFD"
    then return 0
    else
	mbfl_message_error 'writing to the server'
	exit_because_error_writing_to_server
    fi
}

#page
#### sending data to the server

# Write a  formatted line of text  to the file descriptor  $OUFD; format
# the first parameter with the optional arguments.  If debugging mode is
# on: Log the line.
#
function send () {
    mbfl_mandatory_parameter(TEMPLATE, 1, template)
    shift
    local LINE

    printf -v LINE "$TEMPLATE" "$@"
    write_to_server $OUFD "$LINE"
}

# Like "send()"  but, when  debugging mode  is on: do  not log  the line
# itself, only a message.  This is to prevent secrets to be logged.
#
function send_no_log () {
    mbfl_mandatory_parameter(TEMPLATE, 1, template)
    shift
    local LINE

    printf -v LINE "$TEMPLATE" "$@"
    write_to_server_no_log $OUFD "$LINE"
}

#page
#### email message

# Acquire the  email message from  the selected  source and write  it to
# $OUFD.  The source is selected by the command line parameters.
#
# Just to be safe: a newline is  appended to the message; this allows to
# read the message with "read" without discarding the last line.
#
# Read the email message from stdin line  by line, and write it to $OUFD
# line by  line appending the  carriage return, line feed  sequence.  If
# debugging mode is on: Log a line.
#
function read_and_send_message () {
    local -i EXIT_CODE

    {
        local LINE
        if mbfl_string_is_yes "$script_option_EMAIL_TEST_MESSAGE"
        then
            # Here  we can  detect an  error  through the  exit code  of
            # "print_email_test_message".
            if ! print_email_test_message
	    then
                mbfl_message_error 'unable to compose test message'
                exit_because_invalid_message_source
            fi
            mbfl_message_verbose 'sending test message\n'
        else
            if mbfl_string_equal "$script_option_EMAIL_MESSAGE_SOURCE" '-'
            then
                mbfl_message_verbose 'reading message from stdin\n'
                exec 5<&0
            else
                mbfl_message_verbose 'reading message from file\n'
                exec 5<"$script_option_EMAIL_MESSAGE_SOURCE"
            fi
            # Here  it is  impossible  to distinguish  between an  error
            # reading the source and an the end of file.
            while IFS= read -rs LINE <&5
            do
		# Take care of quoting any intial dot characters.
                if mbfl_string_equal "${LINE:0:1}" = '.'
                then printf '.%s\n' "$LINE"
                else printf  '%s\n' "$LINE"
                fi
            done
            exec 5<&-
        fi
    } | {
        local LINE
        local -i LINES_COUNT=0 BYTES_COUNT=0
        while IFS= read -rs LINE
        do
	    write_to_server_no_log $OUFD "$LINE"
            let ++LINES_COUNT
	    # The bytes  count for a line  is the line length  plus 2 to
	    # account for the carriage return and line feed.
            BYTES_COUNT+=$((${#LINE} + 2))
        done
        mbfl_message_debug_printf 'sent message (%d lines, %d bytes)' $LINES_COUNT $BYTES_COUNT
	return 0
    }
    EXIT_CODE=$?
    if ((0 == $EXIT_CODE))
    then return 0
    else exit $EXIT_CODE
    fi
}

# Compose and print to stdout a  test email message.  The addresses must
# be in the variables "$script_option_EMAIL_FROM_ADDRESS" and "TO_ADDRESS".
#
function print_email_test_message () {
    local TO_ADDRESS DATE MESSAGE_ID MESSAGE
    local -i i

    acquire_local_hostname

    TO_ADDRESS=" <${script_option_RECIPIENTS[$i]}>"
    for ((i=1; i < ${#script_option_RECIPIENTS[@]}; ++i))
    do TO_ADDRESS+=", <${script_option_RECIPIENTS[$i]}>"
    done

    if ! DATE=$(mbfl_date_email_timestamp)
    then
        mbfl_message_error 'unable to determine date in RFC-2822 format for test message'
        exit_failure
    fi

    printf -v MESSAGE_ID '%d-%d-%d@%s' "$RANDOM" "$RANDOM" "$RANDOM" "$LOCAL_HOSTNAME"
    MESSAGE="Sender: ${script_option_EMAIL_FROM_ADDRESS}
From: <${script_option_EMAIL_FROM_ADDRESS}>
To: ${TO_ADDRESS}
Subject: test message from ${script_PROGNAME}
Message-ID: <${MESSAGE_ID}>
Date: ${DATE}
\n\
This is a test message from the ${script_PROGNAME} script.
Configuration:
\tSMTP hostname:\t\t\t${script_option_SMTP_HOSTNAME}
\tSMTP port:\t\t\t${script_option_SMTP_PORT}
\tsession type:\t\t\t${script_option_SESSION_TYPE}
\tscript option gnutls-cli:\t${script_option_GNUTLS_CONNECTOR}
\tscript option openssl:\t\t${script_option_OPENSSL_CONNECTOR}
\tselected connector:\t\t${script_option_CONNECTOR}
\tauth file:\t\t\t'${script_option_AUTHINFO_FILE}'
\tauth user:\t\t\t'${script_option_AUTH_USER}'
\tauth method plain:\t\t${script_option_AUTH_PLAIN}
\tauth method login:\t\t${script_option_AUTH_LOGIN}
--\x20
The ${script_PROGNAME} script
Copyright ${script_COPYRIGHT_YEARS} $script_AUTHOR
"
    printf "$MESSAGE"
}

#page
#### SMTP/ESMTP protocol

# Exchange greetings with the server.  Send  a "HELO" or "EHLO" line and
# read lines until the first starting with "250 ".
#
# The parameter TYPE must be one among: "helo", "ehlo".
#
function esmtp_exchange_greetings () {
    mbfl_mandatory_parameter(TYPE, 1, type of greetings)

    acquire_local_hostname
    mbfl_message_verbose 'esmtp: exchanging greetings with server\n'
    case $TYPE in
        helo) send 'HELO %s' "$LOCAL_HOSTNAME" ;;
        ehlo) send 'EHLO %s' "$LOCAL_HOSTNAME" ;;
    esac
    recv_until_string '250 '
}

# Do the  selected authentication  process with the  credentials already
# read from the selected authinfo file.
#
# The    selected   authentication    must    be    in   the    variable
# "script_option_AUTH_TYPE", the login name and  the password must be in
# the variables "LOGIN_NAME" and "PASSWORD".
#
# Notice that the secrets are not logged by the debugging functions.
#
function esmtp_authentication () {
    mbfl_mandatory_parameter(AUTH_TYPE,  1, authorisation type)

    case $AUTH_TYPE in
        none)
            :
            ;;

        plain)
	    mbfl_mandatory_parameter(LOGIN_NAME, 2, login name)
	    mbfl_mandatory_parameter(PASSWORD,   3, login password)
            local AUTH_PREFIX='AUTH PLAIN ' ENCODED_STRING
            mbfl_message_verbose 'performing AUTH PLAIN authentication\n'
            if ! ENCODED_STRING=$(printf '\x00%s\x00%s' "$LOGIN_NAME" "$PASSWORD" | pipe_base64)
	    then
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            fi
	    mbfl_message_debug_printf 'sent (%d bytes): %s<encoded string>' $(( ${#AUTH_PREFIX} + ${#ENCODED_STRING} )) "$AUTH_PREFIX"
            send_no_log '%s%s' "$AUTH_PREFIX" "$ENCODED_STRING"
            recv 235
            ;;

        login)
	    mbfl_mandatory_parameter(LOGIN_NAME, 2, login name)
	    mbfl_mandatory_parameter(PASSWORD,   3, login password)
            local ENCODED_USER_STRING ENCODED_PASS_STRING
            mbfl_message_verbose 'performing AUTH LOGIN authentication\n'

            if ! ENCODED_USER_STRING=$(echo -n "$LOGIN_NAME" | pipe_base64)
	    then
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            fi
            if ! ENCODED_PASS_STRING=$(echo -n "$PASSWORD"   | pipe_base64)
	    then
                mbfl_message_error 'unable to encode string for authentication'
                exit_failure
            fi

            send 'AUTH LOGIN'
            recv 334
	    mbfl_message_debug_printf 'sent (%d bytes): <encoded string>' ${#ENCODED_USER_STRING}
            send_no_log "$ENCODED_USER_STRING"
            recv 334
	    mbfl_message_debug_printf 'sent (%d bytes): <encoded string>' ${#ENCODED_PASS_STRING}
            send_no_log "$ENCODED_PASS_STRING"
            recv 235
            ;;

	*)
	    mbfl_message_error_printf 'internal error: invalid AUTH TYPE: "%s"' "$AUTH_TYPE"
	    exit_because_failure
	    ;;
    esac
    return 0
}

# Do the SMTP dialog required to send a message.
#
function esmtp_send_message () {
    local -i i

    mbfl_message_verbose 'esmtp: sending message\n'
    send 'MAIL FROM:<%s>' "$script_option_EMAIL_FROM_ADDRESS"
    recv 250
    for ((i=0; i < ${#script_option_RECIPIENTS[@]}; ++i))
    do
        send 'RCPT TO:<%s>' "${script_option_RECIPIENTS[$i]}"
        recv 250
    done
    send %s DATA
    recv 354
    read_and_send_message
    send %s .
    recv 250
    return 0
}

# Quit an SMTP session.
#
function esmtp_quit () {
    mbfl_message_verbose 'esmtp: end dialogue\n'
    send %s QUIT
    recv 221
    return 0
}

#page
#### authinfo file: authentication credentials from authinfo file
#
# The authinfo file  is a line-oriented text file whose  lines must have
# the following format:
#
#    machine <hostname> login <usermail> password <password>
#
# for example:
#
#    machine smtp.gmail.com login mrc.mgg@gmail.com password <password>
#
# where:
#
# <hostname> is the name of the SMTP server, for example smtp.gmail.com.
#
# <usermail> is the user's email address, for example mrc.mgg@gmail.com.
#
# <password> is the secret password for authentication.
#

# Read  the  credentials  from  the  authinfo  file  whose  pathname  is
# OPTION_AUTHINFO_FILE.   Use  the  values in  OPTION_SMTP_HOSTNAME  and
# OPTION_AUTH_USER to select an entry from the file; store the resulting
# informations   in  the   uplevel   variables  AUTHINFO_AUTH_USER   and
# AUTHINFO_AUTH_PASSWORD.
#
function authinfo_read () {
    mbfl_mandatory_parameter(OPTION_AUTHINFO_FILE,           1, autihinfo file pathname)
    mbfl_mandatory_parameter(OPTION_SMTP_HOSTNAME,           2, SMTP hostname)
    mbfl_mandatory_parameter(OPTION_AUTH_USER,               3, SMTP login username)
    mbfl_mandatory_nameref_parameter(AUTHINFO_AUTH_USER,     4, authinfo username variable reference)
    mbfl_mandatory_nameref_parameter(AUTHINFO_AUTH_PASSWORD, 5, authinfo password variable reference)
    # We use the  ":graph:" class for the password: as  described in the
    # manual pages regex(7), wctype(3),  isgraph(3), it includes all the
    # printable characters with the exclusion of spaces.
    local -r ENTRY_REX='^machine[ \t]+([a-zA-Z0-9_.\-]+)[ \t]+login[ \t]+([a-zA-Z0-9_.@\-]+)[ \t]+password[ \t]+([[:graph:]]+)[ \t]*$'
    local ENTRY_LINE FOUND=false

    mbfl_message_debug_printf 'reading authinfo file: %s' "$OPTION_AUTHINFO_FILE"

    # If a line is invalid: ignore it.
    #
    while IFS= read ENTRY_LINE
    do
	if [[ $ENTRY_LINE =~ $ENTRY_REX ]]
	then
	    if mbfl_string_equal "$OPTION_SMTP_HOSTNAME" "${BASH_REMATCH[1]}"
	    then
		# Save the values from the line regex matching.
		AUTHINFO_AUTH_USER=${BASH_REMATCH[2]}
		AUTHINFO_AUTH_PASSWORD=${BASH_REMATCH[3]}
		{
		    local USERNAME_REX="^.*${OPTION_AUTH_USER}.*$"
		    if [[ ${BASH_REMATCH[2]} =~ $USERNAME_REX ]]
		    then
			FOUND=true
			break
		    fi
		}
	    fi
	fi
    done <"$OPTION_AUTHINFO_FILE"

    if ! $FOUND
    then
        mbfl_message_error_printf 'unknown authorisation information for \"%s@%s\"' \
				  "$OPTION_AUTH_USER" "$OPTION_SMTP_HOSTNAME"
        exit_because_unknown_auth_user
    fi
}

#page
#### hostinfo file
#
# The hostinfo file  is a line-oriented text file whose  lines must have
# the following format:
#
#    machine <hostname> service smtp port <port> session <sestype> auth <authtype>
#
# where:
#
# <hostname> is the name of the SMTP server, for example smtp.gmail.com.
#
# <port>  is the  port number  to which  this script  must connect;  for
# example 25 for plain sessions; for GMail/TLS it is 587.
#
# <sestype> is the type of session to  use; it must be one among: plain,
# tls, starttls.
#
# <authtype> is the type of authentication to use; it must be one among:
# none, plain, login.
#

# Read the  hostinfo file  whose pathname is  OPTION_HOSTINFO_FILE.  Use
# the value  in OPTION_SMTP_HOSTNAME to  select an entry from  the file;
# store   the   resulting   informations  in   the   uplevel   variables
# HOSTINFO_SMTP_PORT, HOSTINFO_SESSION_TYPE, HOSTINFO_AUTH_TYPE.
#
function hostinfo_read () {
    mbfl_mandatory_parameter(OPTION_HOSTINFO_FILE,          1, hostinfo file pathname)
    mbfl_mandatory_parameter(OPTION_SMTP_HOSTNAME,          2, SMTP hostname)
    mbfl_mandatory_nameref_parameter(HOSTINFO_SMTP_PORT,    3, hostinfo SMTP port variable reference)
    mbfl_mandatory_nameref_parameter(HOSTINFO_SESSION_TYPE, 4, hostinfo session type variable reference)
    mbfl_mandatory_nameref_parameter(HOSTINFO_AUTH_TYPE,    5, hostinfo auth type variable reference)
    local ENTRY_LINE
    local -r ENTRY_REX='^machine[ \t]+([a-zA-Z0-9_.\-]+)[ \t]+service[ \t]+smtp[ \t]+port[ \t]+([0-9]+)[ \t]+session[ \t]+(plain|tls|starttls)[ \t]+auth[ \t]+(login|plain|none)[ \t]*$'
    local FOUND=false

    mbfl_message_debug_printf 'reading hostinfo file: %s' "$OPTION_HOSTINFO_FILE"

    # If a line is invalid: ignore it.
    #
    while IFS= read ENTRY_LINE
    do
	if [[ $ENTRY_LINE =~ $ENTRY_REX ]]
	then
	    if mbfl_string_equal "$OPTION_SMTP_HOSTNAME" "${BASH_REMATCH[1]}" && mbfl_string_is_network_port "${BASH_REMATCH[2]}"
	    then
		HOSTINFO_SMTP_PORT=${BASH_REMATCH[2]}
		HOSTINFO_SESSION_TYPE=${BASH_REMATCH[3]}
		HOSTINFO_AUTH_TYPE=${BASH_REMATCH[3]}
		FOUND=true
		break
	    fi
	fi
    done <"$OPTION_HOSTINFO_FILE"

    if ! $FOUND
    then
        mbfl_message_error_printf 'unknown hostinfo information for \"%s\"' "$OPTION_SMTP_HOSTNAME"
        exit_because_unknown_host
    fi
}

#page
#### helpers

# If the global variable LOCAL_HOSTNAME is empty: fill it with the fully
# qualified domain name of the local hostname.
#
function acquire_local_hostname () {
    if mbfl_string_is_empty "$LOCAL_HOSTNAME"
    then
	if ! LOCAL_HOSTNAME=$(program_hostname --fqdn)
	then
            mbfl_message_error 'unable to acquire local hostname'
            exit_failure
	fi
    fi
}

#page
#### running external programs

function program_hostname () {
    local HOSTNAME_PROGRAM
    mbfl_program_found_var HOSTNAME_PROGRAM hostname || exit $?
    mbfl_program_exec "$HOSTNAME_PROGRAM" "$@"
}

function pipe_base64 () {
    local BASE64
    mbfl_program_found_var BASE64 base64 || exit $?
    mbfl_program_exec "$BASE64"
}

#page
### let's go

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
