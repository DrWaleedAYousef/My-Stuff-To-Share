# Introduction #
This repo is a set of miscellanea that I would like to share with students, and followers in
general, for wider benefit. You are welcome to fork, clone, modify, etc. (as indicated in the
license). Each section of the following corresponds to a folder in the repo. The objectives of
sharing this are:

1. giving motivation and inspiration to students to use the "power of text" through scripting. So,
even if you do not benefit from the scripts in this repo, I hope you get motivated and inspired to
write your own to automate your work.

2. spreading the benefit, since I am sure these scripts are beneficial for their own sake.


# Emacs #
Here, I put Emacs related files, including of course my `.emacs` configuration file. Currently, I do
not consider myself an expert in Emacs since I cannot customize everything fluently in LISP; you
will find many very sophisticated `.emacs` files over the net. However, my `.emacs` file can be a
good start for novices to Emacs.


# Git-Scripts #
These are a set of miscellaneous scripts that I created to ease using git, including creating,
deleting, etc. completely from the command line without signing into the web interface
[Github](Github.com).


# LaTeX #
This is a set of LaTeX templates, scripts, and modules that I usually use to prepare my lecture
notes and other documents. They can be very helpful for anyone composing similar documents.

## BibTeX ##
Is a simple folder that accounts for an example for all students how to organize your library using
the "power of test" to git rid of other software. The folder contains a `bib` file, along with
`pdf`s. The `bib` file is your library that contains articles, books, etc. Each item has a key that
should be informative, e.g., `Yousef2017MethodSystemForComputer`; and in case it has a `pdf`, it
should be named `Yousef2017MethodSystemForComputer.pdf`. In addition, each item has a set of
keywords that should help you in classifying your items. Keywords should be as clear as
possible. When adding a keyword to a new item, it should be selected from the existing keywords (or
add a new one). This is to avoid having two keywords with different spelling styles (e.g.,
Microcalcification and micro-calcification).

## LaTeX-Lecture-Template-Preparation-Script ##
This script is very beneficial for producing a lengthy document like the lecture notes. This script
is to save the nonsense time and effort wasted in writing `\chapter{} \section{} \includegraphics
...` insanely many times for each chapter, section, figure, etc. You just need to have a directory
of `Graphics` containing the graphics of each chapter, and a text file `Sections.txt` that contains
the chapter and section titles both are in the folder `LectureNotesDesitenationDirectory`, to which
all the latex code will be automatically generated when running the shell script. Now, run the shell
script, and it will parse the folder `Graphics` and the titles file `Sections.txt` and will generate
all the stuff for you. Of course, you can change the `FrontMatterTemplate.tex` and
`MainTemplate.tex` as you like. After generating the `LaTeX` code under that folder, you can compile
it to generate the `pdf` which contains all the chapter titles, section titles, and all the
graphics.

## LaTeX-Lecture-Template ##
Contains the LaTeX template that I always use in preparing the lecture notes. If you compile the
`.tex` file, you will get exactly the same `pdf` part (chapter 1 as a sample) of the Digital Design
course.


# Miscellaneous-Scripts #
Some general scripts that I created to automate things, including backing up my work (both
incremental or full backups), auto-downloading a series of files, etc.
