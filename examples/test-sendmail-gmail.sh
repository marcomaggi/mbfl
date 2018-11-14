# test-sendmail-gmail.sh --
#

declare -r SCRIPT=examples/sendmail-mbfl.sh

# These will use gnutls.
true && {
    true && bash "$SCRIPT" \
        --debug --verbose --test-message                        \
        --starttls						\
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-plain

    true && bash "$SCRIPT" \
        --debug --verbose --test-message                        \
        --gnutls --starttls					\
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-login
}

true && {
    true && bash "$SCRIPT" \
        --debug --verbose --test-message                        \
        --openssl --starttls					\
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-plain

    true && bash "$SCRIPT" \
        --debug --verbose --test-message                        \
        --openssl --starttls					\
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-login
}

### end of file
