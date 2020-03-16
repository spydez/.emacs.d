;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------HELP!-------------------------------------
;;--                 My fancy header generator is broken...                   --
;;------------------------------------------------------------------------------


(require 'subr-x)
;; Want s.el for `s-trim', but don't want to require as we use other
;; parts of mis2 very early in init before packages.
;; (require 's)

(require 'mis2-parts)
(require 'mis2-center)

;;------------------------------------------------------------------------------
;; Consts & Vars
;;------------------------------------------------------------------------------

(defcustom mis2/comment/border-adjustments
  ;; pycodestyle E265: block comments should start with '# '.
  '((python-mode " ")) ;; "# " as border for e.g. "# ---" instead of "#---".
  "Adjustments to `mis2/comment/borders' per mode.
e.g. python-mode can ask for a space after it's comment to ensure
pylint is happier w/ wrapped or centered comments generated by
these functions."
  :group 'mis2
  :type '(alist :key-type symbol :value-type string))


;;------------------------------------------------------------------------------
;; Commands
;;------------------------------------------------------------------------------

;; May want "no border" instead of "no trim" for interactive?..
(defun mis2/comment/center (from to &optional trim)
  "Centers region marked by FROM and TO.

Interactively, a prefix arg means \"do not trim\".

Non-interactively, if TRIM is non-nil, lines will be trimmed just before
re-centering, otherwise they will only be recentered."
  (interactive (progn
                 (barf-if-buffer-read-only)
                 (list (region-beginning)
                       (region-end)
                       ;; No trim if yes prefix arg
                       (null current-prefix-arg))))

  (let ((start-point (point-marker))
        (start-bol (line-beginning-position))
        (start-eol (line-end-position))
        (start (min from to))
        (end (max from to)))

    ;; Mark end.
    (goto-char end)
    ;; We don't want a line with no actual characters selected.
    (when (= (line-beginning-position) (point))
      (forward-line -1)
      ;; But where to go now? Gotta make sure region is valid...
      (goto-char (max (line-end-position) start)))
    ;; Whatever line we're on now... Sure. This is the end.
    (end-of-line)
    (setq end (copy-marker (point) t))

    ;; Go back to start to get ready for loop.
    (goto-char start)
    (beginning-of-line)

    ;; Center region marked by current point & end.
    (while (< (point) end)
      ;; strip comment chars...
      (uncomment-region (line-beginning-position) (line-end-position))

      ;; trim line and center
      (let* ((line (delete-and-extract-region (line-beginning-position)
                                              (line-end-position)))
             (line (if trim (s-trim line) line))
             (centered (mis2/comment/center/build line)))

        ;; Re-insert.
        ;; `delete-and-extract-region' puts at at start of region so
        ;; just `insert'.
        (insert centered)

        ;; Update loop condition.
        (forward-line 1)))

    ;; go back to where we were
    (goto-char start-point)
    (set-marker start-point nil)))
;;test
;;    test


;;------------------------------------------------------------------------------
;; Main Entry Point?
;;------------------------------------------------------------------------------

(defun mis2/comment/center/build
    (comment &optional comment/fill-spaces? comment/fill-char
             indent paddings borders)
  "Centers COMMENT string. Wraps it in comment characters (or
  BORDERS if non-nil), gives it a padding of PADDINGS (or
  'mis2/center' default if nil), and fills the center
  arount COMMENT with COMMENT/FILL-CHAR characters if
  COMMENT/FILL-SPACES? is non-nil."

  (mis2/comment/unless
    ;; build string from prog-mode parts section
    (mis2/parts/build
     (mis2/comment/center/parts comment
                               comment/fill-spaces? comment/fill-char
                               indent paddings borders))))
