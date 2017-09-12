;;; sendmail-mbfl.el --- send mail with sendmail-mbfl.sh

;; Copyright (C) 2009, 2013, 2015  Marco Maggi <marco.maggi-ipsu@poste.it>
;; Copyright (C) 1995,  1996, 1999, 2000, 2001, 2002,  2003, 2004, 2005,
;; 2006, 2007, 2008 Free Software Foundation, Inc.

;; Author: Marco Maggi <marco.maggi-ipsu@poste.it>
;; Keywords: mail

;; Bits  of   this  library  are   from  "starttls.el"  by   Daiki  Ueno
;; <ueno@unixuser.org> and  Simon Josefsson <simon@josefsson.org>, which
;; comes with GNU Emacs 22.3.

;; Bits  of  this library  are  from  "smtpmail.el"  by Tomoji  Kagatani
;; <kagatani@rbc.ncl.omron.co.jp>   maintained    by   Simon   Josefsson
;; <simon@josefsson.org> with hacking from various people.

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
(require 'sendmail)


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
  "*Value for `process-connection-type' to use when starting sendmail-mbfl process."
  :version "22.3"
  :type 'boolean
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-envelope-from-function 'sendmail-mbfl-envelope-from
  "Select a function to find the sender of an email message.

Select a  function to call  to acquire, from the  current buffer,
the  envelope email  address of  the sender,  to be  used in  the
\"MAIL FROM\" SMTP command.

The function  is invoked with no  arguments and it  must return a
single  string representing  the email  address.  If  no suitable
address is found: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-envelope-from'."
  :version "22.3"
  :type 'function
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-envelope-to-function 'sendmail-mbfl-envelope-to
  "Select a function to find the receiver of an email message.

Select a  function to call  to acquire, from the  current buffer,
the envelope email addresses of the  receivers, to be used in the
\"RCPT TO\" SMTP command.

The function  is invoked with no  arguments and it  must return a
list  of strings  representing email  addresses.  If  no suitable
address is found: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-envelope-to'."
  :version "22.3"
  :type 'function
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-extract-addresses-function 'sendmail-mbfl-extract-addresses
  "Select a function to extract email addresses.

Select a  function to call to  extract a list of  email addresses
from an email header.  It is  invoked with the buffer narrowed to
the header  to examine, with  no arguments  and it must  return a
list of strings representing email addresses, or nil.

The  selected function  is used  by `sendmail-mbfl-envelope-from'
and `sendmail-mbfl-envelope-to'."
  :version "22.3"
  :type 'function
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-hostname-function 'sendmail-mbfl-hostname
  "Select a function to extract the hostname from a hostinfo file.

Select a  function to call  to extract  the hostname of  the SMTP
server to used.  The result is used as search key in the selected
hostinfo file.

The function  is invoked with no  arguments and it  must return a
string representing  the hostname; if  it is unable  to determine
the hostname: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-hostname'."
  :version "22.3"
  :type 'function
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-username-function 'sendmail-mbfl-username
  "Select a function to extract the username from an authinfo file.

Select  a function  to call  to extract  the username  with which
login to  the SMTP server.  The  result is used as  search key in
the selected authinfo file.

The function  is invoked with no  arguments and it  must return a
string representing  the username; if  it is unable  to determine
the username: it must raise an error.

The  selected  function  is  used by  `send-mail-with-mbfl'.   By
default it is set to `sendmail-mbfl-username'."
  :version "22.3"
  :type 'function
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-host-info (expand-file-name "~/.mbfl-hostinfo")
  "The pathname of the file holding informations about known SMTP servers."
  :version "22.3"
  :type 'string
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-auth-info (expand-file-name "~/.mbfl-authinfo")
  "The pathname of the file holding informations about known accounts at SMTP servers."
  :version "22.3"
  :type 'string
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-connector "openssl"
  "Select the external program used to establish a TLS transport layer.

Select the external program to use to establish the TLS transport
layer.  Valid  values are  the strings:  \"gnutls\", \"openssl\".
The default is \"openssl\"."
  :version "22.3"
  :type 'string
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-timeout 5
  "Select the timeout in seconds for reading answers from the SMTP server. The default is 5."
  :version "22.3"
  :type 'integer
  :group 'sendmail-mbfl)


(defmacro compensation (vars &rest BODY)
  ;; Example:
  ;;
  ;;  (compensation ((buf (generate-new-buffer "*this*")
  ;;			  (kill-buffer buf)))
  ;;     (with-current-buffer buf
  ;;       ...))
  ;;
  (let ((NAME		(caar vars))
	(ACQUIRE	(car (cdar vars)))
	(RELEASE	(cadr (cdar vars))))
    `(let ((,NAME ,ACQUIRE))
       (unwind-protect
	   (progn ,@BODY)
	 ,RELEASE))))


(defun sendmail-mbfl-envelope-from ()
  "Extract the sender address.

Interpret the current  buffer as an email message  and search the
contents for an email address to  be used as envelope sender.  It
examines the headers \"From\" and \"Sender\", in this order.

Return a  single string  representing the  email address.   If no
suitable address is found: an error is raised."
  (let ((addresses (cond
		    ((message-field-value "From")
		     (sendmail-mbfl-extract-address-trampoline "From"))
		    ((message-field-value "Sender")
		     (sendmail-mbfl-extract-address-trampoline "Sender"))
		    (t
		     (error "Unable to find a sender address")))))
    (if (null addresses)
	(error "Unable to find a sender address")
      (car addresses))))

(defun sendmail-mbfl-envelope-from/message ()
  (interactive)
  (message "Envelope sender address: %s" (sendmail-mbfl-envelope-from)))

(defun sendmail-mbfl-envelope-to ()
  "Find an email receiver in the current buffer.

Interpret the current  buffer as an email message  and search the
contents for  email addresses to  be used as  envelope receivers.
It examines the headers \"To\", \"Cc\" and \"Bcc\".

Return a  list of  strings representing  email addresses.   If no
suitable address is found: an error is raised."
  (let* ((receivers (apply 'nconc
			   (mapcar (function (lambda (HEADER)
					       (when (message-field-value HEADER)
						 (sendmail-mbfl-extract-address-trampoline HEADER))))
				   '("To" "Cc" "Bcc")))))
    (if (null receivers)
	(error "unable to find receivers addresses")
      receivers)))

(defun sendmail-mbfl-envelope-to/message ()
  (interactive)
  (message "Envelope receiver address: %s" (sendmail-mbfl-envelope-to)))

(defun sendmail-mbfl-extract-address-trampoline (HEADER)
  "Move to the specified HEADER and extract email addresses from the field.

Move to the specified HEADER and extract email addresses from the
field.  Return  the list  of addresses  as strings  or nil  if no
addresses are found.

Addresses  are  extracted  using  the function  selected  by  the
customisable variable `sendmail-mbfl-extract-addresses-function'."
  (save-excursion
    (save-restriction
      (message-position-on-field HEADER)
      (message-narrow-to-field)
      (funcall sendmail-mbfl-extract-addresses-function))))

(defun sendmail-mbfl-extract-addresses ()
  "Extract a list of email addresses from the current buffer.

Extract a  list of email  addresses from the current  buffer.  It
must  be  invoked with  the  buffer  narrowed  to the  header  to
examine.  Return a list of email  addresses as strings, or nil if
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
  "Extract the hostname of the SMTP server to be used to send the message.

Extract, from the current buffer, the hostname of the SMTP server
to be used to send the message.  The result is used as search key
in the selected hostinfo file.

Return a  string representing  the hostname; if  it is  unable to
determine the hostname: raise an error."
  (let* ((address	(sendmail-mbfl-envelope-from))
	 (ell		(split-string address "@" t)))
    (if (= 2 (length ell))
	(cadr ell)
      (error "unable to extract hostname from address: %s" address))))

(defun sendmail-mbfl-hostname/message ()
  (interactive)
  (message "Hostname: %s" (sendmail-mbfl-hostname)))

(defun sendmail-mbfl-username ()
  "Extract the username with which to login to the SMTP server.

Extract,  from the  current buffer,  the username  with which  to
login to  the SMTP server.  The  result is used as  search key in
the selected authinfo file.

Return a  string representing  the username; if  it is  unable to
determine the username: raise an error."
  (let* ((address	(sendmail-mbfl-envelope-from))
	 (ell		(split-string address "@" t)))
    (if (= 2 (length ell))
	(car ell)
      (error "unable to extract username from address: %s" address))))

(defun sendmail-mbfl-username/message ()
  (interactive)
  (message "Username: %s" (sendmail-mbfl-username)))


(defun sendmail-mbfl-normalise-message ()
  "Normalise the email message in the current buffer.

Normalise the email  message in the current buffer so  that it is
ready to  be posted or  delivered.  Scan the headers  for invalid
lines  and try  to  fix  them.  Scan  the  message for  mandatory
headers and, if missing, add  them; this may require querying the
user for informations.

It is to be called BEFORE acquiring sender and receiver addresses
from  the headers.   It is  an  interactive function:  it can  be
explicitly applied to a buffer by the user any number of times.

This function does NOT remove the headers/body separator.

Large  pieces of  this  function are  from `smtpmail-send-it'  in
`smtpmail.el'."
  (interactive)
  (message "sendmail-mbfl: normalising message...")
  (save-excursion
    ;; Move point to the headers delimiter.
    (rfc822-goto-eoh)
    (let ((delimline (point-marker)))
      ;; Require one newline at the end of the message.
      (goto-char (point-max))
      (or (= ?\n (preceding-char)) (insert ?\n))
      ;; Expand mail aliases.
      (if mail-aliases
	  (expand-mail-aliases (point-min) delimline))
      ;; Remove blank lines from the headers.
      (goto-char (point-min))
      (while (and (re-search-forward "\n\n\n*" delimline t)
		  (< (point) delimline))
	(replace-match "\n"))
      ;; Insert an extra newline if we  need it to work around Sun's bug
      ;; that swallows newlines.
      (goto-char (1+ delimline))
      (when (eval mail-mailer-swallows-blank-line)
	(newline))
      ;; Don't send out a blank subject line.
      (dolist (HEADER '("From" "To" "Subject"))
	(goto-char (point-min))
	(when (or (re-search-forward (concat "^" HEADER ":\\([ \t]*\n\\)+\\b") delimline t)
		  ;; This one matches just before the header delimiter.
		  (and (re-search-forward (concat "^" HEADER ":\\([ \t]*\n\\)+" HEADER) delimline t)
		       (= (match-end 0) delimline)))
	  (error "sendmail-mbfl: error empty \"%s\" header" HEADER)))
      ;; Insert a `Message-Id:' field if there isn't one yet.
      (goto-char (point-min))
      (unless (re-search-forward "^Message-I[dD]:" delimline t)
	(insert "Message-ID: " (message-make-message-id) "\n"))
      ;; Insert a `Date:' field if there isn't one yet.
      (goto-char (point-min))
      (unless (re-search-forward "^Date:" delimline t)
	(insert "Date: " (message-make-date) "\n"))
      ;; Possibly add a MIME header for the current coding system
      (let (charset)
	(goto-char (point-min))
	(and (eq mail-send-nonascii 'mime)
	     (not (re-search-forward "^MIME-version:" delimline t))
	     (progn (skip-chars-forward "\0-\177")
		    (/= (point) (point-max)))
	     smtpmail-code-conv-from
	     (setq charset
		   (coding-system-get smtpmail-code-conv-from
				      'mime-charset))
	     (goto-char delimline)
	     (insert "MIME-version: 1.0\n"
		     "Content-type: text/plain; charset="
		     (symbol-name charset)
		     "\nContent-Transfer-Encoding: 8bit\n")))
      ))
  (message "sendmail-mbfl: completed message normalisation."))

(defun sendmail-mbfl-prepare-message-for-mta ()
  "Prepare the email message in the current buffer to be sent to an MTA.

Prepare the email message in the  current buffer to be sent to an
MTA.  Headers like \"Fcc\" and \"Bcc\"  are removed.  It is to be
called  AFTER acquiring  sender and  receiver addresses  from the
headers."
  (message "sendmail-mbfl: preparing message...")
  (save-excursion
    (save-restriction
      (message-narrow-to-headers-or-head)
      (message-remove-header "Bcc")
      (message-remove-header "Fcc"))
    (mail-sendmail-undelimit-header)))


(defun sendmail-mbfl-delivery ()
  "Perform special delivery of the email message in the current buffer.

Perform  special delivery  of the  email message  in the  current
buffer.   If  the  message  has an  \"Fcc\"  header,  deliver  is
performed relying on `mail-do-fcc' from `sendmail.el'.

It is to be  called after `sendmail-mbfl-normalise-message' or an
equivalent normalisation has been applied to the message."
  (interactive)
  (message "sendmail-mbfl: performing special deliveries...")
  ;; Move point to the headers delimiter.
  (save-excursion
    (rfc822-goto-eoh)
    (let ((delimline (point-marker)))
      ;; Find and handle any FCC fields.
      (goto-char (point-min))
      (when (re-search-forward "^FCC:" delimline t)
	(compensation ((buffer (generate-new-buffer "*sendmail-mbfl special delivery message*")
			       (kill-buffer buffer)))
	  (sendmail-mbfl-copy-message-buffer buffer (current-buffer))
	  (with-current-buffer buffer
	    (let ((coding-system-for-write (select-message-coding-system)))
	      (mail-do-fcc delimline)))))))
  (message "sendmail-mbfl: special deliveries completed."))


(defun sendmail-mbfl-post ()
  "Post the email message in the current buffer using an MTA.

Posting involves:

1. Preparing the message with `sendmail-mbfl-prepare-message-for-mta'.

2. Saving the message into a temporary file.

3. Sending the file using the script selected with the customisable
   variable `sendmail-mbfl-program'.

It is to be  called after `sendmail-mbfl-normalise-message' or an
equivalent normalisation has been applied to the message."
  (interactive)
  (let* ((main
	  '(lambda ()
	     (let ((mail-buffer (current-buffer)))
	       (compensation ((message-buffer (generate-new-buffer "*sendmail-mbfl temporary message*")
					      (kill-buffer message-buffer)))
		 (with-current-buffer message-buffer
		   (sendmail-mbfl-copy-message-buffer message-buffer mail-buffer)
		   (let* ((FROM-ADDRESS	(funcall acquire-from-address))
			  (TO-ADDRESSES	(funcall acquire-to-addresses))
			  (HOSTNAME	(funcall acquire-hostname))
			  (USERNAME	(funcall acquire-username)))
		     (sendmail-mbfl-prepare-message-for-mta)
		     (compensation ((message-tempfile (funcall create-message-file)
						      (delete-file message-tempfile)))
		       (funcall write-message-buffer-to-message-file message-tempfile)
		       (compensation ((PROCESS (funcall launch-async-process message-tempfile
							HOSTNAME USERNAME FROM-ADDRESS TO-ADDRESSES)
					       (funcall cleanup-process PROCESS)))
			 (funcall show-process-buffer PROCESS)
			 (funcall receive-process-output PROCESS)
			 (if (and (= 0 (process-exit-status PROCESS))
				  (eq 'exit (process-status PROCESS)))
			     (progn
			       (message "sendmail-mbfl: message delivered successfully")
			       (funcall bury-process-buffer PROCESS))
			   (message "sendmail-mbfl: message delivery error"))))))))))

	 (create-message-file
	  '(lambda ()
	     (message "sendmail-mbfl: creating temporary file...")
	     (make-temp-file "sendmail-mbfl")))

	 (write-message-buffer-to-message-file
	  '(lambda (TEMPFILE)
	     (let ((coding-system-for-write (select-message-coding-system)))
	       (write-region nil nil TEMPFILE))))

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

	 (log-command-line
	  '(lambda (buffer command-line)
	     (with-current-buffer buffer
	       (insert (mapconcat '(lambda (x) x) command-line "\t\\\n\t") "\n\n"))))

	 (launch-async-process
	  '(lambda (MESSAGE-FILE HOSTNAME USERNAME FROM-ADDRESS TO-ADDRESSES)
	     (let* ((process-connection-type sendmail-mbfl-process-connection-type)
		    (buffer (generate-new-buffer "*Output from sendmail-mbfl*"))
		    (command-line (nconc (list sendmail-mbfl-program
					       (concat "--host-info=" sendmail-mbfl-host-info)
					       (concat "--auth-info=" sendmail-mbfl-auth-info)
					       (concat "--host=" HOSTNAME)
					       (concat "--username=" USERNAME)
					       (concat "--timeout="
						       (number-to-string sendmail-mbfl-timeout))
					       (cond
						((string-equal "gnutls" sendmail-mbfl-connector)
						 "--gnutls")
						((string-equal "openssl" sendmail-mbfl-connector)
						 "--openssl")
						(t
						 (error "unknown TLS connector program: %s"
							sendmail-mbfl-connector)))
					       (concat "--message=" MESSAGE-FILE)
					       (concat "--envelope-from=" FROM-ADDRESS))
					 (mapcar '(lambda (ADDRESS)
						    (concat "--envelope-to=" ADDRESS))
						 TO-ADDRESSES)
					 sendmail-mbfl-extra-args)))
	       (message "sendmail-mbfl: running script...")
	       (funcall log-command-line buffer command-line)
;;;(set-window-buffer (selected-window) buffer)
	       (apply #'start-process "sendmail-mbfl" buffer command-line))))

	 (show-process-buffer
	  '(lambda (PROCESS)
	     (let ((buffer (process-buffer PROCESS)))
	       (set-buffer buffer)
	       (set-window-buffer (selected-window) buffer)
	       (sit-for 0.1))))

	 (bury-process-buffer
	  '(lambda (PROCESS)
	     (let* ((buffer (process-buffer PROCESS))
		    (other  (other-buffer buffer)))
	       (bury-buffer buffer)
	       (set-window-buffer (selected-window) other)
	       (sit-for 0.1))))

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

    (funcall main)))


(defun sendmail-mbfl-copy-message-buffer (DST-BUFFER SRC-BUFFER)
  "Copy an email message from SRC-BUFFER to DST-BUFFER.

Set   encoding  and   text  representation   properties   of  the
destination buffer to be equal to the ones of the source buffer."
  (with-current-buffer DST-BUFFER
    (erase-buffer)
    (setq coding-system-for-write (with-current-buffer SRC-BUFFER
				    buffer-file-coding-system))
    (set-buffer-multibyte (with-current-buffer SRC-BUFFER
			    enable-multibyte-characters))
    (insert-buffer-substring SRC-BUFFER)))


(defun send-mail-with-mbfl ()
  "Implement a method of sending email messages to a SMTP/ESMTP server using an external program.

It supports plain SMTP session as well as sessions encrypted with
the SSL/TLS protocol.

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
  (sendmail-mbfl-normalise-message)
  (sendmail-mbfl-delivery)
  (sendmail-mbfl-post))

(defun sendmail-mbfl-activate ()
  "Set  `message-send-mail-function' so  that  `message.el' sends
mail using `send-mail-with-mbfl'."
  (interactive)
  (setq message-send-mail-function 'send-mail-with-mbfl))

(provide 'sendmail-mbfl)
;;; sendmail-mbfl.el ends here
