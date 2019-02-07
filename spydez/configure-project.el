;; -*- emacs-lisp -*-


;;---
;; Helm Projectile Commands:
;;---
;; C-c p h: All-in-one command (helm-projectile)
;;   Usage: This command, by default, is the combination of these 5 commands:
;;     - helm-projectile-switch-to-buffer
;;     - helm-projectile-find-file
;;     - helm-projectile-switch-project
;; C-c p p: Enter project portal (helm-projectile-switch-project)
;;   Usage: This is the very first command you need to use before using other
;;   commands, because it is the entrance to all of your projects and the only
;;   command that can be used outside of a project, aside from
;;   helm-projectile-find-file-in-known-projects. The command lists all visited
;;   projects. If you first use Projectile, you have to visit at least a project
;;   supported by Projectile to let it remember the location of this project.
;;   The next time you won't have to manually navigate to that project but jump
;;   to it instantly using helm-projectile-switch-project.
;;
;; Lots more: https://tuhdo.github.io/helm-projectile.html
;;   Bit too verbose for here right now.

;;---
;; Projectile Commands:
;;---
;; C-c p f: Find file in current project
;; C-c p p: Switch project
;; C-c p g: Grep in project
;; C-c p r: Replace in project
;; C-c p m: Invoke a command via the Projectile Commander
;; many many more: https://projectile.readthedocs.io/en/latest/usage/


;;------------------------------------------------------------------------------
;; TODO: General Settings?
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; Projectile
;;------------------------------------------------------------------------------
;; https://github.com/bbatsov/projectile
;; https://www.projectile.mx/en/latest/
;; https://wikemacs.org/wiki/Projectile
;; https://tuhdo.github.io/helm-projectile.html

;; You can go one step further and set a list of folders which Projectile is
;; automatically going to check for projects:
;; https://projectile.readthedocs.io/en/latest/usage/
;; (setq projectile-project-search-path '("~/projects/" "~/work/"))


;; http://pages.sachachua.com/.emacs.d/Sacha.html#org2bcc47a
;; the package itself
(use-package projectile
  :diminish projectile-mode
  :config
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p"))
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    
    ;; Using Emacs Lisp for indexing files is really slow on Windows. To enable
    ;; external indexing, add this setting. The alien indexing method uses
    ;; external tools (e.g. git, find, etc) to speed up the indexing process.
    (setq projectile-indexing-method 'alien)

    ;; I don't have any ignored yet... Maybe `third-party' if dirs can be ignored...
    ;; (add-to-list 'projectile-globally-ignored-files "node-modules")
    )

  :config
  (projectile-global-mode))

;; integrate with Helm
;; demos and such: https://tuhdo.github.io/helm-projectile.html
(use-package helm-projectile)


;;------------------------------------------------------------------------------
;; TODOs
;;------------------------------------------------------------------------------

;; TODO: What needs done to get projectile running on this repo?
;; TODO: What needs done to get projectile running on work repo?
;; TODO: Start trying out those `C-c p ...' commands
;; TODO: save projectile-bookmarks.eld in git? move it to secrets?
;;       - one per system-name, probably...
;;       - ignore here, save in secrets, one per sys is probably a good call...
;;       - might have to pay attention to this bug: https://github.com/bbatsov/projectile/issues/989


;;------------------------------------------------------------------------------
;; Provide this.
;;------------------------------------------------------------------------------
(provide 'configure-project)