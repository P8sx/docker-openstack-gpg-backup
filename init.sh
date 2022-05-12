#!/bin/sh

# Import GPG public keys
gpg --import /config/*.gpg
mkdir /temp

if [ ! -z "$CRON" ] 
then
    echo "$CRON_INTERVAL /backup.sh" >> /backup.cron
    crontab /backup.cron
fi
./backup.sh
# tail -f /dev/null