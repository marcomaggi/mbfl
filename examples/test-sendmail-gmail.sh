# test-sendmail-gmail.sh --
#
# For this SMTP server we want a line like the following in the hostinfo
# file:
#
#   machine smtp.gmail.com service smtp port 587 session starttls auth plain
#
# and a line like the following in the authinfo file:
#
#   machine smtp.gmail.com login mrc.mgg@gmail.com password <the-password>
#

declare -r SCRIPT=examples/sendmail-mbfl.sh

declare -r COMMON_OPTIONS='--verbose --debug --test-message	\
   --host=smtp.gmail.com					\
   --envelope-from=mrc.mgg@gmail.com				\
   --envelope-to=marco.maggi-ipsu@poste.it			\
   --username=mrc.mgg						\
   --starttls'

declare FURTHER_OPTIONS

# These will use: GNU TLS.
if true
then
    FURTHER_OPTIONS=

    # Defaults to "gnutls-cli".  Uses AUTH PLAIN.
    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-plain
	echo
    fi

    # Explicitly selects "gnutls-cli".  Uses AUTH LOGIN.
    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-login --gnutls
	echo
    fi
fi

# These will use OpenSSL.
if true
then
    declare FURTHER_OPTIONS='--openssl'

    if true
    then
	# Uses AUTH PLAIN.
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-plain
	echo
    fi

    if true
    then
	# Uses AUTH LOGIN.
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-login
	echo
    fi
fi

### end of file
