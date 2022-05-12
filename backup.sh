#!/bin/sh


source /config/openrc.sh
cd /data


RECIPIENTS=$(gpg --list-keys --with-colons --fast-list-mode | awk -F: '/^pub/{printf "-r %s ", $5}') 
FILES=$(find * -maxdepth 1 -type f | sed -e "s/^\.\///g")

for BASE_FILE in $FILES; do
    # Remove any temp data
    rm -rf /temp/*
    # Encrypt and compress if specified
    if [ "$COMPRESS_FILE" = true ]; then
        FILE_NAME="${BASE_FILE}.gz"
        gzip -c $BASE_FILE > /temp/$FILE_NAME
        gpg --trust-model always --encrypt $RECIPIENTS --output /temp/$FILE_NAME.gpg /temp/$FILE_NAME
    else
        FILE_NAME="${BASE_FILE}"
        gpg --trust-model always --encrypt $RECIPIENTS --output /temp/$FILE_NAME.gpg $BASE_FILE
    fi
 
    # Upload
    if [ ! -z "$DELETE_AFTER" ]; then
        swift upload -H "X-Delete-After: ${DELETE_AFTER}" -H "content-type:application/pgp-encrypted" $BUCKET /temp/$FILE_NAME.gpg --skip-identical --object-name $FILE_NAME.gpg
    else
        swift upload -H "content-type:application/pgp-encrypted"  $BUCKET /temp/$FILE_NAME.gpg --skip-identical --object-name $FILE_NAME.gpg
    fi
    
    if [ "$REMOVE_BASE_FILE" = true ]; then
        rm $BASE_FILE
    fi
done

