#!/bin/sh

# Import GPG public keys
gpg --import /config/*.gpg
tail -f /dev/null