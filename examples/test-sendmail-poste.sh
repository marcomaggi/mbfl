# test-sendmail-poste.sh --
#
# For this SMTP server we want a line like the following in the hostinfo
# file:
#
#   machine relay.poste.it service smtp port 465 session tls auth login
#
# and a line like the following in the authinfo file:
#
#   machine relay.poste.it login marco.maggi-ipsu@poste.it password <the-password>
#

declare -r SCRIPT=examples/sendmail-mbfl.sh

declare -r COMMON_OPTIONS='--debug --verbose --test-message	\
   --host=relay.poste.it					\
   --envelope-from=marco.maggi-ipsu@poste.it			\
   --envelope-to=mrc.mgg@gmail.com				\
   --tls --timeout=15						\
   --username=marco.maggi'

# These will use "gnutls-cli".
if true
then
    # Use AUTH PLAIN.  Automatically select GNU TLS.
    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} --auth-plain
	echo
    fi

    # Use AUTH LOGIN.  Explicitly select GNU TLS.
    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} --auth-login --gnutls
	echo
    fi
fi

# These will use "openssl".
if true
then
    FURTHER_OPTIONS='--openssl'

    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-plain
	echo
    fi

    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-login
	echo
    fi
fi

### end of file
