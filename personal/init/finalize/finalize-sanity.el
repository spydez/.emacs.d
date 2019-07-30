;; -*- mode: emacs-lisp; lexical-binding: t -*-

;;------------------------------------------------------------------------------
;; Modes and vars.
;;------------------------------------------------------------------------------

;; Helm should be enabled, not ido?
(when (bound-and-true-p ido-mode)
 (error "Ido Mode should not be enabled right now?"))


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'finalize-sanity)
