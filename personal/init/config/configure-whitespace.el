;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------------------------------------------------
;; Tab Settings
;;------------------------------------------------------------------------------
;; https://www.emacswiki.org/emacs/NoTabs
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Just-Spaces.html
;; https://www.emacswiki.org/emacs/TabsAreEvil
;; https://www.emacswiki.org/emacs/SmartTabs

;; always replace tabs with spaces
(customize-set-variable 'indent-tabs-mode nil
                        "Indent with spaces, never tabs.")
;; set default tab width for all buffers
(customize-set-variable 'tab-width spydez/dev-env/tab/normal
                        "Default tab-width to my normal (not min) width.")

;; TODO: do I need a tab-stop-list? What's it used in? Not prog-modes...
;; https://www.emacswiki.org/emacs/TabStopList
;; (setq tab-stop-list (spydez/range 0 120 spydez/tab-width))
;; TODO: range function is in lisp/misc-functions... load them earlier?

;; NOTE: M-x tabify and M-x untabify exist and work on regions.

;; TODO: this is not a tab thing... if start using put in right section.
  ;; TODO: is this global or per-mode in old .emacs?
  ;; New lines are always indented
  ;;(global-set-key (kbd "RET") 'newline-and-indent)


;;------------------------------------------------------------------------------
;; Trailing Whitespace.
;;------------------------------------------------------------------------------

;; https://melpa.org/#/ws-butler
;; Only removes whitespace from regions you've changed.
;; Trial: [2019-07-30 Tue]
(use-package ws-butler
  :demand t

  ;;----------
  :custom
  ;;----------
  (ws-butler-convert-leading-tabs-or-spaces t)

  ;;----------
  :config
  ;;----------

  ;; For a bug. See for more info:
  ;;  (spydez/help/issue/path "whitespace-and-butler" "move-to-column.org")
  ;;  (spydez/help/issue/visit "whitespace-and-butler" "move-to-column.org")
  (defun spydez/advice/move-to-column/force-fix (args)
    "Un-lose the one single space that's being lost sometimes."
    (let ((column (nth 0 args))
          (force (nth 1 args)))

      ;; bug conditions:
      ;;   1. whitespace-mode is on
      ;;   2. move-to-column is called with 'force' set true.
      ;;   3. ws-butler-keep-whitespace-before-point is on
      ;; Number 3 isn't actually necessary but it's the only time I've
      ;; noticed this bug (aside from contriving it in bug hunts/repros).
      (when (and (or global-whitespace-mode whitespace-mode)
                 force
                 ;; Not needed but ws-butler is what triggers this all the time
                 ;; so I'll contain my brute force fix to only work if ws-butler
                 ;; is setup to expect move-to-column to restore point.
                 ws-butler-keep-whitespace-before-point)
        ;; Possibly a bugged move-to-column... Let's figure out how far we
        ;; have to go.
        (save-excursion
          (let ((at-last-line (> (forward-line 1) 0)))
            (unless at-last-line (forward-line -1))
            (move-end-of-line nil)
            (when (and (> column (current-column))
                       (not at-last-line))
              ;; We're in bug territory, and we want past current EOL, and this
              ;; line has a '\n' in it, so I think we have a bugged
              ;; move-to-column case. Up by one to offset for move-to-column's
              ;; off-by-one-in-this-instance bug.
              (setq column (1+ column))))))
      ;; return list of (fixed or ignored) inputs
      (list column force)))
  ;; And now add our shenanigan to the function...
  (advice-add 'move-to-column
              :filter-args #'spydez/advice/move-to-column/force-fix)
  ;;(advice-remove 'move-to-column #'spydez/advice/move-to-column/force-fix)

  ;; Turn on ws-butler globally.
  ;; NOTE: if I want to exclude modes, can do via customizing of variable
  ;;   `ws-butler-global-exempt-modes'.
  (ws-butler-global-mode 1))


;;------------------------------------------------------------------------------
;; Whitespace in General.
;;------------------------------------------------------------------------------

;; Trial: [2019-07-16 Tue]
;; ...Finally. Took long enough to figure out making things look ok.
;; (set-face-attribute ...) kids. Helps a lot when your theme has
;; defaults that you can just steal and tweak.
(use-package whitespace
  ;; TODO: delete this when ws-butler/whitespace-mode bug issue resolved.
;;  :disabled ;; this is fucking up ws-butler, which is just hilarious... -_-
  :ensure nil
  :demand t

  ;;----------
  :init
  ;;----------
  (spydez/hook/defun org-mode-hook t
      "whitespace-mode" "org-mode" "init/config/configure-whitespace.el"
    "I like some whitespace-mode stuff in org-mode, but want less
than other modes."
    ;; make a local copy of whitespace-style we can modify and...
    (set (make-local-variable 'whitespace-style)
         ;; ...set it as old one with removed 'too-long line' highlighting
         (remove 'lines-tail whitespace-style)))

  ;;----------
  :hook
  ;;----------
  (org-mode . spydez/hook/whitespace-mode/org-mode)

;; ws-butler Trial: [2019-07-30 Tue]
;;   ;;----------
;;   :hook
;;   ;;----------
;;   ;; This... Doesn't work here? Doesn't get called.
;;   ;; Trial: [2019-07-11 Thu]
;;   ;; https://batsov.com/articles/2011/11/25/emacs-tip-number-3-whitespace-cleanup/
;;   (before-save-hook . whitespace-cleanup)

  ;;----------
  :custom
  ;;----------
  (whitespace-line-column nil
   (concat "Set 'lines-tail/'lines in `whitespace-style' to base "
           "off of `fill-column' instead of just 80."))

  (whitespace-style
   (quote
    ;;---
    ;; visualization via faces (see set-face-attribute below)
    ;;---
    (face

     ;;---
     ;; general/normal whitespace
     ;;---
     tabs spaces newline

     ;;---
     ;; the bad kind
     ;;---
     trailing space-before-tab space-after-tab

     ;; `empty' lines were annoying as emacs or whitespace is bad at cleaning up
     ;; the visualization when the line is no longer matching this whitespace
     ;; warning type.
     ;;empty       ;; ...lines (...at beginning/end of buffer)

     lines-tail  ;; `lines' would be whole line...
     ;; lines-tail is just whatever's past fill-column

     ;;---
     ;; not sure if want or bad or what.
     ;;---
     indentation

     ;;---
     ;; visualize these whitespaces with non-whitespace chars via display-table
     ;;---
     space-mark tab-mark newline-mark)))

  ;; (whitespace-style ;; minus `face'
  ;; '(tabs spaces trailing lines space-before-tab newline
  ;;                     indentation empty space-after-tab space-mark
  ;;                     tab-mark newline-mark))

  ;;----------
  :config
  ;;----------

  ;; ws-butler Trial: [2019-07-30 Tue]
  ;; ;; Why does this not work in :hook section? -_-
  ;; (add-hook 'before-save-hook 'whitespace-cleanup)
  ;; ;; May want ws-butler for less greedy cleanup, especially on work source repos

  ;; TODO: A way to tell use-package to load after zenburn if
  ;; zenburn is going to load? (eval-after-load ...)?
  (require 'with)
  (with-feature 'zenburn-theme
    ;; Change color/faces of whitespace attributes.
    ;; Defaults are ugly/distracting/meh. Make 'em more backgroundy.
    (zenburn-with-color-variables
      ;; bg+3 looks good, I think, for "noticible but not in your face"
      ;; bg+2 might be better after I get used to things...
      ;;   Yeah.

      ;;--------
      ;; General
      ;;--------
      (set-face-attribute 'whitespace-space nil
                          :foreground zenburn-bg+2
                          :background zenburn-bg)

      (set-face-attribute 'whitespace-hspace nil
                          :foreground zenburn-bg+2
                          :background zenburn-bg)

      ;; Red bg was a bit too poppy-outty. Set to something a bit tamer.
      (set-face-attribute 'whitespace-tab nil
                          ;; orange works about the same as red+2
                          ;; :foreground zenburn-orange
                          :foreground zenburn-red+2
                          :background zenburn-bg)
                          ;; Original:
                          ;; :foreground zenburn-bg+2
                          ;; :background zenburn-red-1)

      ;; Red bg was a bit too poppy-outty. Set to something a bit tamer.
      (set-face-attribute 'whitespace-trailing nil
                          ;; orange works about the same as red+2
                          ;; :foreground zenburn-orange
                          :foreground zenburn-red+2
                          :background zenburn-bg)
                          ;; Original:
                          ;; :foreground zenburn-bg+1
                          ;; :background zenburn-red)


      ;;---------
      ;; Org-Mode
      ;;---------

      ;; org-indent-mode has a problem with a white foreground for the 'fake'
      ;; whitespace it uses in front of indented notes beneath headers.

      ;; This face, `org-indent', is not the problem. It's the indented area
      ;; before the problem whitespace. *sigh* The problem is
      ;; `org-indent-boundry-char', and I'm not sure how to hide it exactly.
      ;;
      ;; Note:
      ;;   Fixed in:
      ;;     GNU Emacs 26.1 (build 1, x86_64-w64-mingw32) of 2018-05-30
      ;;     Org mode version 9.1.9 (release_9.1.9-65-g5e4542)
      ;;   On:
      ;;     [2019-07-31 Wed]
      ;;
      ;; `org-indent-boundry-char' was always being inserted into indent
      ;; array as a separate, un-faced character so it didn't use this face.
      ;; I have advised the function that creates the arrays, but it may
      ;; crop up again in the next version(s).
      (set-face-attribute 'org-indent nil
                          :inherit 'org-hide
                          :foreground zenburn-bg-05
                          :background zenburn-bg-05)

      ;; TRIAL: [2019-08-28]
      ;; Trying out my custom zenburn-magenta-bg. Magenta FG was just too
      ;; eye-stabby. Could go to -1 or -2 if not obvious enough.
      (set-face-attribute 'whitespace-line nil
                          :foreground nil ;; use whatever other things want (comments, code)
                          :background spydez/theme/color/zenburn-magenta-bg-1)
                          ;; originally:
                          ;; :foreground zenburn-magenta
                          ;; :background zenburn-bg)


      ;;--------
      ;; Not Set
      ;;--------

      ;; This is too bright, and annoying. Tone down if added back into
      ;; `whitespace-style'.
      ;; (set-face-attribute 'whitespace-space-after-tab nil
      ;;                     :foreground zenburn-red
      ;;                     :background zenburn-yellow)

      ;; Don't think any of these are customized right now.
      ;; (set-face-attribute 'whitespace-newline nil
      ;;                     :foreground zenburn-bg+1)
      ;;
      ;;
      ;; (set-face-attribute 'whitespace-space-before-tab nil
      ;;                     :foreground zenburn-orange
      ;;                     :background zenburn-orange)
      ;;
      ;; (set-face-attribute 'whitespace-indentation nil
      ;;                     :foreground zenburn-red
      ;;                     :background zenburn-yellow)
      ;;
      ;; (set-face-attribute 'whitespace-empty nil
      ;;                     :background zenburn-yellow)
      ;;
      ))

  (global-whitespace-mode 1) ;; positive: enable, other: disable
  )


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'configure-whitespace)
