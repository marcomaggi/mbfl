;;; sendmail-mbfl.el --- send mail with sendmail-mbfl.sh

;; Copyright (C) 2009  Marco Maggi <marcomaggi@gna.org>
;; Copyright (C) 1999,  2000, 2001, 2002, 2003, 2004,  2005, 2006, 2007,
;; 2008 Free Software Foundation, Inc.

;; Author: Marco Maggi <marcomaggi@gna.org>
;; Keywords: mail

;; This library is modeled after  some bits of the library "starttls.el"
;; by    Daiki   Ueno    <ueno@unixuser.org>    and   Simon    Josefsson
;; <simon@josefsson.org>, which comes with GNU Emacs 22.3.

;; This file is free software;  you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation;  either version 3, or (at  your option) any
;; later version.

;; This file  is distributed  in the  hope that it  will be  useful, but
;; WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
;; MERCHANTABILITY  or FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
;; General Public License for more details.

;; You should  have received  a copy of  the GNU General  Public License
;; along with  GNU Emacs; see  the file COPYING.   If not, write  to the
;; Free  Software Foundation,  Inc.,  51 Franklin  Street, Fifth  Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This  module implements  a  method  of sending  email  messages to  a
;; SMTP/ESMTP server using an  external program.  It supports plain SMTP
;; session as well as sessions encrypted with the SSL/TLS protocol.
;;
;; To handle the encrypted layer  it can use both the "openssl" program,
;; distributed with  OpenSSL, and the  "gnutls-cli" program, distributed
;; with GNU TLS.
;;
;; The encrypted  layer does NOT support  certificate authentication, so
;; it is vulnerable to certain attacks.  It can be used, though, to send
;; email to public email services like Gmail.
;;
;; The core of this module is an interface function which interprets the
;; current buffer  contents as an email  message and sends  it using the
;; "sendmail-mbfl.sh" GNU Bash script distributed with MBFL.
;;
;; The function  `send-mail-with-mbfl' can be invoked  directly from the
;; minibuffer,      or,     better,      used      as     value      for
;; `message-send-mail-function'.
;;
;; MBFL is  a library of  functions for the  GNU Bash shell.  It  can be
;; downloaded from:
;;
;;	http://gna.org/projects/mbfl
;;
;; while development takes place at:
;;
;;      http://github.com/marcomaggi/mbfl/tree/master
;;
;; the home page is:
;;
;;	http://marcomaggi.github.com/mbfl.html
;;
;; the  full  documentation of  the  script,  and  a discussion  of  its
;; internals, are available in the MBFL documentation in Texinfo format:
;;
;;	http://marcomaggi.github.com/docs/mbfl.html
;;

;;; Code:

