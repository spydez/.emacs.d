;; -*- emacs-lisp; lexical-binding: t -*-


;;------------------------------------------------------------------------------
;; Master List & Reason I'm Doing System/Hash.
;;------------------------------------------------------------------------------

;; C-u C-x C-e with point on end of next line to find out your hash:
;;   spydez/setup/system/hash
;;   e.g.: "computer-898a-27ab"
;; This is so bootstrap-this-early.el can live in its proper home, and be found with
;; an easy (load ...) or (require ...)

;; Find this system, setup domain names, reform reduced hash string.
(defvar spydez/bootstrap/system/known-p t)
(cond ;; switch case on system name hashes

 ;;---
 ;; Next System Here:
 ;;---
 ;; ((equal spydez/setup/system/hash "<something>")
 ;;  (setq spydez/setup/domain/name "home"
 ;;        spydez/setup/domain/subname "comp"
 ;;        spydez/setup/system/hash (spydez/hash-and-reduce spydez/setup/system/name spydez/setup/domain/subname)))

 ;;---
 ;; Home Desktop 2017-
 ;;---
 ((equal spydez/setup/system/hash "computer-2418-d188")
  (setq spydez/setup/domain/name "home"
        ;; I never know what to call my home stuff...
        ;;   - Name it after less popular OSes? Like Plan 9 from Bell Labs?
        ;;   - Name it an androgynous name? Like Sasha from this list?
        ;;     https://en.wikipedia.org/wiki/Unisex_name#English
        ;;   - Name it an element, like back when I was doing that? But I got
        ;;     stuck on Boron for a phone and then there were 3 borons and it
        ;;     got confusing...
        ;; Also, this is just the prefix for a hash (right now), so...
        spydez/setup/domain/subname "plan9"
        spydez/setup/system/hash (spydez/hash-and-reduce spydez/setup/system/name spydez/setup/domain/subname)))
 
 ;;---
 ;; PFO Desktop 2013-
 ;;---
 ((equal spydez/setup/system/hash "computer-898a-27ab")
  (setq spydez/setup/domain/name "work"
        spydez/setup/domain/subname "pfo"
        spydez/setup/system/hash (spydez/hash-and-reduce spydez/setup/system/name spydez/setup/domain/subname)))
 
 ;;---
 ;; Fallthrough Case - nothing specified so defaults will be used
 ;;---
 (t (spydez/warning/message nil nil "Update 'Master List' for this system (%s) here." spydez/setup/system/hash)
    (setq spydez/bootstrap/system/exists-p nil)))


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'master-list)