;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Lachlan Kermode"
      user-mail-address "lachiekermode@gmail.com")

;; FONTS, THEME et al
(setq doom-font (font-spec :family "Julia Mono" :size 20)
       doom-variable-pitch-font (font-spec :family "Julia Mono" :size 20))
(set-frame-parameter (selected-frame) 'alpha '(85 50))

(setq doom-theme 'doom-one)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(set-face-attribute 'default nil :height 120)
(setq display-line-numbers-type t)

;; ORG and DEFT
(setq PKB_DIR "~/Dropbox (Brown)/obsidian")
(setq org-directory PKB_DIR)
(after! org
        (setq org-log-done 'time) ;; add timestamps to DONE
)

(setq deft-extensions '("org" "md"))
(setq deft-directory PKB_DIR)

;; KEY REBINDINGS to make more vim-link
(map! "C-}"             #'next-buffer
      "C-t"             #'previous-buffer
      "C-o"             #'+neotree/open)

;; citations
;; following https://jonathanabennett.github.io/blog/2019/05/29/writing-academic-papers-with-org-mode/
(use-package helm-bibtex
    :custom
    (helm-bibtex-bibliography '("~/Dropbox (Brown)/obsidian/references/master.bib"))
    (reftex-default-bibliography '("~/Dropbox (Brown)/obsidian/references/master.bib"))
    (bibtex-completion-pdf-field "file")
    :hook (Tex . (lambda () (define-key Tex-mode-map "\C-ch" 'helm-bibtex))))

(use-package org-ref
    :custom
    (org-ref-default-bibliography "~/Dropbox (Brown)/obsidian/references/master.bib"))

(add-to-list 'org-latex-classes
            '("apa6"
                "\\documentclass{apa6}"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-latex-pdf-process
'("latexmk -pdflatex='pdflatex -output-directory build -interaction nonstopmode' -pdf -bibtex -f %f"))
