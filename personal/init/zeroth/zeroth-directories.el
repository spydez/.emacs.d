;; -*- emacs-lisp; lexical-binding: t -*-


;;------------------------------------------------------------------------------
;; Functions
;;------------------------------------------------------------------------------

(defun spydez/dir-name (name parent)
  "Expand name as child dir of parent in platform-agnostic manner."
  (file-name-as-directory (expand-file-name name parent)))

;; There are some existing packages for dealing with windows->unix or unix->windows paths...
;;   Windows emacs, Cygwin paths: https://www.emacswiki.org/emacs/cygwin-mount.el
;;   Cygwin/WSL emacs, win paths: https://github.com/victorhge/windows-path
;; but..: aren't on melpa, haven't been updated in years, etc.
(defun spydez/dir/windows-to-mingw (dir)
  "Bad hack. Absolute minimum to change from `c:/path/to/dir' to `/c/path/to/dir'"
  (concat "/" (replace-regexp-in-string ":" "" dir) "/"))


;;------------------------------------------------------------------------------
;; Constants
;;------------------------------------------------------------------------------

;; TODO: spydez/dir/setup-blah, spydez/dir/setup/blah, spydez/setup/dir/blah, spydez/dir/blah....?

;;---
;; Base Dirs
;;---

(defconst spydez/dir/home (expand-file-name "~")
  "User's $HOME directory. In native format (unix vs windows paths).")

(defconst spydez/dir/emacs (expand-file-name user-emacs-directory)
  ;; user-init-file and user-emacs-directory can be helpful here
  "This should be a platform-agnostic way to find .emacs.d. Especially when I
can't decided on where, exactly, $HOME is for bash/emacs/etc on Windows.")


;;---
;; Personal Dirs
;;---

(defconst spydez/dir/emacs/personal (spydez/dir-name "personal" spydez/dir/emacs)
  "All of my own personal/custom setup code/vars/definitions...")


;;---
;; Device/System Dirs
;;---

(defconst spydez/dir/personal/dev (spydez/dir-name "dev" spydez/dir/emacs/personal)
  "Device/system-specific init/config files and settings
(including their defaults) should reside under here.")

(defconst spydez/dir/dev/defaults (spydez/dir-name "defaults" spydez/dir/personal/dev)
  "All of my optional/default setup elisp files...")

(defconst spydez/dir/dev/domain-all (spydez/dir-name "domains" spydez/dir/personal/dev)
  "Domains folder. For subdirs of work, home, etc.")
(defconst spydez/dir/dev/domain-this (spydez/dir-name spydez/setup/domain/name spydez/dir/dev/domain-all)
  "Anything that has to be domain specific. Tab widths or whatnot.")

(defconst spydez/dir/dev/system-all (spydez/dir-name "computers" spydez/dir/personal/dev)
  "Computers folder. For subdirs of different computers.")
(defconst spydez/dir/dev/system-this (spydez/dir-name spydez/setup/system/hash spydez/dir/dev/system-all)
  "Anything that has to be computer specific. Overriding tab widths or whatnot.")


;;---
;; Init Dirs
;;---

(defconst spydez/dir/personal/init (spydez/dir-name "init" spydez/dir/emacs/personal)
  "Base dir for my personal init files.")
(defconst spydez/dir/init/zeroth (spydez/dir-name "zeroth" spydez/dir/personal/init)
  "Dir for my personal init files related to early-init, basic consts/funcs.")
(defconst spydez/dir/init/boot (spydez/dir-name "boot" spydez/dir/personal/init)
  "Dir for my personal init files related to early-init, bootstrapping.")
(defconst spydez/dir/init/config (spydez/dir-name "config" spydez/dir/personal/init)
  "Dir for my personal init files related to normal init, configuration, use-package, etc.")
(defconst spydez/dir/init/finalize (spydez/dir-name "finalize" spydez/dir/personal/init)
  "Dir for my personal init files related to sanity, double checking, final steps.")


;;---
;; Other Dirs
;;---

(defconst spydez/dir/personal/lisp (spydez/dir-name "lisp" spydez/dir/emacs/personal)
  "Extra, non-init files for lisp code I've made or scrounged...")

;; not used in code (right now? [2019-02-25]) but trying out using
;; a const in org notes...
(defconst spydez/dir/personal/docs (spydez/dir-name "docs" spydez/dir/emacs/personal)
  "Here there be +monsters+ documentation. Or documents... or a few doctors...")
(defconst spydez/dir/docs/notes (spydez/dir-name "notes" spydez/dir/personal/docs)
  "Here there be +monsters+ documentation.")

(defconst spydez/dir/emacs/manual-packages (spydez/dir-name "manual-package-archive" spydez/dir/emacs)
  "Packages that are stuck back before package.el, {ELPA,MELPA,...}, use-package...")


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'zeroth-directories)