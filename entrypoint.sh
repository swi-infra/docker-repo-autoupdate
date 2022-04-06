#!/bin/sh -xe

if [ -z "$MANIFEST_URL" ] || [ -z "$MANIFEST" ]; then
    echo "MANIFEST_URL or MANIFEST not provided"
    exit 1
fi

POLLING_FREQ=${POLLING_FREQ:-"*/5 * * * *"}
GIT_BRANCH=${GIT_BRANCH:-master}
GIT_REMOTE=${GIT_REMOTE:-origin}
REPO_GROUPS=${REPO_GROUPS:-default,letp}

if ! [ -e "$VOLUME_PATH" ]; then
    mkdir -p $VOLUME_PATH
fi

    cd $VOLUME_PATH
if [ -e "$VOLUME_PATH/.repo" ]; then
    echo "Resetting repo"
    repo forall -vc "git reset $GIT_REMOTE/$GIT_BRANCH --hard"
fi
echo "initializing $MANIFEST_URL [$MANIFEST:$REPO_GROUPS] -> $VOLUME_PATH"
repo init -u "$MANIFEST_URL" -m "$MANIFEST" -g "$REPO_GROUPS"
echo "Sync repo"
repo sync

if [ -n "$ONE_SHOT" ]; then
    echo "ONE SHOT: done"
    exit 0
fi

# No logrotate
if [ -e "/etc/cron.daily/logrotate" ]; then
    rm /etc/cron.daily/logrotate
fi

echo "export VOLUME_PATH=\"$VOLUME_PATH\"" > /etc/update.env.sh
echo "export GIT_REMOTE=\"$GIT_REMOTE\"" >> /etc/update.env.sh
echo "export GIT_BRANCH=\"$GIT_BRANCH\"" >> /etc/update.env.sh

# Make sure the update works
/update.sh

touch /var/log/messages
tail -f /var/log/messages &

touch /var/log/update.log
tail -f /var/log/update.log &

echo "$POLLING_FREQ /update.sh >> /var/log/update.log 2>&1" | crontab -
rsyslogd
crond
CRON_PID=$!

set +e

wait $CRON_PID
