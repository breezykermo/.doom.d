;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Lachlan Kermode"
      user-mail-address "lachiekermode@gmail.com")

;; FONTS, THEME et al
(setq doom-font (font-spec :family "Hack" :size 20)
       doom-variable-pitch-font (font-spec :family "Hack" :size 20))
(set-frame-parameter (selected-frame) 'alpha '(100 50))

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

;; KEY REBINDINGS to make more vim-like
; (map! "C-}"             #'next-buffer
;       "C-t"             #'previous-buffer
;       "C-o"             #'+neotree/open)plans

(map! "C-}"             #'next-buffer)
(map! "C-t"             #'previous-buffer)

(map! :desc "Vim-like window movement up"
      "C-k"             #'evil-window-up)
(map! :desc "Vim-like window movement down"
      "C-j"             #'evil-window-down)
(map! :desc "Vim-like window movement left"
      "C-h"             #'evil-window-left)
(map! :desc "Vim-like window movement right"
      "C-l"             #'evil-window-right)
(map! :leader
      (:prefix ("w" . "window")
      :desc "Tmux-like window split"
      "c"               #'evil-window-split))
(map! :leader
      :desc "Faster access of agenda"
      "a"               #'org-agenda-list)

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

; (setq org-latex-pdf-process '("latexmk -shell-escape -bibtex -pdf %f"))
(setq org-latex-pdf-process
'("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))
; (setq org-latex-pdf-process (list
;    "latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

;; conversion from markdown to orgmode
(use-package! org-pandoc-import :after org)
