# test-mbfl-smtp-posteit.sh --
#

#set -x

BODY='From: marco.maggi-ipsu@poste.it
To: mrc.mgg@gmail.com
Subject: ciao

Ciao
'

echo "$BODY" | \
    ./mbfl-smtp-posteit.sh              \
    --auth-user='marco.maggi-ipsu'      \
    --from='marco.maggi-ipsu@poste.it'  \
    --to='mrc.mgg@gmail.com'            \
    --verbose --debug

### end of file
