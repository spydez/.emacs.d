;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------------------------------------------------
;; General Settings
;;------------------------------------------------------------------------------
(require 'with)

;;------------------------------------------------------------------------------
;; All of the transposes!
;;------------------------------------------------------------------------------

;; If I still need better/less common bigrams/chords...
;; https://english.stackexchange.com/a/110579
;; https://www.reddit.com/r/emacs/comments/22hzx7/what_are_your_keychord_abbreviations/

;; https://github.com/abo-abo/hydra/wiki/Emacs#Transpose
;; Hydra for all the transposes because all I ever remember is letter and word.
(with-all-features '(key-chord hydra)
  (defhydra spydez/hydra/transpose (:color red)
    "Transpose"
    ("c" transpose-chars "characters")
    ("w" transpose-words "words")
    ("l" transpose-lines "lines")
    ("s" transpose-sentences "sentences")
    ("p" transpose-paragraphs "paragraphs")
    ("x" transpose-sexps "sexprs")
    ("o" org-transpose-words "Org mode words")
    ("e" org-transpose-elements "Org mode elements")
    ("t" org-table-transpose-table-at-point "Org mode table")
    ("q" nil "cancel" :color blue))
  ;; Not sure about key chord... "cg" maybe better?
  ;; Going with 'tp' transpose and also 'p' is in the common-stuff hydra
  (spydez/key-chord/define-global "t" 'spydez/hydra/transpose/body))
;;  ;; else
;;  (spydez/warning/message nil nil
;;                          "Key-Chord or Hydra package not present. Cannot make spydez/hydra/transpose."))


;;------------------------------------------------------------------------------
;; Common Actions
;;------------------------------------------------------------------------------

;; Hydra for some random collection of things I happen to do a lot...
(with-feature 'hydra
  (defhydra spydez/hydra/grab-bag (:color blue ;; default exit heads
                                   :idle 1.0   ;; no help for this many seconds
                                   :hint nil)  ;; no hint - just fancy docstr
    "
^Signatures^                ^Org-Mode^
^----------^----------------^--------^------------
_s_: sig:  %-15`spydez/signature/short-pre  _n_: New Journal Entry
_-_: sig:  %-15`spydez/signature/name-post  _v_: Visit Journal
_t_: todo: %-15`spydez/signature/todo
_c_: todo: %-15(spydez/signature/todo/comment)
"
;; "%-15" for right-padded 15 length, which should be longer than these, which
;; should be longest signatures... Update as needed.
;;   (length (spydez/signature/todo/comment))
;;   (length spydez/signature/name-post)
    ("s" (spydez/signature/insert spydez/signature/short-pre))
    ("-" (spydez/signature/insert spydez/signature/name-post))
    ("t" (spydez/signature/insert spydez/signature/todo))
    ("c" (spydez/signature/insert spydez/signature/todo/comment))

    ("n" org-journal-new-entry)
    ("v" (funcall org-journal-find-file
                  (org-journal-get-entry-path))))

  ;; global keybind (can override minor mode binds)
  (bind-key* "C-," #'spydez/hydra/grab-bag/body))

;; (with-function 'spydez/hydra/grab-bag/body
;;   ;; global keybind (can override minor mode binds)
;;   (bind-key* "C-," spydez/hydra/grab-bag/body))


;; I want this one to be a way to visit and open common files...
;; Haven't wrapped my head around dynamic hydras yet though.
(with-all-features '(key-chord hydra)
  (defhydra spydez/hydra/common-stuff (:color blue)
    "Common Actions/Files"

    ;; this already has its own hydra
    ("w" spydez/hydra/engine-mode/body "web search" :exit t)

    ;; (if (bound-and-true-p spydez/file/auto-open-list)
    ;;     (let (;;(file-list spydez/file/auto-open-list)
    ;;           (i 1))
    ;;       (dolist (file spydez/file/auto-open-list)
    ;;         ;; hydra head is 1 through 0, so iter 1 through 10
    ;;         (when (and (<= i 10)
    ;;                    (not (null file)))
    ;;           ;; and then mod 10 to string for the head keybind
    ;;           ((number-to-string (% i 10))
    ;;            ;; our specific file in a lambda...
    ;;            (lambda () (find-file file))
    ;;            ;; and a helpful docstring
    ;;            (format "open %s" (file-name-nondirectory file))
    ;;            )))))
    )

  ;; "eu" is super convenient on Dvorak, but it's a bad combo for English words...
  ;; ".p" might work better... (one row up)
  ;; "-p"? Key chords that aren't English or Codelish are hard..ep.
  ;; double dash for the common hydra?
  (spydez/key-chord/define-global "-" 'spydez/hydra/common-stuff/body))
;; [2019-09-20]Switched from "if featurep"s to with, so lost this fail warning.
;; (spydez/warning/message nil nil
;;                         "Key-Chord or Hydra package not present. Cannot make spydez/hydra/common-stuff."))

;; TODO: make `with' better?
;; (<with-macro> <args>
;;  (:error <body>)
;;  <standard body>)


;; TODO: make a hydra here for... files and stuff with 'eu' keychord.
;;    TODO: add a 'reload-init' type func in it if I'm in the right project or something?

;; TODO: need macros and stuff for the open-files bit, I think?
;; And this looks like a close-enough-to-start:
;;   https://www.reddit.com/r/emacs/comments/3ba645/does_anybody_have_any_real_cool_hydras_to_share/cskfthg
;; soo.... what do I want? In the middle fo a defhydra, I want to provide two
;; lists,
;;   (spydez/py-range 0 10)
;; and
;;   'auto-open-files
;; and have it generate those entries.
;;
;; Alternatively we can do the hint define thing to have it just put them
;; in every time the hydra is called?


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; The End.
;;------------------------------------------------------------------------------
(provide 'finalize-keybinds)
