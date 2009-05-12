# test-sendmail-gmail.sh --
#

bash sendmail-mbfl.sh \
    --debug --verbose --test-message                            \
    --hostname=smtp.gmail.com --port=587                        \
    --from=mrc.mgg@gmail.com --to=marco.maggi-ipsu@poste.it     \
    --delayed-starttls --username=mrc.mgg --auth-login

### end of file
