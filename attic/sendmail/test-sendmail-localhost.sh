# test-sendmail-localhost.sh --
#

PROGNAME=test-sendmail-localhost.sh
FROM_ADDRESS=marco@localhost
TO_ADDRESS=root@localhost
declare -r SCRIPT=examples/sendmail-mbfl.sh

function print_message () {
    local LOCAL_HOSTNAME DATE MESSAGE_ID MESSAGE
    LOCAL_HOSTNAME=$(hostname --fqdn)                   || exit 2
    DATE=$(date --rfc-2822)                             || exit 2
    MESSAGE_ID=$(printf '%d-%d-%d@%s' $RANDOM $RANDOM $RANDOM "$LOCAL_HOSTNAME")
    MESSAGE="Sender: $FROM_ADDRESS
From: $FROM_ADDRESS
To: $TO_ADDRESS
Subject: demo from $PROGNAME
Message-ID: <$MESSAGE_ID>
Date: $DATE

This is a text demo from the $PROGNAME script.
.This is a line starting with a dot.
--\x20
Marco
"
    printf "$MESSAGE"
}

declare -r COMMON_OPTIONS="--debug --verbose	\
   --host=localhost				\
   --envelope-from=$FROM_ADDRESS		\
   --envelope-to=$TO_ADDRESS"

declare FURTHER_OPTIONS

# Send the test message.
if true
then
    FURTHER_OPTIONS='--test-message'

    # Explicitly selects the port number.
    if true
    then
	set -x
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --port=25
	set +x
	echo
    fi

    # Read the port number from the hostinfo file.
    if true
    then
	set -x
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS}
	set +x
	echo
    fi

    # Read the port  number from the hostinfo file.  Send  a copy of the
    # message to the sender.
    if true
    then
	set -x
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS} --envelope-to=$FROM_ADDRESS
	set +x
	echo
    fi
fi

# Read the message from stdin
if true
then
    FURTHER_OPTIONS='--message=-'

    if true
    then
	print_message | bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS}
	echo
    fi
fi

# Read the message from a file.
if true
then
    : ${TMPDIR:=/tmp}
    PATHNAME=${TMPDIR}/message.$RANDOM.$$
    print_message >$PATHNAME
    trap "rm -f '$PATHNAME'" EXIT

    FURTHER_OPTIONS="--message=$PATHNAME"

    if true
    then
	bash "$SCRIPT" ${COMMON_OPTIONS} ${FURTHER_OPTIONS}
	echo
    fi
fi

### end of file
