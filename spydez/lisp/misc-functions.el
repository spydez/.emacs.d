;; -*- emacs-lisp -*-


;;-----------------------------------elisp--------------------------------------
;;--                       Misc Functions for Elisp.                          --
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; General Settings?
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; dos2unix Type Functions
;;------------------------------------------------------------------------------

(defun spydez/to-unix-auto ()
  "Change the current buffer's line-ends to Unix, preserving the coding system."
  (interactive)
  (let ((coding-str (symbol-name buffer-file-coding-system)))
    (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
      (setq coding-str
            (concat (substring coding-str 0 (match-beginning 0)) "-unix"))
      (message "CODING: %s" coding-str)
      (set-buffer-file-coding-system (intern coding-str)) )))

(defun spydez/to-unix-utf8 ()
  "Change the current buffer to UTF-8 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-unix t))


;;------------------------------------------------------------------------------
;; Misc Utility Functions
;;------------------------------------------------------------------------------

(defun spydez/range (start count &optional step-size)
  (let ((step (if (integerp step-size) step-size 1)))
    (loop repeat count for i from start by step collect i)))

;; I think this is better right where it's used as it's just the once.
;; (defun spydez/auto-open-files () 
;;   (if (and window-system (boundp 'spydez/auto-open-list))
;;       (dolist (file spydez/auto-open-list)
;;         (find-file file))))


;;------------------------------------------------------------------------------
;; Whitespaces And Deletion Functions
;;------------------------------------------------------------------------------

;; TODO: these seem... like things emacs already does, I think? Maybe they avoid
;; kill ring or something.

(defun spydez/delete-word (arg)
  "Kill characters forward until encountering the end of a word. With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun spydez/backward-delete-word (arg)
  "Kill characters backward until encountering the beginning of a word. With argument, do this that many times."
  (interactive "p")
  (spydez/delete-word (- arg)))

;; From: http://www.emacswiki.org/cgi-bin/wiki/DeletingWhitespace
(defun spydez/whack-whitespace (arg)
  "Delete all white space from point to the next word.  With prefix ARG
   delete across newlines as well.  The only danger in this is that you
   don't have to actually be at the end of a word to make it work.  It
   skips over to the next whitespace and then whacks it all to the next
   word."
  (interactive "P")
  (let ((regexp (if arg "[ \t\n]+" "[ \t]+")))
    (re-search-forward regexp nil t)
    (replace-match "" nil nil)))


;;------------------------------------------------------------------------------
;; Dates & Times
;;------------------------------------------------------------------------------

(setq spydez/yyyy-mm-dd "%Y-%m-%d")
(setq spydez/dd-mon-yy "%d %b %y")
(defun spydez/next-friday (format)
  (let ((today (nth 6 (decode-time (current-time)))))
    (format-time-string 
     format
     (time-add 
      (current-time) 
      (days-to-time 
       (if (eq 5 today) ; saturday is only day bigger than friday
           6
         (- 5 today)))))))


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------

;; TODO: I don't think I use any of these, so they might just be better as gone.

;; TODO: A smaller, quicker prefix to both provide a clean auto-complete for
;; these interactive funcs and let them be a bit more discoverable.

;; Also these are ~10 years old and back when I knew almost enough about
;; emacs/elisp to set it up correctly. There may be some that don't need
;; to exist (anymore).


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'misc-functions)
