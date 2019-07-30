;; -*- mode: emacs-lisp; lexical-binding: t -*-


;;------------------------------------------------------------------------------
;; General Settings
;;------------------------------------------------------------------------------

;; Setting up virtualenv to use with python:
;;   http://nhoffman.github.io/.emacs.d/#org766cea6
;; Works for pythons 2 and 3.


;;------------------------------------------------------------------------------
;; Python
;;------------------------------------------------------------------------------

;; TODO: python-mode vs elpy...?
;; https://github.com/jorgenschaefer/elpy

;; I know I have settings in hook in old .emacs
;; but for now, just... leave all this commented out until I get to it.
(defun spydez/hook/python-mode ()
  ;; (setq tab-width ...
  ;;       py-indent-offset ...
  ;;       py-smart-indentation ...)
  ;; TODO: I probably want most or all of these, or some competing package/feature
  ;; (these from still-barebones csharp)
;  (paredit-mode 1)
;  (omnisharp-mode 1)
;  (my/disable-paredit-spaces-before-paren)
;  (company-mode 1)
;  (yas-minor-mode 1)
;  (flycheck-mode 1)
  )

;; python-mode itself comes with emacs now.
;; (setq python-fill-docstring-style 'django)

;; Django has several modes for different parts:
;; https://code.djangoproject.com/wiki/Emacs
;;   - i.e. the python, the html, the css,
;;     the templates w/ html and template language interwoven


;;------------------------------------------------------------------------------
;; Compilation
;;------------------------------------------------------------------------------
;; TODO: Is this key the usual for compiling? Do I need to compile?
;; Is there a better key? `C-c C-c' is/was comment-region in cpp-mode and
;; I like that command...
(eval-after-load 'python-mode
  '(bind-key "C-c C-c" 'compile python-mode-map))


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------
;; TODO: check out python in emacs repl?

;; TODO: django mode?


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'configure-python)
