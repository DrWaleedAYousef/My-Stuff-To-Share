#!/bin/bash
######### Creat Directory Structure for Lecture Notes  #########
# Created By: Waleed A. Yousef, Ph.D.

# Version: 1.0

# Date: Jan., 17, 2016
###############################################

DIR="./AA-LectureNotesDesitenationDirectory-AA"
if [ -d "$DIR" ]; then rm -r "$DIR"; fi
mkdir -p $DIR/Graphics
COURSE="LectureNotes-Optimization"

cp MainTemplate.tex "$DIR/$COURSE.tex"
cp preample.tex "$DIR/preample.tex"
mkdir $DIR/FrontMatter
cp FrontMatter.tex $DIR/FrontMatter/
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

#     for f in $DIR/Graphics/$FileName/*.{jpg,png}
#     do
# 	shortf=`expr $f | rev | cut -d'/' -f-3 | rev`
# 	shortf="../$shortf"
# 	cat <<EOF >> "$DIR/$FileName/$FileName.tex"

# \hfil\includegraphics[width=.5\textwidth]{$shortf}\hfil
# EOF
#     done

    cp Graphics/FrontMatter/*.{jpg,png} $DIR/Graphics/
    for f in Graphics/$FileName/*.{jpg,png}
    do
        cp $f $DIR/Graphics/
	shortf=`expr $f | rev | cut -d'/' -f-1 | rev`
        shortf="../Graphics/$shortf"
	cat <<EOF >> "$DIR/$FileName/$FileName.tex"

\clearpage
\hfil\includegraphics[width=.5\textwidth]{$shortf}\hfil
EOF
    done

    cat <<EOF >> "$DIR/$FileName/$FileName.tex"

%%% Local Variables:
%%% mode: latex
%%% TeX-master: "../$COURSE"
%%% End:

EOF

done < "./Sections.txt"
