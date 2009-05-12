# test-sendmail-localhost.sh --
#

PROGNAME=test-sendmail-localhost.sh
FROM_ADDRESS=marco@localhost
TO_ADDRESS=root@localhost

function print_message () {
    local LOCAL_HOSTNAME DATE MESSAGE_ID MESSAGE
    LOCAL_HOSTNAME=$(hostname --fqdn)                   || exit 2
    DATE=$(date --rfc-2822)                             || exit 2
    MESSAGE_ID=$(printf '%d-%d-%d@%s' $RANDOM $RANDOM $RANDOM "$LOCAL_HOSTNAME")
    MESSAGE="Sender: $FROM_ADDRESS
From: $FROM_ADDRESS
To: $TO_ADDRESS
Subject: proof from $PROGNAME
Message-ID: <$MESSAGE_ID>
Date: $DATE

This is a text proof from the $PROGNAME script.
--\x20
Marco
"
    printf "$MESSAGE"
}

true && bash sendmail-mbfl.sh                   \
    --debug --verbose --test-message            \
    --hostname=localhost --port=25              \
    --from=$FROM_ADDRESS --to=$TO_ADDRESS

true && print_message | bash sendmail-mbfl.sh   \
    --debug --verbose --message=-               \
    --hostname=localhost --port=25              \
    --from=$FROM_ADDRESS --to=$TO_ADDRESS

true && {
    : ${TMPDIR:=/tmp}
    PATHNAME=${TMPDIR}/message.$RANDOM.$$
    print_message >$PATHNAME
    trap "rm -f '$PATHNAME'" EXIT
    bash sendmail-mbfl.sh   \
        --debug --verbose --message=$PATHNAME   \
        --hostname=localhost --port=25          \
        --from=$FROM_ADDRESS --to=$TO_ADDRESS
}

### end of file
