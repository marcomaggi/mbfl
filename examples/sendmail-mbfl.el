;;; sendmail-mbfl.el --- send mail with sendmail-mbfl.sh

;; Copyright (C) 2009  Marco Maggi
;; Copyright (C) 1999,  2000, 2001, 2002, 2003, 2004,  2005, 2006, 2007,
;; 2008 Free Software Foundation, Inc.

;; Author: Marco Maggi <mrc.mgg@gmail.com>
;; Keywords: mail

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

;; This module implements a method  of sending email messages to an SMTP
;; server using an external program.   It supports plain SMTP session as
;; well as sessions encrypted with the SSL/TLS protocol.
;;
;; To handle the encrypted bridge  it can use both the "openssl" program
;; distributed  with OpenSSL  and the  "gnutls-cli"  program distributed
;; with GNU TLS.
;;
;; The encrypted session does not support certificate authentication, so
;; it  is vulnerable  to  man-in-the-middle attacks.   It  can be  used,
;; though, to send email to public email services like Gmail.
;;
;; The core of this module is an interface function which interprets the
;; current buffer  contents as an email  message and sends  it using the
;; "sendmail-mbfl.sh" GNU Bash script distributed with MBFL.
;;
;; The function can be invoked  directly from the minibuffer, or used as
;; value for `message-send-mail-function'.
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
;; The  full  documentation of  the  script,  and  a discussion  of  its
;; internals, are available in the MBFL documentation in Texinfo format:
;;
;;	http://marcomaggi.github.com/docs/mbfl.html

;; This library is modeled after  some bits of the library "starttls.el"
;; by    Daiki   Ueno    <ueno@unixuser.org>    and   Simon    Josefsson
;; <simon@josefsson.org>, which comes with GNU Emacs 22.3.

;;; Code:

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
  "Function  to  call to  acquire  from  the  current buffer  the
envelope email  address of the sender,  to be used  in the \"MAIL
FROM\" SMTP command.

It must  return a single  string representing the  email address.
If no suitable address is found: it must raise an error.

This function is used by `send-mail-with-mbfl'."
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-envelope-to-function 'sendmail-mbfl-envelope-to
  "Function  to  call to  acquire  from  the  current buffer  the
envelope  email addresses  of the  receivers, to  be used  in the
\"RCPT TO\" SMTP command.

It must return a list of strings representing email addresses. If
no suitable address is found: it must raise an error.

This function is used by `send-mail-with-mbfl'."
  :group 'sendmail-mbfl)

(defcustom sendmail-mbfl-extract-addresses-function 'sendmail-mbfl-extract-addresses
  "Function to call to extract a list of email addresses from the
current buffer.   It is invoked  with the buffer narrowed  to the
header to examine.   It must return a list  of email addresses or
nil."
  :group 'sendmail-mbfl)

(defun sendmail-mbfl-envelope-from ()
  "Interpret the  current buffer as  an email message  and search
the contents for an email address to be used as envelope sender.

Return  a single string  representing the  email address.   If no
suitable address is found: an error is raised.

This  function assumes  that  the function  `message-field-value'
from `message.el' can extract header values from the buffer."
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
receivers.

Return  a list of  strings representing  email addresses.   If no
suitable address is found: an error is raised.

This  function assumes  that  the function  `message-field-value'
from `message.el' can extract header values from the buffer."
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
  "Move to the specified header  and use the selected function to
extract  email addresses  from  the field.   Return  the list  of
addresses or nil.

Addresses    are    extracted    through    the    function    in
`sendmail-mbfl-extract-addresses-function'."
  (save-excursion
    (save-restriction
      (message-position-on-field HEADER)
      (message-narrow-to-field)
      (funcall sendmail-mbfl-extract-addresses-function))))

