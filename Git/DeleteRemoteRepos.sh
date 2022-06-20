#!/bin/sh

REMREP="AnyRemoteRep"
ACCOUNT="ISOT"

case $ACCOUNT in
    MY           )
        URL="https://api.github.com/repos/DrWaleedAYousef";;

    ISOT           )
        URL="https://api.github.com/repos/isotlaboratory";;

    HCILAB )
        URL="https://api.github.com/repos/hci-lab";;
esac

USR="DrWaleedAYousef"
curl -u "$USR" -X "DELETE" "$URL/$REMREP"
