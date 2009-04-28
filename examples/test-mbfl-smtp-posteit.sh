# test-mbfl-smtp-posteit.sh --
#

#set -x

BODY="X-Mio: marco\r
Sender: <marco.maggi-ipsu@poste.it>\r
From: <marco.maggi-ipsu@poste.it>\r
To: <mrc.mgg@gmail.com>\r
Subject: ciao\r
Date: $(date --rfc-2822)\r
Message-ID: ${RANDOM}-${RANDOM}-${RANDOM}@$(hostname)\r
\r
Ciao\r
"

echo "$BODY" | \
    ./mbfl-smtp-posteit.sh            \
    --auth-user=marco.maggi-ipsu      \
    --from=marco.maggi-ipsu@poste.it  \
    --to=mrc.mgg@gmail.com            \
    --verbose --debug

### end of file
