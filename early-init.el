
;; TODO: notes, pretty this, etc




;;----------------------------------------------------------------------------;;
;;                                 Bootstrap.                                 ;;
;;---To pull oneself up by the bootstraps, one must first find one's boots.---;;
;;                           ...Oh, there they are.

;; After agonizing about this for all of [2019-02-13], and various points
;; throughout from the start, I think the new early-init.el is the best place to
;; put enough of the bootstrap to find the local settings here.
;;
;; Also, it appears that some of the window settings improve startup by
;; significant fractions of a second. Other settings too.
;;
;; However, early-init is an Emacs 27 thing. So for Emacs 26.1 til then, we'll
;; just have to fudge things. For Emacs 27 and onward, the message above will
;; start being spit out, and eventually, decades from now, I'll notice and fix
;; things to how they should be.
;;
;; See: https://github.com/search?q=early-init.el&type=Code
(when (boundp 'early-init-file)
  (message "Update early-init.el for actual active duty! Emacs %s uses early-init proper." emacs-version))




;;------------------------------------------------------------------------------
;; Necessary stuff.
;;------------------------------------------------------------------------------

;; Need to know something about my boots so I can pull the right straps.


;;---
;; Hashing
;;---
(defconst spydez/hash/default 'sha512
  "Default hashing function to use for spydez/hash-input.")
(defconst spydez/hash/slice 4
  "Default hashing slice size to use for spydez/hash-and-reduce.")
(defconst spydez/hash/join "-"
  "Default hashing slice size to use for spydez/hash-and-reduce.")
(defconst spydez/hash/prefix "hash"
  "Default hashing slice size to use for spydez/hash-and-reduce.")

;; Wanted to use dash for this but its way before packages have been bootstrapped.
;; Well, even more now that it's in early-init.el...
(defun spydez/hash-input (input &optional hash)
  "Returns a hash string of input. Hard-coded to sha512 atm."
  (let ((hash (or hash spydez/hash/default))) ;; set hash to default if unspecified
    (if (member hash (secure-hash-algorithms)) ;; make sure it exists as a supported algorithm
        (secure-hash hash input)
      (error "Unknown hash: %s" hash))
    ))
(defun spydez/hash-and-reduce (input &optional prefix hash slice join)
  (let* ((hash-full (spydez/hash-input input hash))
         ;; (hash-len (length hash-full)) ;; negative numbers work in substring, yay
         (slice (or slice spydez/hash/slice))
         (join (or join spydez/hash/join))
         (prefix (or prefix spydez/hash/prefix)))
    (message "hashed: %s %s %s %s" input prefix hash slice join)
    (mapconcat 'identity
               (list prefix
                     (substring hash-full 0 slice)
                     (substring hash-full (- slice) nil))
               join)
    ))


;;---
;; Domain & System Setup
;;---
(defconst spydez/file/bootstrap/local "local.el"
  "Definitions for how this computer is different from others, for getting bootstrap started.")
(defconst spydez/setup/domain/name "work"
  "A domain/folder for setups similar to this. E.g. work vs personal.")
(defconst spydez/setup/domain/subname "computer"
  "A sub-domain/folder for setups similar to this. E.g. work laptop vs work PC.")
(defconst spydez/setup/system/name (system-name)
  "(Plain String) Intended for this specific computer's setup folder.")
(defconst spydez/setup/system/hash (spydez/hash-and-reduce spydez/setup/system/name spydez/setup/domain/subname)
  "(Hashed) Intended for this specific computer's setup folder.")


;;---
;; Directories
;;---
(defun spydez/dir-name (name parent)
  "Expand name as child dir of parent in platform-agnostic manner."
  (file-name-as-directory (expand-file-name name parent)))

;; TODO: spydez/dir/setup-blah, spydez/dir/setup/blah, spydez/setup/dir/blah, spydez/dir/blah....?

(defconst spydez/dir/emacs (expand-file-name user-emacs-directory)
  ;; user-init-file and user-emacs-directory can be helpful here
  "This should be a platform-agnostic way to find .emacs.d. Especially when I
can't decided on where, exactly, $HOME is for bash/emacs/etc on Windows.")

(defconst spydez/dir/emacs/personal (spydez/dir-name "spydez" spydez/dir/emacs)
  "All of my own personal/custom setup code/vars/definitions...")

;; TODO: personal to "personal", or maybe a list of guesses at where the "defaults" would be...
;; Then the min necessary for loading/getting file from defaults that contains these
;; consts and funcs necessary for 1st step of bootstrap?
;; derived-TODO: move personal to "personal"? OR guess "personal", then "spydez"... etc?
;;   TODO-TOO: name the looking for stuff to start bootstrap: "finding shoe", cuz you need a shoe
;;     to pull yourself up by your bootstraps, right? RIGHT?!
;;   TODO: May need a place in the shoe closet for system/hash -> domain/name? IDK


(defconst spydez/dir/personal/defaults (spydez/dir-name "defaults" spydez/dir/emacs/personal)
  "All of my optional/default setup elisp files...") ; TODO: rename to "overrides" or something? Add another one for overrides?
(defconst spydez/dir/personal/domain (spydez/dir-name spydez/setup/domain/name spydez/dir/emacs/personal)
  "Anything that has to  be domain specific. Tab widths or whatnot.")
(defconst spydez/dir/domain/comp (spydez/dir-name spydez/setup/system/hash spydez/dir/personal/domain)
  "Anything that has to be computer specific. Overriding tab widths or whatnot.")

;;---
;; Load Path
;;---

;; Save off orginal. We're going to have a reduced set for bootstrapping, then reset and add the full monty.
(defconst spydez/dir/load-path/orig load-path)

;; Load-Path dirs for finding bootstrapping files:
(add-to-list 'load-path spydez/dir/personal/defaults) ;; defaults first so everything else overrides.
;; Could add a domain level if needed?
(add-to-list 'load-path spydez/dir/domain/comp) ;; most specific to this computer last



(defconst spydez/bootstrap/complete 'early
  "values: nil, 'early, 'default, 'specific
compare: (eq spydez/bootstrap/complete 'early)")

;; (provide 'early-init)
;; early-init ends here
