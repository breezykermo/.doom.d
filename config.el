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

;; ORG
(setq PKB_DIR "~/Dropbox (Brown)/lyt")
(setq org-directory PKB_DIR)
(setq org-deadline-warning-days 3)
(after! org
        (setq org-log-done 'time) ;; add timestamps to DONE
        (setq org-default-notes-file "/home/lox/Dropbox (Brown)/lyt/org/notes.org")
)

(after! citar
  (setq! citar-bibliography '("/home/lox/Dropbox (Brown)/lyt/references/master.bib")))
(require 'calfw)

;; REMAPS
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

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

; ATTEMPT TO HAVE MULTI TABLE FORMULAS
; https://emacs.stackexchange.com/questions/42604/org-table-spreadsheet-recalculate-all-tblfm-lines
(defun cmdbufmod-prepare (bufmod-list &optional start bound)
  "Prepare buffer for `cmdbufmod' with modifications BUFMOD-LIST.
See `cmdbufmod' for the format of BUFMOD-LIST.
If START is a buffer position the search for the regular expressions in BUFMOD-LIST
starts there. Otherwise it starts at `point-min'.
Optional BOUND limits the search.
Return the list of original text sections.
Each text section is a cons of an insertion marker and the old text
that needs to be restored there."
  (unless start (setq start (point-min)))
  (let (original-list)
    (save-excursion
      (dolist (bufmod bufmod-list)
    (let ((place (car bufmod))
          (newtext (cdr bufmod)))
      (goto-char start)
      (while (if (functionp place)
               (funcall place bound)
              (re-search-forward place bound t))
        (setq original-list
          (cons (cons (set-marker (make-marker) (match-beginning 0))
                  (match-string 0))
            original-list))
        (replace-match (propertize (if (functionp newtext)
                       (funcall newtext)
                     newtext)
                       'cmdbufmod t 'rear-nonsticky '(cmdbufmod)))))))
    original-list))

(defun cmdbufmod-cleanup (original-list)
  "Restore original text sections from ORIGINAL-LIST.
See the return value of `cmdbufmod-prepare' for the structure of ORIGINAL-LIST."
  (cl-loop for interval being the intervals property 'cmdbufmod
       if (get-text-property (car interval) 'cmdbufmod)
       do (delete-region (car interval) (cdr interval)))
  (cl-loop for original in original-list do
       (goto-char (car original))
       (insert (cdr original))))

(defun cmdbufmod (bufmod-list fun &rest args)
  "After applying BUFMOD-LIST to current buffer run FUN with ARGS like `apply'.
BUFMOD is a list of buffer modifications. Each buffer modification
is a cons \(PLACE . NEWTEXT).
PLACE can be a regular expression or a function.
If PLACE is a function it should search for the next place to be replaced
starting at point. It gets the search bound as an argument,
should set match-data like `re-search-forward',
and return non-nil if a match is found.
If PLACE is a regular expression it is treated like the function
\(lambda () (re-search-forward PLACE nil t))

NEWTEXT can be a replacement string or a function.
A function should return the string for `replace-match'."
  (let (original-list)
    (unwind-protect
        (progn
          (save-excursion
            (setq original-list (cmdbufmod-prepare bufmod-list)))
          (apply fun args))
      (save-excursion (cmdbufmod-cleanup original-list)))))

(defconst org-table-multi-tblfm-re "[[:space:]]*#\\+TBLFM:"
  "Regular expression identifying \"#+TBLFM:\" at the beginning of lines.
Don't include a leading carret here!")

(defun org-table-multi-tblfm-search (&optional bound)
  "Search for next \"#\\+TBLFM:\"-line that is preceded by another such line.
If BOUND is non-nil search stops there or at `point-max' otherwise.
The match-data is set to the match of \"[[:space:]]*\n[[:space:]]*#\\+TBLFM:[[:\" at the beginning of line."
  (interactive) ;; for testing
  (let ((re (concat "[[:space:]]*\n" org-table-multi-tblfm-re "[[:space:]]*"))
        found)
    (while (and (setq found (re-search-forward re bound t))
                (null
                 (save-excursion
                   (forward-line -1)
                   (looking-at-p org-table-multi-tblfm-re)))))
    found))

(defun org-table-multi-tblfm (oldfun &rest args)
  "Replace buffer local table formulas when calling OLDFUN with ARGS."
  (if (looking-at-p (concat "[[:space:]]*\n" org-table-multi-tblfm-re))
      (apply oldfun args)
    (cmdbufmod '((org-table-multi-tblfm-search . "::")) oldfun args)))

(advice-add 'org-table-recalculate :around #'org-table-multi-tblfm)
