# test-sendmail-poste.sh --
#

declare -r SCRIPT=examples/sendmail-mbfl.sh

# These will use gnutls-cli.
true && {
    true && bash "$SCRIPT" \
        --debug --verbose --test-message                \
        --host=relay.poste.it --port=465                \
        --envelope-from=marco.maggi-ipsu@poste.it       \
        --envelope-to=mrc.mgg@gmail.com                 \
        --tls --username=marco.maggi --auth-plain

    true && bash "$SCRIPT" \
        --debug --verbose --test-message                \
        --gnutls                                        \
        --host=relay.poste.it --port=465                \
        --envelope-from=marco.maggi-ipsu@poste.it       \
        --envelope-to=mrc.mgg@gmail.com                 \
        --tls --username=marco.maggi --auth-login
}

# These will use openssl.
true && {
    true && bash "$SCRIPT" \
        --debug --verbose --test-message                \
        --openssl                                       \
        --host=relay.poste.it --port=465                \
        --envelope-from=marco.maggi-ipsu@poste.it       \
        --envelope-to=mrc.mgg@gmail.com                 \
        --tls --username=marco.maggi --auth-plain

    true && bash "$SCRIPT" \
        --debug --verbose --test-message                \
        --openssl                                       \
        --host=relay.poste.it --port=465                \
        --envelope-from=marco.maggi-ipsu@poste.it       \
        --envelope-to=mrc.mgg@gmail.com                 \
        --tls --username=marco.maggi --auth-login
}

### end of file