;; (mis2/comment/center/build "Hello there.")
;; (mis2/comment/center/build "Hello there." t)
;; (mis2/comment/center/build "Hello there." t ?x)
;; (mis2/comment/center/build "Hello there." nil ?x)
;; (mis2/comment/center/build "")
;; (mis2/comment/center/build "" t)
;; (mis2/comment/center/build "test" t)
;; (mis2/comment/center/build "foo" nil ?- 4)
;; (mis2/comment/center/build "Hello, World!" nil nil nil '("-x" "y="))
;; (mis2/comment/center/build "Hello, World!" nil nil nil '("-" "=") '(";;m" "m;;"))
;; (mis2/comment/center/build "(will center on exit)")
;; (mis2/comment/center/build "(will center on exit)" nil mis2/center/char/padding)


(defun mis2/comment/wrap (arg &optional trim concat-sep border-adj)
  "Turns ARG into a string and then into a proper comment based
on mode (uses `comment-*' emacs functions).

If CONCAT-SEP is non-nil, use it instead of a space.

Passes BORDER-ADJ to `mis2/comment/borders' as
WITH-ADJUSTMENTS arg.

If TRIM is non-nil, trims resultant string before returning."
  (mis2/comment/unless
    (let* ((string (if (stringp arg) arg (format "%s" arg)))
           (concat-sep (or concat-sep " "))
           (comment-parts (mis2/comment/borders border-adj))
           (prefix (nth 0 comment-parts))
           (postfix (nth 1 comment-parts))
           (comment (mapconcat 'identity
                               (list prefix string postfix) concat-sep)))
      (if trim
          (string-trim comment)
        comment))))
;; (mis2/comment/wrap "foo")
;; (mis2/comment/wrap "foo" t)
;; (mis2/comment/wrap "---" nil "")
;; (mis2/comment/wrap "")
;; (mis2/comment/wrap (make-string 3 ?-) t "")
;; (mis2/comment/wrap (make-string 3 ?-) t "" t)


(defun mis2/comment/ignore ()
  "Guesses whether to ignore everything based on Emacs' comment-* vars/funcs."
  ;; first try: if comment-start is null, ignore.
  (null comment-start))


(defmacro mis2/comment/unless (&rest body)
  "Runs BODY forms if `mis2/comment/ignore' is non-nil."
  (declare (indent defun))
  `(unless (mis2/comment/ignore)
     ,@body))


;;------------------------------------------------------------------------------
;; Functions
;;------------------------------------------------------------------------------

(defun mis2/comment/borders (&optional with-adjustments)
  "Gets comment prefix/postfix appropriate for mode. Returns a
  parts list like e.g. elisp-mode: (\";;\" nil)"
  (mis2/comment/unless
    (let* ((adjustment
            (if with-adjustments
                (nth 1 (assoc major-mode
                              mis2/comment/border-adjustments))
              nil))
           (pad-more (comment-add nil))
           ;; pad and trim as applicable
           (prefix   (comment-padright comment-start pad-more))
           (prefix   (if (stringp prefix) (string-trim-right prefix) prefix))
           (postfix  (comment-padleft comment-end pad-more))
           (postfix  (if (stringp postfix) (string-trim-left postfix) postfix))
           ;; if we have an adjustment, add it onto the insides of borders
           (prefix   (concat prefix (if (and prefix adjustment)
                                        adjustment)))
           (postfix  (concat (if (and postfix adjustment) adjustment)
                             postfix)))

      ;; and return
      (list prefix postfix))))
;; (mis2/comment/borders)
;; (nth 0 (mis2/comment/borders))
;; (nth 1 (mis2/comment/borders))
;; (length (nth 1 (mis2/comment/borders)))


(defun mis2/comment/center/parts
    (comment &optional comment/fill-spaces? comment/fill-char
             indent paddings borders)
  "Returns a centered-comment parts list, ala
`mis2/center/parts', but with prog-mode-specific
borders (comment delimiters) assuming nil BORDERS."
  (mis2/comment/unless
    (let* ((borders (or borders (mis2/comment/borders t))))
      (mis2/center/parts comment
                        comment/fill-spaces?
                        comment/fill-char
                        nil
                        borders
                        paddings
                        indent))))
;; (mis2/comment/center/parts "hello?")
;; (mis2/comment/center/parts "hello there" t)
;; (mis2/comment/center/parts "hello there" nil nil 4)


;;------------------------------------------------------------------------------
;; Tasks, Wants, Feature Requests, etc.
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; The End.
;;------------------------------------------------------------------------------
(provide 'mis2-comment)