;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Lachlan Kermode"
      user-mail-address "lachiekermode@gmail.com")

;; FONTS, THEME et al
(setq doom-font (font-spec :family "sourcecodepro" :size 20)
       doom-variable-pitch-font (font-spec :family "sans" :size 20))
(set-frame-parameter (selected-frame) 'alpha '(85 50))

(setq doom-theme 'doom-one)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(set-face-attribute 'default nil :height 120)
(setq display-line-numbers-type t)

;; ORG, ORG-ROAM and DEFT
(setq PKB_DIR "~/Dropbox/obsidian")
(setq ORG_EXTS '("org" "md"))
(setq org-directory PKB_DIR)
(setq org-roam-directory PKB_DIR)
(setq org-roam-file-extensions ORG_EXTS)

(use-package org-roam :ensure t)
(use-package md-roam
  :config
  (setq org-roam-title-sources '((mdtitle title mdheadline headline) (mdalias alias)))
  (setq md-roam-file-extension-single "md"))

(after! org
        (setq org-log-done 'time) ;; add timestamps to DONE
)

(setq deft-extensions ORG_EXTS)
(setq deft-directory PKB_DIR)

;; KEY REBINDINGS to make more vim-link
(map! "C-}"             #'next-buffer
      "C-{"             #'previous-buffer
      "C-o"             #'+neotree/open)

(add-to-list 'org-file-apps '("pdf" . "zathura %s"))
