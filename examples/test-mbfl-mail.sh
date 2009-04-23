# test-mbfl-mail.sh --
#

BODY='From: marco@localhost
To: root@localhost
Subject: ciao

Ciao
'
FILE=$(tempfile)
trap "rm '$FILE'" EXIT

echo "$BODY" | \
    bash mbfl-mail.sh --from=marco@localhost --to=root@localhost --verbose --debug


echo "$BODY" >"$FILE"
bash mbfl-mail.sh \
    --from=marco@localhost --to=root@localhost --body="$FILE" \
    --verbose --debug

### end of file
