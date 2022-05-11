#!/bin/sh

RECIPIENTS=$(gpg --list-keys --with-colons --fast-list-mode | awk -F: '/^pub/{printf "-r %s ", $5}') 

source /config/openrc.sh
cd /data
FILES=$(find . -maxdepth 1 -type f)


for FILE in $FILES
do
    gpg --trust-model always --encrypt $RECIPIENTS --output $FILE.gpg $FILE
    swift upload -H "X-Delete-After: ${DELETE_AFTER}" $BUCKET $FILE.gpg
    rm $FILE
    rm $FILE.gpg
done

