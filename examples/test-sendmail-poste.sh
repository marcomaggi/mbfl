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
   --tls							\
   --username=marco.maggi'

# These will use "gnutls-cli".
if true
then
    # Use AUTH PLAIN.  Automatically select GNU TLS.
    if false
    then bash "$SCRIPT" ${COMMON_OPTIONS} --auth-plain
    fi

    # Use AUTH LOGIN.  Explicitly select GNU TLS.
    if true
    then bash "$SCRIPT" ${COMMON_OPTIONS} --auth-login --gnutls
    fi
fi

# These will use "openssl".
if false
then
    FURTHER_OPTIONS='--openssl'

    if true
    then bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-plain
    fi

    if true
    then bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --auth-login
    fi
fi

### end of file
