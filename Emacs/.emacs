;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Emacs General Options ;;;;;;;;;;;;;;;;

;; (add-to-list 'load-path "~/.emacs.d/loadpath/benchmark-init-el-master")
;; (require 'benchmark-init-loaddefs)
;; (benchmark-init/activate)

(add-to-list 'load-path "~/.emacs.d/loadpath")

;; The following is so that use-package installs itself :):)
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
;;(require 'diminish)
(require 'bind-key)

(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1
      ring-bell-function 'ignore ;; to stop the beeb.
      use-package-always-ensure t
      inhibit-splash-screen t
      inhibit-startup-screen +1
      file-name-coding-system 'mule-utf-8)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1))
;;(server-start)

(use-package ace-window
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind ( ("C-x o" . ace-window))
  )
(winner-mode 1) ;; history

(column-number-mode t)

(use-package solarized-theme
  :config (load-theme 'solarized-dark t)
  )

(use-package smart-mode-line
  :init (setq sml/theme 'dark)
  (setq sml/no-confirm-load-theme t)
  :config (sml/setup))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ce22122f56e2ca653678a4aaea2d1ea3b1e92825b5ae3a69b5a2723da082b8a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "4bf9b00abab609ecc2a405aa25cc5e1fb5829102cf13f05af6a7831d968c59de" default)))
 '(org-agenda-files
   (quote
    ("~/MyDocuments/Phd/Projects/PassiveCooling/Proposal02.org" "~/MyDocuments/Phd/Manuscripts/AAToBePublishedAA/Mousa2016WindAnalysis/Mousa2016Prediction03.org")))
 '(package-selected-packages
   (quote
    (ghub magit magithub magit-gh-pulls markdown-mode flycheck ebdb ztree nlinum solarized-theme php-mode auctex smartparens org-ref python-cell ox-bibtex gscholar-bibtex jedi faff-theme ein elpy org-linkid gnus-namazu nnir bbdb-vcard doi-utils lua-mode org-ac org-latex matlab-mode helm-sage auto-complete-sage w3m gnus-desktop-notify mm-util magic-latex-buffer helm-dash openwith dired+ bbdb impatient-mode expand-region guide-key auto-complete smart-mode-line ace-window))))

;; ;; ;; ;; Org mode & calendar ;;;;;;;;;;;;;;;;;
;; ;; Still needs alot of customization
(use-package org
  :init
  (setq
   org-agenda-files (quote ("~/MyDocuments/Phd/Manuscripts/AAToBePublishedAA/Mousa2016WindAnalysis/Mousa2016Prediction03.org"))
   org-babel-load-languages (quote (
				    (C		.	t)
				    (R		.	t)
				    (calc	.	t)
				    (emacs-lisp	.	t)
				    (gnuplot	.	t)
				    (latex	.	t)
				    (matlab	.	t)
				    (python	.	t)
				    (ditaa	.	t)
				    (shell	.	t)))
   calendar-week-start-day 6
   org-src-fontify-natively t
   org-confirm-babel-evaluate nil
   )
  :config
  (define-key org-mode-map "\M-q" 'toggle-truncate-lines)
  (define-key org-mode-map "\M-q" 'fill-paragraph)
  (setq org-startup-truncated t)
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
		 '("memoir" "\\documentclass{memoir}"
		   ("\\chapter{%s}"		.	"\\chapter*{%s}")
		   ("\\section{%s}"		.	"\\section*{%s}")
		   ("\\subsection{%s}"	.	"\\subsection*{%s}")
		   ("\\subsubsection{%s}"	.	"\\subsubsection*{%s}")
		   ("\\paragraph{%s}"		.	"\\paragraph*{%s}")
		   ("\\subparagraph{%s}"	.	"\\subparagraph*{%s}"))))
  )


;;;;;;;;;;;;;;; bibtex, helm-bibtex, org-ref ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put this in bib file and C-x C-e to rename all entries key
;;
;;(bibtex-map-entries (lambda (key start end) (bibtex-clean-entry t)))

