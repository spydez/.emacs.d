;; -*- mode: emacs-lisp; lexical-binding: t -*-


(require 'seq)


;;--------------------------Little Bit of Sanity...----------------------------
;;--                         Early Step Completed?                           --
;;-----------------------------------------------------------------------------
(spydez/init/step/at 'bootstrap 'early)
;; step/at complains so we don't have to... Just want the sanity check of
;; calling it to be here.


;;-----------------------------------System------------------------------------
;;--                        Find It and Check It...                          --
;;-----------------------------------------------------------------------------
(cond
 ;;-----------------------------------------------------------------------------
 ;; Known System
 ;;-----------------------------------------------------------------------------
 ((bound-and-true-p spydez/bootstrap/system/known-p)

  ;; system's dir exists or system doesn't need special setup here.
  (if (or (file-exists-p (spydez/dirky/path :load-path :dev/system))
          (not spydez/dev/setup/additional-required))
      ;; a-ok - no need to do anything
      (spydez/init/step/set-completed 'bootstrap '(system specific))

    ;; needs another step done?
    (mis/warning
     nil nil
     "  System '%s' needs additional setup! %s %s"
     spydez/dev/system/name
     (if spydez/dev/setup/additional-required
         "(more setup required?)"
       (format "(setup file missing: %s" (spydez/dirky/path :load-path :dev/system))))
    (spydez/init/step/set-completed 'bootstrap '(system default))))
 ;;!!!!!
 ;; AFTER SETUP IN master-list.el ONLY!
 ;;   If you need to create the system's dir for additional-setup, put cursor
 ;; after closing parenthesis and eval with C-x C-e
 ;;---
 ;; (make-directory (spydez/dirky/path :load-path :dev/system))
 ;;---
 ;; Creates the dir, fails if no parent.
 ;; Parent is probably (spydez/dirky/path :load-path :personal) and
 ;; should exist manually.
 ;;!!!!!


 ;;---------------------------------------------------------------------------
 ;; New System Instructions
 ;;---------------------------------------------------------------------------
 ;; Tell user to setup up this system.
 ((not (bound-and-true-p spydez/bootstrap/system/known-p))
  ;; Put point at end of (mis/warning nil nil ...) then:
  ;;   C-x C-e to evaluate these sexprs.
  (mis/warning
   nil nil
   "Hello there from bootstrap-system. This system needs added to: '%s'"
   (spydez/path/to-file (spydez/dirky/path :load-path :devices) "master-list.el"))

  ;; Make sure these are correct:
  (mis/warning
   nil nil
   "New computer? Make sure these are correct:")
  (mis/warning
   nil nil
   "  system/name: %s" spydez/dev/system/name)
  (mis/warning
   nil nil
   "  system/hash: %s" spydez/dev/system/hash)

  ;; Then make sure these folders/files are correct/exist:
  (mis/warning
   nil nil
   "  dir/domain: %s" (spydez/dirky/path :load-path :dev/domain))
  (mis/warning
   nil nil
   "  dir/system: %s" (spydez/dirky/path :load-path :dev/system))

  ;; And we're only done w/ default bootstrap.
  (spydez/init/step/set-completed 'bootstrap '(system default))))


;;--------------------------Little Bit of Sanity...----------------------------
;;--                   "How was bootstrap today, Honey?"                     --
;;-----------------------------------------------------------------------------
;; Not too much sanity.
(cond ((spydez/init/step/at 'bootstrap '(system specific))
       ;; good to go
       t)

      ;; using default - should probably warn
      ((spydez/init/step/at 'bootstrap '(system default))
       (mis/warning nil nil
           "Specific bootstrap does not exist for this computer: %s %s"
           spydez/init/step/completed spydez/dev/system/hash))

      ;; fallthrough cases - nothing used
      (t (error (mis/warning nil nil
                    "Bootstrap: No bootstrap at all for this computer?: %s %s"
                    spydez/init/step/completed spydez/dev/system/hash))))


;;------------------------------------------------------------------------------
;; Tasks, Wants, Feature Requests, etc.
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; The Actual End.
;;------------------------------------------------------------------------------
(provide 'bootstrap-system)
