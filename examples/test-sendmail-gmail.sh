# test-sendmail-gmail.sh --
#

# These will use gnutls.
false && {
    true && bash sendmail-mbfl.sh \
        --debug --verbose --test-message                        \
        --delayed-starttls                                      \
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-plain

    true && bash sendmail-mbfl.sh \
        --debug --verbose --test-message                        \
        --gnutls --delayed-starttls                             \
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-login
}

true && {
    false && bash sendmail-mbfl.sh \
        --debug --verbose --test-message                        \
        --openssl --delayed-starttls                            \
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-plain

    true && bash sendmail-mbfl.sh \
        --debug --verbose --test-message                        \
        --openssl --delayed-starttls                            \
        --host=smtp.gmail.com --port=587                        \
        --envelope-from=mrc.mgg@gmail.com                       \
        --envelope-to=marco.maggi-ipsu@poste.it                 \
        --username=mrc.mgg --auth-login
}

### end of file
