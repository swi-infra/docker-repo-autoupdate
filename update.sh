#!/bin/sh -xe

recover() {
    echo "Recovering repo"
    cd $VOLUME_PATH
    rm -rf *
    repo sync
}

echo "[$(date +"%H:%M:%S")] === Start ==="

source /etc/update.env.sh

cd $VOLUME_PATH

echo "Resetting repo"
repo forall -c "git reset $GIT_REMOTE/$GIT_BRANCH --hard ; git clean -fdx"
echo "Sync repo"
if ! repo sync; then
    recover
fi

echo -e "[$(date +"%H:%M:%S")] --- End ---\n"

