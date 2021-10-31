"""From an fls file of a full path name FILE_FULL_NAME, created by the LaTeX process, this script
compiles all the files, with an extension in EXTENSIONS, that exist in the current directory tree
and generates two folders at the same directory level of this file: A-JOURNAL, that keeps the same
directory structure and A-ARXIV that puts all files at the root. For the latter, all file-names
inside the tex files have to be re-parsed and changed to call the root files.

It assumes that all file names in the fls file start with either / or ./ , which is very logical.

You can run this script from wherever, as long as you keep the full path name of the fls file in
FILE_FULL-NAME.
"""

FILE_FULL_NAME = '/home/wyousef/Downloads/AAMyDocumentsAA/Reps/UVIC/zz-Archived-zz/A-UNAVOIDS/Paper/main-paper.fls'

import os
import shutil

JOURNAL_DIR = './A-JOURNAL'
ARXIV_DIR = './A-ARXIV'
EXTENSIONS = ['.pdf', '.png', '.jpg', '.svg', '.tex', '.bbl', '.pdf_tex']
FLS_FILE = os.path.basename(FILE_FULL_NAME)
WORKING_DIR = os.path.dirname(FILE_FULL_NAME)
os.chdir(WORKING_DIR)
shutil.rmtree(JOURNAL_DIR, ignore_errors=True)
shutil.rmtree(ARXIV_DIR, ignore_errors=True)

if not (os.path.exists(JOURNAL_DIR) or os.path.exists(ARXIV_DIR)):
    os.mkdir(JOURNAL_DIR)
    os.mkdir(ARXIV_DIR)
    with open(FLS_FILE, 'r') as f:
        for line in f:
            if 'INPUT' in line:
                source = line.split(' ')[1].rstrip()
                _, e = os.path.splitext(source)
                if (e in EXTENSIONS and source[0:2] == './'):
                    shutil.copy(source, ARXIV_DIR)
                    source_dir = os.path.dirname(source)
                    if source_dir == '.':
                        tmp_dir = JOURNAL_DIR
                    else:
                        tmp_dir = os.path.join(JOURNAL_DIR, source_dir[2:])
                        os.makedirs(tmp_dir, exist_ok=True)
                    shutil.copy(source, tmp_dir)
