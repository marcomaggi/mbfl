# test-mbfl-mail.sh --
#

#set -x

BODY='From: marco@localhost
To: root@localhost
Subject: ciao

Ciao
'

echo "$BODY" | \
    ./mbfl-smtp-gmail.sh                \
    --from='mrc.mgg@gmail.com'          \
    --to='marco.maggi-ipsu@poste.it'    \
    --verbose --debug

### end of file
