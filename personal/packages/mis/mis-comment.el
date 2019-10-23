;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------HELP!-------------------------------------
;;--                 My fancy header generator is broken...                   --
;;------------------------------------------------------------------------------


;; §-TODO-§ [2019-10-23]: refactor? or is ok. Dunno. Just wanna find out.

(require 'subr-x)

;;------------------------------------------------------------------------------
;; Consts & Vars
;;------------------------------------------------------------------------------

(defcustom mis/comment/padding-adjustments
  ;; pycodestyle E265: block comments should start with '# '.
  '((python-mode " ")) ;; "# " as padding for e.g. "# ---" instead of "#---".
  "Adjustments to `mis/comment/paddings' per mode.
e.g. python-mode can ask for a space after it's comment to ensure
pylint is happier w/ wrapped or centered comments generated by
these functions."
  :group 'mis
  :type '(alist :key-type symbol :value-type string))


;;------------------------------------------------------------------------------
;; Functions
;;------------------------------------------------------------------------------

(defun mis/comment/paddings (&optional with-adjustments)
  "Gets comment prefix/postfix appropriate for mode. Returns a
  parts list like e.g. elisp-mode: (\";;\" nil)"
  (let* ((adjustment
          (if with-adjustments
              (nth 1 (assoc major-mode
                            mis/comment/padding-adjustments))
            nil))
         (pad-more (comment-add nil))
         (prefix   (string-trim-right (comment-padright comment-start
                                                        pad-more)))
         (postfix  (comment-padleft comment-end (comment-add pad-more)))
         ;; if we have an adjustment, add it onto insides of paddings
         (prefix   (concat prefix (if (and prefix adjustment) adjustment)))
         (postfix  (concat adjustment (if (and postfix adjustment) postfix))))

    ;; and return
    (list prefix postfix)))
;; (mis/comment/paddings)
;; (nth 0 (mis/comment/paddings))
;; (nth 1 (mis/comment/paddings))
;; (length (nth 1 (mis/comment/paddings)))


(defun mis/comment/wrap (arg &optional trim concat-sep padding-adj)
  "Turns ARG into a string and then into a proper comment based
on mode (uses `comment-*' emacs functions).

If CONCAT-SEP is non-nil, use it instead of a space.

Passes PADDING-ADJ to `mis/comment/paddings' as
WITH-ADJUSTMENTS arg.

If TRIM is non-nil, trims resultant string before returning."
  (let* ((string (if (stringp arg) arg (format "%s" arg)))
         (concat-sep (or concat-sep " "))
         (comment-parts (mis/comment/paddings padding-adj))
         (prefix (nth 0 comment-parts))
         (postfix (nth 1 comment-parts))
         (comment (mapconcat 'identity
                             (list prefix string postfix) concat-sep)))
    (if trim
        (string-trim comment)
      comment)))
;; (mis/comment/wrap "foo")
;; (mis/comment/wrap "foo" t)
;; (mis/comment/wrap "---" nil "")
;; (mis/comment/wrap "")
;; (mis/comment/wrap (make-string 3 ?-) t "")
;; (mis/comment/wrap (make-string 3 ?-) t "" t)


(defun mis/comment/center/parts
    (comment &optional comment/fill-spaces? comment/fill-char
             indent borders paddings)
  "Returns a centered-comment parts list, ala
`mis/center/parts', but with prog-mode-specific
paddings (comment delimiters) assuming nil PADDINGS."
  (let* ((paddings (or paddings (mis/comment/paddings t))))
    (mis/center/parts comment
                                comment/fill-spaces?
                                comment/fill-char
                                paddings
                                borders
                                indent)))
;; (mis/comment/center/parts "hello?")
;; (mis/comment/center/parts "hello there" t)
;; (mis/comment/center/parts "hello there" nil nil 4)


(defun mis/comment/center
    (comment &optional comment/fill-spaces? comment/fill-char
             indent borders paddings)
  "Centers COMMENT string. Wraps it in comment characters (or
  PADDINGS if non-nil), gives it a border of BORDERS (or
  'mis/center' default if nil), and fills the center
  arount COMMENT with COMMENT/FILL-CHAR characters if
  COMMENT/FILL-SPACES? is non-nil."

  ;; build string from prog-mode parts section
  (mis/parts/build
   (mis/comment/center/parts comment
                                          comment/fill-spaces? comment/fill-char
                                          indent borders paddings)))
;; (mis/comment/center "Hello there.")
;; (mis/comment/center "Hello there." t)
;; (mis/comment/center "Hello there." t ?x)
;; (mis/comment/center "Hello there." nil ?x)
;; (mis/comment/center "")
;; (mis/comment/center "" t)
;; (mis/comment/center "test" t)
;; (mis/comment/center "foo" nil ?- 4)
;; (mis/comment/center "Hello, World!" nil nil nil '("-x" "y="))
;; (mis/comment/center "Hello, World!" nil nil nil '("-" "=") '(";;m" "m;;"))
;; (mis/comment/center "(will center on exit)")
;; (mis/comment/center "(will center on exit)" nil mis/center/char/border)


;;------------------------------------------------------------------------------
;; Tasks, Wants, Feature Requests, etc.
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; The End.
;;------------------------------------------------------------------------------
(provide 'mis-comment)