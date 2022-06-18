#!/bin/sh
######### Git initialization local and remote repos #########
# Created By: Waleed A. Yousef, Ph.D.

# Version: 1.0

# Date: Aug., 16, 2018

# Ref, API: https://docs.github.com/en/rest/repos#create

# Description: This script does three things. (1) On the remote, it creates a private repo REMREP for
# the user USR; if REMREP already exists it will leave it as is. (2) On local, it will initialize a
# repo (git-init) for what is inside the folder LOCREP (if the later does not exist it will create it
# ). If LOCREP exists and already has a repo it will leave it as
# is. Then for the repo inside LOCREP it will add its remote and force push it to REMREP (just in case REMREP
# already exists BUT BE AWARE).

# from the shell (not a script) the command above should be:
# curl -u 'USR' https://api.github.com/user/repos -d '{"name":"REMREP","public":"false"}'

###############################################
REMREP="TMP" #can be any new repo name; however, if this repo exists remotely it will be
ACCOUNT="MY"
case $ACCOUNT in
    MY           )
        LOCREP="/home/wyousef/Downloads/AAMyDocumentsAA/Reps/DrWaleedAYousef/$REMREP" #The local path of the repo.
        URL="https://api.github.com/user/repos";;

    ISOT           )
        LOCREP="/home/wyousef/Downloads/AAMyDocumentsAA/Reps/UVIC/$REMREP" #The local path of the repo.
        URL="https://api.github.com/orgs/isotlaboratory/repos";;

    HCILAB )
        LOCREP="/home/wyousef/Downloads/AAMyDocumentsAA/Reps/HCI-LAB/$REMREP" #The local path of the repo.
        URL="https://api.github.com/orgs/hci-lab/repos";;
esac

# ################################# Creating remote repo
USR="DrWaleedAYousef"
curl -X POST -u '"$USR"' "$URL" -d '{
"name":"'"$REMREP"'",
"public":"false",
"allow_merge_commit":"false",
"allow_squash_merge":"true",
"allow_rebase_merge":"true",
"delete_branch_on_merge":"true"
}'

################################# Creating Empty local repo if directory does not exist, then push it
if ! [ -d "$LOCREP" ]; then mkdir "$LOCREP"; fi
# touch .gitignore
cp README.md "$LOCREP/"
cp .gitignore "$LOCREP/"
cp LICENSE "$LOCREP/"
cd "$LOCREP"
if ! [ -d .git ]
then
    git init
    git add -A
    git commit -m 'Initializing'
fi

git remote add origin "https://github.com/$USR/$REMREP.git"
git push -f -u origin master


