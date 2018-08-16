#!/bin/sh
######### Git initialization local and remote repos #########
# Created By: Waleed A. Yousef, Ph.D.

# Version: 1.0

# Date: Aug., 16, 2018

# Description: This script does three things. (1) On the remote, it creates a private repo REP for
# the user USR; if REP already exists it will leave it as is. (2) On local, it will initialize a
# repo (git-init) for what is inside the folder DIR (if the later does not exist it will create it
# and create an empty .ignore file). If DIR exists and already has a repo it will leave it as
# is. Then for the repo inside DIR it will add its remote and force push it to REP (just in case REP
# already exists BUT BE AWARE).
###############################################

REP="My-Stuff-To-Share" #can be any new repo name; however, if this repo exists remotely it will be
			#overwritten with a force push as exaplained above (so TAKE CARE).
DIR="/home/wyousef/Downloads/AAMyDocumentsAA/Reps/DrWaleedAYousef/My-Stuff-To-Share"
USR="DrWaleedAYousef"
REMOTE="https://github.com"

################################# Creating Empty local repo if directory does not exist
if ! [ -d "$DIR" ]; then mkdir "$DIR"; fi
cd "$DIR"
if ! [ -d .git ]
then
    git init
    touch .gitignore
    git add -A
    git commit -m 'Initializing'
fi
################################# Creating remote repo
curl -u '"$USR"' https://api.github.com/user/repos -d '{"name":"'"$REP"'","public":"false"}'

################################# Pushing current repo
git remote add origin "$REMOTE/$USR/$REP.git"
git push -f -u origin master

#### General help instruction
#############################

# for full command line options see: https://gist.github.com/caspyin/2288960  where you can see the full command as
# curl --user "caspyin" --request POST --data '{"description":"Created via API","public":"true","files":{"file1.txt":{"content":"Demo"}}' https://api.github.com/gists

# from the shell (not a script) the command above should be:
# curl -u 'USR' https://api.github.com/user/repos -d '{"name":"REP","public":"false"}'