(defun sendmail-mbfl-extract-addresses ()
  "Extract a list of email addresses from the current buffer.  It
must  be  invoked with  the  buffer  narrowed  to the  header  to
examine.  It must return a list of email addresses or nil."
;;;  (message "looking for addresses")
  (let ((addresses nil)
	(rex (concat "[[:space:]]*<?[[:space:]]*"
		     "\\([^[:space:]]+@[^[:space:]>,]+\\)"
		     "[[:space:]]*>?"
		     "[[:space:]]*,?"
		     "\\([[:space:]]*\\|$\\)")))
    (while (re-search-forward rex (point-max) t)
      (setq addresses (cons (match-string 1) addresses)))
    addresses))

(defun send-mail-with-mbfl ()
  "Send an  email messages  to an SMTP  server using  an external
program.   It supports  plain SMTP  session as  well  as sessions
encrypted with the SSL/TLS protocol.

To handle  the encrypted bridge  it can use both  the \"openssl\"
program distributed  with OpenSSL and  the \"gnutls-cli\" program
distributed with GNU TLS.

The    encrypted   session    does   not    support   certificate
authentication, so it is vulnerable to man-in-the-middle attacks.
It can  be used, though, to  send email to  public email services
like Gmail.

The core of this module is an interface function which interprets
the  current buffer  contents as  an email  message and  sends it
using the  \"sendmail-mbfl.sh\" GNU Bash  script distributed with
MBFL.

The function can be invoked directly from the minibuffer, or used
as value for `message-send-mail-function'.

MBFL is a library of functions for the GNU Bash shell.  It can be
downloaded from:

\thttp://gna.org/projects/mbfl

while development takes place at:

\thttp://github.com/marcomaggi/mbfl/tree/master

The full  documentation of  the script, and  a discussion  of its
internals,  are available  in the  MBFL documentation  in Texinfo
format:

\thttp://marcomaggi.github.com/docs/mbfl.html
"
  (interactive)
  (let ((message-tempfile (progn
			    (message "sendmail-mbfl: creting temporary file...")
			    (make-temp-file "sendmail-mbfl"))))
    (unwind-protect
	(let* ((FROM-ADDRESS (funcall sendmail-mbfl-envelope-from-function))
	       (TO-ADDRESS (funcall sendmail-mbfl-envelope-to-function)))
	  (message "sendmail-mbfl: from address: %s" FROM-ADDRESS)
	  (dolist (address TO-ADDRESS)
	    (message "sendmail-mbfl: to address: %s" address))
	  ;; remove the bcc header
	  (save-excursion
	    (save-restriction
	      (message-narrow-to-headers-or-head)
	      (message-remove-header "Bcc")))
	  ;; write the buffer to the file
	  (write-region nil nil message-tempfile)
	  (let* ((process-connection-type starttls-process-connection-type)
		 (process-buffer (generate-new-buffer "*output from sendmail-mbfl*"))
		 (args (nconc (list (concat "--message=" message-tempfile)
				    (concat "--envelope-from=" FROM-ADDRESS))
			      (mapcar '(lambda (ADDRESS)
					 (concat "--envelope-to=" ADDRESS))
				      TO-ADDRESS)
			      sendmail-mbfl-extra-args))
		 (process (progn
			    (message "sendmail-mbfl: running script...")
			    (with-current-buffer process-buffer
			      (insert sendmail-mbfl-program " "
				      (mapconcat '(lambda (x) x) args " ")
				      "\n"))
			    (apply #'start-process "sendmail-mbfl"
				   process-buffer sendmail-mbfl-program args))))
	    (unwind-protect
		(progn
		  (message "sendmail-mbfl: message sent")
		  (sit-for 0.1)
		  (accept-process-output process 0 100 t)
		  (while (and (processp process)
			      (eq (process-status process) 'run))
		    (accept-process-output process 0 100 t)
		    (sit-for 0.1)))
	      (delete-process process)
	      (with-current-buffer process-buffer
		(setq buffer-read-only t)))))
      (delete-file message-tempfile))))

(provide 'sendmail-mbfl)
;;; sendmail-mbfl.el ends here