(defun my-bibtex-shortcuts ()
  (local-set-key (kbd "C-c ]") 'org-ref-bibtex-hydra/body))
(add-hook 'bibtex-mode-hook 'my-bibtex-shortcuts)

;; ;; from : https://github.com/higham/dot-emacs/blob/master/.emacs
(defvar bp/bibtex-fields-ignore-list
  '("abstract" "issn" "eprint" "issue_date" "articleno" "numpages" "acmid" "lccn" "oclcnum" "form" "date_added" "mendeley-tags" "pmid" "annote"))
(defun bp/bibtex-clean-entry-hook ()
  (save-excursion
    (let (bounds)
      (when (looking-at bibtex-entry-maybe-empty-head)
	(goto-char (match-end 0))
	(while (setq bounds (bibtex-parse-field))
	  (goto-char (bibtex-start-of-field bounds))
	  (if (member (bibtex-name-in-field bounds)
		      bp/bibtex-fields-ignore-list)
	      (kill-region (caar bounds) (nth 3 bounds))
	    (goto-char (bibtex-end-of-field bounds))))))))

(add-hook 'bibtex-clean-entry-hook 'bp/bibtex-clean-entry-hook)

(setq
 bibtex-autokey-name-case-convert-function (quote capitalize)
 bibtex-autokey-names (quote 1)
 bibtex-autokey-titleword-case-convert-function (quote capitalize)
 bibtex-autokey-titleword-ignore
 (quote ;; [^[:upper:]].* for ignoring lower case title words
  ("." ".." "the" "The" "and" "And" "Eine?" "Der" "Die" "Das" ".*[^[:upper:][:lower:]0-9].*"))
 bibtex-autokey-titleword-length 30
 bibtex-autokey-titleword-separator ""
 bibtex-autokey-titlewords (quote 4)
 bibtex-autokey-titlewords-stretch 0
 bibtex-autokey-use-crossref nil
 bibtex-autokey-year-length 4
 bibtex-autokey-year-title-separator ""
 bibtex-entry-format t
 ;; bibtex-entry-format
 ;; (quote
 ;;  (opts-or-alts numerical-fields page-dashes whitespace inherit-booktitle realign last-comma delimiters unify-case braces strings sort-fields))
 )

(setq reftex-extra-bindings t)
;; To use the extra key bindings associated with reftex, this statement has to be loaded before any reftex load. org-ref seems to load reftex.
(use-package org-ref
  ;;  :defer 10
  :init
  (setq org-ref-bibliography-notes "~/MyDocuments/Phd/PDF/Notes/Notes.org"
	org-ref-default-bibliography '("~/MyDocuments/Phd/texmf/bibtex/bib/base/publications.bib" "~/MyDocuments/Phd/texmf/bibtex/bib/base/booksIhave.bib")
	org-ref-pdf-directory "~/MyDocuments/Phd/PDF/"
	org-ref-open-pdf-function '(org-ref-get-mendeley-filename)
	org-ref-bibtex-assoc-pdf-with-entry-move-function (quote copy-file) ;;could be rename-file
	org-ref-clean-bibtex-entry-hook
	(quote
	 (org-ref-bibtex-format-url-if-doi orcb-key-comma org-ref-replace-nonascii orcb-& orcb-% org-ref-title-case-article orcb-clean-year orcb-clean-doi orcb-clean-pages org-ref-sort-bibtex-entry))
	))

(use-package helm-bibtex
  :init
  (setq bibtex-completion-notes-path "~/MyDocuments/Phd/PDF/Notes/Notes.org"
	bibtex-completion-bibliography '("~/MyDocuments/Phd/texmf/bibtex/bib/base/publications.bib" "~/MyDocuments/Phd/texmf/bibtex/bib/base/booksIhave.bib")
	bibtex-completion-library-path "~/MyDocuments/Phd/PDF/"
	bibtex-completion-pdf-field "File"
	bibtex-completion-pdf-symbol "⌘"
	bibtex-completion-notes-symbol "✎"
	helm-bibtex-full-frame nil
	bibtex-completion-additional-search-fields (quote (keywords journal author))
	bibtex-completion-display-formats
	'((article      .	"${=type=:7} ${=has-pdf=:1} ${year:4} ${keywords:80}  ${author:10}  ${title:40}")
	  (book		.	"${=type=:7} ${=has-pdf=:1} ${year:4} ${keywords:80}  ${author:10}  ${title:40}")
	  (t            .	"${=type=:7} ${=has-pdf=:1} ${year:4} ${keywords:80}  ${author:10}  ${title:40}"))
	))

(use-package gscholar-bibtex
  :init
  (setq gscholar-bibtex-default-source "Google Scholar")
  )

;; ;; ;; ;; ;; ;; ;;;;;;; Editing obtained ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
	;; This would override `fill-column' if it's an integer.
	(emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))
(define-key global-map "\M-Q" 'unfill-paragraph)

(setq global-visual-line-mode t)

(setq-default fill-column 100)
;;(add-hook 'text-mode-hook 'auto-fill-mode)

(use-package re-builder
  :config
  (setq reb-re-syntax 'string)
  )
(use-package guide-key
  :config
  (setq guide-key/guide-key-sequence t
	guide-key/idle-delay 1)
  (guide-key-mode 1) ;; Enable guide-key-mode after loading
  )
(use-package expand-region
  :config
  (setq  expand-region-smart-cursor t)
  :bind ( ("C-=" . er/expand-region)
	  ("C--" . er/contract-region))
  )

(load "init-smartparens")

(setq isearch-allow-scroll t)

;;;- , parenthesis-related
;;(show-paren-mode t)
(setq show-paren-style (quote expression))
(setq blink-matching-delay 0)

(setq ispell-personal-dictionary "~/.emacs.d/loadpath/MyPersonalDictionary.txt")
;;;- , spelling
(dolist
    (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist
    (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;;;- , miscellanies
(setq-default show-trailing-whitespace t)

(delete-selection-mode 1)
(use-package smartparens
  :config
  (load "init-smartparens")
  )

 ;;;; helm ;;;;;;;;;;;;;;;;
(use-package helm
  :init
  (global-unset-key (kbd "C-x c"))
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (set-variable (quote helm-mode-fuzzy-match) t nil)
  (setq ;;helm-ff-locate-db-filename "~/locate.db"
   helm-split-window-in-side-p t)
  :bind ( ("C-c h"	.	helm-command-prefix)
	  ("M-x"	.	helm-M-x	)
	  ("C-x b"	.	helm-buffers-list)
	  ("C-x C-f"	.	helm-find-files))
  :config
  (require 'helm-config)
  (helm-mode 1)
  ;; the following is to overcome the bug in ffap to open files inside curly braces
  ;; (setcdr (assq 'file ffap-string-at-point-mode-alist)
  ;; 	  '("--:\\\\$+<>@-Z_[:alpha:]~*?" "<@" "@>;.,!:"))
   )

(use-package helm-dash
  :bind ( ("C-h h" . helm-dash-at-point))
  )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PDF & Images & Pinting ;;;;;;;;;;;;;;
(use-package pdf-tools
  :defer 10
  :init (pdf-tools-install)
  (setq pdf-misc-print-programm "/usr/bin/lp")
  (setq-default pdf-view-display-size (quote fit-page))
  (setq pdf-view-incompatible-modes
   (quote
    (linum-relative-mode helm-linum-relative-mode nlinum-mode nlinum-hl-mode nlinum-relative-mode yalinum-mode)))
  )

(setq  lpr-command "lp"
       lpr-printer-switch "-d"
       lpr-switches (quote ("-o Resolution=600" "-n 1 -o page-ranges=1-"))
       )

(setq thumbs-conversion-program "/usr/bin/convert")
(setq ps-print-header nil)
(load "pdftools")   ;;for spooling to pdf.

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Shell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq explicit-shell-file-name "/usr/bin/bash" ;;shell called with M-x shell
      shell-file-name "/usr/bin/bash") ;;shell used by Emacs

(defun cls ()
  "Hi, you will clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (push-button RET)
    (message "erase eshell buffer")))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; w3m ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package w3m)
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(setq w3m-use-cookies t)
(autoload 'browse-url-interactive-arg "browse-url")
(setq w3m-edit-function (quote find-file-other-window))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Email ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package bbdb
  :init
  (setq bbdb-completion-list t
	bbdb-file "~/.emacs.d/loadpath/bbdb"
	bbdb-mail-user-agent (quote mh-e-user-agent)
	bbdb-complete-mail-allow-cycling t
	bbdb-completion-display-record nil)
  (add-hook 'gnus-Startup-hook 'bbdb-insinuate-gnus)
  :config
  (bbdb-initialize 'gnus)
  )

(use-package bbdb-vcard
  )

(add-hook 'message-mode-hook 'turn-on-orgstruct++)
(add-hook 'message-mode-hook 'turn-on-orgtbl)
;; ;;(setq org-startup-truncated t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; File Managment ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dired+)
(require 'dired-fixups)
(require 'dired-tar)
(setq dired-listing-switches "-lGha --group-directories-first")
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
(add-hook 'dired-mode-hook 'auto-revert-mode)
(setq dired-auto-revert-buffer t)
(setq auto-revert-interval 0.5)
(setq auto-revert-verbose nil)

(setq dired-dwim-target t);; to process, by default, to the recently opened dired window.
(setq dired-recursive-copies (quote always)) ; “always” means no asking

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Arabic Encoding ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default default-input-method "arabic")
(eval-after-load "quail/arabic"
  '(let ((quail-current-package (assoc "arabic" quail-package-alist)))
     (quail-define-rules ((append . t)) ;; don't clobber the existing rules
                         ("0" "\u0660")
                         ("1" "\u0661")
                         ("2" "\u0662")
                         ("3" "\u0663")
                         ("4" "\u0664")
                         ("5" "\u0665")
                         ("6" "\u0666")
                         ("7" "\u0667")
                         ("8" "\u0668")
                         ("9" "\u0669"))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AUCTex LaTeX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package auctex
  :defer t
  :ensure t)

(use-package magic-latex-buffer
  :init
  (add-hook 'LaTeX-mode-hook 'magic-latex-buffer)
  :config
  (setq magic-latex-enable-block-highlight t
	magic-latex-enable-suscript        t
	magic-latex-enable-pretty-symbols  t
	magic-latex-enable-block-align     nil
	magic-latex-enable-inline-image    nil
	magic-latex-enable-minibuffer-echo t)
  (push '("\\\\Vert\\>"			.	"||") ml/symbols)
  (push '("\\\\vert\\>"			.	"|") ml/symbols)
  (push '("\\\\citep\\>"		.	"♇") ml/symbols)
  (push '("\\\\textsuperscript\\>"	.	"⁺") ml/symbols)
  (push '("\\\\label\\>"		.	"🏷") ml/symbols)
  (push '("\\\\chapter\\>"		.	"🕅") ml/symbols)
  (push '("\\\\section\\>"		.	"§") ml/symbols)
  (push '("\\\\subsection\\>"		.	"§§") ml/symbols)
  (push '("\\\\subsubsection\\>"	.	"§§§") ml/symbols)
  (push '("\\\\pageref\\>"		.	"⎗") ml/symbols)
  )
;; ☿ ♃ ♄ ♅ ♆ 📄🗟 

(add-hook 'LaTeX-mode-hook '(lambda () (setq TeX-command-default "LaTeX")))
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)

(defvar LaTeX-enumitem-key-val-options
  '(;;
    ("Ex. ")
    ("Def. ")
    ("partopsep=0in,parsep=0in,topsep=0in,itemsep=0.1in,leftmargin=\\parindent")
    ("partopsep=0in")
    ("label")
    ("align" ("left" "right" "parleft")))
  "Key=value options for enumitem macros and environments.")
(add-hook 'LaTeX-mode-hook
	  (lambda () (LaTeX-add-environments
		      '("itemize" LaTeX-env-args [TeX-arg-key-val LaTeX-enumitem-key-val-options])
		      '("enumerate" LaTeX-env-args [TeX-arg-key-val LaTeX-enumitem-key-val-options])
		      '("description" LaTeX-env-args [TeX-arg-key-val LaTeX-enumitem-key-val-options])
		      '("example" LaTeX-env-args [TeX-arg-key-val LaTeX-enumitem-key-val-options])
		      '("definition" LaTeX-env-args [TeX-arg-key-val LaTeX-enumitem-key-val-options])
		      '("axiom" LaTeX-env-label)
		      '("theorem" LaTeX-env-label))))

(add-hook 'LaTeX-mode-hook (lambda () (TeX-fold-mode 1)))
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(setq TeX-view-program-selection '((output-pdf "PDF Tools")))
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

(setq LaTeX-includegraphics-read-file 'LaTeX-includegraphics-read-file-relative)
(setq LaTeX-item-indent 0)
(setq LaTeX-section-hook
      (quote
       (LaTeX-section-heading LaTeX-section-title LaTeX-section-section LaTeX-section-label)))
(setq TeX-PDF-mode t)
(setq TeX-arg-right-insert-p t)
(setq TeX-auto-save t)
(setq TeX-display-help nil)
(setq TeX-insert-braces nil)
(setq-default TeX-master nil)
(setq TeX-mode-hook (quote ((lambda nil (outline-minor-mode t)))))
(setq TeX-parse-self t)
(setq TeX-source-correlate-method (quote synctex))
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)
(setq TeX-newline-function (quote reindent-then-newline-and-indent))
(setq TeX-engine (quote xetex))

;;;- , preview-latex
'(LaTeX-mode-hook (quote (LaTeX-preview-setup preview-mode-setup)))
(setq preview-auto-cache-preamble t)
(setq preview-preserve-counters t)

(use-package reftex
  :init
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)
  ;;  :config
  (setq
   reftex-auto-recenter-toc t
   reftex-default-bibliography '("~/MyDocuments/Phd/texmf/bibtex/bib/base/publications.bib" "~/MyDocuments/Phd/texmf/bibtex/bib/base/booksIhave.bib")
   reftex-bibpath-environment-variables (quote ("BIBINPUTS" "TEXBIB" "~/MyDocuments/Phd/texmf/bibtex/bib/base/"))
   reftex-cite-format (quote natbib)
   reftex-label-alist (quote(
			     ("axiom"   ?x  "axm:"  "~\\ref{%s}" t ("axiom")   -2)
			     ("theorem" ?h "thm:" "~\\ref{%s}" t ("theorem") -3)))
   reftex-insert-label-flags (quote ("sftxh" "nil"))
   reftex-multiref-punctuation (quote ((44 . ", ") (45 . "--") (43 . ", and ")))
   reftex-plug-into-AUCTeX t
   reftex-ref-style-default-list (quote ("Default" "Hyperref"))
   reftex-sort-bibtex-matches (quote author)
   reftex-toc-include-file-boundaries t
   reftex-toc-split-windows-fraction 0.2
   reftex-toc-split-windows-horizontally t
   ))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Key-bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-c e") 'eshell)
(global-set-key [(control return)]   'align-newline-and-indent)
(global-set-key (kbd "C-c C-p")   'print-buffer)
(global-set-key (kbd "C-c h g")   'helm-bibtex-with-local-bibliography)
(global-set-key (kbd "C-x g")   'magit-status)


;;;;;;;;;;;;;;;;;;;;;;; Programming ;;;;;;;;;;;;;;;;
(use-package magit)
(setq auth-sources '("~/.authinfo.gpg"))
(setq magit-process-find-password-functions '(magit-process-password-auth-source))
(use-package magithub
  :after magit
  :ensure t
  :config (magithub-feature-autoinject t))

(use-package lua-mode
  )

(use-package php-mode
  )

(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;;;;;;;;;;;;;;;;;;;;;; Sage ;;;;;;;;;;;;;;;;
(use-package sage-shell-mode
  :init  (setq sage-shell:use-prompt-toolkit t
	       sage-shell:sage-root "~/Downloads/AAProgramsAA/sage-7.4"
	       sage-shell:input-history-cache-file "~/.emacs.d/.sage_shell_input_history"
	       )
  (add-hook 'sage-shell-mode-hook #'eldoc-mode)
  (add-hook 'sage-shell:sage-mode-hook #'eldoc-mode)
  (add-hook 'sage-shell-after-prompt-hook #'sage-shell-view)
  :config
  (sage-shell:define-alias)

(use-package helm-sage)

;;;;;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setenv "WORKON_HOME" "~/Downloads/AAProgramsAA/anaconda3/envs/")
  (pyvenv-mode 1)
  (pyvenv-workon "MyDefaultEnv")
  (setq elpy-shell-use-project-root nil)
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package company
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode)
    (setq company-idle-delay 0)
    (bind-keys :map company-active-map
               ("C-n"		.	company-select-next)
               ("C-p"		.	company-select-previous)
               ("C-d"		.	company-show-doc-buffer)
               ("<enter>"	.	company-complete)
	       ("<tab>"		.	company-complete-common-or-cycle)
               ("<escape>"	.	company-abort)
               )))

(require 'ein)
(require 'ein-loaddefs)
(require 'ein-notebook)
(require 'ein-subpackages)
(setq
 ein:jupyter-default-server-command "/home/wyousef/Downloads/AAProgramsAA/anaconda3/envs/MyDefaultEnv/bin/jupyter"
 ein:jupyter-default-notebook-directory "/home/wyousef/Downloads/ZZPythonTryingZZ/code"
 ein:completion-backend 'ein:use-ac-jedi-backend
 )

