#!/bin/sh

REP="TMP"
USR="DrWaleedAYousef"
REMOTE="https://api.github.com/repos"

curl -u "$USR" -X "DELETE" "$REMOTE/$USR/$REP"

### from the command line:
# curl -u DrWaleedAYousef -X "DELETE" https://api.github.com/repos/DrWaleedAYousef/REP
