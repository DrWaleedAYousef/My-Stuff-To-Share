
;;; Commentary ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Emacs General Options ;;;;;;;;;;;;;;;;
;; (add-to-list 'load-path "~/.emacs.d/loadpath/benchmark-init-el-master")
;; (require 'benchmark-init-loaddefs)
;; (benchmark-init/activate)

;; The following is so that use-package installs itself :):)
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(
			             ("gnu" . "https://elpa.gnu.org/packages/")
			             ("melpa" . "https://melpa.org/packages/")
			             ;; ("melpa-stable" . "http://stable.melpa.org/packages/")
			             ;; ("marmalade" . "https://marmalade-repo.org/packages/")
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

(use-package ace-window
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind ( ("C-x o" . ace-window))
  )
(winner-mode 1) ;; history

(column-number-mode t)

;;(desktop-save-mode 1)

(use-package solarized-theme
  :config (load-theme 'solarized-dark-high-contrast t)
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
   '("7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "ce22122f56e2ca653678a4aaea2d1ea3b1e92825b5ae3a69b5a2723da082b8a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "4bf9b00abab609ecc2a405aa25cc5e1fb5829102cf13f05af6a7831d968c59de" default))
 '(package-selected-packages
   '(forge transpar transpose company-quickhelp pdfgrep virtualenv markdown-preview-mode pdf-tools twittering-mode markdown-mode flycheck ebdb nlinum solarized-theme php-mode auctex smartparens org-ref python-cell ox-bibtex gscholar-bibtex faff-theme elpy org-linkid gnus-namazu nnir bbdb-vcard doi-utils lua-mode org-ac org-latex matlab-mode helm-sage auto-complete-sage w3m gnus-desktop-notify mm-util magic-latex-buffer helm-dash openwith dired+ bbdb impatient-mode expand-region guide-key auto-complete smart-mode-line ace-window))
 '(solarized-high-contrast-mode-line t))

;;;;;;;;;;;;;;; bibtex, helm-bibtex, org-ref ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put this in bib file and C-x C-e to rename all entries key (bibtex-map-entries (lambda (key start end) (bibtex-clean-entry t)))

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

;; (setq reftex-extra-bindings t)
;; To use the extra key bindings associated with reftex, this statement has to be loaded before any
;; reftex load. org-ref seems to load reftex.
(use-package org-ref
  ;;:defer 10
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

(add-to-list 'load-path "~/.emacs.d/loadpath")
(require 'transpar)
(global-set-key (kbd "C-c C-x") 'transpose-paragraph-as-table)

(progn
  ;; make indent commands use space only (never tab character)
  (setq-default indent-tabs-mode nil)
  ;; emacs 23.1 to 26, default to t
  ;; if indent-tabs-mode is t, it means it may use tab, resulting mixed space and tab
  )
(setq-default tab-width 4)

(use-package pdfgrep
  :config
  (pdfgrep-mode))

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

(defun copy-and-comment-region (beg end &optional arg)
  "Duplicate the region and comment-out the copied text.
See `comment-region' for behavior of a prefix arg."
  (interactive "r\nP")
  (copy-region-as-kill beg end)
  (goto-char end)
  (yank)
  (comment-region beg end arg))

 ;;;; helm ;;;;;;;;;;;;;;;;
(use-package helm
  :init
  (global-unset-key (kbd "C-x c"))
  (global-set-key   (kbd "C-c h") 'helm-command-prefix)
  (global-set-key   (kbd "C-x b") 'helm-mini)
  (global-set-key   (kbd "C-c h o") 'helm-occur)
  (global-set-key   (kbd "C-x C-f") 'helm-find-files)
  (global-set-key   (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key   (kbd "C-x r b") 'helm-filtered-bookmarks)
  (setq helm-mode-fuzzy-match t
	    helm-completion-in-region-fuzzy-match t
	    helm-locate-fuzzy-match t
	    helm-M-x-fuzzy-match t
	    helm-recentf-fuzzy-match t
	    recentf-max-menu-items 100
	    recentf-max-saved-items 100
	    helm-split-window-inside-p t)
  :bind ( ("M-x"	.	helm-M-x	)
	      )
  :config
  (require 'helm-config)
  (helm-mode 1)
  (helm-autoresize-mode t)
  ;; the following is to overcome the bug in ffap to open files inside curly braces
  ;; (setcdr (assq 'file ffap-string-at-point-mode-alist)
  ;; 	  '("--:\\\\$+<>@-Z_[:alpha:]~*?" "<@" "@>;.,!:"))
  )
(use-package helm-dash
  :bind ( ("C-h h" . helm-dash-at-point))
  )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PDF & Images & Pinting ;;;;;;;;;;;;;;
;; ;;(require 'printing) try it; seems nice for printing buffers instead of pdf-tools-save-buffer

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
       lpr-switches (quote ("-o fit-to-page=true" "-o sides=two-sided-long-edge" "-o Resolution=600" "-n 1 -o page-ranges=1-"))
       )

(setq thumbs-conversion-program "/usr/bin/convert")
(setq ps-print-header nil)
(load "pdftools")   ;;for spooling to pdf.

(add-hook 'image-mode-hook
          (lambda ()
            (auto-revert-mode)
            (auto-image-file-mode)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Shell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq explicit-shell-file-name "/usr/bin/bash" ;;shell called with M-x shell
      shell-file-name "/usr/bin/bash") ;;shell used by Emacs

(defun Mycls ()
  (interactive)
  (if (equal major-mode 'inferior-python-mode)
      (let ((inhibit-read-only t))
	    (erase-buffer)
	    (comint-send-input)
	    (message "erase buffer"))

    (if (equal major-mode 'eshell-mode)
	    (let ((inhibit-read-only t))
	      (erase-buffer)
	      (eshell-send-input)
	      (message "erase buffer"))

      (if (equal major-mode 'python-mode)
	      (let ((inhibit-read-only t) (curwin (selected-window)))
	        (elpy-shell-switch-to-shell)
	        (erase-buffer)
	        (comint-send-input)
	        (message "erase buffer")
	        (select-window curwin))
	    (erase-buffer)))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; w3m ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package w3m)
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(setq w3m-use-cookies t)
(autoload 'browse-url-interactive-arg "browse-url")
(setq w3m-edit-function (quote find-file-other-window))

;; (use-package impatient-mode
;;   :init
;;   (httpd-start)
;;   :config
;;   (add-hook 'html-mode-hook 'impatient-mode)
;;   (defun ggl ()
;;     (interactive)
;;     (shell-command
;;      (concat "google-chrome-stable" " '" "http://localhost:8080/imp/live/" (buffer-name) " '" ) nil nil)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Email ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package bbdb
  :init
  (setq bbdb-completion-list t
	    bbdb-file "~/.emacs.d/loadpath/bbdb"
	    bbdb-mail-user-agent (quote mh-e-user-agent)
	    bbdb-complete-mail-allow-cycling t
	    bbdb-completion-display-record nil
	    bbdb-allow-duplicates t
	    )
  (add-hook 'gnus-Startup-hook 'bbdb-insinuate-gnus)
  :config
  (bbdb-initialize 'gnus)
  )

(use-package bbdb-vcard
  )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; File Managment ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;- , dired-mode
;;(use-package dired+)
;;the following to run dired commands asnychronously
;;(autoload 'dired-async-mode "dired-async.el" nil t)
;;(dired-async-mode 1)

;; (use-package openwith
;;   :config
;;   (openwith-mode t)
;;   (setq openwith-associations
;;   	'(("\\.\\(?:mpe?g\\|avi\\|wmv\\|wav\\|mp4\\)\\'" "mplayer" ("-idx" file))
;;   	  ("\\.\\(?:doc\\|docx\\|ppt\\|pptx\\|ppsx\\|xls\\|xlsx\\|odp\\)\\'" "libreoffice" (file))))
;;   )
(load "~/.emacs.d/loadpath/dired+.el")
;;(require 'dired-fixups)
(require 'dired-tar)
;; ;; (setq image-dired-track-movement nil)
(setq dired-listing-switches "-lGha --group-directories-first")
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
(add-hook 'dired-mode-hook 'auto-revert-mode)
(setq dired-auto-revert-buffer t)
(setq auto-revert-interval 0.5)
;; ;; ;;(setq auto-revert-mode t)
;; ;; ;;(setq global-auto-revert-mode t)
(setq auto-revert-verbose nil)

(setq dired-dwim-target t);; to process, by default, to the recently opened dired window.
(setq dired-recursive-copies (quote always)) ; “always” means no asking
;; ;; (setq dired-recursive-deletes (quote top)) ; “top” means ask once

;; ;; helm does this automatically
;; ;;(require 'dired-x);; C-x C-j to jump from a buffer directly to its directory.


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

;;(set-default-font "DejaVu Sans Mono")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AUCTex LaTeX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auctex
  :defer t
  :ensure t)

(setq sentence-end-double-space nil)

;;;; Just for indenting the LaTeX preprocessing operators: taken from:
;;;; https://emacs.stackexchange.com/questions/5439/auto-indenting-if-statements-with-auctex/5493
(setq LaTeX-begin-regexp "\\(?:begin\\|if@\\)\\b")
(setq LaTeX-end-regexp "\\(?:end\\|else\\|fi\\)\\b")
(defun LaTeX-indent-level-count ()
  "Count indentation change caused by all \\left, \\right, \\begin, and
\\end commands in the current line."
  (save-excursion
    (save-restriction
      (let ((count 0))
        (narrow-to-region (point)
                          (save-excursion
                            (re-search-forward
                             (concat "[^" TeX-esc "]"
                                     "\\(" LaTeX-indent-comment-start-regexp
                                     "\\)\\|\n\\|\\'"))
                            (backward-char)
                            (point)))
        (while (search-forward TeX-esc nil t)
          (cond
           ((looking-at "left\\b")
            (setq count (+ count LaTeX-left-right-indent-level)))
           ((looking-at "right\\b")
            (setq count (- count LaTeX-left-right-indent-level)))
           ((looking-at LaTeX-begin-regexp)
            (setq count (+ count LaTeX-indent-level)))
           ((looking-at "else\\b"))
           ((looking-at LaTeX-end-regexp)
            (setq count (- count LaTeX-indent-level)))
           ((looking-at (regexp-quote TeX-esc))
            (forward-char 1))))
        count))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
  (push '("\\\\boxplus\\>"		.	"⊞") ml/symbols)
  (push '("\\\\Vert\\>"			.	"||") ml/symbols)
  (push '("\\\\vert\\>"			.	"|") ml/symbols)
  (push '("\\\\citep\\>"		.	"♇") ml/symbols)
  (push '("\\\\textsuperscript\\>"	.	"⁺") ml/symbols)
  (push '("\\\\subref\\>"		.	"☞") ml/symbols)
  (push '("\\\\label\\>"		.	"🏷") ml/symbols)
  (push '("\\\\chapter\\>"		.	"🕅") ml/symbols)
  (push '("\\\\section\\>"		.	"§") ml/symbols)
  (push '("\\\\subsection\\>"		.	"§§") ml/symbols)
  (push '("\\\\subsubsection\\>"	.	"§§§") ml/symbols)
  (push '("\\\\pageref\\>"		.	"⎗") ml/symbols)
  (push '("\\\\eqref\\>"		.	"⎗☞") ml/symbols)
  (push '("\\\\bigl\\>"			.	"⎗!") ml/symbols)
  (push '("\\\\biggl\\>"		.	"⎗!") ml/symbols)
  (push '("\\\\Bigl\\>"			.	"⎗!") ml/symbols)
  (push '("\\\\Biggl\\>"		.	"⎗!") ml/symbols)
  (push '("\\\\bigr\\>"			.	"⎗!") ml/symbols)
  (push '("\\\\biggr\\>"		.	"⎗!") ml/symbols)
  (push '("\\\\Bigr\\>"			.	"⎗!") ml/symbols)
  (push '("\\\\Biggr\\>"		.	"⎗!") ml/symbols)
  (push '("\\\\mathbf\\>"		.	"⎗■") ml/symbols)
  (push '("\\\\frac\\>"			.	"⎗÷") ml/symbols)
  (push '("\\\\widehat\\>"		.	"◠") ml/symbols)
  (push '("\\\\textarabic\\>"		.	"ع") ml/symbols)
  (push '("\\\\text\\>"			.	"T") ml/symbols)
  (push '("\\\\tag\\>"			.	"T") ml/symbols)
  (push '("\\\\ldots\\>"		.	"…") ml/symbols)
  )
;;;; for example to enter ⊞: C-x 8 RET #x229E
;;;; ☿ ♃ ♄ ♅ ♆ 📄🗟 ∧⋀

(add-hook 'LaTeX-mode-hook '(lambda () (setq TeX-command-default "LaTeX")))
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
;;(add-hook 'LaTeX-mode-hook 'auto-fill-mode)

;;(add-hook 'LaTeX-mode-hook (lambda () (load "arabluatex.el")))

(defvar LaTeX-enumitem-key-val-options
  '(;;
    ("Ex. ")
    ("Def. ")
    ;; ("partopsep=0in,parsep=0in,topsep=0in,itemsep=0.1in,leftmargin=\\parindent")
    ("partopsep=0in,parsep=0in,topsep=0in,itemsep=0.0in,leftmargin=0.1in")
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
;;(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)

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
;; (setq TeX-engine (quote xetex))
;; (setq TeX-engine-alist
;;       '((xetex "XeTeX -shell escape"
;; 	       "xetex -shell-escape"
;; 	       "xelatex -shell-escape")))
(setq TeX-engine (quote luatex))
(setq TeX-engine-alist
      '((luatex "LuaTex -shell escape"
	            "luatex -shell-escape"
	            "lualatex -shell-escape")))

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
(global-set-key (kbd "C-c q") 'Mycls)
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c p")   'copy-and-comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-c e") 'eshell)
(global-set-key [(control return)]   'align-newline-and-indent)
(global-set-key (kbd "C-c C-p")   'print-buffer)
(global-set-key (kbd "C-c h g")   'helm-bibtex-with-local-bibliography)
(global-set-key (kbd "C-x g")   'magit-status)
(global-set-key (kbd "C-c s")   'fileloop-continue)


;;;;;;;;;;;;;;;;;;;;;;; Programming ;;;;;;;;;;;;;;;;


(add-hook 'magit-process-find-password-functions
            'magit-process-password-auth-source)
(use-package magit
  :init
  (add-hook 'magit-process-find-password-functions
          'magit-process-password-auth-source)
  :config
  (add-hook 'magit-process-find-password-functions
            'magit-process-password-auth-source)
  (setq
   auth-sources '("~/.authinfo.gpg")
   magit-diff-refine-hunk 'all
   ;; magit-process-find-password-functions '(magit-process-password-auth-source)
   ))

(use-package forge
  :after magit)

(ghub-request "GET" "/user" nil
              :forge 'github
              :host "api.github.com"
              :username "DrWaleedAYousef"
              :auth 'forge)

;;(use-package lua-mode)

(use-package php-mode
  )

(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  ;; (setq markdown-command "multimarkdown")
  (setq markdown-command "pandoc")
  )

(use-package markdown-preview-mode
  :init
  (setq  markdown-preview-auto-open (quote file))
  )

;;;;;;;;;;;;;;;;;;;;;;; Sage ;;;;;;;;;;;;;;;;

(use-package helm-sage)

;;;;;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;

(defun mp-display-message ()
  (interactive)
  ;;; Place your code below this line, but inside the bracket.
  (elpy-shell-switch-to-shell)
  (Mycls)
  (other-window -1)
  (elpy-shell-send-region-or-buffer)
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (when (load "flycheck" t t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  :config
  (setenv "WORKON_HOME" "~/Downloads/AAProgramsAA/anaconda3/envs/")
  (pyvenv-mode 1)
  ;; (pyvenv-workon "MyDefaultEnv")
  (pyvenv-workon "MyNewEnv")
  (setq elpy-shell-use-project-root nil)
  (setq elpy-project-root-finder-functions nil)
  (when (load "flycheck" t t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  )

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
               ("C-q"		.	company-abort)
               )))

(use-package company-quickhelp
  :init
  (eval-after-load 'company
    '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))
  )

(use-package twittering-mode
  :init
  (add-hook 'twittering-edit-mode-hook (lambda () (flyspell-mode)))
  :config
  (setq twittering-use-master-password t
	    twittering-icon-mode t
	    twittering-use-icon-storage t
	    twittering-convert-fix-size 48
	    twittering-display-remaining t
	    twittering-status-format "%i  %S, %RT{%FACE[bold]{%S}} %@  %FACE[shadow]{%p%f%L%r%FIELD-IF-NONZERO[ ↺%d]{retweet_count}%FIELD-IF-NONZERO[ Likes: %d]{retweet_count}}\n%FOLD[       ]{%T}\n"))