(require 'message)

(defgroup sendmail-mbfl nil
  "Send mail using the \"sendmail-mbfl.sh\" GNU Bash script."
  :version "22.3"
  :group 'mail)

(defcustom sendmail-mbfl-program "sendmail-mbfl.sh"
  "Name of the MBFL shell script."
  :version "22.3"
  :type 'string
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-extra-args '("--verbose" "--debug")
  "Extra arguments to `sendmail-mbfl.sh'."
  :type '(repeat string)
  :group 'senmdail-mbfl)

(defcustom sendmail-mbfl-process-connection-type nil
  "*Value  for  `process-connection-type'  to use  when  starting
sendmail-mbfl process."
  :version "22.3"
  :type 'boolean
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-envelope-from-function 'sendmail-mbfl-envelope-from
  "Select a function  to call to acquire, from  the current buffer,
the  envelope email  address of  the sender,  to be  used  in the
\"MAIL FROM\" SMTP command.

The function  is invoked with no  arguments and it  must return a
single  string representing  the email  address.  If  no suitable
address is found: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-envelope-from'."
  :version "22.3"
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-envelope-to-function 'sendmail-mbfl-envelope-to
  "Select a function  to call to acquire, from  the current buffer,
the envelope email addresses of  the receivers, to be used in the
\"RCPT TO\" SMTP command.

The function  is invoked with no  arguments and it  must return a
list  of strings  representing email  addresses.  If  no suitable
address is found: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-envelope-to'."
  :version "22.3"
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-extract-addresses-function 'sendmail-mbfl-extract-addresses
  "Select a function to call to extract a list of email addresses
from an  email header.  It is  invoked with no  arguments and the
buffer narrowed to the header to examine.

The function  is invoked with no  arguments and it  must return a
list of strings representing email addresses, or nil.

The  selected function  is used  by `sendmail-mbfl-envelope-from'
and `sendmail-mbfl-envelope-to'."
  :version "22.3"
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-hostname-function 'sendmail-mbfl-hostname
  "Select a function to call  to extract the hostname of the SMTP
server to used.  The result is used as search key in the selected
hostinfo file.

The function  is invoked with no  arguments and it  must return a
string representing  the hostname; if  it is unable  to determine
the hostname: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-hostname'."
  :version "22.3"
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-username-function 'sendmail-mbfl-username
  "Select a function  to call to extract the  username with which
to login into the SMTP server.   The result is used as search key
in the selected authinfo file.

The function  is invoked with no  arguments and it  must return a
string representing  the username; if  it is unable  to determine
the username: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-username'."
  :version "22.3"
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-host-info (expand-file-name "~/.hostinfo")
  "The pathname of the file holding informations about known SMTP
servers."
  :version "22.3"
  :type 'string
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-auth-info (expand-file-name "~/.authinfo")
  "The  pathname of  the  file holding  informations about  known
accounts at SMTP servers."
  :version "22.3"
  :type 'string
  :group 'sendmail-mbfl)

(defun sendmail-mbfl-envelope-from ()
  "Interpret the  current buffer as  an email message  and search
the contents for an email  address to be used as envelope sender.
It examines the headers \"Sender\" and \"From\", in this order.

Return  a single string  representing the  email address.   If no
suitable address is found: an error is raised."
  (let ((addresses (cond
		    ((message-field-value "Sender")
		     (sendmail-mbfl-extract-address-trampoline "Sender"))
		    ((message-field-value "From")
		     (sendmail-mbfl-extract-address-trampoline "From"))
		    (t
		     (error "Unable to find a sender address")))))
    (if (null addresses)
	(error "Unable to find a sender address")
      (car addresses))))

(defun sendmail-mbfl-envelope-from/message ()
  (interactive)
  (message "Envelope sender address: %s" (sendmail-mbfl-envelope-from)))

(defun sendmail-mbfl-envelope-to ()
  "Interpret the  current buffer as  an email message  and search
the  contents  for  email   addresses  to  be  used  as  envelope
receivers.  It examines the headers \"To\", \"Cc\" and \"Bcc\".

Return  a list of  strings representing  email addresses.   If no
suitable address is found: an error is raised."
  (let* ((receivers (apply 'nconc
			   (mapcar '(lambda (HEADER)
				      (when (message-field-value HEADER)
					(sendmail-mbfl-extract-address-trampoline HEADER)))
				   '("To" "Cc" "Bcc")))))
    (if (null receivers)
	(error "Unable to find receivers addresses.")
      receivers)))

(defun sendmail-mbfl-envelope-to/message ()
  (interactive)
  (message "Envelope receiver address: %s" (sendmail-mbfl-envelope-to)))

(defun sendmail-mbfl-extract-address-trampoline (HEADER)
  "Move to the specified  HEADER and extract email addresses from
the field.  Return the list of  addresses as strings or nil if no
addresses are found.

Addresses  are  extracted  using  the function  selected  by  the
customisable variable `sendmail-mbfl-extract-addresses-function'."
  (save-excursion
    (save-restriction
      (message-position-on-field HEADER)
      (message-narrow-to-field)
      (funcall sendmail-mbfl-extract-addresses-function))))

(defun sendmail-mbfl-extract-addresses ()
  "Extract a list of email addresses from the current buffer.  It
must  be  invoked with  the  buffer  narrowed  to the  header  to
examine.  Return a list of  email addresses as strings, or nil if
no address is found."
  (let ((addresses nil)
	(rex (concat "[[:space:]]*<?[[:space:]]*"
		     "\\([^[:space:]]+@[^[:space:]>,]+\\)"
		     "[[:space:]]*>?"
		     "[[:space:]]*,?"
		     "\\([[:space:]]*\\|$\\)")))
    (while (re-search-forward rex (point-max) t)
      (setq addresses (cons (match-string 1) addresses)))
    addresses))

(defun sendmail-mbfl-hostname ()
  "Extract,  from the current  buffer, the  hostname of  the SMTP
server to  be used to  send the message.   The result is  used as
search key in the selected hostinfo file.

Return a  string representing  the hostname; if  it is  unable to
determine the hostname: raise an error."
  (let* ((address	(sendmail-mbfl-envelope-from))
	 (ell		(split-string address "@" t)))
    (if (= 2 (length ell))
	(cadr ell)
      (error "unable to extract hostname from address: %s"
	     from-address))))

(defun sendmail-mbfl-hostname/message ()
  (interactive)
  (message "Hostname: %s" (sendmail-mbfl-hostname)))

(defun sendmail-mbfl-username ()
  "Extract, from  the current buffer, the username  with which to
login to  the SMTP server.  The  result is used as  search key in
the selected authinfo file.

Return a  string representing  the username; if  it is  unable to
determine the username: raise an error."
  (let* ((address	(sendmail-mbfl-envelope-from))
	 (ell		(split-string address "@" t)))
    (if (= 2 (length ell))
	(car ell)
      (error "unable to extract username from address: %s"
	     from-address))))

(defun sendmail-mbfl-username/message ()
  (interactive)
  (message "Username: %s" (sendmail-mbfl-username)))

(defun send-mail-with-mbfl ()
  "Implement a  method of sending email messages  to a SMTP/ESMTP
server using an external program.  It supports plain SMTP session
as well as sessions encrypted with the SSL/TLS protocol.

To handle  the encrypted  layer it can  use both  the \"openssl\"
program,  distributed   with  OpenSSL,  and   the  \"gnutls-cli\"
program, distributed with GNU TLS.

The encrypted layer  does NOT support certificate authentication,
so it is vulnerable to  certain attacks.  It can be used, though,
to send email to public email services like Gmail.

The core of this module is an interface function which interprets
the  current buffer  contents as  an email  message and  sends it
using the  \"sendmail-mbfl.sh\" GNU Bash  script distributed with
MBFL.

The function  `send-mail-with-mbfl' can be  invoked directly from
the    minibuffer,    or,    better,    used   as    value    for
`message-send-mail-function'.

MBFL is a library of functions for the GNU Bash shell.  It can be
downloaded from:

\thttp://gna.org/projects/mbfl

while development takes place at:

\thttp://github.com/marcomaggi/mbfl/tree/master

the home page is:

\thttp://marcomaggi.github.com/mbfl.html

the full  documentation of  the script, and  a discussion  of its
internals,  are available  in the  MBFL documentation  in Texinfo
format:

\thttp://marcomaggi.github.com/docs/mbfl.html"
  (interactive)
  (let* ((create-message-file
	  '(lambda ()
	     (message "sendmail-mbfl: creating temporary file...")
	     (make-temp-file "sendmail-mbfl")))

	 (acquire-from-address
	  '(lambda ()
	     (let ((FROM-ADDRESS (funcall sendmail-mbfl-envelope-from-function)))
	       (message "sendmail-mbfl: from address: %s" FROM-ADDRESS)
	       FROM-ADDRESS)))

	 (acquire-to-addresses
	  '(lambda ()
	     (let ((TO-ADDRESSES (funcall sendmail-mbfl-envelope-to-function)))
	       (dolist (address TO-ADDRESSES)
		 (message "sendmail-mbfl: to address: %s" address))
	       TO-ADDRESSES)))

	 (acquire-hostname
	  '(lambda ()
	     (let ((HOSTNAME (funcall sendmail-mbfl-hostname-function)))
	       (message "sendmail-mbfl: hostname: %s" HOSTNAME)
	       HOSTNAME)))

	 (acquire-username
	  '(lambda ()
	     (let ((USERNAME (funcall sendmail-mbfl-username-function)))
	       (message "sendmail-mbfl: username: %s" USERNAME)
	       USERNAME)))

	 (remove-bcc-header
	  '(lambda ()
	     (save-excursion
	       (save-restriction
		 (message-narrow-to-headers-or-head)
		 (message-remove-header "Bcc")))))

	 (write-message-buffer-to-message-file
	  '(lambda (TEMPFILE)
	     (write-region nil nil TEMPFILE)))

	 (log-command-line
	  '(lambda (buffer command-line)
	     (with-current-buffer buffer
	       (insert (mapconcat '(lambda (x) x) command-line "\t\\\n\t") "\n\n"))))

	 (launch-async-process
	  '(lambda (HOSTNAME USERNAME FROM-ADDRESS TO-ADDRESSES)
	     (let* ((process-connection-type sendmail-mbfl-process-connection-type)
		    (buffer (generate-new-buffer "*output from sendmail-mbfl*"))
		    (command-line (nconc (list sendmail-mbfl-program
					       (concat "--host-info=" sendmail-mbfl-host-info)
					       (concat "--auth-info=" sendmail-mbfl-auth-info)
					       (concat "--host=" HOSTNAME)
					       (concat "--username=" USERNAME)
					       (concat "--message=" message-tempfile)
					       (concat "--envelope-from=" FROM-ADDRESS))
					 (mapcar '(lambda (ADDRESS)
						    (concat "--envelope-to=" ADDRESS))
						 TO-ADDRESSES)
					 sendmail-mbfl-extra-args)))
	       (message "sendmail-mbfl: running script...")
	       (funcall log-command-line buffer command-line)
	       (apply #'start-process "sendmail-mbfl" buffer command-line))))

	 (receive-process-output
	  '(lambda (PROCESS)
	     (message "sendmail-mbfl: sending message")
	     (sit-for 0.1)
	     (accept-process-output PROCESS 0 100 t)
	     (while (and (processp PROCESS)
			 (eq (process-status PROCESS) 'run))
	       (accept-process-output PROCESS 0 100 t)
	       (sit-for 0.1))))

	 (cleanup-process
	  '(lambda (PROCESS)
	     (when (eq (process-status PROCESS) 'run)
	       (delete-process PROCESS))
	     (with-current-buffer (process-buffer PROCESS)
	       (setq buffer-read-only t)))))

    (let ((message-tempfile (funcall create-message-file)))
      (unwind-protect
	  (let* ((FROM-ADDRESS	(funcall acquire-from-address))
		 (TO-ADDRESSES	(funcall acquire-to-addresses))
		 (HOSTNAME	(funcall acquire-hostname))
		 (USERNAME	(funcall acquire-username)))
	    (funcall remove-bcc-header)
	    (funcall write-message-buffer-to-message-file message-tempfile)
	    (let* ((PROCESS (funcall launch-async-process
				     HOSTNAME USERNAME FROM-ADDRESS TO-ADDRESSES)))
	      (unwind-protect
		  (progn
		    (funcall receive-process-output PROCESS)
		    (if (and (= 0 (process-exit-status PROCESS))
			     (eq 'exit (process-status PROCESS)))
			(message "sendmail-mbfl: message delivered successfully")
		      (progn
			(message "sendmail-mbfl: message delivery error")
			(let ((buffer (process-buffer PROCESS)))
			  (set-buffer buffer)
			  (set-window-buffer (selected-window) buffer)))))
		(funcall cleanup-process PROCESS)))))
	(delete-file message-tempfile))))

(provide 'sendmail-mbfl)
;;; sendmail-mbfl.el ends here
