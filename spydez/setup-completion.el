;; -*- emacs-lisp -*-

;; setup-completion.el - Helm, ido, ivy, etc...

;; I was using ido in previous .emacs setup. Fuzzy file completion is a must for
;; whatever I'll be using now.

;; ido:
;;   old ido setup: https://github.com/spydez/emacs/blob/master/libs/custom/ido-config.el
;;   ido intro blog: https://www.masteringemacs.org/article/introduction-to-ido-mode

;; Helm:
;;   Hacker News replies about Helm: https://news.ycombinator.com/item?id=11100312

;;------------------------------------------------------------------------------
;; Trial: Helm package
;;------------------------------------------------------------------------------
;; Try out this newfangle Helm thing...

;;------------------------------------------------------------------------------
;; Disabled: ido package
;;------------------------------------------------------------------------------
;; used to use ido - disabling it for a test of Helm

;; combination of my old ido setup and zzamboni's to try to modernize it:
;; https://github.com/zzamboni/dot-emacs/blob/master/init.org
;; but I'm starting off with it disabled for Helm trial, so not sure how working this is.

(use-package ido
  :disabled
  :config
  (ido-mode t)
  (ido-everywhere 1)
  (setq ido-ignore-buffers '("\\` " "^\*" ".*Completion" "^irc\." "\.TAGS$") ; ignore buffers like these
        ido-case-fold t               ; be case-insensitive
        ido-enable-flex-matching t    ; be flexable in search if nothing better
        ido-use-filename-at-point nil ; annoying:       try to use filename...
        ido-use-url-at-point nil      ; quite annoying: ... or url at point
        ido-use-virtual-buffers t     ; if recentf enabled, allow visit to recently closed files
        ido-auto-merge-work-directories-length -1 ; ido should let me make my new file instead of going on a search for it
        ; ido-max-prospects 5             ; don't spam my minibuffer
        ; ido-confirm-unique-completion t ; wait for RET, even with unique completion
        ))

(use-package ido-completing-read+
  :disabled
  :config
  (ido-ubiquitous-mode 1))

;; ido-related function for find in tags...
;; Can enable and get working if I'm back in a place with ido and tags files.
;; (defun spydez/ido/find-file-in-tag-files ()
;;   (interactive)
;;   (save-excursion
;;     (let ((enable-recursive-minibuffers t))
;;       (visit-tags-table-buffer))
;;     (find-file (ido-completing-read "Project file: "
;;                          (tags-table-files)
;;                          nil t))))
;; 
;; (global-set-key "\C-cf" 'spydez/ido/find-file-in-tag-files)