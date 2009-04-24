# test-mbfl-smtp-gmail.sh
#

#set -x

BODY='From: mrc.mgg@gmail.com
To: marco.maggi-ipsu@poste.it
Subject: ciao

Ciao
'

echo "$BODY" | \
    ./mbfl-smtp-gmail.sh                \
    --auth-user='mrc.mgg@gmail.com'     \
    --from='mrc.mgg@gmail.com'          \
    --to='marco.maggi-ipsu@poste.it'    \
    --verbose --debug

### end of file
