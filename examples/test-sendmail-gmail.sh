# test-sendmail-gmail.sh --
#

bash sendmail-mbfl.sh \
    --debug --verbose --test-message                            \
    --hostname=relay.poste.it --port=465                        \
    --from=mrc.mgg@gmail.com --to=marco.maggi-ipsu@poste.it     \
    --username=marco.maggi --auth-login

### end of file
