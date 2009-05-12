# test-sendmail-poste.sh --
#

bash sendmail-mbfl.sh \
    --debug --verbose --test-message                            \
    --hostname=relay.poste.it --port=465                        \
    --from=marco.maggi-ipsu@poste.it --to=mrc.mgg@gmail.com     \
    --starttls --username=marco.maggi --auth-login

### end of file
