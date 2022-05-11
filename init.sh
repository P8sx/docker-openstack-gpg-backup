#!/bin/sh

# Import GPG public keys
gpg --import /config/*.gpg

if [ ! -z "$CRON" ] 
then
    echo "$CRON_INTERVAL /backup.sh" >> /backup.cron
    crontab /backup.cron
fi

tail -f /dev/null