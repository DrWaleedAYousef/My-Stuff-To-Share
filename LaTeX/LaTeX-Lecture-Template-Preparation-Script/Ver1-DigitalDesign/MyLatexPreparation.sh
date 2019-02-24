#!/bin/bash
######### Creat Directory Structure for Lecture Notes  #########
# Created By: Waleed A. Yousef, Ph.D.

# Version: 1.0

# Date: Jan., 17, 2016
###############################################

### Assume that DIR (a full path name anywhere) exists and includes Graphics, which includes the
figures of each chapter

DIR="./LectureNotesDesitenationDirectory"
COURSE="LectureNotesMA214"

cp MainTemplate.tex "$DIR/$COURSE.tex"
mkdir $DIR/FrontMatter
cp FrontMatterTemplate.tex $DIR/FrontMatter/FrontMatter.tex
cat <<EOF >> "$DIR/FrontMatter/FrontMatter.tex"

%%% Local Variables:
%%% mode: latex
%%% TeX-master: "../$COURSE"
%%% End:
EOF

i=0
while read line
do
    i=`expr $i + 1`
    if [[ "$i" -lt 10 ]]; then FileName="Ch0$i"; else FileName="Ch$i"; fi
    if ! [ -d "$DIR/$FileName" ]; then mkdir "$DIR/$FileName"; fi
    cat <<EOF >> "$DIR/$FileName/$FileName.tex"
\chapter{$line}

EOF
    j=0
    while read line
    do
	j=`expr $j + 1`
	if  [ -z "$line" ]; then break; fi
	cat <<EOF >> "$DIR/$FileName/$FileName.tex"
\clearpage
\section{$line}

EOF
    done
    shopt -s nullglob
    for f in $DIR/Graphics/$FileName/*.{jpg,png}
    do
	shortf=`expr $f | rev | cut -d'/' -f-3 | rev`
	shortf="../$shortf"
	cat <<EOF >> "$DIR/$FileName/$FileName.tex"

\hfil\includegraphics[width=.5\textwidth]{$shortf}\hfil
EOF
    done
    cat <<EOF >> "$DIR/$FileName/$FileName.tex"

%%% Local Variables:
%%% mode: latex
%%% TeX-master: "../$COURSE"
%%% End:

EOF

done < "$DIR/Sections.txt"
